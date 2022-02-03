--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

fuels = {
      "minegistics_basenodes:coal_lump",
      "minegistics_basenodes:planks",
      "minegistics:fuel_charcoal",
      "minegistics:fuel_coal_coke"
}

--Items that are gathered by the collectors

material = {
      "minegistics_basenodes:coal_lump",
      "minegistics_basenodes:copper_lump",
      "minegistics_basenodes:tin_lump",
      "minegistics_basenodes:iron_lump",
      "minegistics_basenodes:gold_lump",
      "minegistics:material_fat",
      "minegistics:material_fruit",
      "minegistics:material_leather",
      "minegistics:material_meat",
      "minegistics:material_milk",
      "minegistics_basenodes:planks"
  }

--Items that are produced through a kiln, factory, or workshop

products = {
   ["minegistics:product_ash"] = {},
   ["minegistics:product_copper_wire"] = {},
   ["minegistics:product_furniture"] = {},
   ["minegistics:product_lye"] = {},
   ["minegistics:product_mechanical_parts"] = {},
   ["minegistics:product_pearlash"] = {},
   ["minegistics:product_potash"] = {},
   ["minegistics:product_steel_lump"] = {},
   ["minegistics:product_tallow"] = {},
   ["minegistics:product_cement"] = {}
}

--Highest level of production used to upgrade towns/markets or make lots of money

goods = {
   ["minegistics:good_building_material"] = {},
   ["minegistics:good_ceramic"] = {},
   ["minegistics:good_luxury_furniture"] = {},
   ["minegistics:good_luxury_meal"] = {},
   ["minegistics:good_luxury_tools"] = {},
   ["minegistics:good_simple_meal"] = {},
   ["minegistics:good_soap"] = {},
   ["minegistics:good_toys"] = {}
}

item_worth = {
    ["minegistics_basenodes:coal_lump"] = 1,
    ["minegistics_basenodes:planks"] = 1,
    ["minegistics_basenodes:tin_lump"] = 2,
    ["minegistics_basenodes:copper_lump"] = 3,
    ["minegistics_basenodes:iron_lump"] = 4,
    ["minegistics_basenodes:gold_lump"] = 5,
    ["minegistics:coal_product"] = 6,
    ["minegistics:tin_product"] = 7,
    ["minegistics:copper_product"] = 8,
    ["minegistics:iron_product"] = 9,
    ["minegistics:gold_product"] = 10
}

minetest.register_craftitem("minegistics:coal_product", {
	description = ("Coal Product: Produced by factories."),
	inventory_image = "coal_product.png",
	groups = {coal = 1, flammable = 1}
})

minetest.register_craftitem("minegistics:copper_product", {
	description = ("Copper Product: Produced by factories."),
	inventory_image = "copper_product.png"
})

minetest.register_craftitem("minegistics:tin_product", {
	description = ("Tin Product: Produced by factories."),
	inventory_image = "tin_product.png"
})

minetest.register_craftitem("minegistics:gold_product", {
	description = ("Gold Product: Produced by factories."),
	inventory_image = "gold_product.png"
})

minetest.register_craftitem("minegistics:iron_product", {
	description = ("Iron Product: Produced by factories."),
	inventory_image = "iron_product.png"
})

minetest.register_craftitem("minegistics:iron_product", {
	description = ("Iron Product: Produced by factories."),
	inventory_image = "iron_product.png"
})
