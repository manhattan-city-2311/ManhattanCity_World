/datum/vehicle_interior
	var/id
	var/global/gid = 0

	//11 at max
	var/size_x = 0
	var/size_y = 0

	var/list/mob/living/carbon/human/occupants = null
	var/turf/middle_turf
	var/obj/effect/vehicle_entrance/entrance = null
	var/obj/structure/vehicledoor/door = null
	var/obj/manhattan/vehicle/large/vehicle = null

	var/global/list/datum/map_template/templates_cache = list()

/datum/vehicle_interior/New(interior_template, new_vehicle)
	var/is_failed = TRUE
	for(var/obj/effect/interior_spawn/S in GLOB.vehicle_spawnpoints)
		middle_turf = get_turf(S)

		if(!(interior_template in templates_cache))
			templates_cache[interior_template] = new interior_template
		
		if(!templates_cache[interior_template].load(middle_turf, centered = TRUE))
			continue

		is_failed = FALSE
		qdel(S)
		break

	if(is_failed)
		message_admins("Failed to load [type]")
		CRASH("Failed to load [type]")
		
	id = gid++

	for(var/obj/effect/vehicle_entrance/E in get_area(middle_turf))
		entrance = E
		entrance.id = id
		break
	for(var/obj/structure/vehicledoor/E in get_area(middle_turf))
		door = E
		door.id = id
		door.interior = src
		break
	vehicle = new_vehicle
	if(!vehicle)
		return

	GLOB.vehicle_interiors += src

/obj/effect/vehicle_entrance
	var/id

/obj/effect/interior_spawn
	icon = 'icons/effects/effects.dmi'
	icon_state = "rift"
	var/free_x = 0
	var/free_y = 0

/obj/effect/interior_spawn/New()
	. = ..()
	GLOB.vehicle_spawnpoints += src
	icon_state = null

/obj/effect/interior_spawn/Destroy()
	GLOB.vehicle_spawnpoints -= src
	. = ..()

/obj/manhattan/vehicle/large
	var/datum/vehicle_interior/interior = null
	var/size_x = 0
	var/size_y = 0
	var/datum/map_template/interior_template = /datum/map_template

/obj/manhattan/vehicle/large/get_all_positions()
	return ..() + list(VP_INTERIOR)

/obj/manhattan/vehicle/large/initialize()
	. = ..()
	interior = new(interior_template, src)

/obj/manhattan/vehicle/large/proc/move_to_interior(atom/movable/user, puller)
	if(user == puller)
		visible_message(SPAN_NOTICE("[user] enters the interior of [src]."))
	else
		visible_message(SPAN_NOTICE("[puller] put [user] into interior of \the [src]."))
	to_chat(user, SPAN_NOTICE("You are now in the interior of [src]."))
	playsound(src, 'sound/vehicles/modern/vehicle_enter.ogg', 150, 1, 5)

	if(!interior?.entrance)
		to_chat(user, SPAN_OCCULT("or not."))
		return

	user.forceMove(get_turf(interior.entrance))
	occupants[user] = VP_INTERIOR

	return TRUE

/obj/manhattan/vehicle/large/handle_entering(mob/user, position, puller)
	if(position == VP_INTERIOR)
		return move_to_interior(user, puller)
	return ..()

/obj/structure/vehiclewall
	name = "vehicle wall"
	icon = 'icons/vehicles/interior/walls.dmi'
	icon_state = "noborder"

	layer = ABOVE_MOB_LAYER
	plane = ABOVE_MOB_PLANE

	density = TRUE
	opacity = TRUE
	anchored = TRUE
	breakable = FALSE

/obj/structure/vehicledoor
	name = "vehicle door"
	icon = 'icons/vehicles/interior/walls.dmi'
	icon_state = "ambulancedoor"

	layer = ABOVE_MOB_LAYER
	plane = ABOVE_MOB_PLANE

	density = TRUE
	opacity = TRUE
	anchored = TRUE

	var/id
	var/datum/vehicle_interior/interior = null

/obj/structure/vehicledoor/attack_hand(mob/user)
	. = ..()
	interior.vehicle.exit_vehicle(user)

/obj/structure/vehicledoor/MouseDrop_T(mob/target, mob/user)
	. = ..()
	if(ismob(target))
		interior.vehicle.exit_vehicle(target, ingore_incap_check = TRUE, puller = user)
	else
		target.forceMove(interior.vehicle.pick_valid_exit_loc())
