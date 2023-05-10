/obj/manhattan/vehicle/large/hyperloop
	name = "magnet-driven vacuum transit system capsule"
	desc = "An extraordinary aerodynamic capsule suspended above a magnet structure that is used for propelling it in a vacuum tunnel."
	icon = 'icons/vehicles/hyperloop.dmi'

	appearance_flags = PIXEL_SCALE

	bound_x = 160
	bound_y = 256
	density = TRUE
	interior_template = /datum/map_template/hyperloop

	size_x = 7
	size_y = 16

	var/number_of_seats = 20

/obj/manhattan/vehicle/large/hyperloop/get_exit_offsets()
	return list(
		"[NORTH]" = list( 5, 2,  5, 6),
		"[SOUTH]" = list(-1, 2, -1, 6),
	)

/obj/manhattan/vehicle/large/hyperloop/update_icon()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		bounds = "160,256"
	else
		bounds = "256,160"

/obj/manhattan/vehicle/large/hyperloop/get_calculation_iterations()
	return 1

/obj/manhattan/vehicle/large/hyperloop/attack_hand(mob/user)
	if(dir & NORTH || dir & SOUTH)
		var/D = get_dir(src, user)
		if(!(D & EAST) && !(D & WEST))
			return
	else if(dir == EAST || dir == WEST)
		var/D = get_dir(src, user)
		if(!(D & NORTH) && !(D & SOUTH))
			return
	enter_as_position(user, "interior")

/datum/map_template/hyperloop
	name = "Hyperloop"
	mappath = 'maps/interiors/hyperloop.dmm'

/obj/structure/track/magnet
	name = "electromagnetic suspension track"

/obj/structure/track/magnet/ex_act()
	return