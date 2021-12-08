--
-- Aliases for map generator outputs
--

-- ESSENTIAL node aliases
-- Basic nodes
minetest.register_alias("mapgen_stone", "basenodes:stone")
minetest.register_alias("mapgen_water_source", "basenodes:water_source")
minetest.register_alias("mapgen_river_water_source", "basenodes:river_water_source")

-- Additional essential aliases for v6
minetest.register_alias("mapgen_lava_source", "basenodes:lava_source")
minetest.register_alias("mapgen_dirt", "basenodes:dirt")
minetest.register_alias("mapgen_dirt_with_grass", "basenodes:dirt_with_grass")
minetest.register_alias("mapgen_sand", "basenodes:sand")
minetest.register_alias("mapgen_tree", "basenodes:tree")
minetest.register_alias("mapgen_leaves", "basenodes:leaves")
minetest.register_alias("mapgen_apple", "basenodes:apple")

-- Essential alias for dungeons
minetest.register_alias("mapgen_cobble", "basenodes:cobble")
minetest.register_alias("mapgen_gravel", "basenodes:gravel")
minetest.register_alias("mapgen_desert_stone", "basenodes:desert_stone")
minetest.register_alias("mapgen_desert_sand", "basenodes:desert_sand")
minetest.register_alias("mapgen_dirt_with_snow", "basenodes:dirt_with_snow")
minetest.register_alias("mapgen_snowblock", "basenodes:snowblock")
minetest.register_alias("mapgen_snow", "basenodes:snow")
minetest.register_alias("mapgen_ice", "basenodes:ice")
minetest.register_alias("mapgen_junglegrass", "basenodes:junglegrass")
minetest.register_alias("mapgen_jungletree", "basenodes:jungletree")
minetest.register_alias("mapgen_jungleleaves", "basenodes:jungleleaves")
minetest.register_alias("mapgen_pine_tree", "basenodes:pine_tree")
	minetest.register_alias("mapgen_pine_needles", "basenodes:pine_needles")
-- Optional alias for mossycobble (should fall back to cobble)
if minetest.settings:get_bool("devtest_dungeon_mossycobble", false) then
	minetest.register_alias("mapgen_mossycobble", "basenodes:mossycobble")
end
-- Optional aliases for dungeon stairs (should fall back to full nodes)
if minetest.settings:get_bool("devtest_dungeon_stairs", false) then
	minetest.register_alias("mapgen_stair_cobble", "stairs:stair_cobble")
	if minetest.settings:get_bool("devtest_v6_mapgen_aliases", false) then
		minetest.register_alias("mapgen_stair_desert_stone", "stairs:stair_desert_stone")
	end
end
