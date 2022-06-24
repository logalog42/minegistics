--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

local ores = {
    "minegistics_basenodes:stone_with_coal",
    "minegistics_basenodes:stone_with_iron",
    "minegistics_basenodes:stone_with_tin",
    "minegistics_basenodes:stone_with_copper",
    "minegistics_basenodes:stone_with_gold"
}

minetest.register_on_generated(function(minp, maxp, blockseed)
if minp.y > 0 or maxp.y < 0 then return end
   local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
   local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
   local data = vm:get_data()
   for z = minp.z, maxp.z do
      for x = minp.x, maxp.x do
         for y = -1,-1,1 do
            local vi = area:index(x, y, z)
            local rand_gen = math.random(1,100)
            if rand_gen >= 2 then
               local rand_node = math.random(1,100)
               if rand_node >= 15 then
                  data[area:index(x, y, z)] = minetest.get_content_id("minegistics_basenodes:dirt_with_grass")
               else
                  data[area:index(x, y, z)] = minetest.get_content_id("minegistics_basenodes:stone")
               end
            else
               local rand_ore = math.random(1,100)
               if rand_ore >= 70 then
                  local max = rand_ore >= 90 and 5 or rand_ore >= 80 and 4 or 3
                  local rand_node = math.random(1, max)
                  data[area:index(x, y, z)] = minetest.get_content_id(ores[rand_node])
               else
                  local rand_node = math.random(1,100)
                  if rand_node >= 15 then
                     data[area:index(x, y, z)] = minetest.get_content_id("minegistics_basenodes:dirt_with_grass")
                  else
                     data[area:index(x, y, z)] = minetest.get_content_id("minegistics_basenodes:dirt_with_grass")
                     data[area:index(x, y+1, z)] = minetest.get_content_id("minegistics_basenodes:tree")
                  end
               end
            end
         end
      end
   end
vm:set_data(data)
vm:write_to_map(data)
end
)
