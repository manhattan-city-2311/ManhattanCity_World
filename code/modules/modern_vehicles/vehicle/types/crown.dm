/obj/item/vehicle_part/engine/crown
	name = "crown's brand engine"

	// Note:
	xs = list(0, 1000, 1500, 2000, 3000, 5000, 5500, 6000)
	ys = list(0, 50,   100,  150,  200,  250,  150,  100)
	max_rpm = 6000

	mass = 140

/obj/item/vehicle_part/gearbox/crown
	name = "crown's brand gearbox"
	mass = 44
	gears = list(
		"R"  = -2.929,
		"N"  = 0,
		"1" = 3.538,
		"2" = 2.045,
		"3" = 1.333,
		"4" = 1.028,
		"5" = 0.820
	)
	topgear = 3.6
	efficiency = 0.9

/obj/item/vehicle_part/fueltank/crown
	capacity = 65

/obj/manhattan/vehicle/crown
	name = "Crown"
	desc = "A standard police cruiser with MCPD livery. It's the oldest, cheapest and one of the most robust cars in widespread service on many colonies."

	icon = 'icons/vehicles/crown.dmi'
	icon_state = "crown"

	comp_prof = /datum/component_profile/crown

	light_color = "#f1ffe1"

	weight = 2000

	components = list(
		VC_RIGHT_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_RIGHT_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_LEFT_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_LEFT_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_ENGINE = /obj/item/vehicle_part/engine/crown,
		VC_GEARBOX = /obj/item/vehicle_part/gearbox/crown,
		VC_CARDAN = /obj/item/vehicle_part/cardan,
		VC_FUELTANK = /obj/item/vehicle_part/fueltank/crown
	)

	aerodynamics_coefficent = 0.36
	traction_coefficent = 13.8

/obj/manhattan/vehicle/crown/get_transfer_case()
	return TRANSFER_CASE_AWD

/obj/manhattan/vehicle/crown/get_braking_force()
	return 2000

/obj/manhattan/vehicle/crown/update_icon()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		bounds = "41,76"
	else
		bounds = "98,39"
	bound_x = 8
	bound_y = 6

/obj/item/vehicle_component/health_manager/crown
	integrity = 100
	resistances = list("brute"=30,"burn"=40,"emp"=25,"bomb"=10)

/datum/component_profile/crown
	vital_components = newlist(/obj/item/vehicle_component/health_manager/crown)
