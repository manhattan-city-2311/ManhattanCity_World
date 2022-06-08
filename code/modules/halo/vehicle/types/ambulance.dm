/obj/manhattan/vehicles/ambulance
	name = "City Ambulance"
	desc = "A vehicle for transporting wounded and unstable patients. Can hold 3 people"

	icon = 'icons/vehicles/ambulance.dmi'
	icon_state = "ambulance"
	anchored = 1

	bound_height = 96
	bound_width = 64

	comp_prof = /datum/component_profile/ambulance

//	ammo_containers = newlist(/obj/item/ammo_magazine/warthog_mag)

	occupants = list(1,5)
	exposed_positions = list("driver" = 10,"passenger" = 10)

	vehicle_size = ITEM_SIZE_VEHICLE_LARGE
	capacity_flag = ITEM_SIZE_VEHICLE_LARGE

//	move_sound = 'code/modules/halo/sounds/warthog_move.ogg'

	light_color = "#E1FDFF"

	min_speed = 10
	max_speed = 6

/obj/manhattan/vehicles/ambulance/update_icon()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		bounds = "96,64"
	else
		bounds = "64,96"

/obj/manhattan/vehicles/ambulance/on_death()
	. = ..()

/obj/item/vehicle_component/health_manager/ambulance
	integrity = 300
	resistances = list("brute"=50,"burn"=60,"emp"=25,"bomb"=50)

/datum/component_profile/ambulance
	vital_components = newlist(/obj/item/vehicle_component/health_manager/ambulance)