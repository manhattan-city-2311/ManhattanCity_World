/obj/manhattan/vehicle/truck
	name = "Pickup Truck" //should rename it later
	desc = "A nondescript larger-than-average vehicle with two front seats and a plethora of cargo space in its open cab."

	icon = 'icons/vehicles/truck.dmi'
	icon_state = "truck"

	bound_height = 96
	bound_width = 64

	comp_prof = /datum/component_profile/truck

//	ammo_containers = newlist(/obj/item/ammo_magazine/warthog_mag)

	occupants = list(2,0)
	exposed_positions = list("driver" = 10,"passenger" = 50)

	vehicle_size = ITEM_SIZE_VEHICLE_LARGE
	capacity_flag = ITEM_SIZE_VEHICLE_LARGE

//	move_sound = 'code/modules/halo/sounds/warthog_move.ogg'

	light_color = "#E1FDFF"

/obj/manhattan/vehicle/truck/update_icon()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		bounds = "64,96"
	else
		bounds = "96,64"

/obj/manhattan/vehicle/truck/on_death()
	. = ..()

/obj/item/vehicle_component/health_manager/truck
	integrity = 150
	resistances = list("brute"=30,"burn"=40,"emp"=25,"bomb"=10)

/datum/component_profile/truck
	vital_components = newlist(/obj/item/vehicle_component/health_manager/truck)