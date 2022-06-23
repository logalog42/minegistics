--
-- Craftitems
--

-- Register Craftitems

minetest.register_craftitem("minegistics_basenodes:coal_lump", {
	description = ("Coal Lump"),
	inventory_image = "default_coal_lump.png",
	groups = {coal = 1, flammable = 1}
})

minetest.register_craftitem("minegistics_basenodes:copper_lump", {
	description = ("Copper Lump"),
	inventory_image = "default_copper_lump.png"
})

minetest.register_craftitem("minegistics_basenodes:tin_lump", {
   description = ("Tin lump"),
   inventory_image = "default_tin_lump.png"
})

minetest.register_craftitem("minegistics_basenodes:gold_lump", {
	description = ("Gold Lump"),
	inventory_image = "default_gold_lump.png"
})

minetest.register_craftitem("minegistics_basenodes:iron_lump", {
	description = ("Iron Lump"),
	inventory_image = "default_iron_lump.png"
})

minetest.register_craftitem("minegistics_basenodes:planks", {
   description = ("Lumber"),
   inventory_image = "default_wood.png"
})

--
-- Node definitions
--

-- Register nodes

minetest.register_node("minegistics_basenodes:stone", {
	description = "Stone",
	tiles = {"default_stone.png"},
})

minetest.register_node("minegistics_basenodes:dirt_with_grass", {
	description = "Dirt with Grass",
	tiles ={"default_grass.png"},
})

minetest.register_node("minegistics_basenodes:dirt", {
	description = "Dirt",
	tiles ={"default_dirt.png"},
})

minetest.register_node("minegistics_basenodes:tree", {
   descriptions = "Woods",
   drawtype="mesh",
   mesh = "minegistics_tree.obj",
   tiles={"minegistics_tree.png"}
})

minetest.register_node("minegistics_basenodes:stone_with_coal", {
	description = ("Coal Ore"),
	tiles = {"default_stone.png^default_mineral_coal.png"},
})

minetest.register_node("minegistics_basenodes:stone_with_iron", {
	description = ("Iron Ore"),
	tiles = {"default_stone.png^default_mineral_iron.png"},
})

minetest.register_node("minegistics_basenodes:stone_with_copper", {
	description = ("Copper Ore"),
	tiles = {"default_stone.png^default_mineral_copper.png"},
})

minetest.register_node("minegistics_basenodes:stone_with_tin", {
	description = ("Tin Ore"),
	tiles = {"default_stone.png^default_mineral_tin.png"},
})

minetest.register_node("minegistics_basenodes:stone_with_gold", {
	description = ("Gold Ore"),
	tiles = {"default_stone.png^default_mineral_gold.png"},
})

--
-- Ore definitions
--

-- Register ores

base_ores = {
    ["minegistics_basenodes:stone_with_coal"] = "minegistics_basenodes:coal_lump",
    ["minegistics_basenodes:stone_with_tin"] = "minegistics_basenodes:tin_lump",
    ["minegistics_basenodes:stone_with_copper"] = "minegistics_basenodes:copper_lump",
    ["minegistics_basenodes:stone_with_iron"] = "minegistics_basenodes:iron_lump",
    ["minegistics_basenodes:stone_with_gold"] = "minegistics_basenodes:gold_lump",
    ["minegistics_basenodes:tree"] = "minegistics_basenodes:planks"
}
