//
// Mobs Subsystem - Process mob.Life()
//

SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = FIRE_PRIORITY_MOBS
	wait = 2 SECONDS
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	var/log_extensively = FALSE
	var/list/timelog = list()
	var/list/busy_z_levels = list()
	var/slept_mobs = 0

/datum/controller/subsystem/mobs/stat_entry()
	..("P: [global.mob_list.len] | S: [slept_mobs]")

/datum/controller/subsystem/mobs/fire(resumed = FALSE)
	var/list/busy_z_levels = src.busy_z_levels

	if (!resumed)
		slept_mobs = 0
		currentrun = mob_list.Copy()
		busy_z_levels.Cut()
		for(var/mob/played_mob as anything in player_list)
			if(!played_mob || isobserver(played_mob))
				continue
			busy_z_levels |= played_mob.z

	//cache for sanic speed (lists are references anyways)
	var/list/queue = currentrun
	var/times_fired = src.times_fired
	var/mob/M
	for(var/i = queue.len to 1 step -1)
		M = queue[i]

		if(QDELETED(M))
			mob_list -= M
		else
			if(M.low_priority && !(M.z in busy_z_levels))
				++slept_mobs
				continue
			try
				M.Life(times_fired)
			catch(var/exception/e)
				log_runtime(e, M, "Caught by [name] subsystem")

		if (MC_TICK_CHECK)
			queue.Cut(i)
			return
