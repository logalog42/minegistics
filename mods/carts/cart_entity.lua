-- carts/cart_entity.lua

local lumps = {
      "basenodes:coal_lump",
      "basenodes:copper_lump", 
      "basenodes:tin_lump",
      "basenodes:iron_lump", 
      "basenodes:gold_lump"
  }

local cart_entity = {
	initial_properties = {
		physical = false, -- otherwise going uphill breaks
		collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		visual = "mesh",
		mesh = "carts_cart.b3d",
		visual_size = {x=1, y=1},
		textures = {"carts_cart.png"}
	},

	driver = nil,
	punched = false, -- used to re-send velocity and position
	velocity = {x=0, y=0, z=0}, -- only used on punch
	old_dir = {x=1, y=0, z=0}, -- random value to start the cart on punch
	old_pos = nil,
	old_switch = 0,
	railtype = nil,
	attached_items = {},
	cartInv = {},
  load = true
}

function cart_entity:on_activate(staticdata, dtime_s)
	self.object:set_armor_groups({immortal=1})
	if string.sub(staticdata, 1, string.len("return")) ~= "return" then
		return
	end
	local data = minetest.deserialize(staticdata)
	if type(data) ~= "table" then
		return
	end
	self.railtype = data.railtype
  self.cartInv = data.cartInv
	self.load = data.load
	if data.old_dir then
		self.old_dir = data.old_dir
	end
end

function cart_entity:get_staticdata()
	return minetest.serialize({
      railtype = self.railtype,
      old_dir = self.old_dir,
      cartInv = self.cartInv,
      load = self.load
	})
end

-- 0.5.x and later: When the driver leaves
function cart_entity:on_detach_child(child)
	if child and child:get_player_name() == self.driver then
		self.driver = nil
		carts:manage_attachment(child, nil)
	end
end

function cart_entity:on_punch(puncher, time_from_last_punch, tool_capabilities, direction)
	local pos = self.object:get_pos()
	local vel = self.object:get_velocity()
	if not self.railtype or vector.equals(vel, {x=0, y=0, z=0}) then
		local node = minetest.get_node(pos).name
		self.railtype = minetest.get_item_group(node, "connect_to_raillike")
	end
	-- Punched by non-player
	if not puncher or not puncher:is_player() then
		local cart_dir = carts:get_rail_direction(pos, self.old_dir, nil, nil, self.railtype)
		if vector.equals(cart_dir, {x=0, y=0, z=0}) then
			return
		end
		self.velocity = vector.multiply(cart_dir, 2)
		self.punched = true
		return
	end
	-- Player digs cart by sneak-punch
	if puncher:get_player_control().sneak then
		if self.sound_handle then
			minetest.sound_stop(self.sound_handle)
		end
		-- Detach driver and items
		if self.driver then
			if self.old_pos then
				self.object:set_pos(self.old_pos)
			end
			local player = minetest.get_player_by_name(self.driver)
			carts:manage_attachment(player, nil)
		end
		for _, obj_ in ipairs(self.attached_items) do
			if obj_ then
				obj_:set_detach()
			end
		end
		-- Pick up cart
		local inv = puncher:get_inventory()
		if not minetest.is_creative_enabled(puncher:get_player_name())
				or not inv:contains_item("main", "carts:cart") then
			local leftover = inv:add_item("main", "carts:cart")
			-- If no room in inventory add a replacement cart to the world
			if not leftover:is_empty() then
				minetest.add_item(self.object:get_pos(), leftover)
			end
		end
		self.object:remove()
		return
	end
	-- Player punches cart to alter velocity
	if puncher:get_player_name() == self.driver then
		if math.abs(vel.x + vel.z) > carts.punch_speed_max then
			return
		end
	end

	local punch_dir = carts:velocity_to_dir(puncher:get_look_dir())
	punch_dir.y = 0
	local cart_dir = carts:get_rail_direction(pos, punch_dir, nil, nil, self.railtype)
	if vector.equals(cart_dir, {x=0, y=0, z=0}) then
		return
	end

	local punch_interval = 1
	if tool_capabilities and tool_capabilities.full_punch_interval then
		punch_interval = tool_capabilities.full_punch_interval
	end
	time_from_last_punch = math.min(time_from_last_punch or punch_interval, punch_interval)
	local f = 2 * (time_from_last_punch / punch_interval)

	self.velocity = vector.multiply(cart_dir, f)
	self.old_dir = cart_dir
	self.punched = true
