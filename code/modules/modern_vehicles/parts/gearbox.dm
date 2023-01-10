#define VC_GEARBOX "gearbox"

/obj/item/vehicle_part/gearbox
	name = "gearbox"
	desc = "Gearbox. Modificates torque from the engine."
	id = VC_GEARBOX

	var/selected_gear = "N"

	mass = 70
	var/list/gears = list(
		"R"  = -4.2,
		"N"  = 0,
		"1" = 3.4,
		"2" = 2.5,
		"3" = 1.6,
		"4" = 1.1,
		"5" = 0.87
	)
	var/topgear = 4.2
	var/efficiency = 0.9

/obj/item/vehicle_part/gearbox/proc/get_efficiency()
	return max(0, efficiency - (100 - integrity) * 0.01)

/obj/item/vehicle_part/gearbox/proc/get_ratio()
	return topgear * gears[selected_gear]

/obj/item/vehicle_part/gearbox/proc/upshift()
	if(selected_gear == gears[gears.len])
		return
	switch(selected_gear)
		if("R")
			selected_gear = "N"
			return
		if("N")
			selected_gear = "1"
			return
	selected_gear = "[text2num(selected_gear) + 1]"

/obj/item/vehicle_part/gearbox/proc/downshift()
	switch(selected_gear)
		if("R", "N")
			return
/*
		if("N")
			selected_gear = "R"
			return
*/
		if("1")
			selected_gear = "N"
			return
	selected_gear = "[text2num(selected_gear) - 1]"
