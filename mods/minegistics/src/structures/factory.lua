minetest.register_node("minegistics:Factory", {
   description = "Factory: Converts material into products.\n" ..
    "Both can be sold but products are worth more.",
   tiles = {"buildings.png"},
   groups = {dig_immediate=2},
   drawtype = 'mesh',
   mesh = "factory.obj",
   wield_image = "factory_wield.png",
   inventory_image = "factory_wield.png",
   on_construct = function(pos)
      table.insert(power_consumers, pos)
      local meta = minetest.get_meta(pos)
      local selected_id = 1
      meta:set_string("formspec",
          "size[8,9]"..
          "list[current_name;main;0,0;8,4;]"..
          "dropdown[1,1;2,1;items; coal_product.png , coal_product; " .. selected_id .. "]"..
          "list[current_player;main;0,5;8,4;]" ..
          "listring[]")
      meta:set_string("infotext", "factory")
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
