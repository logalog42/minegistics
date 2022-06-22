--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

minegistics = {}
local loaded = false
minegistics.modpath = minetest.get_modpath("minegistics")
dofile(minegistics.modpath .. DIR_DELIM .. "src" .. DIR_DELIM .. "mapgen.lua")
dofile(minegistics.modpath .. DIR_DELIM .. "src" .. DIR_DELIM .. "power.lua")
dofile(minegistics.modpath .. DIR_DELIM .. "src" .. DIR_DELIM .. "items.lua")
dofile(minegistics.modpath .. DIR_DELIM .. "src" .. DIR_DELIM .. "hud.lua")
dofile(minegistics.modpath .. DIR_DELIM .. "src" .. DIR_DELIM .. "formspec.lua")
dofile(minegistics.modpath .. DIR_DELIM .. "src" .. DIR_DELIM .. "initial_items.lua")
dofile(minegistics.modpath .. DIR_DELIM .. "src" .. DIR_DELIM .. "welcome_message.lua")
dofile(minegistics.modpath .. DIR_DELIM .. "structures" .. DIR_DELIM .. "collector.lua")
dofile(minegistics.modpath .. DIR_DELIM .. "structures" .. DIR_DELIM .. "factory.lua")
dofile(minegistics.modpath .. DIR_DELIM .. "structures" .. DIR_DELIM .. "farm.lua")
dofile(minegistics.modpath .. DIR_DELIM .. "structures" .. DIR_DELIM .. "market.lua")
dofile(minegistics.modpath .. DIR_DELIM .. "structures" .. DIR_DELIM .. "town.lua")
dofile(minegistics.modpath .. DIR_DELIM .. "structures" .. DIR_DELIM .. "warehouse.lua")
dofile(minegistics.modpath .. DIR_DELIM .. "structures" .. DIR_DELIM .. "workshop.lua")
minetest.settings:set_bool("menu_clouds", false)
minetest.settings:set_bool("smooth_lighting", true)
minetest.register_item(":", { type = "none", wield_image = "blank.png"})

--TODO create a power bar for hud for easy referance

 --initializes the player and loads saved game
 minetest.register_on_joinplayer(function(player)
    player:hud_set_flags({hotbar = true, healthbar = false})
    player:set_properties({
        textures = { "blank.png", "blank.png" },
        visual = "upright_sprite",
        visual_size = { x = 1, y = 2 },
        collisionbox = {-0.49, 0, -0.49, 0.49, 2, 0.49 },
        initial_sprite_basepos = {x = 0, y = 0}
    })
    skybox.set(player, 1)
    minetest.set_player_privs(player:get_player_name(), {fly=true, fast=true})
    player:set_clouds({density = 0})
    local name = player:get_player_name()
    if loaded == false then
        local file = io.open(minetest.get_worldpath() .. DIR_DELIM .. "save_data.json", "r")
        if file then
            local data = minetest.parse_json(file:read "*a")
            if data then
                if data.money then
                    money = data.money
                end
                if data.item_prices then
                    item_prices = data.item_prices
                end
                if data.power_producers then
                    power_producers = data.power_producers
                end
                if data.power_consumers then
                    power_consumers = data.power_consumers
                end
            else
                minetest.log("error", "Failed to read save_data.json")
            end
            io.close(file)
        end
        loaded = true
    end
end)

--saves data
minetest.register_on_shutdown(function()
    local save_vars = {
        money = money,
        item_prices = item_prices,
        power_producers = power_producers,
        power_consumers = power_consumers
    }
    local save_data = minetest.write_json(save_vars)
    local save_path = minetest.get_worldpath() .. DIR_DELIM .. "save_data.json"
    minetest.safe_file_write(save_path, save_data)
end)

--main game loop
minetest.register_globalstep(function(dtime)   
    update_shared_hud()
end)
