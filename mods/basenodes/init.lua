local WATER_ALPHA = "^[opacity:" .. 160
local WATER_VISC = 1
local LAVA_VISC = 7

--
-- Craftitems
--

-- Register Craftitems

minetest.register_craftitem("basenodes:coal_lump", {
	description = ("Hopefully this isn't in your stocking."),
	inventory_image = "default_coal_lump.png",
	groups = {coal = 1, flammable = 1}
})

minetest.register_craftitem("basenodes:copper_lump", {
	description = ("Copper Lump"),
	inventory_image = "default_copper_lump.png"
})

minetest.register_craftitem("basenodes:tin_lump", {
   description = ("Tin lump"),
   inventory_image = "default_tin_lump.png"
})

minetest.register_craftitem("basenodes:gold_lump", {
	description = ("Gold Lump"),
	inventory_image = "default_gold_lump.png"
})

minetest.register_craftitem("basenodes:iron_lump", {
	description = ("Iron Lump"),
	inventory_image = "default_iron_lump.png"
})

minetest.register_craftitem("basenodes:fat", {
	description = ("fat"),
	inventory_image = "fat.png"
})

minetest.register_craftitem("basenodes:leather", {
	description = ("Leather"),
	inventory_image = "leather.png"
})

minetest.register_craftitem("basenodes:meat", {
	description = ("Meat"),
	inventory_image = "meat.png"
})

minetest.register_craftitem("basenodes:milk", {
	description = ("Moo milk"),
	inventory_image = "milk.png"
})

minetest.register_craftitem("basenodes:fruit", {
	description = ("fruit"),
	inventory_image = "fruit.png"
})

minetest.register_craftitem("basenodes:wheat", {
	description = ("wheat"),
	inventory_image = "wheat.png"
})

minetest.register_craftitem("basenodes:cotton", {
	description = ("cotton"),
	inventory_image = "default_cotton.png"
})

minetest.register_craftitem("basenodes:clay", {
	description = ("clay"),
	inventory_image = "default_clay.png"
})

minetest.register_craftitem("basenodes:steel_lump", {
	description = ("Steel lump"),
	inventory_image = "steel_lump.png"
})

minetest.register_craftitem("basenodes:steel_ingot", {
	description = ("Steel Ingot"),
	inventory_image = "default_steel_ingot.png"
})

minetest.register_craftitem("basenodes:iron_ingot", {
	description = ("Iron Ingot"),
	inventory_image = "iron_ingot.png"
})

minetest.register_craftitem("basenodes:copper_ingot", {
	description = ("Copper Ingot"),
	inventory_image = "default_copper_ingot.png"
})

minetest.register_craftitem("basenodes:bronze_ingot", {
	description = ("Bronze Ingot"),
	inventory_image = "default_bronze_ingot.png"
})

minetest.register_craftitem("basenodes:mechanical_parts", {
	description = ("Mechanical Parts"),
	inventory_image = "mechanical_parts.png"
})

minetest.register_craftitem("basenodes:copper_wire", {
	description = ("Copper Wire"),
	inventory_image = "copper_wire.png"
})

minetest.register_craftitem("basenodes:tallow", {
	description = ("Tallow"),
	inventory_image = "tallow.png"
})

minetest.register_craftitem("basenodes:lye", {
	description = ("Lye"),
	inventory_image = "lye.png"
})

minetest.register_craftitem("basenodes:ash", {
	description = ("Ash"),
	inventory_image = "ash.png"
})

minetest.register_craftitem("basenodes:potash", {
	description = ("potash"),
	inventory_image = "potash.png"
})

minetest.register_craftitem("basenodes:pearlash", {
	description = ("pearlash"),
	inventory_image = "pearlash.png"
})

minetest.register_craftitem("basenodes:luxury_tools", {
	description = ("Luxury Tools"),
	inventory_image = "luxury_tools.png"
})

minetest.register_craftitem("basenodes:building_material", {
	description = ("Building Material"),
	inventory_image = "building_material.png"
})

