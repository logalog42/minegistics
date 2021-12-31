--[[
    Shop Menu
    Author: Droog71
    License: AGPLv3
]]--

local index = 1
local item_buttons = {}
local item_btn_keys = {}
local loaded = false

local items_for_sale = { 
    ["Collector"] = "minegistics:Collector",
    ["Factory"] = "minegistics:Factory",
    ["Town"] = "minegistics:town",
    ["Warehouse"] = "minegistics:Warehouse",
    ["Market"] = "minegistics:Market",
    ["Rail"] = "carts:rail",
    ["Powered Rail"] = "carts:powerrail",
    ["Brake Rail"] = "carts:brakerail",
    ["Cart"] = "carts:cart"
}
local item_prices = { 
    ["Collector"] = 2000,
    ["Factory"] = 1000,
    ["Town"] = 1000,
    ["Warehouse"] = 1000,
    ["Market"] = 5000,
    ["Rail"] = 100,
    ["Powered Rail"] = 500,
    ["Brake Rail"] = 100,
    ["Cart"] = 1000
}

--defines the inventory formspec
local function inventory_formspec(player)
    local formspec = {
        "size[8,7.5]",
        "bgcolor[#353535;false]",
        "list[current_player;main;0,3.5;8,4;]",
        "list[current_player;craft;3,0;3,3;]",
        "list[current_player;craftpreview;7,1;1,1;]",
        "button[0.5,1;2,0.5;Shop;Shop]"
    }
    return formspec
end

minetest.register_on_joinplayer(function(player)
    if loaded == false then
        for item_name,item in pairs(items_for_sale) do
            item_buttons[index] = "button[3," .. 
                index .. ";4,2;" .. item_name ..
                ";" .. item_name .. "]" ..
                "item_image[7," .. index + 0.6 .. 
                ";0.6,0.6;" .. item .. "]" ..
                "label[8," .. index + 0.6 .. ";" .. " $" .. 
                item_prices[item_name] .."]"
            item_btn_keys[item_name] = item
            index = index + 1
        end
        loaded = true
    end
    local formspec = inventory_formspec(player)
    player:set_inventory_formspec(table.concat(formspec, ""))
end)

--defines the shop formspec
function shop_formspec(player)
    local formspec = {
        "size[10,16]",
        "bgcolor[#353535;false]",
        table.concat(item_buttons),
        "label[3.5,11.5;".."Your balance: $" .. player_money[player:get_player_name()].."]",
        "button[3,13;4,2;Back;Back]"
    }
    return formspec
end

--handles clicked buttons
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "" then return end
    local player_name = player:get_player_name()
    for key, val in pairs(fields) do
        if key == "Shop" then
            local formspec = shop_formspec(player)
            player:set_inventory_formspec(table.concat(formspec, ""))
        elseif key == "Back" then
            local formspec = inventory_formspec(player)
            player:set_inventory_formspec(table.concat(formspec, ""))
        else
            for item_name,item in pairs(item_btn_keys) do
                if key == item_name then
                    local item = ItemStack(item)
                    if player_money[player_name] >= item_prices[item_name] then
                        if player:get_inventory():add_item("main", item) then
                            player_money[player_name] = player_money[player_name] - item_prices[item_name]
                            minetest.chat_send_player(
                                player_name,"You bought a " .. item_name .. "!   " ..
                                "$" .. player_money[player_name] .. " remaining."
                            )
                            local formspec = shop_formspec(player)
                            player:set_inventory_formspec(table.concat(formspec, ""))
                        end
                    else
                        minetest.chat_send_player(player_name, "You can't afford that!")
                    end
                end
            end
        end
    end    
end)
