--[[
	Minegistics
		logalog
		Droog71
	License: AGPLv3
]]--

--TODO Set a limit to the size train will take from a location


local function spawn_passengers(train, pos)
	if train.crowd_sound == false then
		minetest.sound_play('trains_people', {
			pos = pos,
			loop = false,
			max_hear_distance = 16
		})
		train.crowd_sound = true
	end
	if minetest.settings:get_bool("minegistics_particles", true) then
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
end

local function can_collect_train(player)
	local name = player:get_player_name()
	local inv = player:get_inventory()
	local creative = minetest.is_creative_enabled(name)
	local has_train = inv:contains_item("main", "trains:train")
	return creative == false or has_train == false
end

local function get_object_id(object)
	for id, entity in pairs(minetest.luaentities) do
		if entity.object == object then
			return id
		end
	end
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
		self.sound_handle = minetest.sound_play("trains_train_moving", {
			object = self.object,
			gain = (speed / trains.speed_max) / 2,
			loop = true,
		})
	end
end

--enables filled train mesh.
local function set_train_filled(train)
	train.object:set_properties({mesh = "train_2.obj", textures = {"trains_train_2.png"}})
end

--enables empty train mesh.
local function set_train_empty(train)
	train.object:set_properties({mesh = "train.obj", textures = {"trains_train.png"}})
end



--deposits or withdraws items at a factory
local function factory_transaction(train, train_inv, contents)
	for output, inputs in pairs(factory_recipes) do
		if train_inv[inputs[1]] == nil then
			train_inv[inputs[1]] = 0
		end
		if train_inv[inputs[2]] == nil then
			train_inv[inputs[2]] = 0
		end
		if train_inv[inputs[1]] > 0 then
			contents:add_item("main", inputs[1] .. " " .. train_inv[inputs[1]])
			train_inv[inputs[1]] =  0
			train.supply_train = true
		end
		if train_inv[inputs[2]] > 0 then
			contents:add_item("main", inputs[2] .. " " .. train_inv[inputs[2]])
			train_inv[inputs[2]] =  0
			train.supply_train = true
		end
	end
	set_train_empty(train)
	if train.supply_train == false then
		local found_item = false
		for output, inputs in pairs(factory_recipes) do
			if (contents:contains_item("main", (output .. " 10"))) then
				contents:remove_item("main", (output .. " 10"))
				if train_inv[output] == nil then
					train_inv[output] = 0
				end
				train_inv[output] = train_inv[output] + 10
				found_item = true
			end
		end
		if found_item then
			set_train_filled(train)
		end
	end
	train:on_punch()
end

--deposits or withdraws items at a workshop
local function workshop_transaction(train, train_inv, contents)
	local ore_hauler = false
	for input, output in pairs(workshop_recipes) do
		if train_inv[input] == nil then
			train_inv[input] = 0
		end
		if train_inv[input] > 0 then
			contents:add_item("main", input .. " " .. train_inv[input])
			train_inv[input] =  0
			ore_hauler = true
		end
	end
	set_train_empty(train)
	if ore_hauler == false then
		local found_item = false
		for input, output in pairs(workshop_recipes) do
			if (contents:contains_item("main", (output .. " 10"))) then
				contents:remove_item("main", (output .. " 10"))
				if train_inv[output] == nil then
					train_inv[output] = 0
				end
				train_inv[output] = train_inv[output] + 10
				found_item = true
			end
		end
		if found_item then
			set_train_filled(train)
		end
	end
	train:on_punch()
end

--withdraws items at a collector or farm.
local function collect(train, train_inv, contents, list)
	local found_item = false
	for _, item in ipairs(list) do
		if (contents:contains_item("main", (item .. " 10"))) then
			contents:remove_item("main", (item .. " 10"))
			if train_inv[item] == nil then
				train_inv[item] = 0
			end
			train_inv[item] = train_inv[item] + 10
			found_item = true
		end
	end
	if found_item then
		set_train_filled(train)
	end
end

--checks if the train is moving and if stopped check for a structure next to it.
local function structure_check(train, dtime)
	local vel = train.object:get_velocity()
	local pos = train.object:get_pos()
	local train_inv = train_cargo[get_object_id(train.object)]
	if train_inv == nil then
		table.insert(train_cargo, get_object_id(train.object), {})
		train_inv = train_cargo[get_object_id(train.object)]
	end
	local directions = {
		vector.new(pos.x + 1, pos.y, pos.z),
		vector.new(pos.x - 1, pos.y, pos.z),
		vector.new(pos.x, pos.y, pos.z + 1),
		vector.new(pos.x, pos.y, pos.z - 1)
	}
	if vel.x == 0 and vel.y == 0 and vel.z == 0 then
		for i, direction in ipairs(directions) do
			local structure_name = minetest.get_node(direction).name
			local contents = minetest.get_inventory({type="node", pos=direction})
			if structure_name == "minegistics:Collector" then
				collect(train, train_inv, contents, resources)
			elseif structure_name == "minegistics:Farm" then
				collect(train, train_inv, contents, farm_resources)
			elseif structure_name == "minegistics:Factory" then
				factory_transaction(train, train_inv, contents)
			elseif structure_name == "minegistics:Workshop" then
				workshop_transaction(train, train_inv, contents)
			elseif structure_name == "minegistics:Town" then
				train.town_train = true
				spawn_passengers(train, pos)
			elseif structure_name == "minegistics:Market" and train.town_train == true then
				minetest.get_meta(direction):set_int("has_town", 1)
				spawn_passengers(train, pos)
			elseif contents ~= nil then
				for item, amount in pairs(train_inv) do
					contents:add_item("main", item .. " " .. amount)
					train_inv[item] =  0
				end
				set_train_empty(train)
				train:on_punch()
			end
		end
	end
