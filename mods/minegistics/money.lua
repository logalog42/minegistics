--[[
    Minetest Money
    Author: Droog71
    License: AGPLv3
]]--

player_money = {}
local loaded = false

--saves data
minetest.register_on_shutdown(function()
    local save_data = minetest.write_json(player_money)
    local save_path = minetest.get_worldpath() .. DIR_DELIM .. "save_data.json"
    minetest.safe_file_write(save_path, save_data)
end)

 --loads data and gives the player money
 minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    if loaded == false then
        local file = io.open(minetest.get_worldpath() .. DIR_DELIM .. "save_data.json", "r")  
        if file then
            local data = minetest.parse_json(file:read "*a")
            if data then
                player_money = data
            else
                minetest.log("error", "Failed to read save_data.json")
            end
            io.close(file)
        end
        loaded = true
    end
    if not player_money[name] then
        player_money[name] = 1000
    end
end)
