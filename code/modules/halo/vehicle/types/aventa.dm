/obj/manhattan/vehicles/aventa
	name = "Aventa sport car"
	desc = "A vehicle for racing across the streets."

	icon = 'icons/vehicles/aventador.dmi'
	icon_state = "aventador"
	anchored = 1

	bound_height = 96
	bound_width = 64

	comp_prof = /datum/component_profile/aventa

	occupants = list(1,0)
	exposed_positions = list("driver" = 10,"passenger" = 10)

	vehicle_size = ITEM_SIZE_VEHICLE
	capacity_flag = ITEMSIZE_NORMAL

//	move_sound = 'code/modules/halo/sounds/warthog_move.ogg'

	light_color = "#E1FDFF"

	min_speed = 6
	max_speed = 1

/obj/manhattan/vehicles/aventa/update_object_sprites()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		bounds = "64,96"
	else
		bounds = "96,64"

/obj/manhattan/vehicles/aventa/on_death()
	. = ..()

/obj/item/vehicle_component/health_manager/aventa
	integrity = 100
	resistances = list("brute"=30,"burn"=40,"emp"=25,"bomb"=10)

/datum/component_profile/aventa
	vital_components = newlist(/obj/item/vehicle_component/health_manager/aventa)

/*/obj/manhattan/vehicles/aventa/Move(var/newloc,var/newdir)
	icon_state = "aventador_moving"
	if(abs(speed[1]) > abs(speed[2]))
		if(speed[1] > 0)
			newdir = EAST
		else
			newdir = WEST
	else
		if(speed[2] > 0)
			newdir = NORTH
		else
			newdir = SOUTH
	if(anchored)
		anchored = 0
		. = ..()
		anchored = 1
	else
		. = ..()
	update_object_sprites()*/