function trains:get_sign(z)
	if z == 0 then
		return 0
	else
		return z / math.abs(z)
	end
end

function trains:velocity_to_dir(v)
	if math.abs(v.x) > math.abs(v.z) then
		return {x=trains:get_sign(v.x), y=trains:get_sign(v.y), z=0}
	else
		return {x=0, y=trains:get_sign(v.y), z=trains:get_sign(v.z)}
	end
end

function trains:is_rail(pos, railtype)
	local node = minetest.get_node(pos).name
	if node == "ignore" then
		local vm = minetest.get_voxel_manip()
		local emin, emax = vm:read_from_map(pos, pos)
		local area = VoxelArea:new{
			MinEdge = emin,
			MaxEdge = emax,
		}
		local data = vm:get_data()
		local vi = area:indexp(pos)
		node = minetest.get_name_from_content_id(data[vi])
	end
	if minetest.get_item_group(node, "rail") == 0 then
		return false
	end
	if not railtype then
		return true
	end
	return minetest.get_item_group(node, "connect_to_raillike") == railtype
end

function trains:get_rail_direction(pos_, dir, old_switch, railtype)
	local pos = vector.round(pos_)
	local cur
	local left_check, right_check = true, true

	-- Check left and right
	local left = {x=0, y=0, z=0}
	local right = {x=0, y=0, z=0}
	if dir.z ~= 0 and dir.x == 0 then
		left.x = -dir.z
		right.x = dir.z
	elseif dir.x ~= 0 and dir.z == 0 then
		left.z = dir.x
		right.z = -dir.x
	end

	local straight_priority = dir.y ~= 0

	-- Normal, to disallow rail switching up- & downhill
	if straight_priority then
		cur = self:check_front_up_down(pos, dir, true, railtype)
		if cur then
			return cur
		end
	end

	-- Normal
	if not straight_priority then
		cur = self:check_front_up_down(pos, dir, true, railtype)
		if cur then
			return cur
		end
	end

	-- Left, if not already checked
	if left_check then
		cur = trains:check_front_up_down(pos, left, false, railtype)
		if cur then
			return cur
		end
	end

	-- Right, if not already checked
	if right_check then
		cur = trains:check_front_up_down(pos, right, false, railtype)
		if cur then
			return cur
		end
	end

	-- Backwards
	if not old_switch then
		cur = trains:check_front_up_down(pos, {
				x = -dir.x,
				y = dir.y,
				z = -dir.z
			}, true, railtype)
		if cur then
			return cur
		end
	end

	return {x=0, y=0, z=0}
end

function trains:check_front_up_down(pos, dir_, check_up, railtype)
	local dir = vector.new(dir_)
	local cur
 
	-- Front
	dir.y = 0
	cur = vector.add(pos, dir)
	if trains:is_rail(cur, railtype) then
		return dir
	end
	-- Up
	if check_up then
		dir.y = 1
		cur = vector.add(pos, dir)
		if trains:is_rail(cur, railtype) then
			return dir
		end
	end
	-- Down
	dir.y = -1
	cur = vector.add(pos, dir)
	if trains:is_rail(cur, railtype) then
		return dir
	end
	return nil
end

function trains:pathfinder(pos_, old_pos, old_dir, distance,
  pf_switch, railtype)

	local pos = vector.round(pos_)
	if vector.equals(old_pos, pos) then
		return
	end

	local pf_pos = vector.round(old_pos)
	local pf_dir = vector.new(old_dir)
	distance = math.min(trains.path_distance_max,
		math.floor(distance + 1))

	for i = 1, distance do
		pf_dir, pf_switch = self:get_rail_direction(
			pf_pos, pf_dir, pf_switch or 0, railtype)

		if vector.equals(pf_dir, {x=0, y=0, z=0}) then
			-- No way forwards
			return pf_pos, pf_dir
		end

		pf_pos = vector.add(pf_pos, pf_dir)

		if vector.equals(pf_pos, pos) then
			-- Success! train moved on correctly
			return
		end
	end
	-- Not found. Put train to predicted position
	return pf_pos, pf_dir
end

function trains:register_rail(name, def, railparams)
    if railparams then
        trains.railparams[name] = table.copy(railparams)
    end
    minetest.register_node(name, def)
end
