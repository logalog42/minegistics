-- carts/init.lua

carts = {}
carts.modpath = minetest.get_modpath("carts")
carts.railparams = {}

-- Maximal speed of the cart in m/s (min = -1)
carts.speed_max = 7
-- Set to -1 to disable punching the cart from inside (min = -1)
carts.punch_speed_max = 5
-- Maximal distance for the path correction (for dtime peaks)
carts.path_distance_max = 3


dofile(carts.modpath.."/functions.lua")
dofile(carts.modpath.."/rails.lua")
dofile(carts.modpath.."/cart_entity.lua")

minetest.register_abm({
    nodenames = {"carts:cart_entity"},
    neighbors = {"minegistics_structures:minegistics_structures_collector"},
    interval = 1, -- Run every 1 second
    chance = 1, -- Select every 1 in 1 node
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta({ x = pos.x, y = pos.y, z = pos.z })
      if meta:get_int("iron") < 100 then
         meta:set_int("iron", (meta:get_int("iron") + 1))
      end
    end
})
