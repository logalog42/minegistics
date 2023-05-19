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
      table.insert(Power_consumers, pos)
      local meta = minetest.get_meta(pos)
	  local inv = meta:get_inventory()
	  meta:set_string("name", "Workshop")
	  meta:set_string("type", "Processing")
	  meta:set_string("infotext", "Workshop")
	  meta:set_string("display_recipe", "")
	  meta:set_string("tutorial", "With this building you are going to process resources into two different items.")
	  inv:set_size("input", 1*4)
	  inv:set_size("output", 1*4)
      meta:set_string("formspec", Strut_form.structure_formspec(pos))
      inv:set_size("main", 5*1)
	end,

	on_receive_fields = function(pos, formname, fields, sender)

		local meta = minetest.get_meta(pos)

		--[[
		minetest.log("default", "----------Recieve Instance----------")
		for key, value in pairs(fields) do
			minetest.log("default", "Field: " .. key .. " = " .. value)
		end
		]]--

		if fields['submit'] then
			local meta = minetest.get_meta(pos)
			local possible_recipes = RecipiesInStructure[meta:get_string("name")]

			for output, inputs in pairs(possible_recipes) do
				local compare_output = string.sub(output, 13, 100)
				--minetest.log("default", "fields.recipes = " .. fields.recipes)
				--minetest.log("default","Compare_output = " .. compare_output)
				if fields.recipes == compare_output then
					--minetest.log("default", "fields.recipes == compare_output")
					meta:set_string("display_recipe", output)
				end
				compare_output = ''
			end

			meta:set_string("formspec", Strut_form.structure_formspec(pos))
			--minetest.log("default", "formspec should be updated.")

		end
	end,

	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		for i,p in pairs(Power_consumers) do
			if p.x == pos.x and p.y == pos.y and p.z == pos.z then
				table.remove(Power_consumers, i)
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
			if Power_stable(pos) then
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory()
				local items = {}
				local working = false
				for input, output in pairs(RecipiesInStructure.Workshop) do
					items[input] = ItemStack(input)
				end
				local inventories = inv:get_lists()
				for name, list in pairs(inventories) do
					for index, item in pairs(items) do
						while inv:contains_item(name, item) do
							local item_name = item:get_name()
							local product = Refinery_recipes[item_name]
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
