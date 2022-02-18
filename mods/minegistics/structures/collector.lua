--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

minetest.register_node("minegistics:Collector", {
   description = "Collector: Gathers resources.\n" ..
    "Place on a resource node and connect to a\n" ..
    "factory or market with rails and a train.",
   tiles = {"buildings.png"},
   groups = {dig_immediate=2, structures=1},
   drawtype = 'mesh',
   mesh = "collector.obj",
   wield_image = "collector_wield.png",
   inventory_image = "collector_wield.png",
   on_construct = function(pos)
      table.insert(power_consumers, pos)
      local meta = minetest.get_meta(pos)
      meta:set_string("formspec",
          "size[8,9]"..
          "list[current_name;main;0,0;8,4;]"..
          "list[current_player;main;0,5;8,4;]" ..
          "listring[]")
      meta:set_string("infotext", "collector")
      local inv = meta:get_inventory()
      inv:set_size("main", 5*1)
  end,
  after_dig_node = function(pos, oldnode, oldmetadata, digger)
      for i,p in pairs(power_consumers) do
          if p.x == pos.x and p.y == pos.y and p.z == pos.z then
              table.remove(power_consumers, i)
              break
          end
      end
      minetest.forceload_free_block(pos, false)
  end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
     return stack:get_count()
  end
})

minetest.register_abm({
    nodenames = {"minegistics:Collector"},
    interval = 10,
    chance = 1,
    action = function(pos)
        minetest.forceload_block(pos, false)
        if power_stable(pos) then
            local next_to = {
               vector.new(pos.x, pos.y - 1, pos.z),
               vector.new(pos.x + 1, pos.y, pos.z),
               vector.new(pos.x - 1, pos.y, pos.z),
               vector.new(pos.x, pos.y, pos.z + 1),
               vector.new(pos.x, pos.y, pos.z - 1)
            }

            for node,ore in pairs(base_ores) do
               for key,direction in ipairs(next_to) do
                  if minetest.get_node(direction).name == node then
                     local meta = minetest.get_meta(pos)
                     local inv = meta:get_inventory()
                     local stack = ItemStack(ore)
                     stack:set_count(10)
                     if inv:add_item("main", stack) then
                        smoke(pos)
                     end
                  end
               end
            end
        end
    end
})
