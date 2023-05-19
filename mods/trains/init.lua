-- trains/init.lua

Trains = {}
Trains.modpath = minetest.get_modpath("trains")

dofile(Trains.modpath.. DIR_DELIM .. "functions.lua")
dofile(Trains.modpath.. DIR_DELIM .. "rails.lua")
dofile(Trains.modpath.. DIR_DELIM .. "train_entity.lua")
