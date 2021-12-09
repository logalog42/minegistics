minetest.register_node("tiled:tiled", {
        description = "Tiled Node (world-aligned)",
        tiles = {{
                name = "tiled_tiled.png",
                align_style = "world",
                scale = 8,
        }},
        groups = {cracky=3},
})

minetest.register_node("tiled:tiled_n", {
        description = "Tiled Node (node-aligned)",
        tiles = {{
                name = "tiled_tiled.png",
                align_style = "node",
                scale = 8,
        }},
        groups = {cracky=3},
})
