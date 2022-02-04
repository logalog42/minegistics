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

materials = {
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
   ["minegistics:good_cement"] = { "minegistics:material_sand", "minegistics:material_gravel"},
   ["minegistics:good_ceramic"] = { "minegistics:material_clay_lump"},
   ["minegistics:good_furniture"] = { "minegistics:material_cotton", "minegistics:material_wood"},
   ["minegistics:good_glass"] = { "minegistics:product_pearlash", "minegistics:material_sand"},
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
   ["minegistics:material_copper_lump"] = 1,
   ["minegistics:material_cotton"] = 1,
   ["minegistics:material_fat"] = 1,
   ["minegistics:material_fruit"] = 1,
   ["minegistics:material_gold_lump"] = 1,
   ["minegistics:material_iron_lump"] = 1,
   ["minegistics:material_leather"] = 1,
   ["minegistics:material_meat"] = 1,
   ["minegistics:material_tin_lump"] = 1,
   ["minegistics:materialwheat"] = 1,
   ["minegistics:material_wood"] = 1,
   ["minegistics:product_ash"] =2,
   ["minegistics:product_bronze_ingot"] = 2,
   ["minegistics:product_copper_ingot"] = 2,
   ["minegistics:product_copper_wire"] = 2,
   ["minegistics:product_gold_ingot"] = 2,
   ["minegistics:product_iron_ingot"] = 2,
   ["minegistics:product_lye"] = 2,
   ["minegistics:product_mechanical_parts"] = 2,
   ["minegistics:product_pearlash"] = 2,
   ["minegistics:product_potash"] = 2,
   ["minegistics:product_steel_ingot"] = 2,
   ["minegistics:product_steel_lump"] = 2,
   ["minegistics:production_tallow"] = 2,
   ["minegistics:good_building_material"] = 3,
   ["minegistics:good_cement"] = 3,
   ["minegistics:good_ceramic"] = 3,
   ["minegistics:good_simple_furniture"] = 3,
   ["minegistics:good_glass"] = 3,
   ["minegistics:good_luxury_furniture"]= 3,
   ["minegistics:good_luxury_meal"] = 3,
   ["minegistics:good_luxury_tools"] = 3,
   ["minegistics:good_simple_meal"] = 3,
   ["minegistics:good_soap"] = 3,
   ["minegistics:good_toys"] = 3

}

--
-- Registration Craftitems
--

-- Fuel Craftitems

minetest.register_craftitem("minegistics:fuel_charcoal", {
	description = ("Charcoal is just wood burned once."),
	inventory_image = "fuel_charcoal.png",
	groups = {coal = 1, flammable = 1}
})

minetest.register_craftitem("minegistics:fuel_coal_coke", {
   description = ("A lump of coal coke"),
   inventory_image = "fuel_coal_coke.png",
   groups = {coal = 1, flammable = 1}
})

minetest.register_craftitem("minegistics:fuel_coal_lump", {
	description = ("Coal Lump"),
	inventory_image = "fuel_coal_lump.png",
	groups = {coal = 1, flammable = 1}
})

minetest.register_craftitem("minegistics:material_wood", {
   description = ("It's wood!"),
   inventory_image = "material_wood.png",
   groups = {coal = 1, flammable = 1}
})

-- Material Craftitems

minetest.register_craftitem("mingistics:material_clay_lump", {
   description = ("lump of clay"),
   inventory_image = "material_clay_lump.png"
})

minetest.register_craftitem("minegistics:material_copper_lump", {
	description = ("Copper Lump"),
	inventory_image = "default_copper_lump.png"
})

minetest.register_craftitem("minegistics:material_cotton", {
   description = ("Some fresh cotton"),
   inventory_image = "minegistics:material_cotton.png"
})

minetest.register_craftitem("minegistics:material_fat", {
   description = ("A lump of fat"),
   inventory_image = "material_fat.png"
})

minetest.register_craftitem("minegistics:material_fruit", {
   description = ("Fruit natures candy"),
   inventory_image = "material.fruit.png"
})

minetest.register_craftitem("minegistics:material_gold_lump", {
	description = ("Gold Lump"),
	inventory_image = "default_gold_lump.png"
})

minetest.register_craftitem("minegistics:material_iron_lump", {
	description = ("Iron Lump"),
	inventory_image = "default_iron_lump.png"
})

