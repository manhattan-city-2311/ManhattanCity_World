//These lists are populated in /datum/controller/subsystem/shuttles/proc/setup_shuttle_docks()
//Shuttle subsystem is instantiated in shuttles.dm.

//shuttle moving state defines are in setup.dm

/datum/shuttle
	var/name = ""
	var/warmup_time = 0
	var/moving_status = SHUTTLE_IDLE

	var/docking_controller_tag	//tag of the controller used to coordinate docking
	var/datum/computer/file/embedded_program/docking/docking_controller	//the controller itself. (micro-controller, not game controller)

	var/arrive_time = 0	//the time at which the shuttle arrives when long jumping
	var/depart_time = 0 //Similar to above, set when the shuttle leaves when long jumping, to compare against arrive time.
	var/flags = SHUTTLE_FLAGS_PROCESS
	var/category = /datum/shuttle

	var/ceiling_type = /turf/unsimulated/floor/shuttle_ceiling

/datum/shuttle/New()
	..()
	if(src.name in shuttle_controller.shuttles)
		CRASH("A shuttle with the name '[name]' is already defined.")
	shuttle_controller.shuttles[src.name] = src
	if(flags & SHUTTLE_FLAGS_PROCESS)
		shuttle_controller.process_shuttles += src
	if(flags & SHUTTLE_FLAGS_SUPPLY)
		if(supply_controller.shuttle)
			CRASH("A supply shuttle is already defined.")
		supply_controller.shuttle = src

/datum/shuttle/Destroy()
	shuttle_controller.shuttles -= src.name
	shuttle_controller.process_shuttles -= src
	if(supply_controller.shuttle == src)
		supply_controller.shuttle = null
	. = ..()

/datum/shuttle/process()
	return

/datum/shuttle/proc/init_docking_controllers()
	if(docking_controller_tag)
		docking_controller = locate(docking_controller_tag)
		if(!istype(docking_controller))
			to_world("<span class='danger'>warning: shuttle with docking tag [docking_controller_tag] could not find it's controller!</span>")

// This creates a graphical warning to where the shuttle is about to land, in approximately five seconds.
/datum/shuttle/proc/create_warning_effect(area/landing_area)
	for(var/turf/T in landing_area)
		new /obj/effect/temporary_effect/shuttle_landing(T) // It'll delete itself when needed.

// Return false to abort a jump, before the 'warmup' phase.
/datum/shuttle/proc/pre_warmup_checks()
	return TRUE

// Ditto, but for afterwards.
/datum/shuttle/proc/post_warmup_checks()
	return TRUE

// If you need an event to occur when the shuttle jumps in short or long jump, override this.
/datum/shuttle/proc/on_shuttle_departure(var/area/origin)
	origin.shuttle_departed()
	return

// Similar to above, but when it finishes moving to the target.  Short jump generally makes this occur immediately after the above proc.
/datum/shuttle/proc/on_shuttle_arrival(var/area/destination)
	destination.shuttle_arrived()
	return

/datum/shuttle/proc/short_jump(var/area/origin,var/area/destination)
	if(moving_status != SHUTTLE_IDLE)
		return

	if(!pre_warmup_checks())
		return

	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)

		make_sounds(origin, HYPERSPACE_WARMUP)
		create_warning_effect(destination)
		sleep(5 SECONDS) // so the sound finishes.

		if(!post_warmup_checks())
			moving_status = SHUTTLE_IDLE

		if (moving_status == SHUTTLE_IDLE)
			make_sounds(origin, HYPERSPACE_END)
			return	//someone cancelled the launch

		on_shuttle_departure(origin)

		moving_status = SHUTTLE_INTRANSIT //shouldn't matter but just to be safe
		move(origin, destination)
		moving_status = SHUTTLE_IDLE

		on_shuttle_arrival(destination)

		make_sounds(destination, HYPERSPACE_END)

