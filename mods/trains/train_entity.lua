--[[
	Minegistics
		logalog
		Droog71
	License: AGPLv3


	TODO:
		Disable train labels displaying state before PR
		Set a limit to the size train will take from a location
	Maybe:
		corelate train sound to train speed
]]--



local function spawn_passengers(train, pos)
	if math.random(1, 20) == 1 then
	-- if train.crowd_sound then
		minetest.sound_play("trains_people", {
			pos = pos,
			loop = false,
			max_hear_distance = 5,
		})
		train.crowd_sound = false
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


local function play_rail_sound(train)
	if not train.sound_handle then
		local speed = train.object:get_velocity():length()
		train.sound_handle = minetest.sound_play("trains_train_moving", {
			object = train.object,
			gain = 0.75,
			max_hear_distance = 10,
			loop = true,
		})
	end
end
local function stop_rail_sound(train)
	if train.sound_handle then
		minetest.sound_stop(train.sound_handle)
		train.sound_handle = nil
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
				train.passengers = true
				spawn_passengers(train, pos)
			elseif structure_name == "minegistics:Market" and train.passengers == true then
				minetest.get_meta(direction):set_int("has_town", 1)
				spawn_passengers(train, pos)
				train.passengers = true
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


local function train_drive(train, dtime)
	train.smoke_timer = train.smoke_timer - dtime
	if train.smoke_timer <= 0 then
		train.smoke_timer = nil
		minetest.add_particle({
			pos = train.object:get_pos(),
			texture = "black_smoke.png",
			expirationtime = 1.5,
			velocity = vector.new(0, 0.75, 0),
			acceleration = vector.new(0, -0.5, 0),
		})
	end

	local new_pos, new_dir, stop = trains.get_next_pos(train, dtime)
	train.object:set_yaw(trains.dir_to_yaw(new_dir))
	train.object:move_to(new_pos, false)
	-- train.object:set_pos(new_pos)
	if stop then
		train.state = "stopped"
		stop_rail_sound(train)
	else
		play_rail_sound(train)
	end
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

	pause_timer = 1,
	smoke_timer = 0.3,
	speed = 1,
	state = "pause",

	passengers = false,
	supply_train = false,
	crowd_sound = false,

	sound_handle = nil,

	on_activate = function(self, staticdata, dtime_s)
		self.object:set_armor_groups({immortal=1})
		if string.sub(staticdata, 1, string.len("return")) ~= "return" then
			return
		end
		local data = minetest.deserialize(staticdata)
		if type(data) ~= "table" then
			return
		end
		self.train_inv = data.train_inv
		self.passengers = data.passengers
		self.supply_train = data.supply_train
		table.insert(train_cargo, get_object_id(self.object), {})
	end,

	on_deactivate = function(self, removal)
		stop_rail_sound(self)
	end,

	get_staticdata = function(self)
		return minetest.serialize({
			passengers = self.passengers,
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
		-- train_drive(self, dtime)
		self.object:set_properties({
			nametag = self.state,
		})
		if self.state == "driving" then
			train_drive(self, dtime)
		elseif self.state == "stopped" then
			structure_check(self, dtime)
			self.state = "pause"
			-- self.pause_timer = 1
		elseif self.state == "pause" then
			self.pause_timer = self.pause_timer - dtime
			if self.pause_timer <= 0 then
				self.pause_timer = nil
				self.state = "driving"
			end
		elseif self.state == "loading" then
			structure_check(self, dtime)
		end
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

		if not minetest.is_creative_enabled(placer:get_player_name()) then
			itemstack:take_item()
		end

		return itemstack
	end,
})
