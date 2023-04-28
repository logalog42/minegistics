--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

Base_ores = {
    ["basenodes:stone_with_coal"] = "basenodes:coal_lump",
    ["basenodes:stone_with_tin"] = "basenodes:tin_lump",
    ["basenodes:stone_with_copper"] = "basenodes:copper_lump",
    ["basenodes:stone_with_iron"] = "basenodes:iron_lump",
    ["basenodes:stone_with_gold"] = "basenodes:gold_lump",
    ["basenodes:tree_1"] = "minegistics:lumber",
	["basenodes:tree_2"] = "minegistics:lumber",
	["basenodes:tree_3"] = "minegistics:lumber",
	["basenodes:tree_4"] = "minegistics:lumber",
}

Fuels = {
    "basenodes:coal_lump",
    "minegistics:lumber"
}

Material = {
    "basenodes:coal_lump",
    "basenodes:copper_lump",
    "basenodes:tin_lump",
    "basenodes:iron_lump",
    "basenodes:gold_lump",
    "minegistics:lumber"
  }

Farm_material = {
    "minegistics:fruit",
    "minegistics:wheat",
    "minegistics:cotton"
}

Ranch_material = {
    "minegistics:fat",
    "minegistics:leather",
    "minegistics:meat",
}

Dairy_material = {
    "minegistics:vessels_milk_bottle",
}

Refinery_recipes = {
    ["basenodes:coal_lump"] = "minegistics:coal_coke_product",
    ["basenodes:copper_lump"] = "minegistics:copper_product",
    ["basenodes:gold_lump"] = "minegistics:gold_product",
    ["basenodes:iron_lump"] = "minegistics:iron_product",
    ["basenodes:tin_lump"] = "minegistics:tin_product",
    ["basenodes:fat"] = "minegistics:tallow_product",
    ["basenodes:lumber"] = "minegistics:ash_product",
    ["basenodes:clay"] = "minegistics:Ceramics",
}

Factory_recipes = {
    ["minegistics:luxury_tools"] = {"steel_ingot", "bronze_ingot"},
    ["minegistics:toys"] = {"minegistics:mechanical_parts", "minegistics:copper_wire"},
    ["minegistics:bronze_ingot"] = {"minegistics:copper_ingot", "minegistics:tin_product"},
    ["minegistics:steel_product"] = {"minegistics:coal_coke", "minegistics:iron_ingot"},
    ["minegistics:cement"] = {"minegistics:gravel", "minegistics:sand"},
    ["minegistics:soap"] = {"minegistics:tallow_product", "minegistics:lye"},
    ["minegistics:luxury_furniture"] = {"minegistics:leather", "minegistics:lumber"},
    ["minegistics:furniture"] = {"minegistics:cotton", "minegistics:lumber"},
    ["minegistics:luxury_meal"] = {"minegistics:fruit", "minegistics:vessels_milk_bottle"},
    ["minegistics:simple_meal"] = {"minegistics:wheat", "minegistics:meat"},
}

Workshop_recipes = {
    ["minegistics:iron_product"] = {"minegistics:iron_ingot", "minegistics:mechanical_parts"},
    ["minegistics:copper_product"] = {"minegistics:copper_ingot", "minegistics:copper_wire"},
    ["minegistics:steel_product"] = {"minegistics:building_materials", "minegistics:steel_ingot"},
    ["minegistics:ash"] = {"minegistics:potash", "minegistics:lye"}
}

Item_worth = {
    ["minegistics:fat"] = 1,
    ["minegistics:fruit"] = 1,
    ["minegistics:leather"] = 1,
    ["minegistics:meat"] = 1,
    ["minegistics:vessels_milk_bottle"] = 1,
    ["basenodes:coal_lump"] = 2,
    ["basenodes:tin_lump"] = 2,
    ["basenodes:iron_lump"] = 2,
    ["basenodes:copper_lump"] = 4,
    ["basenodes:gold_lump"] = 6,
    ["minegistics:lumber"] = 2,
    ["minegistics:coal_product"] = 3,
    ["minegistics:tin_product"] = 3,
    ["minegistics:iron_product"] = 3,
    ["minegistics:furniture"] = 4,
    ["minegistics:copper_wire"] = 6,
    ["minegistics:gold_product"] = 8,
    ["minegistics:building_materials"] = 10,
    ["minegistics:toys"] = 10,
    ["minegistics:mechanical_parts"] = 12
}

minetest.register_craftitem("minegistics:coal_product", {
    description = ("Coal Product: Produced by workshops using coal lumps."),
    inventory_image = "coal_product.png",
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

minetest.register_craftitem("minegistics:lumber", {
   description = ("Lumber"),
   inventory_image = "lumber.png"
})

minetest.register_craftitem("minegistics:building_materials", {
    description = ("Building Materials: Produced by factories using iron product and lumber."),
    inventory_image = "building_material_good.png"
})

minetest.register_craftitem("minegistics:toys", {
    description = ("Toys: Produced by factories using tin product and lumber."),
    inventory_image = "toys_good.png"
})

minetest.register_craftitem("minegistics:furniture", {
    description = ("Furniture: Produced by factories using leather and lumber."),
    inventory_image = "furniture_product.png"
})

minetest.register_craftitem("minegistics:fat", {
    description = ("Fat: Produced by farms."),
    inventory_image = "fat_resource.png"
})

minetest.register_craftitem("minegistics:fruit", {
    description = ("Fruit: Produced by farms."),
    inventory_image = "fruit_resource.png"
})

minetest.register_craftitem("minegistics:leather", {
    description = ("Leather: Produced by farms."),
    inventory_image = "leather_resource.png"
})

minetest.register_craftitem("minegistics:meat", {
    description = ("Meat: Produced by farms."),
    inventory_image = "meat_resource.png"
})

minetest.register_craftitem("minegistics:vessels_milk_bottle", {
    description = ("Milk: Produced by farms."),
    inventory_image = "vessels_milk_bottle_resource.png"
})
