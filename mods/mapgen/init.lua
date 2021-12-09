--
-- Aliases for map generator outputs
--

-- ESSENTIAL node aliases
-- Basic nodes
minetest.register_alias("mapgen_stone", "basenodes:stone")
minetest.register_alias("mapgen_river_water_source", "basenodes:river_water_source")
minetest.register_alias("mapgen_dirt", "basenodes:dirt")
minetest.register_alias("mapgen_dirt_with_grass", "basenodes:dirt_with_grass")
minetest.register_alias("mapgen_sand", "basenodes:sand")
minetest.register_alias("mapgen_leaves", "basenodes:leaves")
minetest.register_alias("mapgen_cobble", "basenodes:cobble")
minetest.register_alias("mapgen_gravel", "basenodes:gravel")


function minetest.register_ores()
	-- Scatter ores

	-- Coal

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_coal",
		wherein        = "default:stone",
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size     = 1,
		y_max          = 0,
		y_min          = -2,
	})

	-- Tin

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_tin",
		wherein        = "default:stone",
		clust_scarcity = 10 * 10 * 10,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})

	-- Copper

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_copper",
		wherein        = "default:stone",
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})

	-- Iron

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_iron",
		wherein        = "default:stone",
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 12,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})

	-- Gold

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_gold",
		wherein        = "default:stone",
		clust_scarcity = 13 * 13 * 13,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})
end
