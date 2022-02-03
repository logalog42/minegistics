--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

fuels = {
      "minegistics:fuel_coal_lump",
      "minegistics:material_wood",
      "minegistics:fuel_charcoal",
      "minegistics:fuel_coal_coke"
}

--Items that are gathered by the collectors

material = {
      "minegistics:fuel_coal_lump",
      "minegistics:material_clay_lump",
      "minegistics:material_copper_lump",
      "minegistics:material_cotton",
      "minegistics:material_tin_lump",
      "minegistics:material_iron_lump",
      "minegistics:material_gold_lump",
      "minegistics:material_fat",
      "minegistics:material_fruit",
      "minegistics:material_leather",
      "minegistics:material_meat",
      "minegistics:material_wood",
      "minegistics:material_wheat",
      "minegistics:material_wood"
  }

--Items that are produced through a kiln, factory, or workshop

products = {
   ["minegistics:product_ash"] = { "minegistics:material_wood"},
   ["minegistics:product_bronze_ingot"] = { "minegistics:copper_ingot", "minegistics:material_tin_lump"},
   ["mingistics:product_copper_ingot"] = { "minegistics:material_copper_lump"},
   ["minegistics:product_copper_wire"] = { "minegistics:material_copper_lump"},
   ["minegistics:product_furniture"] = { "minegistics:material_cotton"},
   ["minegistics:product_glass"] = { "minegistics:product_pearlash", "minegistics:material_sand"},
   ["minegistics:product_gold_ingot"] = { "minegistics:material_gold_lump"},
   ["minegistics:product_iron_ingot"] = { "minegistics:material_iron_lump"},
   ["minegistics:product_lye"] = { "minegistics:product_ash"},
   ["minegistics:product_mechanical_parts"] = { "minegistics:material_iron_lump"},
   ["minegistics:product_pearlash"] = { "minegistics:product_potash"},
   ["minegistics:product_potash"] = { "minegistics:product_ash"},
   ["minegistics:product_steel_ingot"] = { "minegistics:product_steel_lump"},
   ["minegistics:product_steel_lump"] = { "minegistics:fuel_coal_coke", "minegistics:product_iron_ingot"},
   ["minegistics:product_tallow"] = { "minegistics:material_fat"},
   ["minegistics:product_cement"] = { "minegistics_basenodes:default_sand", "minegistics_basenodes:default_gravel"}
}

--Highest level of production used to upgrade towns/markets or make lots of money

goods = {
   ["minegistics:good_building_material"] = { "minegistics:product_steel_lump"},
   ["minegisitcs:good_cement"] = { "minegisitcs:material_sand", "minegisitcs:material_gravel"},
   ["minegistics:good_ceramic"] = { "minegistics:material_clay_lump"},
   ["minegistics:good_furniture"] = { "minegisitcs:material_cotton", "minegisitcs:material_wood"},
   ["minegistics:good_glass"] = { "minegisitcs:product_pearlash", "minegisitcs:material_sand"},
   ["minegistics:good_jewelry"] = { "minegistics:material_gold_lump"},
   ["minegistics:good_luxury_furniture"] = { "minegistics:material_leather", "minegistics:good_simple_furniture"},
   ["minegistics:good_luxury_meal"] = { "minegistics:material_fruit", "minegistics:good_simple_meal"},
   ["minegistics:good_luxury_tools"] = { "minegistics:product_steel_ingot", "minegistics:product_bronze_ingot"},
   ["minegistics:good_simple_furniture"] = {"minegistics:material_wood", "minegistics:material_cotton"},
   ["minegistics:good_simple_meal"] = { "minegistics:material_wheat", "minegistics:material_meat"},
   ["minegistics:good_soap"] = { "minegistics:product_lye", "minegistics:product_tallow"},
   ["minegistics:good_toys"] = { "minegistics:product_mechanical_parts", "minegistics:product_copper_wire"}
}

item_worth = {
   ["minegistics:fuel_charcoal"] = 1,
   ["minegistics:fuel_coal_coke"] = 1,
   ["minegistics:fuel_coal_lump"] = 1,
   ["minegistics:material_clay_lump"] = 1,
   ["minegisitics:material_copper_lump"] = 1,
   ["minegisitics:material_cotton"] = 1,
   ["minegistics:material_fat"] = 1,
   ["minegistics:material_fruit"] = 1,
   ["minegistics:material_gold_lump"] = 1,
   ["minegisitics:material_iron_lump"] = 1,
   ["minegistics:material_leather"] = 1,
   ["minegisitics:material_meat"] = 1,
   ["minegisitics:material_tin_lump"] = 1,
   ["minegistics:materialwheat"] = 1,
   ["minegistics:material_wood"] = 1,
   ["minegistics:product_ash"] =2,
   ["minegistics:product_bronze_ingot"] = 2,
   ["minegistics:product_copper_ingot"] = 2,
   ["minegisitcs:product_copper_wire"] = 2,
   ["minegisitcs:product_gold_ingot"] = 2
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
