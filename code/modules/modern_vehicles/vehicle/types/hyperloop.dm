/obj/vehicles/track_bound/hyperloop
	name = "magnet-driven vacuum transit system capsule"
	desc = "An extraordinary aerodynamic capsule suspended above a magnet structure that is used for propelling it in a vacuum tunnel."
	icon = 'icons/vehicles/hyperloop.dmi'
	track_obj_type = /obj/structure/track/magnet
	bound_x = 160
	bound_y = 256
	density = TRUE
	anchored = TRUE
	var/turf/starting_point = null
	var/locked = TRUE
	var/waitbeforearrival = 20
	var/departurecooldown = 40
	var/active = FALSE
	var/list/occupants = list()
	var/move_dir = SOUTH
	var/fastprocessing = FALSE
	var/datum/vehicle_interior/interior = null
	var/datum/map_template/interior_template = /datum/map_template/hyperloop
	var/arrived = FALSE
	var/departed = FALSE

/datum/map_template/hyperloop
	name = "Hyperloop"
	mappath = 'maps/interiors/hyperloop.dmm'


/obj/vehicles/track_bound/hyperloop/initialize()
	..()
	START_PROCESSING(SSobj, src)
	fastprocessing = FALSE
	interior = new(interior_template, src)
	starting_point = loc

/obj/vehicles/track_bound/hyperloop/process()
	. = ..()
	if(!active)
		return

	if(fastprocessing)
		handle_movement()
		return

	pixel_y = sin(world.time * 5)

	if(waitbeforearrival)
		waitbeforearrival -= 2
	else if(!fastprocessing && !arrived)
		switch_process()
		arrived = TRUE


	if(departurecooldown >= 0)
		departurecooldown -= 2
	else if(!departed)
		depart()

/obj/vehicles/track_bound/hyperloop/proc/handle_movement()
	var/turf/newloc = get_step(src.loc, move_dir)
	var/obj/effect/hyperloopstop/H = locate(/obj/effect/hyperloopstop) in newloc.contents
	if(H)
		switch_process()
		return
	Move(newloc, move_dir)

/obj/vehicles/track_bound/hyperloop/proc/switch_process()
	if(fastprocessing)
		STOP_PROCESSING(SSfastprocess, src)
		START_PROCESSING(SSobj, src)
	else
		START_PROCESSING(SSfastprocess, src)
		STOP_PROCESSING(SSobj, src)

/obj/vehicles/track_bound/hyperloop/attack_hand(mob/user)
	. = ..()

/obj/vehicles/track_bound/hyperloop/proc/exit_vehicle(mob/user)
	occupants -= user
	user.forceMove(src.loc)

/obj/vehicles/track_bound/hyperloop/proc/removeoccupants()
	for(var/mob/user in occupants)
		exit_vehicle(user)

/obj/vehicles/track_bound/hyperloop/proc/depart()
	departed = TRUE
	removeoccupants()
	switch_process()

/obj/vehicles/track_bound/hyperloop/proc/reset()
	arrived = FALSE
	departed = FALSE
	loc = starting_point
	waitbeforearrival = initial(waitbeforearrival)
	departurecooldown = initial(departurecooldown)

/obj/vehicles/track_bound/hyperloop/ex_act()
	return



/obj/structure/track/magnet
	name = "electromagnetic suspension track"

/obj/structure/track/magnet/ex_act()
	return

/obj/effect/hyperloopstop
	name = "hyperloop stop"