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
    offset = -5,
     scale = 10,
     spread = {x = 10, y = 10, z = 10},
     seed = 0,
     octaves = 2,
     persistence = 0.5,
     lacunarity = 2.0,
     flags = "defaults",
  }

    local start = { x = minp.x, y = 0, z = minp.z}
    local finish = {x = maxp.x, y = 0, z = maxp.z}

    local perlin = minetest.get_perlin(np_mountains)

    local vm, emin, emax = minetest.get_voxel_manip(start, finish)
    local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
    local data = vm:get_data()
    for loopz = minp.z, maxp.z do
      for loopx = minp.x, maxp.x do
        local vi = area:index(loopx, 0, loopz)
        local pos = { x = loopx, y = 0, z = loopz}
        local current_perlin = perlin:get_3d(pos)

        --new perlin generating
        --Mountain locations
        if  current_perlin > 1 then
          data[area:index(loopx, 0, loopz)] = minetest.get_content_id("basenodes:stone")
        --Edge around mountain for ore generation
        elseif current_perlin <= 1 and current_perlin >= 0 then
          local rand_ore = math.random(1,100)
          if rand_ore >= 70 then
             local max = rand_ore >= 90 and 5 or rand_ore >= 80 and 4 or 3
             local rand_node = math.random(1, max)
             data[area:index(loopx, 0, loopz)] = minetest.get_content_id(ores[rand_node])
          else
            local rand_node = math.random(1,100)
            data[area:index(loopx, 0, loopz)] = minetest.get_content_id("basenodes:stone")
          end
        --Everything else is grass
        else
          data[area:index(loopx, 0, loopz)] = minetest.get_content_id("basenodes:dirt_with_grass")
        end
     end
 end
vm:set_data(data)
vm:write_to_map(data)
end
)
