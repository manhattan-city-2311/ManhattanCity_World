/datum/map_template/ambulance
	name = "Ambulance"
	mappath = 'maps/interiors/ambulance.dmm'

/obj/structure/vehiclewall/ambulance //backside
	icon_state = "ambulancebordered"

/obj/manhattan/vehicle/large/ambulance
	size_x = 5
	size_y = 6
	interior_template = /datum/map_template/ambulance
