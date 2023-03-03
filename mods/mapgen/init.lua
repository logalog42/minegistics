--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

local ores = {
    "basenodes:stone_with_coal",
    "basenodes:stone_with_iron",
    "basenodes:stone_with_tin",
    "basenodes:stone_with_copper",
    "basenodes:stone_with_gold"
}

minetest.register_on_generated(function(minp, maxp, blockseed)

  local np_mountains = {
    offset = 0,
    scale = 3,
    spread = {x = 10, y = 10, z = 10},
    seed = 800515320,
    octaves = 10,
    persistence = 0.1,
    lacunarity = 1.0,
    flags = "defaults"
  }

  local np_land = {
    offset = 50,
    scale = 50,
    spread = {x = 95, y = 95, z = 95},
    seed = 5349,
    octaves = 3,
    persistence = .5,
    lacunarity = 2,
    flags = "defaults"
  }

  local mountain_perlin = minetest.get_perlin(np_mountains)
  local land_perlin = minetest.get_perlin(np_land)

  local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
  local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
  local data = vm:get_data()

  if minp.y >= -1 or maxp.y <= 1 then
    return
  else
    for loopz = minp.z, maxp.z do
      for loopx = minp.x, maxp.x do
        for loopy = -1, -1, 1 do
          local vi = area:index(loopx, loopy, loopz)
          local pos = { x = loopx, y = loopy, z = loopz}
          local height_perlin = mountain_perlin:get_3d(pos)
          local height_floor_perlin = math.floor(mountain_perlin:get_3d(pos))
          local land_perlin = math.floor(land_perlin:get_3d(pos))

          if land_perlin < 51 then --Land and Sea generating
            --Mountain locations
            if  height_perlin >= 1 then

              --adjacent nodes
              local right_node =       {x = loopx + 1, y = loopy, z = loopz}
              local left_node =        {x = loopx - 1, y = loopy, z = loopz}
              local back_node =        {x = loopx,     y = loopy, z = loopz + 1}
              local front_node =       {x = loopx,     y = loopy, z = loopz - 1}
              --[[
              local right_front_node = {x = loopx + 1, y = loopy, z = loopz - 1}
              local right_back_node =  {x = loopx + 1, y = loopy, z = loopz + 1}
              local left_front_node =  {x = loopx - 1, y = loopy, z = loopz - 1}
              local left_back_node =   {x = loopx - 1, y = loopy, z = loopz + 1}
              ]]--

              local adjacent_node = {right_node, left_node, back_node, front_node}

              --Placing down mountains
              for level = loopy, math.floor(height_perlin) do
                if level >= 2 then
                  data[area:index(loopx, level, loopz)] = minetest.get_content_id("basenodes:snow")
                elseif level == 1 then
                  data[area:index(loopx, level, loopz)] = minetest.get_content_id("basenodes:snow_transition")
                else
                  data[area:index(loopx, level, loopz)] = minetest.get_content_id("basenodes:stone")
                end
              end

              for i, value in ipairs(adjacent_node) do
                if math.floor(mountain_perlin:get_3d(value)) > height_floor_perlin then
                  data[area:index(loopx, height_floor_perlin + 1, loopz)] = minetest.get_content_id("basenodes:snow_slope")
                  data[area:index(loopx, height_floor_perlin + 2, loopz)] = minetest.get_content_id("air")
                elseif math.floor(mountain_perlin:get_3d(value)) < 1 then
                  data[area:index(loopx, height_floor_perlin, loopz)] = minetest.get_content_id("basenodes:snow_slope_transition")
                  data[area:index(loopx, height_floor_perlin + 1, loopz)] = minetest.get_content_id("air")
                end
              end

              --Edge around mountain for ore generation
            elseif height_perlin >= .7 and height_perlin < 1 then
              local rand_ore = math.random(1,200)
              if rand_ore >= 199 then
                local rand_node = math.random(1, 5)
                data[area:index(loopx, loopy, loopz)] = minetest.get_content_id(ores[rand_node])
              elseif rand_ore >= 198 then
                local rand_node = math.random(1, 4)
                data[area:index(loopx, loopy, loopz)] = minetest.get_content_id(ores[rand_node])
              else
                data[area:index(loopx, loopy, loopz)] = minetest.get_content_id("basenodes:stone")
              end

            elseif height_perlin < -2 then
              data[area:index(loopx, loopy, loopz)] = minetest.get_content_id("basenodes:dirt_with_grass")
              data[area:index(loopx, loopy + 1, loopz)] = minetest.get_content_id("basenodes:tree_" .. math.random(1,4))
              
            --Everything else is grass
            else
                data[area:index(loopx, loopy, loopz)] = minetest.get_content_id("basenodes:dirt_with_grass")
            end

          elseif land_perlin < 54 and land_perlin >= 51 then -- Border
            data[area:index(loopx, loopy, loopz)] = minetest.get_content_id("basenodes:sand")
          else --Generating Ocean
            data[area:index(loopx, loopy, loopz)] = minetest.get_content_id("basenodes:water_source")
          end
          for loopy = -2, -2, 1 do
            data[area:index(loopx, loopy, loopz)] = minetest.get_content_id("basenodes:sandstone")
          end
        end
      end
    end
  end
  
  vm:set_data(data)
  vm:write_to_map(data)
end)