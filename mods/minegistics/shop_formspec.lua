guessing = {}
local _contexts = {}
local function get_context(name)
    local context = _contexts[name] or {}
    _contexts[name] = context
    return context
end

minetest.register_on_leaveplayer(function(player)
    _contexts[player:get_player_name()] = nil
end)

function guessing.get_formspec(name, context)
  local text
  if not context.guess then
      text = "I'm thinking of a number... Make a guess!"
  elseif context.guess == context.target then
      text = "Hurray, you got it!"
  elseif context.guess > context.target then
      text = "Too high!"
  else
      text = "Too low!"
  end

    local formspec = {
        "formspec_version[4]",
        "size[6,3.476]",
        "label[0.375,0.5;", minetest.formspec_escape(text), "]",
        "item_image[0.375,1.25;5.25,1.6; minegistics_structures_collector.png ]",
        "button[1.5,2.3;3,0.8;guess;Guess]"
    }

    -- table.concat is faster than string concatenation - `..`
    return table.concat(formspec, "")
end

minetest.register_chatcommand("game", {
    func = function(name)
        guessing.show_to(name)
    end,
})

function guessing.show_to(name)
    local context = get_context(name)
    context.target = context.target or math.random(1, 10)

    local fs = guessing.get_formspec(name, context)
    minetest.show_formspec(name, "guessing:game", fs)
end

minetest.register_chatcommand("game", {
    func = function(name)
        guessing.show_to(name)
    end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "guessing:game" then
        return
    end

    if fields.guess then
        local name = player:get_player_name()
        local context = get_context(name)
        context.guess = tonumber(fields.number)
        guessing.show_to(name)
    end
end)
