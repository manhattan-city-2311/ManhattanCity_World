/obj/manhattan/vehicles/truck
	name = "Car truck"
	desc = "A vehicle for transporting stuff, can hold 4 people."

	icon = 'icons/vehicles/truck.dmi'
	icon_state = "truck"
	anchored = 1

	bound_height = 96
	bound_width = 64

	comp_prof = /datum/component_profile/truck

//	ammo_containers = newlist(/obj/item/ammo_magazine/warthog_mag)

	occupants = list(1,2)
	exposed_positions = list("driver" = 10,"passenger" = 50)

	vehicle_size = ITEM_SIZE_VEHICLE_LARGE
	capacity_flag = ITEM_SIZE_VEHICLE_LARGE

//	move_sound = 'code/modules/halo/sounds/warthog_move.ogg'

	light_color = "#E1FDFF"

	min_speed = 8
	max_speed = 4

/obj/manhattan/vehicles/truck/update_object_sprites()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		bounds = "64,96"
	else
		bounds = "96,64"

/obj/manhattan/vehicles/truck/on_death()
	. = ..()

/obj/item/vehicle_component/health_manager/truck
	integrity = 150
	resistances = list("brute"=30,"burn"=40,"emp"=25,"bomb"=10)

/datum/component_profile/truck
	vital_components = newlist(/obj/item/vehicle_component/health_manager/truck)