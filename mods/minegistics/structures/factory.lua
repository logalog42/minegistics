--[[
	Minegistics
	  logalog
	  Droog71
	License: AGPLv3
]]--

local abm_timer = 0
local background = "form_bg.png"

minetest.register_node("minegistics:Factory", {
	description = "Factory: Combines products to create more advanced items.",
	tiles = {"buildings.png"},
	groups = {dig_immediate=2, structures=1},
	drawtype = "mesh",
	mesh = "factory.obj",
	wield_image = "factory_wield.png",
 	inventory_image = "factory_wield.png",
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.above.y ~= 0 then
        minetest.chat_send_player(placer:get_player_name(), "You can't build here.")
        return
        end
        return minetest.item_place(itemstack, placer, pointed_thing)
    end,
	on_construct = function(pos)
		table.insert(power_consumers, pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("name", "Factory")
		meta:set_string("type", "Assembling")
		meta:set_string("infotext", "Factory")
		local inv = meta:get_inventory()
		inv:set_size("input", 1*4)
		inv:set_size("output", 1*4)
		meta:set_string("formspec", strut_form.structure_formspec(pos, ''))
	
	end,
	
	on_receive_fields = function(pos, formname, fields, sender)
		for key, value in pairs(fields) do
			minetest.log("default", key .. " = " .. value)
		end

		if fields['submit'] then
			if fields['recipies'] ~= '' then
				local display = fields['recipies']
				strut_form.structure_formspec(pos,display)
			end
		end
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
	nodenames = {"minegistics:Factory"},
	interval = 1,
	chance = 1,
	action = function(pos)
		abm_timer = abm_timer + 1
		if abm_timer >= math.random(8, 12) then
			minetest.forceload_block(pos, false)
			if power_stable(pos) then
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory()
				local inventories = inv:get_lists()
				local ingredients = {}
				local working = false
				for output, inputs in pairs(factory_recipes) do
					ingredients[output] = { ItemStack(inputs[1]), ItemStack(inputs[2]) }
				end
				for name, list in pairs(inventories) do
					for result, stacks in pairs(ingredients) do
						while inv:contains_item(name, stacks[1]) and inv:contains_item(name, stacks[2]) do
							inv:remove_item(name, stacks[1])
							inv:remove_item(name, stacks[2])
							local result_stack = ItemStack(result)
							inv:add_item("main", result_stack)
							working = true
						end
					end
				end
				if working then
					minetest.sound_play("factory", {
						pos = pos,
						loop = false,
						max_hear_distance = 16
					})
					if minetest.settings:get_bool("minegistics_particles", true) then
						minetest.add_particlespawner({
							amount = 30,
							time = 3,
							minpos = {x=pos.x,y=pos.y+1,z=pos.z},
							maxpos = {x=pos.x,y=pos.y+2,z=pos.z},
							minvel = {x=0.1, y=0.1, z=0.1},
							maxvel = {x=0.2, y=0.2, z=0.2},
							minacc = {x=-0.1,y=0.1,z=-0.1},
							maxacc = {x=0.2,y=0.2,z=0.2},
							minexptime = 6,
							maxexptime = 8,
							minsize = 10,
							maxsize = 12,
							collisiondetection = false,
							vertical = false,
							texture = "smoke.png"
						})
					end
				end
			end
			abm_timer = 0
		end
	end
})
