local WATER_ALPHA = "^[opacity:" .. 160
local WATER_VISC = 1
local LAVA_VISC = 7

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

minetest.register_craftitem("minegistics_basenodes:flint", {
	description = ("Flint"),
	inventory_image = "default_flint.png"
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

minetest.register_node("minegistics_basenodes:sand", {
	description = "Sand",
	tiles ={"default_sand.png"},
})

minetest.register_node("minegistics_basenodes:gravel", {
	description = "Gravel",
	tiles ={"default_gravel.png"},
})

minetest.register_node("minegistics_basenodes:tree", {
   descriptions = "Woods",
   drawtype="mesh",
   mesh = "minegistics_tree.obj",
   tiles={"minegistics_tree.png"}
})

minetest.register_node("minegistics_basenodes:leaves", {
	description = "Normal Leaves",
	drawtype = "allfaces_optional",
	tiles = {"default_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
})

minetest.register_node("minegistics_basenodes:cobble", {
	description = "Cobblestone",
	tiles ={"default_cobble.png"},
	is_ground_content = false,
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

base_ores = {
    ["minegistics_basenodes:stone_with_coal"] = "minegistics_basenodes:coal_lump",
    ["minegistics_basenodes:stone_with_tin"] = "minegistics_basenodes:tin_lump",
    ["minegistics_basenodes:stone_with_copper"] = "minegistics_basenodes:copper_lump",
    ["minegistics_basenodes:stone_with_iron"] = "minegistics_basenodes:iron_lump",
    ["minegistics_basenodes:stone_with_gold"] = "minegistics_basenodes:gold_lump",
    ["minegistics_basenodes:trunk"] = "minegistics_basenodes:planks"
}

minetest.register_node("minegistics_basenodes:river_water_source", {
	description = "River Water Source".."\n"..
		"Drowning damage: 1",
	drawtype = "liquid",
	waving = 3,
	tiles = { "default_river_water.png"..WATER_ALPHA },
	special_tiles = {
		{name = "default_river_water.png"..WATER_ALPHA, backface_culling = false},
		{name = "default_river_water.png"..WATER_ALPHA, backface_culling = true},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "minegistics_basenodes:river_water_flowing",
	liquid_alternative_source = "minegistics_basenodes:river_water_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
	liquid_range = 2,
	post_effect_color = {a = 103, r = 30, g = 76, b = 90},
	groups = {water = 3, liquid = 3, },
})

minetest.register_node("minegistics_basenodes:river_water_flowing", {
	description = "Flowing River Water".."\n"..
		"Drowning damage: 1",
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"default_river_water_flowing.png"..WATER_ALPHA},
	special_tiles = {
		{name = "default_river_water_flowing.png"..WATER_ALPHA,
			backface_culling = false},
		{name = "default_river_water_flowing.png"..WATER_ALPHA,
			backface_culling = false},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "minegistics_basenodes:river_water_flowing",
	liquid_alternative_source = "minegistics_basenodes:river_water_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
	liquid_range = 2,
	post_effect_color = {a = 103, r = 30, g = 76, b = 90},
	groups = {water = 3, liquid = 3, },
})
