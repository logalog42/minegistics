--[[
    Minegistics
      logalog
      Droog71
    License: AGPLv3
]]--

power_producers = {}
power_consumers = {}

--TODO Add power lines and sub stations

minetest.register_node("minegistics:PowerPlant", {
   description = "Power Plant: Generates power. Requires coal for fuel.\n" ..
      "One power plant is needed for every 5 buildings.\n" ..
      "Must be placed within 200 meters of the buildings it powers.",
   tiles = {"buildings.png"},
   groups = {dig_immediate=2, structures=1},
   drawtype = 'mesh',
   mesh = "power_plant.obj",
   wield_image = "power_plant_wield.png",
   inventory_image = "power_plant_wield.png",
   on_construct = function(pos)
      local meta = minetest.get_meta(pos)
      meta:set_string("formspec",
          "size[8,9]"..
          "list[current_name;main;0,0;8,4;]"..
          "list[current_player;main;0,5;8,4;]" ..
          "listring[]")
      meta:set_string("infotext", "power_plant")
      local inv = meta:get_inventory()
      inv:set_size("main", 5*1)
	end,
  after_dig_node = function(pos, oldnode, oldmetadata, digger)
      for i,p in pairs(power_producers) do
          if p.x == pos.x and p.y == pos.y and p.z == pos.z then
              table.remove(power_producers, i)
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

function power_stable(pos)
    local local_consumers = 0
    local local_producers = 0
    for index,consumer in pairs(power_consumers) do
        if vector.distance(consumer, pos) < 200 then
            local_consumers = local_consumers + 1
        end
    end
    for index,producer in pairs(power_producers) do
        if vector.distance(producer, pos) < 200 then
            local_producers = local_producers + 1
        end
    end
    local stable = local_consumers <= local_producers * 5
    local stable_display = stable and "stable" or "unstable"
    return stable
end

function is_active(pos)
    for _,p in pairs(power_producers) do
        if p.x == pos.x and p.y == pos.y and p.z == pos.z then
            return true
        end
    end
    return false
end

minetest.register_abm({
    nodenames = {"minegistics:PowerPlant"},
    interval = 10,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        minetest.forceload_block(pos, false)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local has_fuel = false
        if inv:contains_item("main", "minegistics_basenodes:coal_lump") then
            inv:remove_item("main", "minegistics_basenodes:coal_lump")
            has_fuel = true
         elseif inv:contains_item("main", "minegistics_basenodes:planks") then
            inv:remove_item("main", "minegistics_basenodes:planks")
            has_fuel = true
        end
        local active = is_active(pos)
        if has_fuel then
            if active == false then
                table.insert(power_producers, pos)
            end
            minetest.add_particlespawner({
                amount = 300,
                time = 6,
                minpos = {x=pos.x,y=pos.y+1,z=pos.z},
                maxpos = {x=pos.x,y=pos.y+2,z=pos.z},
                minvel = {x=0.1, y=0.1, z=0.1},
                maxvel = {x=0.1, y=0.2, z=0.1},
                minacc = {x=-0.1,y=0.1,z=-0.1},
                maxacc = {x=0.1,y=0.2,z=0.1},
                minexptime = 2,
                maxexptime = 4,
                minsize = 10,
                maxsize = 12,
                collisiondetection = false,
                vertical = false,
                texture = "black_smoke.png"
            })
        else
            if active == true then
                for i,p in pairs(power_producers) do
                    if p.x == pos.x and p.y == pos.y and p.z == pos.z then
                        table.remove(power_producers, i)
                        break
                    end
                end
            end
        end
    end
})
