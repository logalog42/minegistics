--[[
	Minegistics
	  logalog
	  Droog71
	License: AGPLv3
]]--

--TODO Create demands of specific items

local abm_timer = 0
local background = "form_bg.png"

minetest.register_node("minegistics:Market", {
	description = "Market: Changes any item into money.\n" ..
		"Must be connected by rail to a factory or collector.\n" ..
		"Must also be connected to a town.",
	tiles = {"buildings.png"},
	groups = {dig_immediate=2, structures=1},
	drawtype = "mesh",
	mesh = "market.obj",
	wield_image = "market_wield.png",
	inventory_image = "market_wield.png",
	on_construct = function(pos)
		table.insert(power_consumers, pos)
		local price_list = "-Prices-\n"
		for item, worth in pairs(item_worth) do
			local item_label = string.sub(item, 13, 100)
			if string.sub(item_label, 1, 9) == "basenodes" then
				item_label = string.sub(item_label, 11, 100)
			end
			price_list = price_list .. item_label .. ": $" .. worth .. "\n"
		end
		local meta = minetest.get_meta(pos)
		local formspec = {
			"size[8,9]",
			"list[context;main;0,0;8,4;]",
			"list[current_player;main;0,5.25;8,4;]",
			"listring[]",
			"image[0,1;9,4.75;"..background.."]",
			"scroll_container[1,2;12,4;recipe_scroll;vertical;0.05]",
			"label[0,0;" .. price_list .. "]",
			"scroll_container_end[]",
			"scrollbar[6.75,1.2;0.25,3.75;vertical;recipe_scroll;0]",
			"button[3.5,10;4,2;Back;Back]",
		}
		meta:set_string("formspec", table.concat(formspec, ""))
		meta:set_string("infotext", "Market")
		local inv = meta:get_inventory()
		inv:set_size("main", 5*1)
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		for i,p in pairs(power_consumers) do
			if p.x == pos.x and p.y == pos.y and p.z == pos.z then
				table.remove(power_consumers, i)
				break
			end
		end
		minetest.forceload_free_block(pos, false)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		return stack:get_count()
	end
})

--converts resources into money
minetest.register_abm({
	nodenames = {"minegistics:Market"},
	interval = 1,
	chance = 1,
	action = function(pos)
		abm_timer = abm_timer + 1
		if abm_timer >= math.random(8, 12) then
			minetest.forceload_block(pos, false)
			local meta = minetest.get_meta(pos)
			if power_stable(pos) and meta:get_int("has_town") == 1 then
				meta:set_int("has_town", 0)
				local inv = meta:get_inventory()
				local items = {}
				for item, worth in pairs(item_worth) do
					items[item] = ItemStack(item)
				end
				local money_earned = 0
				local inventories = inv:get_lists()
				for name, list in pairs(inventories) do
					for index, item in pairs(items) do
						while inv:contains_item(name, item) do
							inv:remove_item(name, item)
							money_earned = money_earned + item_worth[item:get_name()]
						end
					end
				end
				if money_earned > 0 then
					money = math.floor(money + money_earned)
					for index,price in pairs(item_prices) do
						local increase = money_earned * 0.01
						item_prices[index] = math.floor(item_prices[index] + increase)
					end
					for _,player in pairs(minetest.get_connected_players()) do
						local spec = player:get_inventory_formspec()
						local str = string.sub(spec,48,51)
						if str == "Shop" then
							local formspec = shop_formspec(player)
							player:set_inventory_formspec(table.concat(formspec, ""))
						end
					end
					minetest.chat_send_all(
						"Earned $" .. money_earned .. " from market at " ..
						"(" .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. ")"
					)
				end
			end
			abm_timer = 0
		end
	end
})
