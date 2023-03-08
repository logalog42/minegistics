function trains.is_rail(pos)
	local node_name = minetest.get_node(pos).name
	if node_name == "ignore" then
		local vm = minetest.get_voxel_manip()
		local emin, emax = vm:read_from_map(pos, pos)
		local area = VoxelArea:new{
			MinEdge = emin,
			MaxEdge = emax,
		}
		local data = vm:get_data()
		local vi = area:indexp(pos)
		node_name = minetest.get_name_from_content_id(data[vi])
	end
	if minetest.get_item_group(node_name, "rail") ~= 0 then
		return true
	end
end


local directions = {
	vector.new(0, 0, 1),
	vector.new(-1, 0, 0),
	vector.new(1, 0, 0),
	vector.new(0, 1, 0),
	vector.new(0, -1, 0),
	vector.new(0, 0, -1),
}

local a = vector.new(0, 0, 1)
local b = vector.new(-1, 0, 0)
local c = vector.new(1, 0, 0)
local d = vector.new(0, 0, -1)

-- foo
local function yaw_to_dir(yaw)
	yaw = (yaw / math.pi)
	if yaw <= 0.25 then return a, b, c, d
	elseif yaw <= 0.75 then return b, d, a, c
	elseif yaw <= 1.25 then return d, c, b, a
	elseif yaw <= 1.75 then return c, a, d, b
	end
end

function trains.dir_to_yaw(dir)
	if dir.z == 1 then return 0
	elseif dir.x == -1 then return 0.5 * math.pi
	elseif dir.x == 1 then return 1.5 * math.pi
	elseif dir.z == -1 then return math.pi
	end
	return 0.25 * math.pi
end

local vector_zero = vector.zero()
function trains.get_next_pos(train, dtime)
	local pos = train.object:get_pos()
	local node_pos = vector.round(pos)

	local front, left, right, back = yaw_to_dir(train.object:get_yaw())
	local distance = train.speed * dtime

	local new_pos = pos + (front * distance)
	local next_node = new_pos + (front * 0.501)

	-- not prety, but if the train is about to cross the middle of a break_rail node it will stop
	if (pos + (front * 0.501)):round() == node_pos and node_pos ~= next_node:round() and minetest.get_node(node_pos).name == "trains:brake_rail" then
		return node_pos, front, true
	end

	-- if we are standing in the middle of a node we need to decied where to go next
	if pos == node_pos then
		if trains.is_rail(pos + front) then
			return pos + (front * distance), front
		elseif trains.is_rail(pos + left) then
			return pos + (left * distance), left
		elseif trains.is_rail(pos + right) then
			return pos + (right * distance), right
		elseif trains.is_rail(pos + back) then
			return pos + (back * distance), back
		else
			-- there are no surounding nodes
			return pos, vector.zero(), true
		end
	end

	if trains.is_rail(next_node) then
		-- go straight
		return new_pos, front
	else
		if (not trains.is_rail(pos + left)) and (not trains.is_rail(pos + right)) and trains.is_rail(pos + back) then
			-- when we reach a dead end, put in a break
			return node_pos, front, true
		end
		-- if we reach a corner we go to the center of the node
		return node_pos, front
	end

	-- I don't think this is reachable
	return pos, vector.zero(), true
end
