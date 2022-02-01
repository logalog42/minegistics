--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

local train_entity = {
	initial_properties = {
		physical = false,
		collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		visual = "mesh",
		mesh = "train.obj",
		visual_size = {x=1, y=1},
		textures = {"trains_train.png"}
	},
  
	punched = false,
	velocity = {x=0, y=0, z=0},
	old_dir = {x=1, y=0, z=0},
	old_pos = nil,
	old_switch = 0,
	railtype = nil,
	attached_items = {},
	trainInv = {},
  automation_timer = 0,
  town_train = false,
}

function train_entity:on_activate(staticdata, dtime_s)
	self.object:set_armor_groups({immortal=1})
	if string.sub(staticdata, 1, string.len("return")) ~= "return" then
		return
	end
	local data = minetest.deserialize(staticdata)
	if type(data) ~= "table" then
		return
	end
	self.railtype = data.railtype
  self.trainInv = data.trainInv
  self.town_train = data.town_train
	if data.old_dir then
		self.old_dir = data.old_dir
	end
end

function train_entity:get_staticdata()
	return minetest.serialize({
      railtype = self.railtype,
      old_dir = self.old_dir,
      trainInv = self.trainInv,
      town_train = self.town_train,
	})
end

function train_entity:on_punch(puncher, time_from_last_punch, tool_capabilities, direction)
	local pos = self.object:get_pos()
	local vel = self.object:get_velocity()
	if not self.railtype or vector.equals(vel, {x=0, y=0, z=0}) then
		local node = minetest.get_node(pos).name
		self.railtype = minetest.get_item_group(node, "connect_to_raillike")
	end
	if not puncher or not puncher:is_player() then
		local train_dir = trains:get_rail_direction(pos, self.old_dir, nil, nil, self.railtype)
		if vector.equals(train_dir, {x=0, y=0, z=0}) then
			return
		end
		self.velocity = vector.multiply(train_dir, 2)
		self.punched = true
		return
	end
	if puncher:get_player_control().sneak then
		if self.sound_handle then
			minetest.sound_stop(self.sound_handle)
		end
    
		for _, obj_ in ipairs(self.attached_items) do
			if obj_ then
				obj_:set_detach()
			end
		end

		local inv = puncher:get_inventory()
		if not minetest.is_creative_enabled(puncher:get_player_name())
				or not inv:contains_item("main", "minegistics_trains:train") then
			local leftover = inv:add_item("main", "minegistics_trains:train")
			if not leftover:is_empty() then
				minetest.add_item(self.object:get_pos(), leftover)
			end
		end
		self.object:remove()
		return
	end

	local punch_dir = trains:velocity_to_dir(puncher:get_look_dir())
	punch_dir.y = 0
	local train_dir = trains:get_rail_direction(pos, punch_dir, nil, nil, self.railtype)
	if vector.equals(train_dir, {x=0, y=0, z=0}) then
		return
	end

	local punch_interval = 1
	if tool_capabilities and tool_capabilities.full_punch_interval then
		punch_interval = tool_capabilities.full_punch_interval
	end
	time_from_last_punch = math.min(time_from_last_punch or punch_interval, punch_interval)
	local f = 2 * (time_from_last_punch / punch_interval)

	self.velocity = vector.multiply(train_dir, f)
	self.old_dir = train_dir
	self.punched = true
end

local function rail_on_step_event(handler, obj, dtime)
	if handler then
		handler(obj, dtime)
	end
end

local function rail_sound(self, dtime)
	if not self.sound_ttl then
		self.sound_ttl = 1.0
		return
	elseif self.sound_ttl > 0 then
		self.sound_ttl = self.sound_ttl - dtime
		return
	end
	self.sound_ttl = 1.0
	if self.sound_handle then
		local handle = self.sound_handle
		self.sound_handle = nil
		minetest.after(0.2, minetest.sound_stop, handle)
	end
	local vel = self.object:get_velocity()
	local speed = vector.length(vel)
	if speed > 0 then
		self.sound_handle = minetest.sound_play(
			"trains_train_moving", {
			object = self.object,
			gain = (speed / trains.speed_max) / 2,
			loop = true,
		})
	end
end

