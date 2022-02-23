-- trains/init.lua

trains = {}
trains.modpath = minetest.get_modpath("minegistics_trains")
trains.railparams = {}

-- Maximal speed of the train in m/s (min = -1)
trains.speed_max = 6
-- Set to -1 to disable punching the train from inside (min = -1)
trains.punch_speed_max = 4
-- Maximal distance for the path correction (for dtime peaks)
trains.path_distance_max = 3


dofile(trains.modpath.."/functions.lua")
dofile(trains.modpath.."/rails.lua")
dofile(trains.modpath.."/train_entity.lua")
