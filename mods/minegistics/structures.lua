minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
    if node.name == "minegistics:Collector" then
        local item = ItemStack("minegistics_structures:Collector")
        if puncher:get_inventory():add_item("main", item) then
            minetest.remove_node(pos)
        end
    elseif node.name == "minegistics:Market" then
        local item = ItemStack("minegistics:Market")
        if puncher:get_inventory():add_item("main", item) then
            minetest.remove_node(pos)
        end
    end
end)

--Collects Coal
minetest.register_abm({
    nodenames = {"minegistics:Collector"},
    neighbors = {"basenodes:stone_with_coal"},
    interval = 1, -- Run every 1 second
    chance = 1, -- Select every 1 in 1 node
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      if inv:contains_item("main", "basenodes:coal_lump") then
        inv:add_item("main", "basenodes:coal_lump")
      else
        inv:set_stack("main", 1, "basenodes:coal_lump")
      end
    end
})

--Collects Iron
minetest.register_abm({
    nodenames = {"minegistics:Collector"},
    neighbors = {"basenodes:stone_with_iron"},
    interval = 1, -- Run every 1 second
    chance = 1, -- Select every 1 in 1 node
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      if inv:contains_item("main", "basenodes:iron_lump") then
       inv:add_item("main", "basenodes:iron_lump")
      else
       inv:set_stack("main", 2, "basenodes:iron_lump")
      end
      end
})

--Collects Copper
minetest.register_abm({
    nodenames = {"minegistics:Collector"},
    neighbors = {"basenodes:stone_with_copper"},
    interval = 1, -- Run every 1 second
    chance = 1, -- Select every 1 in 1 node
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      if inv:contains_item("main", "basenodes:copper_lump") then
       inv:add_item("main", "basenodes:copper_lump")
      else
       inv:set_stack("main", 3, "basenodes:copper_lump")
      end
      end
})

--Collects Tin
minetest.register_abm({
    nodenames = {"minegistics:Collector"},
    neighbors = {"basenodes:stone_with_tin"},
    interval = 1, -- Run every 1 second
    chance = 1, -- Select every 1 in 1 node
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      if inv:contains_item("main", "basenodes:tin_lump") then
       inv:add_item("main", "basenodes:tin_lump")
      else
       inv:set_stack("main", 4, "basenodes:tin_lump")
      end
      end
})

--Collects Gold
minetest.register_abm({
    nodenames = {"minegistics:Collector"},
    neighbors = {"basenodes:stone_with_gold"},
    interval = 1, -- Run every 1 second
    chance = 1, -- Select every 1 in 1 node
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      if inv:contains_item("main", "basenodes:gold_lump") then
       inv:add_item("main", "basenodes:gold_lump")
      else
       inv:set_stack("main", 5, "basenodes:gold_lump")
      end
      end
})

--Collects Cobblestone
minetest.register_abm({
    nodenames = {"minegistics:Collector"},
    neighbors = {"basenodes:cobblestone"},
    interval = 1, -- Run every 1 second
    chance = 1, -- Select every 1 in 1 node
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta({ x = pos.x, y = pos.y, z = pos.z })
      if meta:get_int("stone") < 100 then
         meta:set_int("stone", (meta:get_int("stone") + 1))
      else
      end
    end
})

--Collects Gravel
minetest.register_abm({
    nodenames = {"minegistics:Collector"},
    neighbors = {"basenodes:gravel"},
    interval = 1, -- Run every 1 seconds
    chance = 1, -- Select every 1 in 1 node
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta({ x = pos.x, y = pos.y, z = pos.z })
      if meta:get_int("gravel") < 100 then
         meta:set_int("gravel", (meta:get_int("gravel") + 1))
      else
      end
    end
})

--Collects Sand
minetest.register_abm({
    nodenames = {"minegistics:Collector"},
    neighbors = {"basenode:sand"},
    interval = 1, -- Run every 1 second
    chance = 1, -- Select every 1 in 1 nodes
    action = function(pos, node, active_object_count, active_object_count_wider)
      local meta = minetest.get_meta({ x = pos.x, y = pos.y, z = pos.z })
      if meta:get_int("sand") < 100 then
         meta:set_int("sand", (meta:get_int("sand") + 1))
      else
      end
    end
})

