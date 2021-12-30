shop = {}
local _contexts = {}
local products = {
   "collector",
   "factory",
   "market",
   "warehouse",
   "cart",
   "rail" }
local function get_context(name)
    local context = _contexts[name] or {}
    _contexts[name] = context
    return context
end

minetest.register_on_leaveplayer(function(player)
    _contexts[player:get_player_name()] = nil
end)

function shop.get_formspec(name, context)

   local formspec = {
     "formspec_version[4]",
     "size[9.5,5]",
     "label[3.25,0.5;Welcome to the store!]",

     "item_image[.25,1;1.5,1.5;minegistics:Collector]",
     "label[.5,2.75;Collector]",
     "field[.25,3;1.5,.5;collector;;0]",

     "item_image[1.75,1;1.5,1.5;minegistics:Factory]",
     "label[2.1,2.75;Factory]",
     "field[1.75,3;1.5,.5;factory;;0]",

     "item_image[3.25,1;1.5,1.5;minegistics:Market]",
     "label[3.6,2.75;Market]",
     "field[3.25,3;1.5,.5;market;;0]",

     "item_image[4.75,1;1.5,1.5;minegistics:Warehouse]",
     "label[4.85,2.75;Warehouse]",
     "field[4.75,3;1.5,.5;warehouse;;0]",

     "item_image[6.25,1;1.5,1.5;carts:cart]",
     "label[6.75,2.75;Cart]",
     "field[6.25,3;1.5,.5;cart;;0]",

     "item_image[7.75,1;1.5,1.5;carts:rail]",
     "label[8.25,2.75;Rail]",
     "field[7.75,3;1.5,.5;rail;;0]",

     "button[3.25,4;3,.5;purchase;Buy]"
  }

    -- table.concat is faster than string concatenation - `..`
    return table.concat(formspec, "")
end

minetest.register_chatcommand("shop", {
    func = function(name)
        shop.show_to(name)
    end,
})

function shop.show_to(name)
    local context = get_context(name)

    local fs = shop.get_formspec(name, context)
    minetest.show_formspec(name, "shop:shop", fs)
end

minetest.register_chatcommand("shop", {
    func = function(name)
        shop.show_to(name)
    end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "shop:shop" then
        return
    end

    if tonumber(fields.collector) ~= 0 then
      
    end
    if tonumber(fields.market) ~= 0 then

    end
    if tonumber(fields.factory) ~= 0 then

    end
    if tonumber(fields.warehouse) ~= 0 then

    end
    if tonumber(fields.cart) ~= 0 then

    end
    if tonumber(fields.rail) ~= 0 then

    end
end)
