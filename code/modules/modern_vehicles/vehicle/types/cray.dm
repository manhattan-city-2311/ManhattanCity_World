/obj/manhattan/vehicle/large/cray
	name = "Cray Corporation Van"
	desc = "A vehicle for transporting various mercenaries and corporative workers."

	icon = 'icons/vehicles/cray.dmi'
	icon_state = "cray"

	//headlights_overlay = "headlights"

	bound_height = 64
	bound_width = 64

	comp_prof = /datum/component_profile/cray

	occupants = list(5,0)
	exposed_positions = list("driver" = 10,"passenger" = 10)

	vehicle_size = ITEM_SIZE_VEHICLE_LARGE
	vehicle_carry_size = ITEM_SIZE_VEHICLE
	capacity_flag = ITEM_SIZE_VEHICLE_LARGE

//	move_sound = 'code/modules/halo/sounds/warthog_move.ogg'

	light_color = "#E1FDFF"

/obj/manhattan/vehicle/large/cray/update_icon()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		bounds = "43,71"
	else
		bounds = "98,47"

/obj/manhattan/vehicle/large/cray/on_death()
	. = ..()

/obj/item/vehicle_component/health_manager/cray
	integrity = 300
	resistances = list("brute"=50,"burn"=60,"emp"=25,"bomb"=50)

datum/component_profile/cray
	vital_components = newlist(/obj/item/vehicle_component/health_manager/cray)