--converts resources into money
minetest.register_abm({
    nodenames = {"minegistics:Market"},
    interval = 10, -- Run every 1 second
    chance = 1, -- Select every 1 in 1 nodes
    action = function(pos, node, active_object_count, active_object_count_wider)
        local lumps = {
            "basenodes:coal_lump",
            "basenodes:copper_lump",
            "basenodes:tin_lump",
            "basenodes:iron_lump",
            "basenodes:gold_lump"
        }
        local meta = minetest.get_meta({ x = pos.x, y = pos.y, z = pos.z })
        local inv = meta:get_inventory()
        local items = {}
        for _,lump in pairs(lumps) do
            items[lump] = ItemStack(lump)
        end
        local money_earned = 0
        local inventories = inv:get_lists()
        for name, list in pairs(inventories) do
            for index, item in pairs(items) do
                while inv:contains_item(name, items[index]) do
                    inv:remove_item(name, items[index])
                    money_earned = money_earned + 1
                end
            end
        end
        if money_earned > 0 then
            for name,money in pairs(player_money) do
                player_money[name] = player_money[name] + money_earned
                minetest.chat_send_all(
                  "Earned $" .. money_earned .. " from market at " ..
                  "(" .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. ")"
                )
            end
        end
    end
})

minetest.register_node("minegistics:Collector", {
   description = " Building to gather resources",
   tiles = {"minegistics_structures_collector.png"},
   on_construct = function(pos)
     local meta = minetest.get_meta(pos)
     meta:set_string("formspec",
         "size[8,9]"..
         "list[current_name;main;0,0;5,1;]"..
         "list[current_player;main;0,5;8,4;]" ..
         "listring[]")
     meta:set_string("infotext", "collector")
     local inv = meta:get_inventory()
     inv:set_size("main", 5*1)
  end,
  can_dig = function(pos,player)
     local meta = minetest.get_meta(pos);
     local inv = meta:get_inventory()
     return inv:is_empty("main")
  end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
     return stack:get_count()
  end,
  on_metadata_inventory_take = function(pos, listname, index, stack, player)
     return stack:get_count()
  end,
})

minetest.register_node("minegistics:Factory", {
   description = " Take resources output goods",
   tiles = {"minegistics_structures_factory.png"},
   on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
         "size[3,4]"..
         "list[current_name;input;.5,1;2,1;]"..
         "list[current_name;output;2,3;1,1;]" ..
         "listring[]")
		meta:set_string("infotext", "depot")
		local inv = meta:get_inventory()
		inv:set_size("input", 2*1)
      inv:set_size("output", 1*1)
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

minetest.register_node("minegistics:town", {
   description = " Building changes specific resources into money",
   tiles = {"minegistics_structures_town.png"},
   on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]" ..
				"listring[]")
		meta:set_string("infotext", "depot")
		local inv = meta:get_inventory()
		inv:set_size("main", 1*1)
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

minetest.register_node("minegistics:market", {
   description = " Building changes material, resources, and product into money",
   tiles = {"minegistics_structures_market.png"},
   on_construct = function(pos)
		local meta = minetest.get_meta(pos)
      meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]" ..
				"listring[]")
		meta:set_string("infotext", "depot")
		local inv = meta:get_inventory()
		inv:set_size("main", 5*4)
	end,
	can_dig = function(pos,player)
		return  minetest.chat_send_player(player:get_player_name(), "Sorry the Market can't be moved once placed.")
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		return stack:get_count()
	end
})

minetest.register_node("minegistics:Warehouse", {
   description = " Building to store any resource",
   tiles = {"minegistics_structures_warehouse.png"},
   on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]" ..
				"listring[]")
		meta:set_string("infotext", "depot")
		local inv = meta:get_inventory()
		inv:set_size("main", 5*4)
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

minetest.register_node("minegistics:furnace", {
   description = "A Building that takes in material, fuel and then ouputs a resource",
   tiles = {"minegistics_structures_furnace"},
   on_construct = function(pos)
      local meta = minetest.get_meta(pos)
      meta:set_string("formspec",
            "size[3,4]"..
            "list[current_name;main;0,0;8,4;]"..
            "list[current_player;main;0,5;8,4;]" ..
            "listring[]")
      meta:set_string("infotext", "depot")
      local inv = meta:get_inventory()
      inv:set_size("main", 5*4)
   end,
   can_dig = function(pos,player)
      local meta = minetest.get_meta(pos);
      local inv = meta:get_inventory()
      return inv:is_empty("main")
   end,
   on_metadata_inventory_put = function(pos, listname, index, stack, player)
      return stack:get_count()
   end,
   on_metadata_inventory_take = function(pos, listname, index, stack, player)
      return stack:get_count()
   end,
})

minetest.register_node("minegistics:Workshop", {
   description = " Take material output resources",
   tiles = {"minegistics_structures_workshop.png"},
   on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
				"size[3,4]"..
				"list[current_name;input;1,.5;1,1;]"..
				"list[current_name;output;0.5,2;2,1;]" ..
				"listring[]")
		meta:set_string("infotext", "depot")
		local inv = meta:get_inventory()
		inv:set_size("input", 1*1)
      inv:set_size("output", 2*1)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("input")
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		return stack:get_count()
	end
})