#define ALL_VEHICLE_POSITIONS list("driver","passenger","gunner")
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

/datum/vehicle_interior/New(var/interior_template = /datum/map_template, var/new_vehicle)
	for(var/obj/effect/interior_spawn/S in GLOB.vehicle_spawnpoints)
		middle_turf = get_turf(S)

		if(!(interior_template in templates_cache))
			templates_cache[interior_template] = new interior_template()

		if(!templates_cache[interior_template].load(middle_turf, centered = TRUE))
			CRASH("[interior_template] was unable to load.")
			return

		GLOB.vehicle_spawnpoints -= S
		qdel(S)
		break

	id = gid++

	for(var/obj/effect/vehicle_entrance/E in range(5, middle_turf))
		entrance = E
		entrance.id = id
		break
	for(var/obj/structure/vehicledoor/E in range(5, middle_turf))
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
	var/free_x = 0
	var/free_y = 0

/obj/effect/interior_spawn/initialize()
	. = ..()
	GLOB.vehicle_spawnpoints += src

/obj/manhattan/vehicle/large
	var/datum/vehicle_interior/interior = null
	var/size_x = 0
	var/size_y = 0
	var/datum/map_template/interior_template = /datum/map_template

/obj/manhattan/vehicle/large/initialize()
	..()
	interior = new(interior_template, src)

/obj/manhattan/vehicle/large/enter_vehicle()
	set name = "Войти в транспорт"
	set category = "Транспорт"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user) || !src.Adjacent(user) || user.incapacitated())
		return
	var/player_pos_choice
	var/list/L = ALL_VEHICLE_POSITIONS
	if(L.len == 1)
		player_pos_choice = L[1]
	else
		player_pos_choice = input(user, "Enter which position?", "Vehicle Entry Position Select", "Cancel") in ALL_VEHICLE_POSITIONS + list("Cancel")

	switch(player_pos_choice)
		if("cancel")
			return
		if("passenger")
			visible_message(SPAN_INFO("[user] enters the interior of [src]."))
			to_chat(user, SPAN_INFO("You are now in the interior of [src]."))
			playsound(src, 'sound/vehicles/modern/vehicle_enter.ogg', 150, 1, 5)
			user.forceMove(get_turf(interior.entrance))
			occupants[user] = "passenger"
		else
			enter_as_position(user, player_pos_choice)
/obj/manhattan/vehicle/large/enter_as_position(var/mob/user,var/position = "driver")
	if(block_enter_exit)
		to_chat(user, SPAN_NOTICE("The [src] is locked."))
		return 0
	if(check_position_blocked(position))
		to_chat(user, SPAN_NOTICE("No [position] spaces in [src]"))
		return 0
	var/mob/living/h_test = user
	if(!istype(h_test) && position == "driver")
		to_chat(user, SPAN_NOTICE("You don't know how to drive that.")) //Let's assume non-living mobs can't drive.
		return
	var/can_enter = check_enter_invalid()
	if(can_enter)
		to_chat(user, SPAN_NOTICE("[can_enter]"))
		return 0
	if(user in occupants)
		if(occupants[user] == position)
			to_chat(user, SPAN_NOTICE("You're already a [position] of [src]"))
			return 0
		occupants[user] = position
		visible_message(SPAN_NOTICE("[user] enters [src] as [position]"))
		update_object_sprites()
		return 1

	occupants[user] = position
	user.forceMove(src)
	update_object_sprites()
	visible_message("<span class = 'notice'>[user] enters the [position] position of [src].</span>")
	to_chat(user,"<span class = 'info'>You are now in the [position] position of [src].</span>")
	playsound(src, 'sound/vehicles/modern/vehicle_enter.ogg', 150, 1, 5)
	return 1

/obj/manhattan/vehicle/large/exit_vehicle(mob/user, ignore_incap_check = 0)
	if(!occupants[user])
		to_chat(user, SPAN_NOTICE("You must be inside [src] to exit it."))
		return
	if(user.incapacitated() && !ignore_incap_check)
		to_chat(user, SPAN_WARNING("You cannot do that when you are incapacitated!"))
		return
	var/nLoc = pick_valid_exit_loc()
	if(!nLoc)
		to_chat(user, SPAN_NOTICE("There is no valid location to exit at."))
		return
	occupants -= user
	user.forceMove(nLoc)
	playsound(src, 'sound/vehicles/modern/vehicle_enter.ogg', 150, 1, 5)
	update_object_sprites()

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
	desc = "Don't joke about the back door!"
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
