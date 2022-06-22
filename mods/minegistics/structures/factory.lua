--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

local abm_timer = 0

minetest.register_node("minegistics:Factory", {
   description = "Factory: Converts resources into products.\n" ..
    "Both can be sold but products are worth more.",
   tiles = {"buildings.png"},
   groups = {dig_immediate=2, structures=1},
   drawtype = 'mesh',
   mesh = "factory.obj",
   wield_image = "factory_wield.png",
   inventory_image = "factory_wield.png",
   on_construct = function(pos)
      table.insert(power_consumers, pos)
      local meta = minetest.get_meta(pos)
      meta:set_string("formspec",
          "size[8,9]"..
          "list[context;main;0,0;8,4;]"..
          "list[current_player;main;0,5;8,4;]" ..
          "listring[]")
      meta:set_string("infotext", "Factory")
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
	can_dig = function(pos,player)
      local meta = minetest.get_meta(pos);
      local inv = meta:get_inventory()
      return inv:is_empty("main")
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
      return stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
      return stack:get_count()
	end
})

--converts resources into products
minetest.register_abm({
    nodenames = {"minegistics:Factory"},
    interval = 1,
    chance = 1,
    action = function(pos)
        abm_timer = abm_timer + 1
        if abm_timer >= math.random(8, 16) then
            minetest.forceload_block(pos, false)
            if power_stable(pos) then
                local meta = minetest.get_meta(pos)
                local inv = meta:get_inventory()
                local items = {}
                local working = false
                for _,lump in pairs(resources) do
                    items[lump] = ItemStack(lump)
                end
                local inventories = inv:get_lists()
                for name, list in pairs(inventories) do
                    for index, item in pairs(items) do
                        while inv:contains_item(name, items[index]) do
                            local item_name = items[index]:get_name()
                            local item_amount = items[index]:get_count()
                            local product = products[item_name]
                            inv:remove_item(name, items[index])
                            stack = ItemStack(product)
                            stack:set_count(item_amount)
                            inv:add_item("main", stack)
                            working = true
                        end
                    end
                end
                if working then
                  minetest.sound_play('factory', {
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
                          maxvel = {x=0.2, y=0.2, z=0.2},
                          minacc = {x=-0.1,y=0.1,z=-0.1},
                          maxacc = {x=0.2,y=0.2,z=0.2},
                          minexptime = 6,
                          maxexptime = 8,
                          minsize = 10,
                          maxsize = 12,
                          collisiondetection = false,
                          vertical = false,
                          texture = "smoke.png"
                      })
                  end
                end
            end
            abm_timer = 0
        end
    end
})
