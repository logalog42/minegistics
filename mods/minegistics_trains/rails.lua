-- trains/rails.lua

trains:register_rail("minegistics_trains:rail", {
	description = ("Rail: For trains."),
	tiles = {
		"trains_rail_straight.png", "trains_rail_curved.png",
		"trains_rail_t_junction.png", "trains_rail_crossing.png"
	},
	inventory_image = "trains_rail_straight.png",
	wield_image = "trains_rail_straight.png",
	groups = trains:get_rail_groups(),
}, {})

trains:register_rail("minegistics_trains:powerrail", {
	description = ("Powered Rail: Increases the speed of a train."),
	tiles = {
		"trains_rail_straight_pwr.png", "trains_rail_curved_pwr.png",
		"trains_rail_t_junction_pwr.png", "trains_rail_crossing_pwr.png"
	},
	groups = trains:get_rail_groups(),
}, {acceleration = 5})

trains:register_rail("minegistics_trains:brakerail", {
	description = ("Brake Rail: Reduces the speed of a train."),
	tiles = {
		"trains_rail_straight_brk.png", "trains_rail_curved_brk.png",
		"trains_rail_t_junction_brk.png", "trains_rail_crossing_brk.png"
	},
	groups = trains:get_rail_groups(),
}, {acceleration = -3})
