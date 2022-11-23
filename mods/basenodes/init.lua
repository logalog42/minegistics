--
-- Craftitems
--

-- Register Craftitems

minetest.register_craftitem("basenodes:coal_lump", {
	description = ("Coal Lump"),
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
	tiles ={"default_grass.png"},
})

minetest.register_node("basenodes:dirt", {
	description = "Dirt",
	tiles ={"default_dirt.png"},
})

minetest.register_node("basenodes:tree", {
   descriptions = "Woods",
   drawtype="mesh",
   mesh = "minegistics_tree.obj",
   tiles={"minegistics_tree.png"}
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

minetest.register_node("basenodes:snow", {
	description = ("Snowy mountain tops"),
	tiles = {"default_snow.png"}
})

minetest.register_node("basenodes:snow_transition", {
	description = ("Snow starting to show"),
	tiles = {"default_snow.png", "default_stone.png", "default_stone.png^default_snow_side.png"}
})

minetest.register_node("basenodes:stone_slope", {
   description = ("Slope for mountain blocks."),
   drawtype = "nodebox",
	 tiles = {
		--"stone_slope_top.png",
		"default_stone.png",
		"default_stone.png",
		"default_stone.png",
		"default_stone.png",
		"default_stone.png",
		"default_stone.png",
		--"stone_slope_back.png",
		--"stone_slope_front.png",
	 },
   use_texture_alpha = "clip",
   --paramtype = "light",
   paramtype2 = "4dir",
   node_box = {
		 		type = "fixed",
		 		fixed = {
	     --1/4th layer
	      {-0.5, -0.5, -0.5, 0.25, -0.25, 0.5},
	      --2/4 layer
	      {-0.5, -0.25, -0.5, 0.1875, 0.0, 0.5},
	      --3/4 layer
	      {-0.5, 0.0, -0.5, 0.125, 0.25, 0.5},
	      --4/4 layer
	      {-0.5, 0.25, -0.5, 0.0, 0.5, 0.5}
				}
	 },
   collision_box = {
		 		type = "fixed",
				fixed = {
	     --1/4th layer
	      {-0.5, -0.5, -0.5, 0.25, -0.25, 0.5},
	      --2/4 layer
	      {-0.5, -0.5, -0.25, 0.1875, 0.0, 0.5},
	      --3/4 layer
	      {-0.5, -0.5, 0.0 , 0.125, 0.25, 0.5},
	      --4/4 layer
	      {-0.5, -0.5, 0.25, 0.0, 0.5, 0.5}
				}
	 }
	 })
--
-- Ore definitions
--

-- Register ores

base_ores = {
    ["basenodes:stone_with_coal"] = "basenodes:coal_lump",
    ["basenodes:stone_with_tin"] = "basenodes:tin_lump",
    ["basenodes:stone_with_copper"] = "basenodes:copper_lump",
    ["basenodes:stone_with_iron"] = "basenodes:iron_lump",
    ["basenodes:stone_with_gold"] = "basenodes:gold_lump",
    ["basenodes:tree"] = "minegistics:lumber"
}
