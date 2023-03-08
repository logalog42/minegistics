--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

minetest.register_node("minegistics:Town", {
  description = "Town: Required to earn money from markets.\n" ..
    "Connect to a market with rails and add a train.",
  tiles = {"buildings.png"},
  groups = {dig_immediate=2, structures=1},
  drawtype = 'mesh',
  mesh = "town.obj",
  wield_image = "town_wield.png",
  inventory_image = "town_wield.png",
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
      meta:set_string("infotext", "Town")
  end,
  after_dig_node = function(pos, oldnode, oldmetadata, digger)
      for i,p in pairs(power_consumers) do
          if p.x == pos.x and p.y == pos.y and p.z == pos.z then
              table.remove(power_consumers, i)
              break
          end
      end
  end
})
