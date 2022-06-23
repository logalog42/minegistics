--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

fuels = {
    "minegistics_basenodes:coal_lump",
    "minegistics_basenodes:planks"
}

resources = {
    "minegistics_basenodes:coal_lump",
    "minegistics_basenodes:copper_lump",
    "minegistics_basenodes:tin_lump",
    "minegistics_basenodes:iron_lump",
    "minegistics_basenodes:gold_lump",
    "minegistics_basenodes:planks"
  }

farm_resources = {
    "minegistics:fat_resource",
    "minegistics:fruit_resource",
    "minegistics:leather_resource",
    "minegistics:meat_resource",
    "minegistics:vessels_milk_bottle_resource",
}

workshop_recipes = {
    ["minegistics_basenodes:planks"] = "minegistics:coal_product",
    ["minegistics_basenodes:coal_lump"] = "minegistics:coal_product",
    ["minegistics_basenodes:copper_lump"] = "minegistics:copper_wire",
    ["minegistics_basenodes:gold_lump"] = "minegistics:gold_product",
    ["minegistics_basenodes:iron_lump"] = "minegistics:iron_product",
    ["minegistics_basenodes:tin_lump"] = "minegistics:tin_product",
}

factory_recipes = {
    ["minegistics:mechanical_parts"] = {"minegistics:iron_product", "minegistics:copper_wire"},
    ["minegistics:building_material_good"] = {"minegistics:iron_product", "minegistics:minegistics_basenodes:planks"},
    ["minegistics:toy_good"] = {"minegistics:tin_product", "minegistics:minegistics_basenodes:planks"}
}

item_worth = {
    ["minegistics:fat_resource"] = 1,
    ["minegistics:fruit_resource"] = 1,
    ["minegistics:leather_resource"] = 1,
    ["minegistics:meat_resource"] = 1,
    ["minegistics:vessels_milk_bottle_resource"] = 1,
    ["minegistics_basenodes:coal_lump"] = 2,
    ["minegistics_basenodes:planks"] = 2,
    ["minegistics_basenodes:tin_lump"] = 2,
    ["minegistics_basenodes:iron_lump"] = 2,
    ["minegistics_basenodes:copper_lump"] = 4,
    ["minegistics_basenodes:gold_lump"] = 6,
    ["minegistics:coal_product"] = 3,
    ["minegistics:tin_product"] = 3,
    ["minegistics:iron_product"] = 3,
    ["minegistics:copper_product"] = 6,
    ["minegistics:gold_product"] = 8,
    ["minegistics:building_material_good"] = 10,
    ["minegistics:toy_good"] = 10,
    ["minegistics:mechanical_parts"] = 12
}

minetest.register_craftitem("minegistics:coal_product", {
    description = ("Coal Product: Produced by workshops using coal lumps."),
    inventory_image = "coal_product.png",
})

minetest.register_craftitem("minegistics:copper_product", {
    description = ("Copper Product: Produced by workshops using copper lumps."),
    inventory_image = "copper_product.png"
})

minetest.register_craftitem("minegistics:copper_wire", {
    description = ("Copper Wire: Produced by workshops using copper lumps."),
    inventory_image = "copper_wire_product.png"
})

minetest.register_craftitem("minegistics:mechanical_parts", {
    description = ("Mechanical Parts: Produced by factories using copper wire and iron product."),
    inventory_image = "mechanical_parts_product.png"
})

minetest.register_craftitem("minegistics:tin_product", {
    description = ("Tin Product: Produced by workshops using tin lumps."),
    inventory_image = "tin_product.png"
})

minetest.register_craftitem("minegistics:gold_product", {
    description = ("Gold Product: Produced by workshops using gold lumps."),
    inventory_image = "gold_product.png"
})

minetest.register_craftitem("minegistics:iron_product", {
    description = ("Iron Product: Produced by workshops using iron lumps."),
    inventory_image = "iron_product.png"
})

minetest.register_craftitem("minegistics:building_material_good", {
    description = ("Building Materials: Produced by factories using iron product and lumber."),
    inventory_image = "building_material_good.png"
})

minetest.register_craftitem("minegistics:toys_good", {
    description = ("Iron Product: Produced by workshops using tin product and lumber."),
    inventory_image = "toys_good.png"
})

minetest.register_craftitem("minegistics:fat_resource", {
    description = ("Fat: Produced by farms."),
    inventory_image = "fat_resource.png"
})

minetest.register_craftitem("minegistics:fruit_resource", {
    description = ("Fruit: Produced by farms."),
    inventory_image = "fruit_resource.png"
})

minetest.register_craftitem("minegistics:leather_resource", {
    description = ("Leather: Produced by farms."),
    inventory_image = "leather_resource.png"
})

minetest.register_craftitem("minegistics:meat_resource", {
    description = ("Meat: Produced by farms."),
    inventory_image = "meat_resource.png"
})

minetest.register_craftitem("minegistics:vessels_milk_bottle_resource", {
    description = ("Milk: Produced by farms."),
    inventory_image = "vessels_milk_bottle_resource.png"
})
