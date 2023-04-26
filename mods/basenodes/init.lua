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

minetest.register_node("basenodes:tree_1", {
   descriptions = "Woods",
   drawtype="mesh",
   mesh = "minegistics_tree.obj",
   tiles={"minegistics_tree.png"},
   sunlight_propagates = true,
   paramtype = "light",
})

minetest.register_node("basenodes:tree_2", {
	descriptions = "Woods",
	drawtype="mesh",
	mesh = "minegistics_tree_2.obj",
	tiles={"minegistics_tree.png"},
	sunlight_propagates = true,
	paramtype = "light",
 })

minetest.register_node("basenodes:tree_3", {
	descriptions = "Woods",
	drawtype="mesh",
	mesh = "minegistics_tree_3.obj",
	tiles={"minegistics_tree.png"},
	sunlight_propagates = true,
	paramtype = "light",
})

minetest.register_node("basenodes:tree_4", {
	descriptions = "Woods",
	drawtype="mesh",
	mesh = "minegistics_tree_4.obj",
	tiles={"minegistics_tree.png"},
	sunlight_propagates = true,
	paramtype = "light",
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
	tiles = {"default_snow.png"},
	paramtype = "light"
})

minetest.register_node("basenodes:snow_transition", {
	description = ("Snow starting to show"),
	tiles = {"default_snow.png", "default_stone.png", "default_stone.png^default_snow_side.png"},
	paramtype = "light"
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
   paramtype = "light",
   node_box = {
				type = "connected",
				connect_front ={
					{-.5,-.5,  -.5,.5, .375,-.375},
					{-.5,-.5,-.375,.5,  .25, -.25},
					{-.5,-.5, -.25,.5, .125,-.125},
					{-.5,-.5,-.125,.5,    0,    0},
					{-.5,-.5,    0,.5,-.125, .125},
					{-.5,-.5, .125,.5, -.25,  .25},
					{-.5,-.5,  .25,.5,-.375, .375}
				},
				connect_left ={
					{  -.5,-.5,-.5,-.375, .375,.5}, 
					{-.375,-.5,-.5, -.25,  .25,.5}, 
					{ -.25,-.5,-.5,-.125, .125,.5},
					{-.125,-.5,-.5,    0,    0,.5},
					{    0,-.5,-.5, .125,-.125,.5},
					{ .125,-.5,-.5,  .25, -.25,.5},
					{  .25,-.5,-.5, .375,-.375,.5}
				},
				connect_back ={
					{-.5,-.5,   .5,.5, .375, .375}, 
					{-.5,-.5, .375,.5,  .25,  .25}, 
					{-.5,-.5,  .25,.5, .125, .125},
					{-.5,-.5, .125,.5,    0,    0},
					{-.5,-.5,    0,.5,-.125,-.125},
					{-.5,-.5,-.125,.5, -.25, -.25},
					{-.5,-.5, -.25,.5,-.375,-.375}
				},
				connect_right ={
					{   .5,-.5,-.5, .375, .375,.5}, 
					{ .375,-.5,-.5,  .25,  .25,.5}, 
					{  .25,-.5,-.5, .125, .125,.5},
					{ .125,-.5,-.5,    0,    0,.5},
					{    0,-.5,-.5,-.125,-.125,.5},
					{-.125,-.5,-.5, -.25, -.25,.5},
					{ -.25,-.5,-.5,-.375,-.375,.5}
				}
	},
	connects_to = {"basenodes:snow", "basenodes:snow_transition", "basenodes:stone"},

})

