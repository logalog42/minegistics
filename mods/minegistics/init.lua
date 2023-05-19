--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

Money = 100

local loaded = false
local enable_fog = minetest.settings:get_bool("enable_fog")
local menu_clouds = minetest.settings:get_bool("menu_clouds")
local mip_map = minetest.settings:get_bool("mip_map")
local smooth_lighting = minetest.settings:get_bool("smooth_lighting")

minetest.settings:set_bool("enable_fog", false)
minetest.settings:set_bool("menu_clouds", false)
minetest.settings:set_bool("mip_map", true)
minetest.settings:set_bool("smooth_lighting", true)
minetest.register_item(":", { type = "none", wield_image = "blank.png"})

dofile(minetest.get_modpath("minegistics") .. DIR_DELIM .. "src" .. DIR_DELIM .. "do_file.lua")

 --initializes the player and loads saved game
 minetest.register_on_joinplayer(function(player)
    player:hud_set_flags({hotbar = true, healthbar = false})
    player:set_properties({
        textures = { "blimp.png" },
        visual = "mesh",
        mesh = "blimp.obj",
        visual_size = { x = 4, y = 4 },
        collisionbox = {-0.49, 0, -0.49, 0.49, 1, 0.49 }
    })
    Skybox.set(player, 1)
    minetest.set_player_privs(player:get_player_name(), {fly=true, fast=true})
    player:set_clouds({density = 0})
    local name = player:get_player_name()
    if loaded == false then
        local file = io.open(minetest.get_worldpath() .. DIR_DELIM .. "save_data.json", "r")
        if file then
            local data = minetest.parse_json(file:read "*a")
            if data then
                if data.money then
                    Money = data.money
                end
                if data.item_prices then
                    Item_prices = data.item_prices
                end
                if data.power_producers then
                    Power_producers = data.power_producers
                end
                if data.power_consumers then
                    Power_consumers = data.power_consumers
                end
            else
                minetest.log("error", "Failed to read save_data.json")
            end
            io.close(file)
        end
        loaded = true
    end
end)

--removes the player from hud lists
minetest.register_on_leaveplayer(function(player)
    if player then
        local name = player:get_player_name()
        Hud_ids[name] = nil
        Hud_bg_ids[name] = nil
    end
end)

--saves data
minetest.register_on_shutdown(function()
    local save_vars = {
        money = Money,
        item_prices = Item_prices,
        power_producers = Power_producers,
        power_consumers = Power_consumers
    }
    local save_data = minetest.write_json(save_vars)
    local save_path = minetest.get_worldpath() .. DIR_DELIM .. "save_data.json"
    minetest.safe_file_write(save_path, save_data)
    minetest.settings:set_bool("enable_fog", enable_fog)
    minetest.settings:set_bool("menu_clouds", menu_clouds)
    minetest.settings:set_bool("mip_map", mip_map)
    minetest.settings:set_bool("smooth_lighting", smooth_lighting)
end)

--main game loop
minetest.register_globalstep(function(dtime)   
    Update_shared_hud()
end)

--gets the size of a table
function Get_table_size(table)
    local size = 0
    for k,v in pairs(table) do
        size = size + 1
    end
    return size
end