local function get_railparams(pos)
	local node = minetest.get_node(pos)
	return trains.railparams[node.name] or {}
end

local v3_len = vector.length
local function rail_on_step(self, dtime)
	local vel = self.object:get_velocity()
	if self.punched then
		vel = vector.add(vel, self.velocity)
		self.object:set_velocity(vel)
		self.old_dir.y = 0
	elseif vector.equals(vel, {x=0, y=0, z=0}) then
		return
	end

	local pos = self.object:get_pos()
	local train_dir = trains:velocity_to_dir(vel)
	local same_dir = vector.equals(train_dir, self.old_dir)
	local update = {}

	if self.old_pos and not self.punched and same_dir then
		local flo_pos = vector.round(pos)
		local flo_old = vector.round(self.old_pos)
		if vector.equals(flo_pos, flo_old) then
			return
		end
	end

	local stop_wiggle = false
	if self.old_pos and same_dir then
		local acc = self.object:get_acceleration()
		local distance = dtime * (v3_len(vel) + 0.5 * dtime * v3_len(acc))

		local new_pos, new_dir = trains:pathfinder(
			pos, self.old_pos, self.old_dir, distance,
			self.old_switch, self.railtype
		)

		if new_pos then
			pos = new_pos
			update.pos = true
			train_dir = new_dir
		end
	elseif self.old_pos and self.old_dir.y ~= 1 and not self.punched then
		stop_wiggle = true
	end

	local railparams

	local dir, switch_keys = trains:get_rail_direction(
		pos, train_dir, self.old_switch, self.railtype
	)
	local dir_changed = not vector.equals(dir, self.old_dir)

	local new_acc = {x=0, y=0, z=0}
	if stop_wiggle or vector.equals(dir, {x=0, y=0, z=0}) then
		vel = {x = 0, y = 0, z = 0}
		local pos_r = vector.round(pos)
		if not trains:is_rail(pos_r, self.railtype)
				and self.old_pos then
			pos = self.old_pos
		elseif not stop_wiggle then
			pos = pos_r
		else
			pos.y = math.floor(pos.y + 0.5)
		end
		update.pos = true
		update.vel = true
	else
		if dir_changed then
			vel = vector.multiply(dir, math.abs(vel.x + vel.z))
			update.vel = true
			if dir.y ~= self.old_dir.y then
				pos = vector.round(pos)
				update.pos = true
			end
		end

		if dir.z ~= 0 and math.floor(pos.x + 0.5) ~= pos.x then
			pos.x = math.floor(pos.x + 0.5)
			update.pos = true
		end
		if dir.x ~= 0 and math.floor(pos.z + 0.5) ~= pos.z then
			pos.z = math.floor(pos.z + 0.5)
			update.pos = true
		end

		local acc = dir.y * -4.0

		railparams = get_railparams(pos)

		local speed_mod = railparams.acceleration
		if speed_mod and speed_mod ~= 0 then
			-- Try to make it similar to the original trains mod
			acc = acc + speed_mod
		else
				acc = acc
		end

		new_acc = vector.multiply(dir, acc)
	end

	local max_vel = trains.speed_max
	for _, v in pairs({"x","y","z"}) do
		if math.abs(vel[v]) > max_vel then
			vel[v] = trains:get_sign(vel[v]) * max_vel
			new_acc[v] = 0
			update.vel = true
		end
	end

	self.object:set_acceleration(new_acc)
	self.old_pos = vector.round(pos)
	if not vector.equals(dir, {x=0, y=0, z=0}) and not stop_wiggle then
		self.old_dir = vector.new(dir)
	end
	self.old_switch = switch_keys

	if self.punched then

		for _, obj_ in pairs(minetest.get_objects_inside_radius(pos, 1)) do
			local ent = obj_:get_luaentity()

			if ent and ent.name == "__builtin:item" and ent.physical_state then
				ent:disable_physics()
				obj_:set_attach(self.object, "", {x=0, y=0, z=0}, {x=0, y=0, z=0})
				self.attached_items[#self.attached_items + 1] = obj_
        add_item_to_train(self, ent)
			end
		end
    
		self.punched = false
		update.vel = true
	end

	railparams = railparams or get_railparams(pos)

	if not (update.vel or update.pos) then
		rail_on_step_event(railparams.on_step, self, dtime)
		return
	end

	local yaw = 0
	if self.old_dir.x < 0 then
		yaw = 0.5
	elseif self.old_dir.x > 0 then
		yaw = 1.5
	elseif self.old_dir.z < 0 then
		yaw = 1
	end
	self.object:set_yaw(yaw * math.pi)

	local anim = {x=0, y=0}
	if dir.y == -1 then
		anim = {x=1, y=1}
	elseif dir.y == 1 then
		anim = {x=2, y=2}
	end
	self.object:set_animation(anim, 1, 0)

	if update.vel then
		self.object:set_velocity(vel)
	end
	if update.pos then
		if dir_changed then
			self.object:set_pos(pos)
		else
			self.object:move_to(pos)
		end
	end

	rail_on_step_event(railparams.on_step, self, dtime)
end

--adjusts inventory based on attached items
function add_item_to_train(train, item_ent)
    if item_ent then
        local inv_item = minetest.deserialize(item_ent:get_staticdata())
        local item_table = {}
        for str in string.gmatch(inv_item["itemstring"], "([^".." ".."]+)") do
            table.insert(item_table, str)
        end
        local item_name = item_table[1]
        local item_amount = item_table[2]
        if item_amount == nil then item_amount = 1 end
        for lump, amount in pairs(train.trainInv) do
            if lump == item_name then
                if train.trainInv[lump] == nil then train.trainInv[lump] = 0 end            
                train.trainInv[lump] = train.trainInv[lump] + item_amount
            end                
        end
    end
end

--attaches an itemstack to the train
function attach_to_train(train, item)
    local item_obj = minetest.add_item(train.object:get_pos(), ItemStack(item))
    local item_ent = item_obj:get_luaentity()
    if item_ent and item_ent.name == "__builtin:item" and item_ent.physical_state then
        item_ent:disable_physics()
        item_obj:set_attach(train.object, "", {x=0, y=0, z=0}, {x=0, y=0, z=0})
        train.attached_items[#train.attached_items + 1] = item_obj
    end
end

--removes all itemstacks from the train
function empty_train(train)
  for _, obj in pairs(train.attached_items) do
    if obj then
      local ent = obj:get_luaentity()
      if ent then
          obj:remove()
      end
    end
  end
end

--checks if the train is moving and if stopped check for a structure next to it.
local function structure_check(self, dtime)
    local vel = self.object:get_velocity()
    local pos = self.object:get_pos()
    local north = minetest.get_meta({x=(pos.x + 1), y=pos.y, z=pos.z})
    local south = minetest.get_meta({x=(pos.x - 1), y=pos.y, z=pos.z})
    local east = minetest.get_meta({x=pos.x, y=pos.y, z=(pos.z + 1)})
    local west = minetest.get_meta({x=pos.x, y=pos.y, z=(pos.z - 1)})
    local directions = {north, south, east, west}

    if vel.x == 0 and vel.y == 0 and vel.z == 0 then
        for i, direction in ipairs(directions) do
            local structure_name = direction:get_string("infotext")
            if structure_name == "collector" then
                local contents = direction:get_inventory()
                for i, lump in ipairs(resources) do
                    while (contents:contains_item("main", (lump .. " 10"))) do
                        contents:remove_item("main", (lump .. " 10"))
                        if self.trainInv[lump] == nil then 
                            self.trainInv[lump] = 0 
                        end
                        self.trainInv[lump] = self.trainInv[lump] + 10
                        attach_to_train(self, lump .. " 10")
                    end
                end
            elseif structure_name == "factory" then
                local ore_hauler = false
                local contents = direction:get_inventory()
                for i, lump in pairs(resources) do
                    if self.trainInv[lump] == nil then 
                        self.trainInv[lump] = 0
                    end
                    if self.trainInv[lump] > 0 then
                        contents:add_item("main", lump .. " " .. self.trainInv[lump])
                        self.trainInv[lump] =  0
                        ore_hauler = true
                    end
                end
                empty_train(self)
                if ore_hauler == false then
                    for input, output in pairs(products) do
                        while (contents:contains_item("main", (output .. " 10"))) do
                            contents:remove_item("main", (output .. " 10"))
                            if self.trainInv[output] == nil then
                                self.trainInv[output] = 0
                            end
                            self.trainInv[output] = self.trainInv[output] + 10
                            attach_to_train(self, output .. " 10")
                        end
                    end
                end
                self:on_punch()
            elseif structure_name == "market" or structure_name == "warehouse" then
                if structure_name == "market" and self.town_train == true then
                    direction:set_int("has_town", 1)
                    spawn_passengers(pos)
                elseif structure_name == "warehouse" or direction:get_int("has_town") == 1 then
                    local contents = direction:get_inventory()
                    for i, lump in pairs(resources) do
                        if self.trainInv[lump] == nil then
                            self.trainInv[lump] = 0
                        end
                        if self.trainInv[lump] > 0 then
                            contents:add_item("main", lump .. " " .. self.trainInv[lump])
                            self.trainInv[lump] =  0
                        end
                    end
                    for input, output in pairs(products) do
                        if self.trainInv[output] == nil then 
                            self.trainInv[output] = 0
                        end
                        if self.trainInv[output] > 0 then
                            contents:add_item("main", output .. " " .. self.trainInv[output])
                            self.trainInv[output] =  0
                        end
                    end
                    empty_train(self)
                    self:on_punch()
                end
            elseif structure_name == "power_plant" then
                local contents = direction:get_inventory()
                for i, fuel in pairs(fuels) do
                    if self.trainInv[fuel] == nil then
                        self.trainInv[fuel] = 0
                    end
                    if self.trainInv[fuel] > 0 then
                        contents:add_item("main", fuel .. " " .. self.trainInv[fuel])
                        self.trainInv[fuel] =  0
                    end
                end
                empty_train(self)
                self:on_punch()
            elseif structure_name == "town" then
              self.town_train = true
              spawn_passengers(pos)
            end
        end
    end
end

function train_entity:on_step(dtime)
    structure_check(self, dtime)
    rail_on_step(self, dtime)
    rail_sound(self, dtime)
    self.automation_timer = self.automation_timer + 1
    if self.automation_timer >= 500 then
        self:on_punch()
        self.automation_timer = 0
    end
end

function spawn_passengers(pos)
    minetest.add_particlespawner({
        amount = 1,
        time = 1,
        minpos = {x=pos.x-0.1,y=pos.y,z=pos.z-0.1},
        maxpos = {x=pos.x+0.1,y=pos.y+1,z=pos.z+0.1},
        minvel = {x=0.1, y=0.01, z=0.1},
        maxvel = {x=0.1, y=0.05, z=0.1},
        minacc = {x=-0.1,y=0.1,z=-0.1},
        maxacc = {x=0.1,y=0.2,z=0.1},
        minexptime = 1,
        maxexptime = 2,
        minsize = 1,
        maxsize = 2,
        collisiondetection = false,
        vertical = false,
        texture = "people.png"
    })
end

minetest.register_entity("minegistics_trains:train", train_entity)

minetest.register_craftitem("minegistics_trains:train", {
	description = "Train: " ..
  "Carries resources from one building to another.\n" ..
  "Must be placed on a rail. (Shift+Click to pick up)",
	inventory_image = "train_wield.png",
	wield_image = "train_wield.png",
	on_place = function(itemstack, placer, pointed_thing)
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local udef = minetest.registered_nodes[node.name]
		if udef and udef.on_rightclick and
				not (placer and placer:is_player() and
				placer:get_player_control().sneak) then
			return udef.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end

		if not pointed_thing.type == "node" then
			return
		end
		if trains:is_rail(pointed_thing.under) then
			minetest.add_entity(pointed_thing.under, "minegistics_trains:train")
		elseif trains:is_rail(pointed_thing.above) then
			minetest.add_entity(pointed_thing.above, "minegistics_trains:train")
		else
			return
		end

		minetest.sound_play({name = "default_place_node_metal", gain = 0.5},
			{pos = pointed_thing.above}, true)

		if not minetest.is_creative_enabled(placer:get_player_name()) then
			itemstack:take_item()
		end
		return itemstack
	end,
})
