/obj/item/vehicle_part/engine/aventa
	name = "aventa's brand engine"

	// Note:
	xs = list(0, 1000, 1500, 2000, 4000, 5500, 7000, 7500, 8000, 8600)
	ys = list(0, 325,  475,  550,  675,  700,  725,  700,  405,  610)
	max_rpm = 8700

	mass = 120

/obj/item/vehicle_part/gearbox/aventa
	name = "aventa's brand gearbox"
	mass = 44
	gears = list(
		"R"  = -2.929,
		"N"  = 0,
		"1" = 3.909,
		"2" = 2.438,
		"3" = 1.810,
		"4" = 1.458,
		"5" = 1.185,
		"6" = 0.967,
		"7" = 0.844
	)
	topgear = 3.42
	efficiency = 0.92

/obj/manhattan/vehicle/aventa
	name = "Aventa sport car"
	desc = "A vehicle for racing across the streets."

	icon = 'icons/vehicles/aventador.dmi'
	icon_state = "aventador"
	anchored = 1

	comp_prof = /datum/component_profile/aventa

//	move_sound = 'code/modules/halo/sounds/warthog_move.ogg'

	light_color = "#E1FDFF"

	weight = 1575

	components = list(
		VC_RIGHT_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_RIGHT_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_LEFT_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_LEFT_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_ENGINE = /obj/item/vehicle_part/engine/aventa,
		VC_CLUTCH = /obj/item/vehicle_part/clutch,
		VC_GEARBOX = /obj/item/vehicle_part/gearbox/aventa,
		VC_CARDAN = /obj/item/vehicle_part/cardan
	)

	aerodynamics_coefficent = 0.23
	traction_coefficent = 13.8

/obj/manhattan/vehicle/aventa/get_braking_force()
	return 1000

/obj/manhattan/vehicle/aventa/update_object_sprites()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		bounds = "64,96"
	else
		bounds = "96,64"

/obj/item/vehicle_component/health_manager/aventa
	integrity = 100
	resistances = list("brute"=30,"burn"=40,"emp"=25,"bomb"=10)

/datum/component_profile/aventa
	vital_components = newlist(/obj/item/vehicle_component/health_manager/aventa)