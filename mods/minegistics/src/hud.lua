--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

Hud_ids = {}
Hud_bg_ids = {}
local shared_hud_timer = 0

--initializes all of the HUD elements
minetest.register_on_joinplayer(function(player)
    if player then
        Hud_bg_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "image",
            position = {x = 0.135, y = 0.95},
            offset = {x = 0, y = 0},
            scale = {x = 2, y = 1},
            text = "hud_bar.png",
            number = 0xFFFFFF
        })
        Hud_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0.05, y = 0.95},
            offset = {x = 0, y = 0},
            scale = {x = 1, y = 1},
            text = "Balance: $" .. Money,
            number = 0x00FF00
        })
    end
end)

--updates HUD info that is shared among all players
function Update_shared_hud()
    shared_hud_timer = shared_hud_timer + 1
    if shared_hud_timer >= 10 then
        for name, id in pairs(Hud_ids) do
            local player = minetest.get_player_by_name(name)
            if player then
                player:hud_remove(Hud_bg_ids[name])
                player:hud_remove(Hud_ids[name])
                if Show_money_on_hud == true then
                    Hud_bg_ids[name] = player:hud_add({
                        hud_elem_type = "image",
                        position = {x = 0.135, y = 0.95},
                        offset = {x = 0, y = 0},
                        scale = {x = 2, y = 1},
                        text = "hud_bar.png",
                        number = 0xFFFFFF
                    })
                    Hud_ids[name] = player:hud_add({
                        hud_elem_type = "text",
                        position = {x = 0.05, y = 0.95},
                        offset = {x = 0, y = 0},
                        scale = {x = 1, y = 1},
                        text = "Balance: $" .. Money,
                        number = 0x00FF00
                    })
                end
                local spec = player:get_inventory_formspec()
                local shop_title = string.sub(spec,48,51)
                if shop_title == "Shop" then
                    local formspec = Shop_formspec(player)
                    player:set_inventory_formspec(table.concat(formspec, ""))
                end
                local power_title = string.sub(spec,46,50)
                if power_title == "Power" then
                    local formspec = Power_formspec(player)
                    player:set_inventory_formspec(table.concat(formspec, ""))
                end
            end
        end
        shared_hud_timer = 0
    end
end
