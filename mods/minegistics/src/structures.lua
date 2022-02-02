--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

minetest.register_node("minegistics:Collector", {
   description = "Collector: Gathers resources.\n" ..
    "Place on a resource node and connect to a\n" ..
    "factory or market with rails and a train.",
   tiles = {"buildings.png"},
   groups = {dig_immediate=2},
   drawtype = 'mesh',
   mesh = "collector.obj",
   wield_image = "collector_wield.png",
   inventory_image = "collector_wield.png",
   groups = {dig_immediate=2},
   on_construct = function(pos)
      table.insert(power_consumers, pos)
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
  after_dig_node = function(pos, oldnode, oldmetadata, digger)
      for i,p in pairs(power_consumers) do
          if p.x == pos.x and p.y == pos.y and p.z == pos.z then
              table.remove(power_consumers, i)
              break
          end
      end
      minetest.forceload_free_block(pos, false)
  end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
     return stack:get_count()
  end
})

minetest.register_node("minegistics:Market", {
   description = "Market: Changes any item into money.\n" ..
    "Must be connected by rail to a factory or collector.\n" ..
    "Must also be connected to a town.",
   tiles = {"buildings.png"},
   groups = {dig_immediate=2},
   drawtype = 'mesh',
   mesh = "market.obj",
   wield_image = "market_wield.png",
   inventory_image = "market_wield.png",
   on_construct = function(pos)
      table.insert(power_consumers, pos)
      local meta = minetest.get_meta(pos)
      meta:set_string("formspec",
          "size[8,9]"..
          "list[current_name;main;0,0;8,4;]"..
          "list[current_player;main;0,5;8,4;]" ..
          "listring[]")
      meta:set_string("infotext", "market")
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

minetest.register_node("minegistics:Town", {
  description = "Town: Required to earn money from markets.\n" ..
    "Connect to a market with rails and add a train.",
  tiles = {"buildings.png"},
  groups = {dig_immediate=2},
  drawtype = 'mesh',
  mesh = "town.obj",
  wield_image = "town_wield.png",
  inventory_image = "town_wield.png",
  on_construct = function(pos)
      table.insert(power_consumers, pos)
      local meta = minetest.get_meta(pos)
      meta:set_string("infotext", "town")
  end,
  after_dig_node = function(pos, oldnode, oldmetadata, digger)
      for i,p in pairs(power_consumers) do
          if p.x == pos.x and p.y == pos.y and p.z == pos.z then
              table.remove(power_consumers, i)
              break
          end
      end
      minetest.forceload_free_block(pos, false)
  end
})

minetest.register_node("minegistics:Warehouse", {
   description = "Warehouse: Stores items.",
   tiles = {"buildings.png"},
   groups = {dig_immediate=2},
   drawtype = 'mesh',
   mesh = "warehouse.obj",
   wield_image = "warehouse_wield.png",
   inventory_image = "warehouse_wield.png",
   on_construct = function(pos)
      table.insert(power_consumers, pos)
      local meta = minetest.get_meta(pos)
      meta:set_string("formspec",
          "size[8,9]"..
          "list[current_name;main;0,0;8,4;]"..
          "list[current_player;main;0,5;8,4;]" ..
          "listring[]")
      meta:set_string("infotext", "warehouse")
      local inv = meta:get_inventory()
      inv:set_size("main", 6*4)
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

--TODO Create a kiln building 1 resource and fuel then output 1 resource

--TODO Create a workshop building which takes 1 resource and outputs 2 resources

--TODO Change the formspec to input two resources and output selected Product

minetest.register_node("minegistics:Factory", {
   description = "Factory: Converts resources into products.\n" ..
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
          --"dropdown[1,1;2,1;items; coal_product.png , coal_product; " .. selected_id .. "]"..
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

local function smoke(pos)
    local rand = math.random(1,6)
    minetest.after(rand, function()
        minetest.add_particlespawner({
            amount = 300,
            time = 3,
            minpos = {x=pos.x,y=pos.y+1,z=pos.z},
            maxpos = {x=pos.x,y=pos.y+2,z=pos.z},
            minvel = {x=0.1, y=0.1, z=0.1},
            maxvel = {x=0.1, y=0.2, z=0.1},
            minacc = {x=-0.1,y=0.1,z=-0.1},
            maxacc = {x=0.1,y=0.2,z=0.1},
            minexptime = 1,
            maxexptime = 2,
            minsize = 10,
            maxsize = 12,
            collisiondetection = false,
            vertical = false,
            texture = "dirt.png"
        })
    end)
end

minetest.register_abm({
    nodenames = {"minegistics:Collector"},
    interval = 10,
    chance = 1,
    action = function(pos)
        minetest.forceload_block(pos, false)
        if power_stable(pos) then
            local next_to = {
               vector.new(pos.x, pos.y - 1, pos.z),
               vector.new(pos.x + 1, pos.y, pos.z),
               vector.new(pos.x - 1, pos.y, pos.z),
               vector.new(pos.x, pos.y, pos.z + 1),
               vector.new(pos.x, pos.y, pos.z - 1)
            }

            for node,ore in pairs(base_ores) do
               for key,direction in ipairs(next_to) do
                  if minetest.get_node(direction).name == node then
                     local meta = minetest.get_meta(pos)
                     local inv = meta:get_inventory()
                     local stack = ItemStack(ore)
                     stack:set_count(10)
                     if inv:add_item("main", stack) then
                        smoke(pos)
                     end
                  end
               end
            end
        end
    end
})

--TODO Create demands of specific items

--converts resources into money
minetest.register_abm({
    nodenames = {"minegistics:Market"},
    interval = 10,
    chance = 1,
    action = function(pos)
        minetest.forceload_block(pos, false)
        local meta = minetest.get_meta(pos)
        if power_stable(pos) and meta:get_int("has_town") == 1 then
            meta:set_int("has_town", 0)
            local inv = meta:get_inventory()
            local items = {}
            local lumps = {}
            for _,lump in pairs(resources) do
                lumps[lump] = ItemStack(lump)
            end
            for _,product in pairs(products) do
                items[product] = ItemStack(product)
            end
            local money_earned = 0
            local inventories = inv:get_lists()
            for name, list in pairs(inventories) do
                for index, item in pairs(lumps) do
                    while inv:contains_item(name, lumps[index]) do
                        inv:remove_item(name, lumps[index])
                        money_earned = money_earned + item_worth[item:get_name()]
                    end
                end
                for index, item in pairs(items) do
                    while inv:contains_item(name, items[index]) do
                        inv:remove_item(name, items[index])
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
    end
})

--converts resources into products
minetest.register_abm({
    nodenames = {"minegistics:Factory"},
    interval = 10,
    chance = 1,
    action = function(pos)
        minetest.forceload_block(pos, false)
        if power_stable(pos) then
            local meta = minetest.get_meta({ x = pos.x, y = pos.y, z = pos.z })
            local inv = meta:get_inventory()
            local items = {}
            local working = false
            for _,lump in pairs(resources) do
                items[lump] = ItemStack(lump)
            end
            local inventories = inv:get_lists()
            for name, list in pairs(inventories) do
                for index, item in pairs(items) do
                    while inv:contains_item(name, items[index]) do
                        local item_name = items[index]:get_name()
                        local item_amount = items[index]:get_count()
                        local product = products[item_name]
                        inv:remove_item(name, items[index])
                        stack = ItemStack(product)
                        stack:set_count(item_amount)
                        inv:add_item("main", stack)
                        working = true
                    end
                end
            end
            if working then
              minetest.add_particlespawner({
                  amount = 300,
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
})
