--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

show_money_on_hud = true
local item_buttons = {}
local item_btn_keys = {}

local items_for_sale = {
    ["Collector"] = "minegistics:Collector",
    ["Power Plant"] = "minegistics:PowerPlant",
    ["Factory"] = "minegistics:Factory",
    ["Town"] = "minegistics:Town",
    ["Warehouse"] = "minegistics:Warehouse",
    ["Market"] = "minegistics:Market",
    ["Rail"] = "trains:rail",
    ["Powered Rail"] = "trains:power_rail",
    ["Brake Rail"] = "trains:brake_rail",
    ["Train"] = "trains:train",
    ["Workshop"] = "minegistics:Workshop",
    ["Farm"] = "minegistics:Farm"
}

item_prices = {
    ["Farm"] = 300,
    ["Collector"] = 300,
    ["Factory"] = 500,
    ["Town"] = 200,
    ["Warehouse"] = 100,
    ["Market"] = 500,
    ["Rail"] = 20,
    ["Workshop"] = 400,
    ["Powered Rail"] = 200,
    ["Brake Rail"] = 40,
    ["Train"] = 100,
    ["Power Plant"] = 350,
}

--defines the inventory formspec
function inventory_formspec(player)
    local display = show_money_on_hud and "true" or "false"
    local formspec = {
        "size[8,7.5]",
        "bgcolor[#2d2d2d;false]",
        "list[current_player;main;0,3.5;8,4;]",
        "button[3,0.5;2,0.5;Power;Power]",
        "tooltip[Power;" ..
        "View power grid status." ..
        ";#353535;#FFFFFF]",
        "button[3,1.5;2,0.5;Shop;Shop]",
        "tooltip[Shop;" ..
        "Purchase buildings, trains and rails." ..
        ";#353535;#FFFFFF]",
        "checkbox[3.05,2.3;display;Show balance on HUD;" .. display .. "]",
    }
    return formspec
end

--defines the inventory formspec
function power_formspec(player)
    local power_info = ""
    for index,pos in pairs(power_producers) do
        local local_consumers = 0
        local local_producers = 0
        for index,consumer in pairs(power_consumers) do
            if vector.distance(consumer, pos) < 200 then
                local_consumers = local_consumers + 1
            end
        end
        for index,producer in pairs(power_producers) do
            if vector.distance(producer, pos) < 200 then
                local_producers = local_producers + 1
            end
        end
        local stable = local_consumers <= local_producers * 5
        local stable_display = stable and "stable" or "unstable"
        power_info = power_info .. local_consumers .. " consumers and " ..
        local_producers .. " producers for power plant at (" ..
        pos.x .. ", " .. pos.y .. ", " .. pos.z .. ")" ..
        " (" .. stable_display .. ")\n"
    end
    local formspec = {
        "size[11,11]",
        "bgcolor[#353535;false]",
        "label[5,0.5;Power]",
        "scroll_container[1,1;12,8;power_scroll;vertical;0.1]",
        "label[1,1;" .. power_info .. "]",
        "scroll_container_end[]",
        "scrollbar[10,1;0.25,8;vertical;power_scroll;0]",
        "button[3.5,10;4,2;Back;Back]"
    }
    return formspec
end

minetest.register_on_joinplayer(function(player)
    local formspec = inventory_formspec(player)
    player:set_inventory_formspec(table.concat(formspec, ""))
end)

--defines the shop formspec
function shop_formspec(player)
    item_buttons = {}
    local index = 1
    for item_name,item in pairs(items_for_sale) do
        local stack = ItemStack(item)
        item_buttons[index] = "button[3," ..
            index .. ";4,2;" .. item_name ..
            ";" .. item_name .. "]" ..
            "item_image[7," .. index + 0.6 ..
            ";0.6,0.6;" .. item .. "]" ..
            "tooltip[" .. item_name .. ";" ..
            stack:get_description() .. ";#353535;#FFFFFF]" ..
            "label[8," .. index + 0.6 .. ";" .. " $" ..
            item_prices[item_name] .."]"
        item_btn_keys[item_name] = item
        index = index + 1
    end
    local formspec = {
        "size[10,16]",
        "bgcolor[#353535;false]",
        "label[4.5,0.5;Shop]",
        table.concat(item_buttons),
        "label[3.5,13.6;".."Your balance: $" .. money.."]",
        "button[3,14;4,2;Back;Back]"
    }
    return formspec
end

--handles clicked buttons
minetest.register_on_player_receive_fields(function(player, formname, fields)
    local player_name = player:get_player_name()
    if formname == "" then
        for key, val in pairs(fields) do
            if key == "Shop" then
                local formspec = shop_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "Back" then
                local formspec = inventory_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "Power" then
                local formspec = power_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "display" then
                show_money_on_hud = not show_money_on_hud
            else
                for item_name,item in pairs(item_btn_keys) do
                    if key == item_name then
                        local stack = ItemStack(item)
                        if item_name == "Rail" then
                            stack:set_count(10)
                        end
                        if money >= item_prices[item_name] then
                            if player:get_inventory():add_item("main", stack) then
                                money = money - item_prices[item_name]
                                local players = minetest.get_connected_players()
                                local player_count = get_table_size(players)
                                local purchaser = player_count > 1 and player_name or "You"
                                minetest.chat_send_all(purchaser .. " bought a " ..
                                    item_name .. "!   " .. "$" .. money .. " remaining."
                                )
                                local formspec = shop_formspec(player)
                                player:set_inventory_formspec(table.concat(formspec, ""))
                            end
                        else
                            minetest.chat_send_player(player_name, "Insufficient funds!")
                        end
                    end
                end
            end
        end
    end
end)

function structure_formspec(player, pos, node)
    local text = "hi"
    
    local formspec = {
        "formspec_version[6]",
		"size[13,10]",

		--Title Area
		"container[.5,.5]" ..
		"label[0,0;" .. node.name .. "]" ..
		"container_end[]" ..

		--Selection Area
		"container[2,2]" ..
		"dropdown[0,0;6,.75;recipies;iron,clay;0;]" ..
		"button_exit[6.25,0;2,.75;submit;Submit]" ..
		"container_end[]" ..
		
		--Input Inventory
		"container[0.25,3.5]" ..
		"list[nodemeta:" .. pos.x .. ",".. pos.y .. ",".. pos.z .. ";input;0,0;1,4;]" ..
		"container_end[]" ..

		--Output Inventory
		"container[11.75,3.5]" ..
		"list[nodemeta:" .. pos.x .. ",".. pos.y .. ",".. pos.z .. ";output;0,0;1,4;]" ..
		"container_end[]" ..

		--Info Display
		"container[1.5,1]" ..
		"label[0,0;", minetest.formspec_escape(text), "]" ..
		"container_end[]",

		--Player Inventory Display
		"container[1.5,8.75]" ..
		"list[current_player;main;0,0;8,1;]" ..
		"container_end[]",
    }
end