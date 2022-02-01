--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

local give_if_not_gotten_already = function(inv, list, item)
	if not inv:contains_item(list, item) then
		inv:add_item(list, item)
	end
end

local give_initial_stuff = function(player)
  local inv = player:get_inventory()
  give_if_not_gotten_already(inv, "main", "minegistics:Market" .. " 1")
  give_if_not_gotten_already(inv, "main", "minegistics:Town" .. " 1")
  give_if_not_gotten_already(inv, "main", "minegistics:Collector" .. " 2")
  give_if_not_gotten_already(inv, "main", "minegistics:PowerPlant" .. " 1")
  give_if_not_gotten_already(inv, "main", "minegistics_trains:train" .. " 3")
  give_if_not_gotten_already(inv, "main", "minegistics_trains:rail" .. " 100")
  give_if_not_gotten_already(inv, "main", "minegistics_basenodes:coal_lump" .. " 100")
	minetest.log("action", "[give_initial_stuff] Giving initial stuff to "..player:get_player_name())
end

minetest.register_on_newplayer(function(player)
	if minetest.settings:get_bool("give_initial_stuff", true) then
		give_initial_stuff(player)
	end
end)

minetest.register_chatcommand("stuff", {
	params = "",
	privs = { give = true },
	description = "Give yourself initial items",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player or not player:is_player() then
			return false, "No player."
		end
		give_initial_stuff(player)
		return true
	end,
})
