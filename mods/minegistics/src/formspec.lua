--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

Show_money_on_hud = true
local item_buttons = {}
local item_btn_keys = {}
Strut_form = {}

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

Item_prices = {
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
function Inventory_formspec(player)
    local display = Show_money_on_hud and "true" or "false"
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
function Power_formspec(player)
    local power_info = ""
    for index,pos in pairs(Power_producers) do
        local local_consumers = 0
        local local_producers = 0
        for index,consumer in pairs(Power_consumers) do
            if vector.distance(consumer, pos) < 200 then
                local_consumers = local_consumers + 1
            end
        end
        for index,producer in pairs(Power_producers) do
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
    local formspec = Inventory_formspec(player)
    player:set_inventory_formspec(table.concat(formspec, ""))
end)

--defines the shop formspec
function Shop_formspec(player)
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
            Item_prices[item_name] .."]"
        item_btn_keys[item_name] = item
        index = index + 1
    end
    local formspec = {
        "size[10,16]",
        "bgcolor[#353535;false]",
        "label[4.5,0.5;Shop]",
        table.concat(item_buttons),
        "label[3.5,13.6;".."Your balance: $" .. Money.."]",
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
                local formspec = Shop_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "Back" then
                local formspec = Inventory_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "Power" then
                local formspec = Power_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "display" then
                Show_money_on_hud = not Show_money_on_hud
            else
                for item_name,item in pairs(item_btn_keys) do
                    if key == item_name then
                        local stack = ItemStack(item)
                        if item_name == "Rail" then
                            stack:set_count(10)
                        end
                        if Money >= Item_prices[item_name] then
                            if player:get_inventory():add_item("main", stack) then
                                Money = Money - Item_prices[item_name]
                                local players = minetest.get_connected_players()
                                local player_count = Get_table_size(players)
                                local purchaser = player_count > 1 and player_name or "You"
                                minetest.chat_send_all(purchaser .. " bought a " ..
                                    item_name .. "!   " .. "$" .. Money .. " remaining."
                                )
                                local formspec = Shop_formspec(player)
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

function Strut_form.recipie_display(type, recipie)
    local input = {}
    local output = {}

    if type == "Processing" then
        local formspec = {  
        --Input 1
        "item_image[1,1;1,1;" .. input(1) .."" ..
        --Working Image
        "animated_image[3,2;5,3;<name>;<texture name>;<frame count>;<frame duration>;<frame start>;<middle>]" ..
        --Output 1
        "item_image[7,2;1,1;" .. output(1) .. "]" ..
        --Output 2
        "item_image[7,2;1,1;" .. output(2) .. "]" 
    

        }
    elseif type == "Assembling" then
        local formspec = {
            --Input 1
            "item_image[1,1;1,1;" .. input(1) .."" ..
            --Input 2
            "item_image[1,3;1,1;" .. input(2) .. "]" ..
            --Working Image
            "animated_image[3,2;5,3;<name>;<texture name>;<frame count>;<frame duration>;<frame start>;<middle>]" ..
            --Output
            "item_image[7,2;1,1;" .. output(1) .. "]" 
        }
    elseif type == "Refining" then
        local formspec = {
            --Input 1
            "item_image[1,1;1,1;" .. input(1) .."" ..
            --Working Image
            "animated_image[3,2;5,3;<name>;<texture name>;<frame count>;<frame duration>;<frame start>;<middle>]" ..
            --Output
            "item_image[7,2;1,1;" .. output(1) .. "]" 
        }
    end
end

function Strut_form.structure_formspec(pos,display)
    local text = "hi"
    local meta = minetest.get_meta(pos)
    local recipies = ""
    local current_recipe

    if display ~= '' then
        current_recipe = Strut_form.recipie_display(meta:get_string('type'), display)
    end

    for output, inputs in pairs(Factory_recipes) do
        local output_label = string.sub(output, 13, 100)
        recipies = recipies .. ", " .. output_label
    end
    
    local formspec = {
        "formspec_version[6]",
		"size[13,10]",

		--Title Area
		"container[.5,.5]" ..
		"label[0,0;" .. meta:get_string('name') .. "]" ..
		"container_end[]" ..

		--Selection Area
		"container[2,2]" ..
		"dropdown[0,0;6,.75;recipies;" .. recipies .. ";0;]" ..
		"button[6.25,0;2,.75;submit;Submit]" ..
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
		"label[0,0;", current_recipe , "]" ..
		"container_end[]",

		--Player Inventory Display
		"container[1.5,8.75]" ..
		"list[current_player;main;0,0;8,1;]" ..
		"container_end[]",
    }
        -- table.concat is faster than string concatenation - `..`
    return table.concat(formspec, "")
end