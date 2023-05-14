#define ARRIVAL_WAITING_FOR_ROUNDSTART -1
#define ARRIVAL_HOLD 0
#define ARRIVAL_INCOMING 1
#define ARRIVAL_WAITING 2

#define ARRIVAL_PERIOD_FEW_PEOPLES (60 SECONDS)
#define ARRIVAL_PERIOD_HOLD_DEPART (30 SECONDS)
#define ARRIVAL_PERIOD_TRANSIT (120 SECONDS)
#define ARRIVAL_PERIOD_WAIT (30 SECONDS) // wait on each station, includes time for arrival
#define ARRIVAL_PERIOD_MIDST_TRANSIT (10 SECONDS) // time for travel between stops, includes time for departion

SUBSYSTEM_DEF(arrival)
	name = "Arrival"
	flags = SS_BACKGROUND
	wait = 5 SECONDS

	var/last_departure = 0
	/*
	 * ARRIVAL_HOLD - next departure if != 0
	 * ARRIVAL_INCOMING - next arrival
	 * ARRIVAL_WAITING - next departure
	 */
	var/next
	var/arrival_state = ARRIVAL_WAITING_FOR_ROUNDSTART

	var/obj/manhattan/vehicle/large/hyperloop/hyperloop
	var/list/obj/effect/arrival_stop/stops = list()
	var/obj/hyperloop_renderer/renderer
	var/current_stop

/datum/controller/subsystem/arrival/stat_entry()
	..("AS:[arrival_state]")

/datum/controller/subsystem/arrival/Initialize()
	hyperloop = new

	do
		renderer = locate("@hyperloop_renderer")
		sleep(1)
	while(!renderer)
	. = ..()

/datum/controller/subsystem/arrival/proc/spawn_passengers()
	var/list/obj/structure/bed/chair/chairs = list()

	for(var/obj/structure/bed/chair/C in hyperloop.interior.area)
		chairs += C

	for(var/mob/new_player/NP in player_list)
		if(!chairs.len)
			break

		if(NP.spawning || !NP.ready)
			continue

		var/atom/movable/chair = pick(chairs)
		var/mob/M = NP.AttemptLateSpawn("Civilian", get_turf(chair))

		if(!M)
			continue

		hyperloop.handle_entering(M, VP_INTERIOR)
		M.forceMove(get_turf(chair))
		chair.buckle_mob(M)
		chairs -= chair

/datum/controller/subsystem/arrival/proc/arrive()
	hyperloop.forceMove(get_turf(stops[current_stop]))
	hyperloop.dir = stops[current_stop].dir

/datum/controller/subsystem/arrival/proc/depart()
	hyperloop.forceMove(null)

/datum/controller/subsystem/arrival/fire()
	if(!stops.len)
		var/worked = FALSE
		for(var/mob/new_player/NP in player_list)
			if(NP.spawning || !NP.ready)
				continue
			NP.AttemptLateSpawn("Civilian")
			worked = TRUE

		if(worked)
			CRASH("No hyperloop stops found ;(")
		return

	if(renderer.icon_state != "static")
		for(var/mob/M in hyperloop.interior.area)
			spawn()
				var/sign = prob(50) ? 1 : -1
				animate(M.client, pixel_x = sign * 3, pixel_y = -sign, time = 2 SECOND)
				animate(M.client, pixel_x = 0       , pixel_y =  0   , time = 2 SECOND)

	switch(arrival_state)
		if(ARRIVAL_HOLD)
			var/n_players = 0
			for(var/mob/new_player/NP in player_list)
				if(NP.spawning || !NP.ready)
					++n_players

			if(!next && (n_players > 5 || (n_players && (last_departure == 0 || (world.time - last_departure) > ARRIVAL_PERIOD_FEW_PEOPLES))))
				next = world.time + ARRIVAL_PERIOD_HOLD_DEPART
			else if(world.time >= next)
				next = world.time + ARRIVAL_PERIOD_TRANSIT
				++arrival_state

				renderer.icon_state = "fast"
				spawn_passengers()
				current_stop = 1

		if(ARRIVAL_INCOMING)
			switch(next - world.time)
				if(15 SECONDS to POSITIVE_INFINITY)
					renderer.icon_state = "fast"
				if(5 SECONDS to 15 SECONDS)
					renderer.icon_state = "medium"
				else
					renderer.icon_state = "slow"

			if(world.time < next)
				return

			flick("static_flick", renderer)
			renderer.icon_state = "static"
			arrive()
			++arrival_state
			next = world.time + ARRIVAL_PERIOD_WAIT

		if(ARRIVAL_WAITING)
			if(world.time < next)
				return
			depart()
			flick("static_flick", renderer)
			renderer.icon_state = "slow"

			spawn(5 SECONDS)
				renderer.icon_state = "medium"

			if(current_stop++ == stops.len)
				arrival_state = ARRIVAL_HOLD
				current_stop = 0
				next = 0
				return

			arrival_state = ARRIVAL_INCOMING
			next = world.time + ARRIVAL_PERIOD_MIDST_TRANSIT

/hook/roundstart/proc/arrival()
	SSarrival.arrival_state = ARRIVAL_HOLD

	return 1

