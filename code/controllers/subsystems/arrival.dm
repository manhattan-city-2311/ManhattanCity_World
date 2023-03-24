#define ARRIVAL_WAITING_FOR_ROUNDSTART -1
#define ARRIVAL_HOLD 0
#define ARRIVAL_INCOMING 1
#define ARRIVAL_WAITING 2

// fuck you
#define ARRIVAL_PERIOD_FEW_PEOPLES (60 SECONDS)
#define ARRIVAL_PERIOD_HOLD_DEPART (30 SECONDS)
#define ARRIVAL_PERIOD_TRANSIT (50 SECONDS)
#define ARRIVAL_PERIOD_WAIT (20 SECONDS)
#define ARRIVAL_PERIOD_MIDST_TRANSIT (10 SECONDS)

/obj/effect/arrival_stop
	icon = 'icons/effects/effects.dmi'
	icon_state = "rift"

/obj/effect/arrival_stop/initialize()
	. = ..()
	SSarrival.stops += src
	icon_state = null

/obj/effect/arrival_stop/Destroy()
	SSarrival.stops -= src
	. = ..()

SUBSYSTEM_DEF(arrival)
	name = "Arrival"
	flags = SS_BACKGROUND | SS_NO_TICK_CHECK
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
	var/current_stop

/datum/controller/subsystem/arrival/Initialize()
	hyperloop = new
	. = ..()

/datum/controller/subsystem/arrival/proc/spawn_passengers()
	var/list/obj/structure/bed/chair/chairs = list()

	for(var/obj/structure/bed/chair/C in hyperloop.interior.area)
		chairs += C

	for(var/mob/new_player/NP in player_list)
		if(NP.spawning || !NP.ready)
			continue

		var/atom/movable/chair = pick(chairs)
		var/mob/M = NP.AttemptLateSpawn("Civilian", get_turf(chair))
		hyperloop.occupants[M] = VP_INTERIOR
		chair.buckle_mob(M)
		chairs -= chair

/datum/controller/subsystem/arrival/proc/arrive()
	hyperloop.forceMove(get_turf(stops[current_stop]))
	// fuck you, me, everyone, all bullshit, heroin, every drop of cofeine in my veins...

/datum/controller/subsystem/arrival/proc/depart()
	hyperloop.forceMove(null)

/datum/controller/subsystem/arrival/fire()
	if(!stops.len)
		for(var/mob/new_player/NP in player_list)
			if(NP.spawning || !NP.ready)
				continue
			NP.AttemptLateSpawn("Civilian")

		CRASH("No hyperloop stops found ;(")

	switch(arrival_state)
		if(ARRIVAL_HOLD)
			var/n_players = 0
			for(var/mob/new_player/NP in player_list)
				if(NP.spawning || !NP.ready)
					++n_players

			if(!next && n_players > 5 || (n_players > 0 && (last_departure == 0 || (world.time - last_departure) > ARRIVAL_PERIOD_FEW_PEOPLES)))
				next = world.time + ARRIVAL_PERIOD_HOLD_DEPART
			else if(world.time >= next)
				next = world.time + ARRIVAL_PERIOD_TRANSIT
				++arrival_state
				spawn_passengers()
				current_stop = 1

		if(ARRIVAL_INCOMING)
			if(world.time < next)
				return
			arrive()
			++arrival_state
			next = world.time + ARRIVAL_PERIOD_WAIT

		if(ARRIVAL_WAITING)
			if(world.time < next)
				return
			depart()

			if(current_stop++ == stops.len)
				arrival_state = ARRIVAL_HOLD
				next = 0
				return

			arrival_state = ARRIVAL_INCOMING
			next = world.time + ARRIVAL_PERIOD_MIDST_TRANSIT



/hook/roundstart/proc/arrival()
	SSarrival.arrival_state = ARRIVAL_HOLD

	return 1

