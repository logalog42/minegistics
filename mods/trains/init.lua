-- trains/init.lua

Trains = {}
Trains.modpath = minetest.get_modpath("trains")

dofile(Trains.modpath.."/functions.lua")
dofile(Trains.modpath.."/rails.lua")
dofile(Trains.modpath.."/train_entity.lua")