end


local function train_drive(self, dtime)
	-- self.object:set_properties({
	-- 	nametag = self.object:get_yaw()/(math.pi),
	-- 	-- nametag = dtime,
	-- })

	local new_pos, new_dir, stop = trains.get_next_pos(self, dtime)
	self.object:set_yaw(trains.dir_to_yaw(new_dir))
	self.object:move_to(new_pos, false)
	-- self.object:set_pos(new_pos)
	if stop then self.state = "stopped" end
end

--Initial entity Creation
-- this table is used as a meta lookup table for the table called 'self'
local train_entity = {
	initial_properties = {
		physical = false,
		collisionbox = {-5/16, -5/16, -5/16, 5/16, 1/16, 5/16},
		visual = "mesh",
		mesh = "train.obj",
		visual_size = {x=1, y=1},
		textures = {"trains_train.png"}
	},

	test = "foo",
	timer = 0,
	speed = 1,
	state = "pause",

	punched = false,
	velocity = {x=0, y=0, z=0},
	old_dir = {x=1, y=0, z=0},
	old_pos = nil,
	old_switch = 0,
	railtype = nil,
	automation_timer = 0,
	town_train = false,
	supply_train = false,
	crowd_sound = false,

	on_activate = function(self, staticdata, dtime_s)
		self.test = nil
		self.object:set_armor_groups({immortal=1})
		if string.sub(staticdata, 1, string.len("return")) ~= "return" then
			return
		end
		local data = minetest.deserialize(staticdata)
		if type(data) ~= "table" then
			return
		end
		self.railtype = data.railtype
		self.train_inv = data.train_inv
		self.town_train = data.town_train
		self.supply_train = data.supply_train
		if data.old_dir then
			self.old_dir = data.old_dir
		end
		table.insert(train_cargo, get_object_id(self.object), {})
	end,

	get_staticdata = function(self)
		return minetest.serialize({
			railtype = self.railtype,
			old_dir = self.old_dir,
			town_train = self.town_train,
			supply_train = self.supply_train
		})
	end,

	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, direction, damage)
		if puncher and puncher:get_player_control().sneak then
			if self.sound_handle then
				minetest.sound_stop(self.sound_handle)
			end
			if can_collect_train(puncher) then
				local inv = puncher:get_inventory()
				local leftover = inv:add_item("main", "trains:train")
				if not leftover:is_empty() then
					minetest.add_item(self.object:get_pos(), leftover)
				end
			end
			self.object:remove()
			return
		end
	end,

	on_step = function(self, dtime, moveresult)
		-- minetest.add_particle({
		-- 	pos = self.object:get_pos(),
		-- 	texture = "black_smoke.png",
		-- 	velocity = vector.new(0, 1, 0)
		-- })
		-- train_drive(self, dtime)
		self.object:set_properties({
			nametag = self.state,
		})
		if self.state == "driving" then
			train_drive(self, dtime)
		elseif self.state == "stopped" then
			structure_check(self, dtime)
			self.state = "pause"
			self.timer = 1
		elseif self.state == "pause" then
			self.timer = self.timer - dtime
			if self.timer <= 0 then
				self.timer = 0
				self.state = "driving"
			end
		elseif self.state == "loading" then
			structure_check(self, dtime)
		end
		-- self.timer = self.timer + dtime
		-- local pos = self.object:get_pos()
		-- if self.timer > 1 then
		-- 	self.timer = self.timer - 0.25
		-- 	if pos.y < 0.5 then
		-- 		pos.y = pos.y + 1
		-- 	else
		-- 		pos.y = pos.y - 1
		-- 	end
		-- 	-- self.object:set_pos(pos)
		-- 	-- self.object:move_to(pos, false)
		-- 	self.object:move_to(pos, true)
		-- end


		-- structure_check(self, dtime)
		-- rail_on_step(self, dtime)
		-- rail_sound(self, dtime)
		-- self.automation_timer = self.automation_timer + 1
		-- if self.automation_timer >= 1000 then
		-- 	self:on_punch()
		-- 	self.town_train = false
		-- 	self.automation_timer = 0
		-- 	self.crowd_sound = false
		-- end
	end,
}










minetest.register_entity("trains:train", train_entity)

minetest.register_craftitem("trains:train", {
	description = "Train: " ..
	"Carries resources from one building to another.\n" ..
	"Must be placed on a rail. (Shift+Click to pick up)",
	inventory_image = "train_wield.png",
	wield_image = "train_wield.png",
	on_place = function(itemstack, placer, pointed_thing)
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local udef = minetest.registered_nodes[node.name]

		if udef and udef.on_rightclick and not (placer and placer:is_player() and placer:get_player_control().sneak) then
			return udef.on_rightclick(under, node, placer, itemstack,
			pointed_thing) or itemstack
		end

		if trains.is_rail(under) then
			minetest.add_entity(pointed_thing.under, "trains:train")
		elseif trains.is_rail(pointed_thing.above) then
			minetest.add_entity(pointed_thing.above, "trains:train")
		else
			return
		end

		minetest.sound_play('trains_train_moving', {
			pos = pointed_thing.above,
			loop = false,
			max_hear_distance = 16
		})

		if not minetest.is_creative_enabled(placer:get_player_name()) then
			itemstack:take_item()
		end

		return itemstack
	end,
})
