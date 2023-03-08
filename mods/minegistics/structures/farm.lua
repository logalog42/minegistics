--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

local abm_timer = 0

minetest.register_node("minegistics:Farm", {
   description = "Farm: Produces goods.\n" ..
    "Place on a grass node and connect to a\n" ..
    "market with rails and a train.",
   tiles = {"buildings.png"},
   groups = {dig_immediate=2, structures=1},
   drawtype = 'mesh',
   mesh = "farm.obj",
   wield_image = "farm_wield.png",
   inventory_image = "farm_wield.png",
   on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.above.y ~= 0 then
        minetest.chat_send_player(placer:get_player_name(), "You can't build here.")
        return
        end
        return minetest.item_place(itemstack, placer, pointed_thing)
    end,
   on_construct = function(pos)
      table.insert(power_consumers, pos)
      local meta = minetest.get_meta(pos)
      meta:set_string("formspec",
          "size[8,9]"..
          "list[context;main;0,0;8,4;]"..
          "list[current_player;main;0,5;8,4;]" ..
          "listring[]")
      meta:set_string("infotext", "Farm")
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
    nodenames = {"minegistics:Farm"},
    interval = 1,
    chance = 1,
    action = function(pos)
        abm_timer = abm_timer + 1
        if abm_timer >= math.random(8, 12) then
            minetest.forceload_block(pos, false)
            if power_stable(pos) then
                local under = minetest.get_node(vector.new(pos.x, pos.y - 1, pos.z))
                if under.name == "basenodes:dirt_with_grass" then
                    local rand = math.random(1, 5)
                    local resource = farm_resources[rand]
                    local meta = minetest.get_meta(pos)
                    local inv = meta:get_inventory()
                    local stack = ItemStack(resource)
                    stack:set_count(10)
                    if inv:add_item("main", stack) then
                        minetest.sound_play('farm', {
                            pos = pos,
                            loop = false,
                            max_hear_distance = 16
                        })
                        if minetest.settings:get_bool("minegistics_particles", true) then
                            minetest.add_particlespawner({
                                amount = 10,
                                time = 1,
                                minpos = {x=pos.x,y=pos.y+1,z=pos.z},
                                maxpos = {x=pos.x,y=pos.y+2,z=pos.z},
                                minvel = {x=0.1, y=0.1, z=0.1},
                                maxvel = {x=0.2, y=0.2, z=0.2},
                                minacc = {x=-0.1,y=0.1,z=-0.1},
                                maxacc = {x=0.2,y=0.2,z=0.2},
                                minexptime = 1,
                                maxexptime = 2,
                                minsize = 2,
                                maxsize = 4,
                                collisiondetection = false,
                                vertical = false,
                                texture = "dirt.png"
                            })
                        end
                    end
                end
            end
            abm_timer = 0
        end
    end
})
