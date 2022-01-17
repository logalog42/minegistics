--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

--defines the greeting formspec
local function greeting_formspec(player)
    local greeting = "Welcome to Minegistics! Press I to open your inventory.\n" ..
      "Hover over the items there and place the objects accordingly.\n" ..
      "Open the shop window for more information.\n" ..
      "Good luck and have fun!"
    local formspec = {
        "size[8.5,8.5]",
        "bgcolor[#2d2d2d;false]",
        "button_exit[3,7;2,0.5;OK;OK]",
        "label[1,1;" .. greeting .. "]"
    }
    return formspec
end

--shows the greeting formspec
minetest.register_on_joinplayer(function(player)
	local cb = function(player)
		if not player or not player:is_player() then
			return
		end
    local name = player:get_player_name()
		minetest.show_formspec(name,"greeting",table.concat(greeting_formspec()))
	end
	minetest.after(2.0, cb, player)
end)
