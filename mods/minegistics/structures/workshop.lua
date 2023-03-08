--[[
	Minegistics
	  logalog
	  Droog71
	License: AGPLv3
]]--

local abm_timer = 0
local background = "form_bg.png"

minetest.register_node("minegistics:Workshop", {
    description = "Workshop: Converts resources into products.\n" ..
        "Both can be sold but products are worth more.",
    tiles = {"buildings.png"},
    groups = {dig_immediate=2, structures=1},
    drawtype = 'mesh',
    mesh = "workshop.obj",
    wield_image = "workshop_wield.png",
    inventory_image = "workshop_wield.png",
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.above.y ~= 0 then
            minetest.chat_send_player(placer:get_player_name(), "You can't build here.")
            return
        end
        return minetest.item_place(itemstack, placer, pointed_thing)
end,
   on_construct = function(pos)
      table.insert(power_consumers, pos)
      local recipe_list = "-Recipes-\n"
      for input, output in pairs(workshop_recipes) do
          local input_label = string.sub(input, 23, 100)
          local output_label = string.sub(output, 13, 100)
          recipe_list = recipe_list .. input_label .. " -> " .. output_label .. "\n"
      end
      local meta = minetest.get_meta(pos)
      local formspec = {
          "size[8,9]",
          "list[context;main;0,0;8,4;]",
          "list[current_player;main;0,5.25;8,4;]",
          "image[0,1;9,4.75;"..background.."]",
          "scroll_container[1,2;12,4;recipe_scroll;vertical;0.05]",
          "label[0,0;" .. recipe_list .. "]",
          "scroll_container_end[]",
          "scrollbar[6.75,1.2;0.25,3.75;vertical;recipe_scroll;0]",
          "button[3.5,10;4,2;Back;Back]"
      }
      meta:set_string("formspec", table.concat(formspec, ""))
      meta:set_string("infotext", "Workshop")
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

--converts resources into products
minetest.register_abm({
	nodenames = {"minegistics:Workshop"},
	interval = 1,
	chance = 1,
	action = function(pos)
		abm_timer = abm_timer + 1
		if abm_timer >= math.random(8, 12) then
			minetest.forceload_block(pos, false)
			if power_stable(pos) then
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory()
				local items = {}
				local working = false
				for input, output in pairs(workshop_recipes) do
					items[input] = ItemStack(input)
				end
				local inventories = inv:get_lists()
				for name, list in pairs(inventories) do
					for index, item in pairs(items) do
						while inv:contains_item(name, item) do
							local item_name = item:get_name()
							local product = workshop_recipes[item_name]
							local stack = ItemStack(product)
							inv:remove_item(name, item)
							inv:add_item("main", stack)
							working = true
						end
					end
				end
				if working then
					minetest.sound_play("workshop", {
						pos = pos,
						loop = false,
						max_hear_distance = 16
					})
					if minetest.settings:get_bool("minegistics_particles", true) then
						minetest.add_particlespawner({
							amount = 10,
							time = 1,
							minpos = {x=pos.x,y=pos.y,z=pos.z},
							maxpos = {x=pos.x,y=pos.y+1,z=pos.z},
							minvel = {x=0.1, y=0.1, z=0.1},
							maxvel = {x=0.2, y=0.2, z=0.2},
							minacc = {x=-0.1,y=0.1,z=-0.1},
							maxacc = {x=0.2,y=0.2,z=0.2},
							minexptime = 1,
							maxexptime = 2,
							minsize = 2,
							maxsize = 4,
							collisiondetection = false,
							vertical = false,
							texture = "black_smoke.png"
						})
					end
				end
			end
			abm_timer = 0
		end
	end
})