minetest.register_node("basenodes:snow_slope", {
	description = ("Slope for mountain blocks."),
	drawtype = "nodebox",
	  tiles = {"default_snow.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	node_box = {
				 type = "connected",
				 connect_front ={
					 {-.5,-.5,  -.5,.5, .375,-.375},
					 {-.5,-.5,-.375,.5,  .25, -.25},
					 {-.5,-.5, -.25,.5, .125,-.125},
					 {-.5,-.5,-.125,.5,    0,    0},
					 {-.5,-.5,    0,.5,-.125, .125},
					 {-.5,-.5, .125,.5, -.25,  .25},
					 {-.5,-.5,  .25,.5,-.375, .375}
				 },
				 connect_left ={
					 {  -.5,-.5,-.5,-.375, .375,.5}, 
					 {-.375,-.5,-.5, -.25,  .25,.5}, 
					 { -.25,-.5,-.5,-.125, .125,.5},
					 {-.125,-.5,-.5,    0,    0,.5},
					 {    0,-.5,-.5, .125,-.125,.5},
					 { .125,-.5,-.5,  .25, -.25,.5},
					 {  .25,-.5,-.5, .375,-.375,.5}
				 },
				 connect_back ={
					 {-.5,-.5,   .5,.5, .375, .375}, 
					 {-.5,-.5, .375,.5,  .25,  .25}, 
					 {-.5,-.5,  .25,.5, .125, .125},
					 {-.5,-.5, .125,.5,    0,    0},
					 {-.5,-.5,    0,.5,-.125,-.125},
					 {-.5,-.5,-.125,.5, -.25, -.25},
					 {-.5,-.5, -.25,.5,-.375,-.375}
				 },
				 connect_right ={
					 {   .5,-.5,-.5, .375, .375,.5}, 
					 { .375,-.5,-.5,  .25,  .25,.5}, 
					 {  .25,-.5,-.5, .125, .125,.5},
					 { .125,-.5,-.5,    0,    0,.5},
					 {    0,-.5,-.5,-.125,-.125,.5},
					 {-.125,-.5,-.5, -.25, -.25,.5},
					 { -.25,-.5,-.5,-.375,-.375,.5}
				 }
	 },
	 connects_to = {"basenodes:snow", "basenodes:snow_transition", "basenodes:stone"},
 
 })

 minetest.register_node("basenodes:snow_slope_transition", {
	description = ("Slope for mountain blocks."),
	drawtype = "nodebox",
	  tiles = {"default_snow.png", "default_stone.png", "default_stone.png^default_snow_side.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	node_box = {
				 type = "connected",
				 connect_front ={
					 {-.5,-.5,  -.5,.5, .375,-.375},
					 {-.5,-.5,-.375,.5,  .25, -.25},
					 {-.5,-.5, -.25,.5, .125,-.125},
					 {-.5,-.5,-.125,.5,    0,    0},
					 {-.5,-.5,    0,.5,-.125, .125},
					 {-.5,-.5, .125,.5, -.25,  .25},
					 {-.5,-.5,  .25,.5,-.375, .375}
				 },
				 connect_left ={
					 {  -.5,-.5,-.5,-.375, .375,.5}, 
					 {-.375,-.5,-.5, -.25,  .25,.5}, 
					 { -.25,-.5,-.5,-.125, .125,.5},
					 {-.125,-.5,-.5,    0,    0,.5},
					 {    0,-.5,-.5, .125,-.125,.5},
					 { .125,-.5,-.5,  .25, -.25,.5},
					 {  .25,-.5,-.5, .375,-.375,.5}
				 },
				 connect_back ={
					 {-.5,-.5,   .5,.5, .375, .375}, 
					 {-.5,-.5, .375,.5,  .25,  .25}, 
					 {-.5,-.5,  .25,.5, .125, .125},
					 {-.5,-.5, .125,.5,    0,    0},
					 {-.5,-.5,    0,.5,-.125,-.125},
					 {-.5,-.5,-.125,.5, -.25, -.25},
					 {-.5,-.5, -.25,.5,-.375,-.375}
				 },
				 connect_right ={
					 {   .5,-.5,-.5, .375, .375,.5}, 
					 { .375,-.5,-.5,  .25,  .25,.5}, 
					 {  .25,-.5,-.5, .125, .125,.5},
					 { .125,-.5,-.5,    0,    0,.5},
					 {    0,-.5,-.5,-.125,-.125,.5},
					 {-.125,-.5,-.5, -.25, -.25,.5},
					 { -.25,-.5,-.5,-.375,-.375,.5}
				 }
	 },
	 connects_to = {"basenodes:snow", "basenodes:snow_transition", "basenodes:stone"},
 
 })

 minetest.register_node("basenodes:sand", {
	description = ("Desert Sand"),
	tiles = {"default_sand.png"}
 })

 minetest.register_node("basenodes:dry_grass", {
	description = ("Where the desert starts to take over"),
	tiles = {"default_dry_grass.png"}
 })

 minetest.register_node("basenodes:dry_dirt", {
	description = ("It's to warm for grass"),
	tiles = {"default_dry_dirt.png"}
 })
 
 minetest.register_node("basenodes:sandstone", {
	description = ("The bottom of the world"),
	tiles = {"default_desert_sandstone.png"}
 })

 minetest.register_node("basenodes:water_source", {
	description = ("Water Source"),
	drawtype = "liquid",
	waving = 3,
	tiles = {
		{
			name = "default_water_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "default_water_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_source = "basenodes:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
})
-- Ore definitions
--

-- Register ores

Base_ores = {
    ["basenodes:stone_with_coal"] = "basenodes:coal_lump",
    ["basenodes:stone_with_tin"] = "basenodes:tin_lump",
    ["basenodes:stone_with_copper"] = "basenodes:copper_lump",
    ["basenodes:stone_with_iron"] = "basenodes:iron_lump",
    ["basenodes:stone_with_gold"] = "basenodes:gold_lump",
    ["basenodes:tree_1"] = "minegistics:lumber",
	["basenodes:tree_2"] = "minegistics:lumber",
	["basenodes:tree_3"] = "minegistics:lumber",
	["basenodes:tree_4"] = "minegistics:lumber",
}
