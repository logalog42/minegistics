--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

local abm_timer = 0

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
          "list[context;main;0,0;8,4;]"..
          "list[current_player;main;0,5;8,4;]" ..
          "listring[]")
      meta:set_string("infotext", "Collector")
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
    interval = 1,
    chance = 1,
    action = function(pos)
        abm_timer = abm_timer + 1
        if abm_timer >= math.random(8, 12) then
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
                            minetest.sound_play('collector', {
                                pos = pos,
                                loop = false,
                                max_hear_distance = 16
                            })
                            if minetest.settings:get_bool("minegistics_particles", true) then
                                minetest.add_particlespawner({
                                    amount = 300,
                                    time = 3,
                                    minpos = {x=pos.x,y=pos.y+1,z=pos.z},
                                    maxpos = {x=pos.x,y=pos.y+2,z=pos.z},
                                    minvel = {x=0.1, y=0.1, z=0.1},
                                    maxvel = {x=0.1, y=0.2, z=0.1},
                                    minacc = {x=-0.1,y=0.1,z=-0.1},
                                    maxacc = {x=0.1,y=0.2,z=0.1},
                                    minexptime = 1,
                                    maxexptime = 2,
                                    minsize = 10,
                                    maxsize = 12,
                                    collisiondetection = false,
                                    vertical = false,
                                    texture = "dirt.png"
                                })
                            end
                         end
                      end
                   end
                end
            end
            abm_timer = 0
        end
    end
})
