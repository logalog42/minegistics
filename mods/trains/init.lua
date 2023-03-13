-- trains/init.lua

trains = {}
trains.modpath = minetest.get_modpath("trains")

dofile(trains.modpath.."/functions.lua")
dofile(trains.modpath.."/rails.lua")
dofile(trains.modpath.."/train_entity.lua")