minetest.register_craftitem("minegistics:material_leather", {
   description = ("The hide of a cow"),
   inventory_image = "material_leather.png"
})

minetest.register_craftitem("minegistics:material_meat", {
   description = ("It's whats for dinner tonight"),
   inventory_image = "material_meat.png"
})

minetest.register_craftitem("minegistics:material_tin_lump", {
   description = ("Tin lump"),
   inventory_image = "default_tin_lump.png"
})

minetest.register_craftitem("minegistics:material_wheat", {
   description = ("The staple of many diets"),
   inventory_image = "material_wheat.png"
})

-- Production Craftitems

minetest.register_craftitem("minegistics:product_ash", {
   description = ("A pile of wood ash"),
   inventory_image = "product_ash.png"
})

minetest.register_craftitem("product_bronze_ingot", {
   description = ("An ingot of bronze metal"),
   inventory_image = "product_bronze_ingot.png"
})

minetest.register_craftitem("minegistics:product_copper_ingot", {
   description = ("An ingot of copper metal"),
   inventory_image = "product_copper_ingot.png"
})

minetest.register_craftitem("minegistics:product_copper_wire", {
   description = ("A spool of copper wire"),
   inventory_image = "product_copper_wire.png"
})

minetest.register_craftitem("minegistics:product_gold_ingot", {
   description = ("An ingot of gold metal"),
   inventory_image = "product_go"
})

minetest.register_craftitem("minegistics:product_iron_ingot", {
   description = ("An ingot of iron metal"),
   inventory_image = "product_iron_ingot.png"
})

minetest.register_craftitem("minegistics:product_lye", {
   description = ("A container of processed lye"),
   inventory_image = "product_lye.png"
})

minetest.register_craftitem("minegistics:product_mechanical_parts", {
   description = ("A collection of gears and sprockets"),
   inventory_image = "product_mechanical_parts.png"
})

minetest.register_craftitem("minegistics:product_pearlash", {
   description = ("A pile of pearlash"),
   inventory_image = "product_pearlash.png"
})

minetest.register_craftitem("minegistics:product_potash", {
   description = ("A pile of potash"),
   inventory_image = "product_potash.png"
})

minetest.register_craftitem("minegistics:product_steel_ingot", {
   description = ("A ingot of steel metal"),
   inventory_image = "product_steel_ingot.png"
})

minetest.register_craftitem("minegistics:product_steel_lump", {
   description = ("A lump of steel"),
   inventory_image = "product_steel_lump.png"
})

minetest.register_craftitem("minegistics:product_tallow", {
   description = ("Tallow rended from fat"),
   inventory_image = "product_tallow.png"
})

--Goods Craftitems

minetest.register_craftitem("minegistics:good_cement", {
   description = ("A mixture that hardens"),
   inventory_image = "good_cement.png"
})

minetest.register_craftitem("minegistics:good_ceramic", {
   description = ("Fancy things to eat on"),
   inventory_image = "good_ceramic.png"
})

minetest.register_craftitem("minegistics:good_glass", {
   description = ("Glass makes a better window than a wall"),
   inventory_image = "good_glass.png"
})

minetest.register_craftitem("minegistics:good_luxury_furniture", {
   description = ("Fancy Places to sit"),
   inventory_image = "good_luxury_furniture.png"
})

minetest.register_craftitem("minegistics:good_luxury_meal", {
   description = ("Fancy Food"),
   inventory_image = "good_luxury_meal.png"
})

minetest.register_craftitem("minegistics:good_luxury_tools", {
   description = ("Oooooh shiney tools"),
   inventory_image = "good_luxury_tools.png"
})

minetest.register_craftitem("minegistics:good_simple_furniture", {
   description = ("A place to rest weary bones"),
   inventory_image = "good_simple_furniture.png"
})

minetest.register_craftitem("minegistics:good_simple_meal", {
   description = ("Daily Bread"),
   inventory_image = "good_simple_meal.png"
})

minetest.register_craftitem("minegistics:good_soap", {
   description = ("Rub a dub dub"),
   inventory_image = "good_soap.png"
})

minetest.register_craftitem("minegistics:good_toys", {
   description = ("It's for fun"),
   inventory_image = "good_toys.png"
})
