minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
    if node.name == "minegistics_structures:Collector" then
        if puncher:get_inventory():add_item("main", item) then
            minetest.remove_node(pos)
            local item = ItemStack("minegistics_structures:Collector")
        end
    elseif node.name == "minegistics_structures:Market" then
        if puncher:get_inventory():add_item("main", item) then
            minetest.remove_node(pos)
            local item = ItemStack("minegistics_structures:Market")
        end
    end
end)

minetest.register_node("minegistics_structures:Collector", {
   description = " Building to gather resources",
   tiles = {"minegistics_structures_collector.png"},
   on_construct = function(pos)
     local meta = minetest.get_meta(pos)
     meta:set_string("formspec",
         "size[8,9]"..
         "list[current_name;main;0,0;8,4;]"..
         "list[current_player;main;0,5;8,4;]" ..
         "listring[]")
     meta:set_string("infotext", "collector")
     local inv = meta:get_inventory()
     inv:set_size("main", 5*1)
  end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
     minetest.chat_send_player(player:get_player_name(), "Allow take: " .. stack:to_string())
     return stack:get_count()
  end,
  on_metadata_inventory_take = function(pos, listname, index, stack, player)
     minetest.chat_send_player(player:get_player_name(), "On take: " .. stack:to_string())
  end,

})

minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
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

minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
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

minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
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

minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
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

minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
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


minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
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

minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
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

minetest.register_abm({
    nodenames = {"minegistics_structures:Collector"},
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



minetest.register_node("minegistics_structures:Factory", {
   description = " Take resources output goods",
   tiles = {"minegistics_structures_factory.png"},
   on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]" ..
				"listring[]")
		meta:set_string("infotext", "depot")
		local inv = meta:get_inventory()
		inv:set_size("main", 2*1)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.chat_send_player(player:get_player_name(), "Allow put: " .. stack:to_string())
		return stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.chat_send_player(player:get_player_name(), "Allow take: " .. stack:to_string())
		return stack:get_count()
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.chat_send_player(player:get_player_name(), "On put: " .. stack:to_string())
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.chat_send_player(player:get_player_name(), "On take: " .. stack:to_string())
	end,
})

minetest.register_node("minegistics_structures:Market", {
   description = " Building changes any resources into money",
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
		inv:set_size("main", 5*1)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.chat_send_player(player:get_player_name(), "Allow put: " .. stack:to_string())
		return stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.chat_send_player(player:get_player_name(), "Allow take: " .. stack:to_string())
		return stack:get_count()
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.chat_send_player(player:get_player_name(), "On put: " .. stack:to_string())
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.chat_send_player(player:get_player_name(), "On take: " .. stack:to_string())
	end,
})

minetest.register_node("minegistics_structures:town", {
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
		minetest.chat_send_player(player:get_player_name(), "Allow put: " .. stack:to_string())
		return stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.chat_send_player(player:get_player_name(), "Allow take: " .. stack:to_string())
		return stack:get_count()
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.chat_send_player(player:get_player_name(), "On put: " .. stack:to_string())
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.chat_send_player(player:get_player_name(), "On take: " .. stack:to_string())
	end,
})

minetest.register_node("minegistics_structures:Warehouse", {
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
		minetest.chat_send_player(player:get_player_name(), "Allow put: " .. stack:to_string())
		return stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.chat_send_player(player:get_player_name(), "Allow take: " .. stack:to_string())
		return stack:get_count()
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.chat_send_player(player:get_player_name(), "On put: " .. stack:to_string())
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.chat_send_player(player:get_player_name(), "On take: " .. stack:to_string())
	end,
})
