minetest.register_node("minegistics_structures:Collector", {
   description = " Building to gather resources",
   tiles = {"minegistics_structures_collector.png"},
})

minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
    neighbors = {"basenodes:stone_with_coal"},
    interval = 1, -- Run every 10 seconds
    chance = 1, -- Select every 1 in 50 nodes
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta({ x = pos.x, y = pos.y, z = pos.z })
      meta:set_int("coal", (meta:get_int("coal") + 1))
    end
})

minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
    neighbors = {"basenodes:stone_with_iron"},
    interval = 1, -- Run every 10 seconds
    chance = 1, -- Select every nodes
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta({ x = pos.x, y = pos.y, z = pos.z })
      meta:set_int("iron", (meta:get_int("iron") + 1))
    end
})

minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
    neighbors = {"basenodes:stone_with_copper"},
    interval = 1, -- Run every 10 seconds
    chance = 1, -- Select every 1 in 50 nodes
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta({ x = pos.x, y = pos.y, z = pos.z })
      meta:set_int("copper", (meta:get_int("copper") + 1))
    end
})

minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
    neighbors = {"basenodes:stone_with_tin"},
    interval = 1, -- Run every 10 seconds
    chance = 1, -- Select every 1 in 50 nodes
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta({ x = pos.x, y = pos.y, z = pos.z })
      meta:set_int("tin", (meta:get_int("tin") + 1))
    end
})

minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
    neighbors = {"basenodes:stone_with_gold"},
    interval = 1, -- Run every 10 seconds
    chance = 1, -- Select every 1 in 50 nodes
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta({ x = pos.x, y = pos.y, z = pos.z })
      meta:set_int("gold", (meta:get_int("gold") + 1))
    end
})


minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
    neighbors = {"basenodes:cobblestone"},
    interval = 1, -- Run every 10 seconds
    chance = 1, -- Select every 1 in 50 nodes
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta({ x = pos.x, y = pos.y, z = pos.z })
      meta:set_int("stone", (meta:get_int("stone") + 1))
    end
})

minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
    neighbors = {"basenodes:gravel"},
    interval = 1, -- Run every 10 seconds
    chance = 1, -- Select every 1 in 50 nodes
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta({ x = pos.x, y = pos.y, z = pos.z })
      meta:set_int("gravel", (meta:get_int("gravel") + 1))
    end
})

minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
    neighbors = {"basenode:sand"},
    interval = 1, -- Run every 10 seconds
    chance = 1, -- Select every 1 in 50 nodes
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta({ x = pos.x, y = pos.y, z = pos.z })
      meta:set_int("sand", (meta:get_int("sand") + 1))
    end
})



minetest.register_node("minegistics_structures:Factory", {
   description = " Take resources output goods",
   tiles = {"minegistics_structures_factory.png"},
})

minetest.register_node("minegistics_structures:Market", {
   description = " Building changes any resources into money",
   tiles = {"minegistics_structures_market.png"},
})

minetest.register_node("minegistics_structures:Town", {
   description = " Building changes specific resources into money",
   tiles = {"minegistics_structures_town.png"},
})

minetest.register_node("minegistics_structures:Warehouse", {
   description = " Building to store any resource",
   tiles = {"minegistics_structures_warehouse.png"},
})
