--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

resources = {
      "minegistics_basenodes:coal_lump",
      "minegistics_basenodes:copper_lump",
      "minegistics_basenodes:tin_lump",
      "minegistics_basenodes:iron_lump",
      "minegistics_basenodes:gold_lump",
      "minegistics:fat_resource",
      "minegistics:fruit_resource",
      "minegistics:leather_resource",
      "minegistics:meat_resource",
      "minegistics:vessels_milk_bottle_resource",
      "minegistics_basenodes:planks"
  }

products = {
    ["minegistics_basenodes:coal_lump"] = "minegistics:coal_product",
    ["minegistics_basenodes:copper_lump"] = "minegistics:copper_product",
    ["minegistics_basenodes:gold_lump"] = "minegistics:gold_product",
    ["minegistics_basenodes:iron_lump"] = "minegistics:iron_product",
    ["minegistics_basenodes:tin_lump"] = "minegistics:tin_product",
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
