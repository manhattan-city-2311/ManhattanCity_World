SUBSYSTEM_DEF(persistent_world)
	name = "Persistent world"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_PERSISTENT_WORLD
	var/online = FALSE
	var/i
	var/start

	// Probably very bad idea, but other variants are far worse.
	var/loading

	var/skip_saving = FALSE

	var/list/obj/queue = list()

/datum/controller/subsystem/persistent_world/stat_entry()
	if(!statclick)
		statclick = new/obj/effect/statclick/debug(null, "Initializing...", src)

	var/msg = "Q: [queue.len]"
	if(i)
		msg += " i: [i] V: [i / ((world.timeofday-start) / (1 SECOND))] O/s"
	stat("\[[state_letter()]][name]", statclick.update(msg))

/datum/controller/subsystem/persistent_world/PreInit()
	. = ..()
	online = fexists("data/world.sav")

/datum/controller/subsystem/persistent_world/Initialize(start_timeofday)
	to_world_log("Loading persistent world")
	admin_notice(SPAN_DANGER("Loading persistent world"), R_DEBUG)
	load_map()
	load_all_businesses()
	to_world("World loading took [(world.timeofday - start_timeofday) / (1 SECOND)] seconds.")
	return ..()

/datum/controller/subsystem/persistent_world/proc/load_map()
	if(!online)
		return
	loading = TRUE
	var/savefile/S = new("data/world.sav")

	var/list/data
	//var/list/turfs_data
	from_save(S, data)
	//from_save(S, turfs_data)

	for(var/datum/map_object/MO as anything in data)
		full_item_load(MO, locate(MO.x, MO.y, MO.z))
		if(TICK_CHECK_HIGH_PRIORITY)
			online = FALSE
			stoplag()
			online = TRUE
	loading = FALSE

/datum/controller/subsystem/persistent_world/proc/save_map()
	if(skip_saving)
		to_world("Map saving skipped.")
		return

	start = world.timeofday
	fdel("data/world.sav")
	var/savefile/S = new("data/world.sav")

	var/original_processing = Master.processing
	Master.processing = FALSE

	var/list/data = list()
	//var/list/current_run = queue
	//var/list/turfs_data = list()
	for(var/area/A)
		if(!A.should_be_saved)
			continue
		for(var/atom/V as anything in A)
			if(!V.dont_save)
				data += full_item_save(V)
				CHECK_TICK_HIGH_PRIORITY
				++i

	to_save(S, data)
	//to_save(S, turfs_data)

	Master.processing = original_processing

/*
	var/dmm_suite/dmm_suite = new
	for(var/z in using_map.station_levels)
		dmm_suite.save_map(locate(1, 1, z), locate(world.maxx, world.maxy, z), "map_save[z]", flags = DMM_IGNORE_MOBS)
*/
	to_world("World saving took [(world.timeofday - start) / (1 SECOND)] seconds with [i / ((world.timeofday-start) / (1 SECOND))] O/s.")
	i = 0
