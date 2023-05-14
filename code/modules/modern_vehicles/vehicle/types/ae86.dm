/obj/item/vehicle_part/engine/ae86
	name = "ae86's brand engine"

	// Note:
	xs = list(0, 1000, 1500, 2000, 3000, 5000, 6500, 7100)
	ys = list(0, 60,   100,  115,  125,  140,  130,  105)
	max_rpm = 7150

	mass = 65

/obj/item/vehicle_part/gearbox/ae86
	name = "ae86's brand gearbox"
	mass = 44
	gears = list(
		"R"  = -2.929,
		"N"  = 0,
		"1" = 3.587,
		"2" = 2.022,
		"3" = 1.384,
		"4" = 1,
		"5" = 0.861,
	)
	topgear = 4.778
	efficiency = 0.87

/obj/item/vehicle_part/fueltank/ae86
	capacity = 50

/obj/manhattan/vehicle/ae86
	name = "Ae86"
	desc = "A drivable replica of the once famous Toyota Sprinter AE86, with maybe slightly better performance. Oddly capable of pulling sick drifts."

	icon = 'icons/vehicles/ae86.dmi'
	icon_state = "ae86"

	comp_prof = /datum/component_profile/ae86

//	move_sound = 'code/modules/halo/sounds/warthog_move.ogg'

	light_color = "#f1ffe1"

	weight = 910

	components = list(
		VC_RIGHT_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_RIGHT_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_LEFT_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_LEFT_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_ENGINE = /obj/item/vehicle_part/engine/ae86,
		VC_GEARBOX = /obj/item/vehicle_part/gearbox/ae86,
		VC_CARDAN = /obj/item/vehicle_part/cardan,
		VC_FUELTANK = /obj/item/vehicle_part/fueltank/ae86
	)

	aerodynamics_coefficent = 0.33
	traction_coefficent = 19.8

/obj/manhattan/vehicle/ae86/get_transfer_case()
	return TRANSFER_CASE_FWD

/obj/manhattan/vehicle/ae86/get_braking_force()
	return 1770

/obj/manhattan/vehicle/ae86/update_icon()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		bounds = "32,64"
	else
		bounds = "80,32"

/obj/item/vehicle_component/health_manager/ae86
	integrity = 100
	resistances = list("brute"=45,"burn"=40,"emp"=25,"bomb"=10)

/datum/component_profile/ae86
	vital_components = newlist(/obj/item/vehicle_component/health_manager/ae86)
