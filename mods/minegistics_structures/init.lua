minetest.register_node("minegistics_structures:Collector", {
   description = " Building to gather resources",
   tiles = {"minegistics_structures_collector.png"},
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
