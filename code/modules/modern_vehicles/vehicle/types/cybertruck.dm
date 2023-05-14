/obj/item/vehicle_part/engine/cybertruck
	name = "cybertruck's brand engine"

	// Note:
	xs = list(0, 1000, 1500, 2000, 3000, 5000, 6500, 7100)
	ys = list(0, 80,   150,  200,  260,  300,  150,  120)
	max_rpm = 7150

	mass = 60

/obj/item/vehicle_part/gearbox/cybertruck
	name = "cybertruck's brand gearbox"
	mass = 44
	gears = list(
		"R"  = -2.929,
		"N"  = 0,
		"1" = 3.09,
		"2" = 2.438,
		"3" = 1.810,
		"4" = 1.458,
		"5" = 1.185,
		"6" = 0.967
	)
	topgear = 3.7
	efficiency = 0.9

/obj/item/vehicle_part/fueltank/cybertruck
	capacity = 50

/obj/manhattan/vehicle/cybertruck
	name = "Cybertruck" //but mom it's not a truck
	desc = "A brand new SUV modification of the famous truck with MCPD livery. Commonly used for high-speed chases, creating roadblocks and ramming them."

	icon = 'icons/vehicles/cybertruck.dmi'
	icon_state = "cybertruck"

	comp_prof = /datum/component_profile/cybertruck

	light_color = "#f1ffe1"

	weight = 2200

	components = list(
		VC_RIGHT_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_RIGHT_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_LEFT_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_LEFT_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_ENGINE = /obj/item/vehicle_part/engine/cybertruck,
		VC_GEARBOX = /obj/item/vehicle_part/gearbox/cybertruck,
		VC_CARDAN = /obj/item/vehicle_part/cardan,
		VC_FUELTANK = /obj/item/vehicle_part/fueltank/cybertruck
	)

	aerodynamics_coefficent = 0.31
	traction_coefficent = 19.8

/obj/manhattan/vehicle/cybertruck/get_transfer_case()
	return TRANSFER_CASE_AWD

/obj/manhattan/vehicle/cybertruck/get_braking_force()
	return 2000

/obj/manhattan/vehicle/cybertruck/update_icon()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		bounds = "43,71"
	else
		bounds = "97,41"
	bound_x = 8
	bound_y = 6

/obj/item/vehicle_component/health_manager/cybertruck
	integrity = 100
	resistances = list("brute"=75,"burn"=70,"emp"=45,"bomb"=30)

/datum/component_profile/cybertruck
	vital_components = newlist(/obj/item/vehicle_component/health_manager/cybertruck)