/datum/shuttle/proc/long_jump(var/area/departing, var/area/destination, var/area/interim, var/travel_time, var/direction)
	//to_world("shuttle/long_jump: departing=[departing], destination=[destination], interim=[interim], travel_time=[travel_time]")
	if(moving_status != SHUTTLE_IDLE)
		return

	if(!pre_warmup_checks())
		return

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)

		make_sounds(departing, HYPERSPACE_WARMUP)
		create_warning_effect(interim) // Really doubt someone is gonna get crushed in the interim area but for completeness's sake we'll make the warning.
		sleep(5 SECONDS) // so the sound finishes.

		if(!post_warmup_checks())
			moving_status = SHUTTLE_IDLE

		if (moving_status == SHUTTLE_IDLE)
			make_sounds(departing, HYPERSPACE_END)
			return	//someone cancelled the launch

		arrive_time = world.time + travel_time*10

		depart_time = world.time

		moving_status = SHUTTLE_INTRANSIT

		on_shuttle_departure(departing)

		move(departing, interim, direction)
		interim.shuttle_arrived()

		var/last_progress_sound = 0
		var/made_warning = FALSE
		while (world.time < arrive_time)
			// Make the shuttle make sounds every four seconds, since the sound file is five seconds.
			if(last_progress_sound + 4 SECONDS < world.time)
				make_sounds(interim, HYPERSPACE_PROGRESS)
				last_progress_sound = world.time

			if(arrive_time - world.time <= 5 SECONDS && !made_warning)
				made_warning = TRUE
				create_warning_effect(destination)
			sleep(5)

		interim.shuttle_departed()
		move(interim, destination, direction)
		moving_status = SHUTTLE_IDLE

		on_shuttle_arrival(destination)

		make_sounds(destination, HYPERSPACE_END)

/datum/shuttle/proc/dock()
	if (!docking_controller)
		return

	var/dock_target = current_dock_target()
	if (!dock_target)
		return

	docking_controller.initiate_docking(dock_target)

/datum/shuttle/proc/undock()
	if (!docking_controller)
		return
	docking_controller.initiate_undocking()

/datum/shuttle/proc/current_dock_target()
	return null

/datum/shuttle/proc/skip_docking_checks()
	if (!docking_controller || !current_dock_target())
		return 1	//shuttles without docking controllers or at locations without docking ports act like old-style shuttles
	return 0

//just moves the shuttle from A to B, if it can be moved
//A note to anyone overriding move in a subtype. move() must absolutely not, under any circumstances, fail to move the shuttle.
//If you want to conditionally cancel shuttle launches, that logic must go in short_jump() or long_jump()
/datum/shuttle/proc/move(var/area/origin, var/area/destination, var/direction=null)

	//to_world("move_shuttle() called for [name] leaving [origin] en route to [destination].")

	//to_world("area_coming_from: [origin]")
	//to_world("destination: [destination]")

	if(origin == destination)
		//to_world("cancelling move, shuttle will overlap.")
		return

	if (docking_controller && !docking_controller.undocked())
		docking_controller.force_undock()

	var/list/dstturfs = list()
	var/throwy = world.maxy

	for(var/turf/T in destination)
		dstturfs += T
		if(T.y < throwy)
			throwy = T.y

	for(var/turf/T in dstturfs)
		var/turf/D = locate(T.x, throwy - 1, T.z)
		for(var/atom/movable/AM as mob|obj in T)
			AM.Move(D)

	for(var/mob/living/carbon/bug in destination)
		bug.gib()

	for(var/mob/living/simple_mob/pest in destination)
		pest.gib()

	origin.move_contents_to(destination, direction=direction)

	for(var/mob/M in destination)
		if(M.client)
			spawn(0)
				if(M.buckled)
					to_chat(M, "<font color='red'>Sudden acceleration presses you into \the [M.buckled]!</font>")
					shake_camera(M, 3, 1)
				else
					to_chat(M, "<font color='red'>The floor lurches beneath you!</font>")
					shake_camera(M, 10, 1)
		if(istype(M, /mob/living/carbon))
			if(!M.buckled)
				M.Weaken(3)

//returns 1 if the shuttle has a valid arrive time
/datum/shuttle/proc/has_arrive_time()
	return (moving_status == SHUTTLE_INTRANSIT)

/datum/shuttle/proc/make_sounds(var/area/A, var/sound_type)
	var/sound_to_play = null
	switch(sound_type)
		if(HYPERSPACE_WARMUP)
			sound_to_play = 'sound/effects/shuttles/hyperspace_begin.ogg'
		if(HYPERSPACE_PROGRESS)
			sound_to_play = 'sound/effects/shuttles/hyperspace_progress.ogg'
		if(HYPERSPACE_END)
			sound_to_play = 'sound/effects/shuttles/hyperspace_end.ogg'
	for(var/obj/machinery/door/E in A)	//dumb, I know, but playing it on the engines doesn't do it justice
		playsound(E, sound_to_play, 50, FALSE)

/datum/shuttle/proc/message_passengers(area/A, var/message)
	for(var/mob/M in A)
		M.show_message(message, 2)
