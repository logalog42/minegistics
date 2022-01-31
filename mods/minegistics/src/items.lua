--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

resources = {
      "basenodes:coal_lump",
      "basenodes:copper_lump",
      "basenodes:tin_lump",
      "basenodes:iron_lump",
      "basenodes:gold_lump",
      "minegistics:fat_resource",
      "minegistics:fruit_resource",
      "minegistics:leather_resource",
      "minegistics:meat_resource",
      "minegistics:vessels_milk_bottle_resource"
  }

products = {
    ["basenodes:coal_lump"] = "minegistics:coal_product",
    ["basenodes:copper_lump"] = "minegistics:copper_product",
    ["basenodes:gold_lump"] = "minegistics:gold_product",
    ["basenodes:iron_lump"] = "minegistics:iron_product",
    ["basenodes:tin_lump"] = "minegistics:tin_product",
}

item_worth = {
    ["basenodes:coal_lump"] = 1,
    ["basenodes:tin_lump"] = 2,
    ["basenodes:copper_lump"] = 3,
    ["basenodes:iron_lump"] = 4,
    ["basenodes:gold_lump"] = 5,
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