minetest.register_craftitem("basenodes:soap", {
	description = ("It makes water wetter to make you clean."),
	inventory_image = "soap.png"
})

minetest.register_craftitem("basenodes:luxury_furniture", {
	description = ("Luxury Furniture"),
	inventory_image = "luxury_furniture.png"
})

minetest.register_craftitem("basenodes:furniture", {
	description = ("A place to rest your head."),
	inventory_image = "furniture.png"
})

minetest.register_craftitem("basenodes:luxury_meals", {
	description = ("Why is fish eggs so fancy?"),
	inventory_image = "luxury_meals.png"
})

minetest.register_craftitem("basenodes:simple_meals", {
	description = ("Plain ole meat and potatoes"),
	inventory_image = "simple_meal.png"
})

minetest.register_craftitem("basenodes:ceramics", {
	description = ("Need something for your tea."),
	inventory_image = "ceramics.png"
})
--
-- Node definitions
--

-- Register nodes

minetest.register_node("basenodes:stone", {
	description = "Stone",
	tiles = {"default_stone.png"},
})

minetest.register_node("basenodes:dirt_with_grass", {
	description = "Dirt with Grass",
	tiles ={"default_grass.png",
		-- a little dot on the bottom to distinguish it from dirt
		"default_dirt.png^basenodes_dirt_with_grass_bottom.png",
		{name = "default_dirt.png^default_grass_side.png",
		tileable_vertical = false}},
})

minetest.register_node("basenodes:dirt", {
	description = "Dirt",
	tiles ={"default_dirt.png"},
})

minetest.register_node("basenodes:sand", {
	description = "Sand",
	tiles ={"default_sand.png"},
})

minetest.register_node("basenodes:gravel", {
	description = "Gravel",
	tiles ={"default_gravel.png"},
})

minetest.register_node("basenodes:wood", {
	description = "lumber",
	tiles ={"default_wood.png"},
})

minetest.register_node("basenodes:cement", {
	description = "Cement",
	tiles ={"cement.png"},
})

minetest.register_node("basenodes:glass", {
	description = "Glass",
	tiles ={"glass.png"},
})

minetest.register_node("basenodes:leaves", {
	description = "Normal Leaves",
	drawtype = "allfaces_optional",
	tiles = {"default_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
})

minetest.register_node("basenodes:cobble", {
	description = "Cobblestone",
	tiles ={"default_cobble.png"},
	is_ground_content = false,
})

minetest.register_node("basenodes:stone_with_coal", {
	description = ("Coal Ore"),
	tiles = {"default_stone.png^default_mineral_coal.png"},
})

minetest.register_node("basenodes:stone_with_iron", {
	description = ("Iron Ore"),
	tiles = {"default_stone.png^default_mineral_iron.png"},
})

minetest.register_node("basenodes:stone_with_copper", {
	description = ("Copper Ore"),
	tiles = {"default_stone.png^default_mineral_copper.png"},
})

minetest.register_node("basenodes:stone_with_tin", {
	description = ("Tin Ore"),
	tiles = {"default_stone.png^default_mineral_tin.png"},
})

minetest.register_node("basenodes:stone_with_gold", {
	description = ("Gold Ore"),
	tiles = {"default_stone.png^default_mineral_gold.png"},
})

minetest.register_node("basenodes:river_water_source", {
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
	liquid_alternative_flowing = "basenodes:river_water_flowing",
	liquid_alternative_source = "basenodes:river_water_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
	liquid_range = 2,
	post_effect_color = {a = 103, r = 30, g = 76, b = 90},
	groups = {water = 3, liquid = 3, },
})

minetest.register_node("basenodes:river_water_flowing", {
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
	liquid_alternative_flowing = "basenodes:river_water_flowing",
	liquid_alternative_source = "basenodes:river_water_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
	liquid_range = 2,
	post_effect_color = {a = 103, r = 30, g = 76, b = 90},
	groups = {water = 3, liquid = 3, },
})
