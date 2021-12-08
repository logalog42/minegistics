local storage_ref = minetest.get_mod_storage()
local stored_centerpos = {}
local check = storage_ref:get_string("spawnbuilder_centerpos_x")
if check ~= "" then
	stored_centerpos.x = storage_ref:get_int("spawnbuilder_centerpos_x")
	stored_centerpos.y = storage_ref:get_int("spawnbuilder_centerpos_y")
	stored_centerpos.z = storage_ref:get_int("spawnbuilder_centerpos_z")
	minetest.log("action", "[spawnbuilder] Spawn platform position loaded: "..minetest.pos_to_string(stored_centerpos))
else
	stored_centerpos = minetest.setting_get_pos("static_spawnpoint")
	-- Default position
	if not stored_centerpos then
		stored_centerpos = { x=0, y=-1, z=0 }
	end
	storage_ref:set_int("spawnbuilder_centerpos_x", stored_centerpos.x)
	storage_ref:set_int("spawnbuilder_centerpos_y", stored_centerpos.y)
	storage_ref:set_int("spawnbuilder_centerpos_z", stored_centerpos.z)
	minetest.log("action", "[spawnbuilder] Initial spawn platform position registered and saved: "..minetest.pos_to_string(stored_centerpos))
end

-- Width of the stored_centerpos platform
local WIDTH
check = storage_ref:get_string("spawnbuilder_width")
if check ~= "" then
	WIDTH = check
else
	WIDTH = tonumber(minetest.settings:get("spawnbuilder_width"))
	if type(WIDTH) == "number" then
		WIDTH = math.floor(WIDTH)
	else
		WIDTH = 33
	end
end
minetest.log("action", "[spawnbuilder] Using spawn platform width of "..WIDTH..".")

-- Height of the platform
local HEIGHT = 2

-- Number of air layers above the platform
local AIRSPACE = 3

-- Testing noise NOISE_PARAMS
local NOISE_PARAMS =
   {
      offset = 0,
      scale = 1,
      spread = { x = 100, y = 100, z = 100 },
      seed = 23,
      octaves = 3,
      persist = 0.70
   };
local SIZE = { x = 100, y = 100, z = 100 };


local function logResult(context, obj)
   local msg = (obj and "good") or "nil";
   minetest.log("error", context.." returned "..msg.." object");
end


-- Generates the platform or platform piece within minp and maxp with the center at centerpos
local function generate_platform(minp, maxp, centerpos)
	-- Get stone and cobble nodes, based on the mapgen aliases. This allows for great compability with practically
	-- all subgames!
   local c_gravel = minetest.get_content_id("mapgen_gravel")
   local c_river = minetest.get_content_id("mapgen_river_water_source")
   local c_grass = minetest.get_content_id("mapgen_dirt_with_grass")
   local c_sand = minetest.get_content_id("mapgen_sand")
	local c_stone = minetest.get_content_id("mapgen_stone")
	local c_cobble
	if minetest.registered_aliases["mapgen_cobble"] == "air" or minetest.registered_aliases["mapgen_cobble"] == nil then
		-- Fallback option: If cobble mapgen alias is inappropriate or missing, use stone instead.
		c_cobble = c_stone
	else
		c_cobble = minetest.get_content_id("mapgen_cobble")
	end

	local w_neg, w_pos
	w_pos = math.floor(WIDTH / 2)
	if math.fmod(WIDTH, 2) == 0 then
		w_neg = -w_pos + 1
	else
		w_neg = -w_pos
	end

	local xmin = math.max(centerpos.x + w_neg, minp.x)
	local xmax = math.min(centerpos.x + w_pos, maxp.x)
	local zmin = math.max(centerpos.z + w_neg, minp.z)
	local zmax = math.min(centerpos.z + w_pos, maxp.z)
	local ymin = math.max(centerpos.y - (HEIGHT-1), minp.y)
	local ymax = math.min(centerpos.y + AIRSPACE, maxp.y)

	if maxp.x >= xmin and minp.x <= xmax and maxp.y >= ymin and minp.y <= ymax and maxp.z >= zmin and minp.z <= zmax then
		local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
		local data = vm:get_data()
		local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})

      -- Loop throught all the positions
		for x = xmin, xmax do
			for y = ymin, ymax do
				for z = zmin, zmax do
               local p_pos = area:index(x, y, z)
					local pos = {x=x,y=y,z=z}
					if minetest.registered_nodes[minetest.get_node(pos).name].is_ground_content == true then

                  if y <= centerpos.y then
							if x == centerpos.x and y == centerpos.y and z == centerpos.z then
								data[p_pos] = c_cobble
								minetest.log("action", "[spawnbuilder] Spawn platform center generated at "..minetest.pos_to_string(pos)..".")
                     -- Generates the top layer of the platform
                     elseif y == centerpos.y then
                        randomNumber = math.random(1, 100)
                        if randomNumber >= 1 and randomNumber < 5 then
                           data[p_pos] = c_cobble
                        elseif randomNumber >= 5 and randomNumber < 10 then
                           data[p_pos] = c_gravel
                        elseif randomNumber >= 10 and randomNumber < 15 then
                           data[p_pos] = c_river
                        elseif randomNumber >= 15 and randomNumber < 20 then
                           data[p_pos] = c_sand
                        elseif randomNumber >= 20 and randomNumber < 25 then
                           data[p_pos] = c_stone
                        else
                           data[p_pos] = c_grass
                        end
                     else
								data[p_pos] = c_stone
							end
						elseif y >= centerpos.y + 1 and y <= ymax then
							data[p_pos] = core.CONTENT_AIR
						end
					end
				end
			end
		end

		vm:set_data(data)
		vm:calc_lighting()
		vm:write_to_map()
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	local centerpos = table.copy(stored_centerpos)

	if minp.x <= centerpos.x and maxp.x >= centerpos.x and minp.y <= centerpos.y and maxp.y >= centerpos.y and minp.z <= centerpos.z and maxp.z >= centerpos.z then
		if not WIDTH or WIDTH <= 0 then
			minetest.log("warning", "[spawnbuilder] Invalid spawnbuilder_width. Spawn platform will NOT be generated.")
			return
		end

		local ground = false
		local air = true
		-- Check for solid ground
		for y = 3, -6, -1 do
			local nn = minetest.get_node({x=centerpos.x, y=centerpos.y+y, centerpos.z}).name
			local walkable = minetest.registered_nodes[nn].walkable
			if y >= 0 and nn ~= "air" then
				air = false
			elseif y < 0 and walkable then
				ground = true
			end
		end
		-- Player has enough space and ground to spawn safely. No change required
		if air and ground then
			minetest.log("action", "[spawnbuilder] Safe player spawn detected. Spawn platform will NOT be generated.")
			return
		end
	end

	generate_platform(minp, maxp, centerpos)
end)
