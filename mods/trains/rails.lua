local rail_node_box = {
	type = "connected",
	connect_sides = {"front", "left", "back", "right"},
	--All box points start in the lower left corner, to upper right
	fixed = {
		--Base layer
		{-4/16, -8/16, -4/16,  4/16, -7/16,  4/16},
		--Railties
		{-3/16, -7/16, -2/16,  3/16, -6/16, -1/16},
		{-3/16, -7/16,  1/16,  3/16, -6/16,  2/16},
		{-2/16, -7/16, -3/16, -1/16, -6/16,  3/16},
		{ 1/16, -7/16, -3/16,  2/16, -6/16,  3/16},
		{-1/16, -7/16, -1/16,  1/16, -6/16,  1/16},
		--Rails
		{-2/16, -6/16, -2/16, -1/16, -5/16, -1/16},
		{ 1/16, -6/16,  1/16,  2/16, -5/16,  2/16},
		{-2/16, -6/16,  1/16, -1/16, -5/16,  2/16},
		{ 1/16, -6/16, -2/16,  2/16, -5/16, -1/16},
	},
	connect_front = {
		--Base
		{-4/16, -8/16, -8/16,  4/16, -7/16, -4/16},
		--Railties
		{-3/16, -7/16, -7/16,  3/16, -6/16, -6/16},
		{-3/16, -7/16, -4/16,  3/16, -6/16, -3/16},
		--Rails
		{-2/16, -6/16, -8/16, -1/16, -5/16, -2/16},
		{ 1/16, -6/16, -8/16,  2/16, -5/16, -2/16},
	},
	disconnected_front = {
		{-1/16, -6/16, -2/16,  1/16, -5/16, -1/16},
	},
	connect_left = {
		--Base
		{-8/16, -8/16, -4/16, -4/16, -7/16,  4/16},
		--Railties
		{-7/16, -7/16, -3/16, -6/16, -6/16,  3/16},
		{-4/16, -7/16, -3/16, -3/16, -6/16,  3/16},
		--Rails
		{-8/16, -6/16, -2/16, -2/16, -5/16, -1/16},
		{-8/16, -6/16,  1/16, -2/16, -5/16,  2/16},
	},
	disconnected_left = {
		{-2/16, -6/16, -1/16, -1/16, -5/16,  1/16},
	},
	connect_back = {
		--Base
		{-4/16, -8/16,  4/16,  4/16, -7/16,  8/16},
		--Railties
		{-3/16, -7/16,  6/16,  3/16, -6/16,  7/16},
		{-3/16, -7/16,  3/16,  3/16, -6/16,  4/16},
		--Rails
		{-2/16, -6/16,  2/16, -1/16, -5/16,  8/16},
		{ 1/16, -6/16,  2/16,  2/16, -5/16,  8/16},
	},
	disconnected_back = {
		{-1/16, -6/16,  1/16,  1/16, -5/16,  2/16},
	},
	connect_right = {
		--Base
		{ 4/16, -8/16, -4/16,  8/16, -7/16,  4/16},
		--Railties
		{ 6/16, -7/16, -3/16,  7/16, -6/16,  3/16},
		{ 3/16, -7/16, -3/16,  4/16, -6/16,  3/16},
		--Rails
		{ 2/16, -6/16, -2/16,  8/16, -5/16, -1/16},
		{ 2/16, -6/16,  1/16,  8/16, -5/16,  2/16},
	},
	disconnected_right = {
		{ 1/16, -6/16, -1/16,  2/16, -5/16,  1/16},
	},
}

local rail_collision_box = {
	type = "connected",
	connect_sides = {"front", "left", "back", "right"},
	fixed = {
		{ -4/16, -8/16, -4/16,  4/16, -5/16,  4/16},
	},
	connect_front = {
		{ -4/16, -8/16, -8/16,  4/16, -5/16, -4/16},
	},
	connect_left = {
		{ -8/16, -8/16, -4/16, -4/16, -5/16,  4/16},
	},
	connect_back = {
		{ -4/16, -8/16,  4/16,  4/16, -5/16,  8/16},
	},
	connect_right = {
		{  4/16, -8/16, -4/16,  8/16, -5/16,  4/16},
	}
}

minetest.register_node("trains:rail", {
	description = ("Rail\nFor trains."),
	short_description = "Rail",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {dig_immediate = 2, rail = 1},
	tiles = {
		"train_new_top.png",
		"train_new_bottom.png",
		"train_new_side.png",
	},
	node_box = rail_node_box,
	collision_box = rail_collision_box,
	selection_box = rail_collision_box,
	connects_to = {"group:rail", "group:structures"},
})

minetest.register_node("trains:brake_rail", {
	description = ("Brake Rail\nReduces the speed of a train."),
	short_description = "Break Rail",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {dig_immediate = 2, rail = 1},
	tiles = {
		"train_new_top_brake.png",
		"train_new_bottom.png",
		"train_new_side.png",
	},
	node_box = rail_node_box,
	collision_box = rail_collision_box,
	selection_box = rail_collision_box,
	connects_to = {"group:rail", "group:structures"},
})

-- minetest.register_node("trains:power_rail", {
-- 	description = ("Powered Rail: Increases the speed of a train."),
-- 	drawtype = "nodebox",
-- 	paramtype = "light",
-- 	groups = {dig_immediate = 2, rail = 1},
-- 	tiles = {
-- 		"train_new_top_power.png",
-- 		"train_new_bottom.png",
-- 		"train_new_side.png",
-- 	},
-- 	node_box = rail_node_box,
-- 	collision_box = rail_collision_box,
-- 	selection_box = rail_collision_box,
-- 	connects_to = {"group:rail", "group:structures"},
-- })
