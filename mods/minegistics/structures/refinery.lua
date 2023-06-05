
local abm_timer = 0
local background = "form_bg.png"

minetest.register_node("minegistics:Refinery", {
	description = "Refinery: basic resources into better goods",
	tiles = {"refinery.png"},
	groups = {dig_immediate=2, structures=1},
	drawtype = "mesh",
    visual_scale = 1,
	mesh = "refinery.obj",
	wield_image = "refinery_wield.png",
 	inventory_image = "refinery_wield.png",
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
		meta:set_string("name", "Refinery")
		meta:set_string("type", "Refining")
		meta:set_string("infotext", "Refinery")
		meta:set_string("display_recipe", "")
		meta:set_string("tutorial", "With this building you are going to take a single resource and turn it into a much more valuable trade good. Mostly for different ores")
		local inv = meta:get_inventory()
		inv:set_size("input", 1*4)
		inv:set_size("output", 1*4)
		meta:set_string("formspec", Strut_form.structure_formspec(pos))
        local timer = minetest.get_node_timer(pos)
        timer:start(3) -- in seconds
	
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
			local possible_recipes = RecipiesInStructure[meta:get_string("name")]

			for output, inputs in pairs(possible_recipes) do
				local compare_output = string.sub(output, 13, 100)
				--minetest.log("default", "fields.recipes = " .. fields.recipes)
				--minetest.log("default","Compare_output = " .. compare_output)
				if fields.recipes == compare_output then
					--minetest.log("default", "fields.recipes == compare_output")
					meta:set_string("display_recipe", output)
					--minetest.log("default", "display_recipe = " .. meta:get_string("display_recipe"))
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
	end,

    on_timer = function(pos)
        minetest.forceload_block(pos, false)
		local meta = minetest.get_meta(pos)
		--minetest.log("default", "display_recipe = " .. meta:get_string("display_recipe"))
        if Power_stable(pos) and meta:get_string("display_recipe") ~= '' then
			local input = meta:get_inventory("input")
			local output = meta:get_inventory("output")
            local ingredients = {}
            local working = false
            for struct_output, struct_input in pairs(RecipiesInStructure.Refinery) do
                ingredients[struct_input] = ItemStack(struct_output)
            end
            for ing_input, ing_output in pairs(ingredients) do
				--minetest.log("default", "ing_output = " .. ing_output .. " ing_input = " .. ing_input)
                if input:contains_item(ing_output == meta.display_recipe and input:contains_item("input", ItemStack(ing_input) .. " 1") then
                    input:remove_item("input", ItemStack(ing_input) .. " 1")
                    output:add_item("output", ItemStack(ing_output) .. " 1")
                    working = true
                end
            end

			local meta = minetest.get_meta(pos)

			local ingredients = {}
			local working = false
			for output, inputs in pairs(RecipiesInStructure.Factory) do
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
		return true
    end
})