end

local function rail_on_step_event(handler, obj, dtime)
	if handler then
		handler(obj, dtime)
	end
end

-- sound refresh interval = 1.0sec
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
			"carts_cart_moving", {
			object = self.object,
			gain = (speed / carts.speed_max) / 2,
			loop = true,
		})
	end
end

local function get_railparams(pos)
	local node = minetest.get_node(pos)
	return carts.railparams[node.name] or {}
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
	local cart_dir = carts:velocity_to_dir(vel)
	local same_dir = vector.equals(cart_dir, self.old_dir)
	local update = {}

	if self.old_pos and not self.punched and same_dir then
		local flo_pos = vector.round(pos)
		local flo_old = vector.round(self.old_pos)
		if vector.equals(flo_pos, flo_old) then
			-- Do not check one node multiple times
			return
		end
	end

	local ctrl, player

	-- Get player controls
	if self.driver then
		player = minetest.get_player_by_name(self.driver)
		if player then
			ctrl = player:get_player_control()
		end
	end

	local stop_wiggle = false
	if self.old_pos and same_dir then
		-- Detection for "skipping" nodes (perhaps use average dtime?)
		-- It's sophisticated enough to take the acceleration in account
		local acc = self.object:get_acceleration()
		local distance = dtime * (v3_len(vel) + 0.5 * dtime * v3_len(acc))

		local new_pos, new_dir = carts:pathfinder(
			pos, self.old_pos, self.old_dir, distance, ctrl,
			self.old_switch, self.railtype
		)

		if new_pos then
			-- No rail found: set to the expected position
			pos = new_pos
			update.pos = true
			cart_dir = new_dir
		end
	elseif self.old_pos and self.old_dir.y ~= 1 and not self.punched then
		-- Stop wiggle
		stop_wiggle = true
	end

	local railparams

	-- dir:         New moving direction of the cart
	-- switch_keys: Currently pressed L/R key, used to ignore the key on the next rail node
	local dir, switch_keys = carts:get_rail_direction(
		pos, cart_dir, ctrl, self.old_switch, self.railtype
	)
	local dir_changed = not vector.equals(dir, self.old_dir)

	local new_acc = {x=0, y=0, z=0}
	if stop_wiggle or vector.equals(dir, {x=0, y=0, z=0}) then
		vel = {x = 0, y = 0, z = 0}
		local pos_r = vector.round(pos)
		if not carts:is_rail(pos_r, self.railtype)
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
		-- Direction change detected
		if dir_changed then
			vel = vector.multiply(dir, math.abs(vel.x + vel.z))
			update.vel = true
			if dir.y ~= self.old_dir.y then
				pos = vector.round(pos)
				update.pos = true
			end
		end
		-- Center on the rail
		if dir.z ~= 0 and math.floor(pos.x + 0.5) ~= pos.x then
			pos.x = math.floor(pos.x + 0.5)
			update.pos = true
		end
		if dir.x ~= 0 and math.floor(pos.z + 0.5) ~= pos.z then
			pos.z = math.floor(pos.z + 0.5)
			update.pos = true
		end

		-- Slow down or speed up..
		local acc = dir.y * -4.0

		-- Get rail for corrected position
		railparams = get_railparams(pos)

		-- no need to check for railparams == nil since we always make it exist.
		local speed_mod = railparams.acceleration
		if speed_mod and speed_mod ~= 0 then
			-- Try to make it similar to the original carts mod
			acc = acc + speed_mod
		else
			-- Handbrake or coast
			if ctrl and ctrl.down then
				acc = acc - 3
			else
				acc = acc
			end
		end

		new_acc = vector.multiply(dir, acc)
	end

	-- Limits
	local max_vel = carts.speed_max
	for _, v in pairs({"x","y","z"}) do
		if math.abs(vel[v]) > max_vel then
			vel[v] = carts:get_sign(vel[v]) * max_vel
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
		-- Collect dropped items
		for _, obj_ in pairs(minetest.get_objects_inside_radius(pos, 1)) do
			local ent = obj_:get_luaentity()
			-- Careful here: physical_state and disable_physics are item-internal APIs
			if ent and ent.name == "__builtin:item" and ent.physical_state then
				ent:disable_physics()
				obj_:set_attach(self.object, "", {x=0, y=0, z=0}, {x=0, y=0, z=0})
				self.attached_items[#self.attached_items + 1] = obj_
        add_item_to_cart(self, ent)
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

	-- call event handler
	rail_on_step_event(railparams.on_step, self, dtime)
end

--adjusts inventory based on attached items
function add_item_to_cart(cart, item_ent)
    if item_ent then
        local inv_item = minetest.deserialize(item_ent:get_staticdata())
        local item_table = {}
        for str in string.gmatch(inv_item["itemstring"], "([^".." ".."]+)") do
            table.insert(item_table, str)
        end
        local item_name = item_table[1]
        local item_amount = item_table[2]
        if item_amount == nil then item_amount = 1 end
        for lump, amount in pairs(cart.cartInv) do
            if lump == item_name then
                if cart.cartInv[lump] == nil then cart.cartInv[lump] = 0 end            
                cart.cartInv[lump] = cart.cartInv[lump] + item_amount
            end                
        end
    end
end

--attaches an itemstack to the cart
function attach_to_cart(cart, item)
    local item_obj = minetest.add_item(cart.object:get_pos(), ItemStack(item))
    local item_ent = item_obj:get_luaentity()
    if item_ent and item_ent.name == "__builtin:item" and item_ent.physical_state then
        item_ent:disable_physics()
        item_obj:set_attach(cart.object, "", {x=0, y=0, z=0}, {x=0, y=0, z=0})
        cart.attached_items[#cart.attached_items + 1] = item_obj
    end
end

--removes all itemstacks from the cart
function empty_cart(cart)
  for _, obj in pairs(cart.attached_items) do
    if obj then
      local ent = obj:get_luaentity()
      if ent then
          obj:remove()
      end
    end
  end
end

-- Checks if the cart is moving and if stopped check for a structure next to it.
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
			if direction:get_string("infotext") == "collector" then
				resources = direction:get_inventory()
				for i, lump in ipairs(lumps) do
					while (resources:contains_item("main", (lump .. " 10"))) do
						resources:remove_item("main", (lump .. " 10"))
            if self.cartInv[lump] == nil then 
              self.cartInv[lump] = 0 
            end
            self.cartInv[lump] = self.cartInv[lump] + 10
            attach_to_cart(self, lump .. " 10")
					end
				end
			elseif direction:get_string("infotext") == "depot" then
				resources = direction:get_inventory()
				for i, lump in ipairs(lumps) do
          if self.cartInv[lump] == nil then 
            self.cartInv[lump] = 0
          end
          if self.cartInv[lump] > 0 then
            resources:add_item("main", lump .. " " .. self.cartInv[lump])
            self.cartInv[lump] =  0
          end
				end
        empty_cart(self)
			end
		end
	end
end

function cart_entity:on_step(dtime)
  structure_check(self, dtime)
	rail_on_step(self, dtime)
	rail_sound(self, dtime)
end

minetest.register_entity("carts:cart", cart_entity)

minetest.register_craftitem("carts:cart", {
	description = ("Cart") .. "\n" .. ("(Sneak+Click to pick up)"),
	inventory_image = minetest.inventorycube("carts_cart_top.png", "carts_cart_front.png", "carts_cart_side.png"),
	wield_image = "carts_cart_front.png",
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
		if carts:is_rail(pointed_thing.under) then
			minetest.add_entity(pointed_thing.under, "carts:cart")
		elseif carts:is_rail(pointed_thing.above) then
			minetest.add_entity(pointed_thing.above, "carts:cart")
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
