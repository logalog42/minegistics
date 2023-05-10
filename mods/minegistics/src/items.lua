--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

Base_ores = {
    ["basenodes:stone_with_coal"] = "minegistics:coal_lump",
    ["basenodes:stone_with_tin"] = "minegistics:tin_lump",
    ["basenodes:stone_with_copper"] = "minegistics:copper_lump",
    ["basenodes:stone_with_iron"] = "minegistics:iron_lump",
    ["basenodes:stone_with_gold"] = "minegistics:gold_lump",
    ["basenodes:tree_1"] = "minegistics:lumber",
	["basenodes:tree_2"] = "minegistics:lumber",
	["basenodes:tree_3"] = "minegistics:lumber",
	["basenodes:tree_4"] = "minegistics:lumber",
}

Fuels = {
    "minegistics:coal_lump",
    "minegistics:lumber"
}

Material = {
    "minegistics:coal_lump",
    "minegistics:copper_lump",
    "minegistics:tin_lump",
    "minegistics:iron_lump",
    "minegistics:gold_lump",
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

RecipiesInStructure = {
    Refinery = {
        ["minegistics:coal_lump"] = "minegistics:coal_coke_product",
        ["minegistics:copper_lump"] = "minegistics:copper_product",
        ["minegistics:gold_lump"] = "minegistics:gold_product",
        ["minegistics:iron_lump"] = "minegistics:iron_product",
        ["minegistics:tin_lump"] = "minegistics:tin_product",
        ["minegistics:fat"] = "minegistics:tallow_product",
        ["minegistics:lumber"] = "minegistics:ash_product",
        ["minegistics:clay"] = "minegistics:Ceramics",
    },

    Factory = {
        ["minegistics:luxury_tools"] = {"minegistics:steel_ingot", "minegistics:bronze_ingot"},
        ["minegistics:toys"] = {"minegistics:mechanical_parts", "minegistics:copper_wire"},
        ["minegistics:bronze_ingot"] = {"minegistics:copper_ingot", "minegistics:tin_product"},
        ["minegistics:steel_product"] = {"minegistics:coal_coke", "minegistics:iron_ingot"},
        ["minegistics:cement"] = {"minegistics:gravel", "minegistics:sand"},
        ["minegistics:soap"] = {"minegistics:tallow_product", "minegistics:lye"},
        ["minegistics:luxury_furniture"] = {"minegistics:leather", "minegistics:lumber"},
        ["minegistics:furniture"] = {"minegistics:cotton", "minegistics:lumber"},
        ["minegistics:luxury_meal"] = {"minegistics:fruit", "minegistics:vessels_milk_bottle"},
        ["minegistics:simple_meal"] = {"minegistics:wheat", "minegistics:meat"},
    },

    Workshop = {
        ["minegistics:iron_product"] = {"minegistics:iron_ingot", "minegistics:mechanical_parts"},
        ["minegistics:copper_product"] = {"minegistics:copper_ingot", "minegistics:copper_wire"},
        ["minegistics:steel_product"] = {"minegistics:building_materials", "minegistics:steel_ingot"},
        ["minegistics:ash"] = {"minegistics:potash", "minegistics:lye"}
    }
}

Item_worth = {
    ["minegistics:fat"] = 1,
    ["minegistics:fruit"] = 1,
    ["minegistics:leather"] = 1,
    ["minegistics:meat"] = 1,
    ["minegistics:vessels_milk_bottle"] = 1,
    ["minegistics:coal_lump"] = 2,
    ["minegistics:tin_lump"] = 2,
    ["minegistics:iron_lump"] = 2,
    ["minegistics:copper_lump"] = 4,
    ["minegistics:gold_lump"] = 6,
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

--
-- Craftitems
--

-- Register Craftitems

minetest.register_craftitem("minegistics:ash", {
    description = (""),
    inventory_image = "ash_product.png"
})

minetest.register_craftitem("minegistics:bronze_ingot", {
    description = (""),
    inventory_image = "bronze_ingot.png"
})

minetest.register_craftitem("minegistics:building_materials", {
    description = ("Building Materials: Produced by factories using iron product and lumber."),
    inventory_image = "building_material_good.png"
})

minetest.register_craftitem("minegistics:cement", {
    description = (""),
    inventory_image = "cement_product.png"
})

minetest.register_craftitem("minegistics:ceramics", {
    description = (""),
    inventory_image = "ceramics_good.png"
})

minetest.register_craftitem("minegistics:charcoal_fuel", {
    description = (""),
    inventory_image = "charcoal_fuel.png"
})

minetest.register_craftitem("minegistics:clay_lump", {
    description = (""),
    inventory_image = "clay_lump.png"
})

minetest.register_craftitem("minegistics:coal_coke", {
    description = (""),
    inventory_image = "coal_coke_fuel.png"
})

minetest.register_craftitem("minegistics:coal_lump", {
	description = ("Coal Lump"),
	inventory_image = "coal_lump.png",
	groups = {coal = 1, flammable = 1}
})

minetest.register_craftitem("minegistics:coal_product", {
    description = ("Coal Product: Produced by workshops using coal lumps."),
    inventory_image = "coal_product.png"
})

minetest.register_craftitem("minegistics:copper_ingot", {
    description = (""),
    inventory_image = "copper_ingot.png"
})

minetest.register_craftitem("minegistics:copper_lump", {
	description = ("Copper Lump"),
	inventory_image = "copper_lump.png"
})

minetest.register_craftitem("minegistics:copper_product", {
    description = (""),
    inventory_image = "copper_product.png"
})

minetest.register_craftitem("minegistics:copper_wire", {
    description = ("Copper Wire: Produced by workshops using copper lumps."),
    inventory_image = "copper_wire_product.png"
})

minetest.register_craftitem("minegistics:cotton", {
    description = (""),
    inventory_image = "cotton.png"
})

minetest.register_craftitem("minegistics:fat", {
    description = ("Fat: Produced by farms."),
    inventory_image = "fat_resource.png"
})

minetest.register_craftitem("minegistics:fruit", {
    description = ("Fruit: Produced by farms."),
    inventory_image = "fruit_resource.png"
})

minetest.register_craftitem("minegistics:furniture", {
    description = ("Furniture: Produced by factories using leather and lumber."),
    inventory_image = "furniture_product.png"
})

minetest.register_craftitem("minegistics:glass", {
    description = (""),
    inventory_image = "glass.png"
})

minetest.register_craftitem("minegistics:gold_lump", {
	description = ("Gold Lump"),
	inventory_image = "gold_lump.png"
})

minetest.register_craftitem("minegistics:gold_product", {
    description = ("Gold Product: Produced by workshops using gold lumps."),
    inventory_image = "gold_product.png"
})

minetest.register_craftitem("minegistics:iron_ingot", {
    description = (""),
    inventory_image = "iron_ingot.png"
})

minetest.register_craftitem("minegistics:iron_lump", {
	description = ("Iron Lump"),
	inventory_image = "iron_lump.png"
})

minetest.register_craftitem("minegistics:iron_product", {
    description = ("Iron Product: Produced by workshops using iron lumps."),
    inventory_image = "iron_product.png"
})

minetest.register_craftitem("minegistics:leather", {
    description = ("Leather: Produced by farms."),
    inventory_image = "leather_resource.png"
})

minetest.register_craftitem("minegistics:lumber", {
    description = ("Lumber"),
    inventory_image = "lumber.png"
 })

 minetest.register_craftitem("minegistics:luxury_furniture", {
    description = (""),
    inventory_image = "luxury_furniture_good.png"
})

minetest.register_craftitem("minegistics:luxury_meal", {
    description = (""),
    inventory_image = "luxury_meal_good.png"
})

minetest.register_craftitem("minegistics:Luxury_tools", {
    description = (""),
    inventory_image = "luxury_tools_good.png"
})

minetest.register_craftitem("minegistics:lye", {
    description = (""),
    inventory_image = "lye_product.png"
})

minetest.register_craftitem("minegistics:meat", {
    description = ("Meat: Produced by farms."),
    inventory_image = "meat_resource.png"
})

minetest.register_craftitem("minegistics:mechanical_parts", {
    description = ("Mechanical Parts: Produced by factories using copper wire and iron product."),
    inventory_image = "mechanical_parts_product.png"
})

minetest.register_craftitem("minegistics:pearlash", {
    description = (""),
    inventory_image = "pearlash_product.png"
})

minetest.register_craftitem("minegistics:potash", {
    description = (""),
    inventory_image = "potash_product.png"
})

minetest.register_craftitem("minegistics:simple_meal", {
    description = (""),
    inventory_image = "simple_meal_good.png"
})

minetest.register_craftitem("minegistics:soap", {
    description = (""),
    inventory_image = "soap_product.png"
})

minetest.register_craftitem("minegistics:steel_ingot", {
    description = (""),
    inventory_image = "steel_ingot.png"
})

minetest.register_craftitem("minegistics:steel_lump", {
    description = (""),
    inventory_image = "steel_lump.png"
})

minetest.register_craftitem("minegistics:tallow", {
    description = (""),
    inventory_image = "tallow_product.png"
})

minetest.register_craftitem("minegistics:tin_lump", {
    description = ("Tin lump"),
    inventory_image = "tin_lump.png"
 })

minetest.register_craftitem("minegistics:tin_product", {
    description = ("Tin Product: Produced by workshops using tin lumps."),
    inventory_image = "tin_product.png"
})

minetest.register_craftitem("minegistics:toys", {
    description = ("Toys: Produced by factories using tin product and lumber."),
    inventory_image = "toys_good.png"
})

minetest.register_craftitem("minegistics:vessels_milk_bottle", {
    description = ("Milk: Produced by farms."),
    inventory_image = "vessels_milk_bottle_resource.png"
})

minetest.register_craftitem("minegistics:wheat", {
    description = (""),
    inventory_image = "wheat.png"
})