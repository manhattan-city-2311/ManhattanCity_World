SUBSYSTEM_DEF(persistent_world)
	name = "Persistent world"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_PERSISTENT_WORLD
	var/online = FALSE
	var/saved_objects = 0
	var/saved_turfs = 0
	var/start

	// Probably very bad idea, but other variants are far worse.
	var/loading

	var/skip_saving = FALSE

	var/list/obj/queue

/datum/controller/subsystem/persistent_world/stat_entry()
	if(!statclick)
		statclick = new/obj/effect/statclick/debug(null, "Initializing...", src)

	var/msg = "Q: [LAZYLEN(queue)]"
	if(saved_objects)
		var/ts = saved_turfs / ((world.timeofday-start) / (1 SECOND))
		var/os = saved_objects / ((world.timeofday-start) / (1 SECOND))
		msg += " T: [saved_turfs] O: [saved_objects] T/s: [ts] O/s: [os]"
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
	var/list/turfs_data

	from_save(S, data)
	from_save(S, turfs_data)

	for(var/list/chunk as anything in data)
		for(var/datum/map_object/MO as anything in chunk)
			full_item_load(MO, locate(MO.x, MO.y, MO.z))
			if(TICK_CHECK_HIGH_PRIORITY)
				online = FALSE
				stoplag()
				online = TRUE

	for(var/list/chunk as anything in turfs_data)
		for(var/datum/map_turf/MT as anything in chunk)
			full_turf_load(MT)
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

	var/list/data = list(list())
	var/data_chunk = 1

	var/list/turfs_data = list(list())
	var/turfs_chunk = 1

	for(var/area/A)
		if(!A.should_objects_be_saved && !A.should_turfs_be_saved)
			continue
		for(var/atom/V as anything in A)
			if(!V.dont_save)
				if(A.should_turfs_be_saved && isturf(V))
					turfs_data[turfs_chunk] += full_turf_save(V)
					if((++saved_turfs % 40000) == 0)
						turfs_data += list(list())
						++turfs_chunk
				else if(A.should_objects_be_saved)
					data[data_chunk] += full_item_save(V)
					if((++saved_objects % 40000) == 0)
						data += list(list())
						++data_chunk
				CHECK_TICK_HIGH_PRIORITY
			

	to_save(S, data)
	to_save(S, turfs_data)

	Master.processing = original_processing

	var/ts = saved_turfs / ((world.timeofday-start) / (1 SECOND))
	var/os = saved_objects / ((world.timeofday-start) / (1 SECOND))
	to_world("World saving took [(world.timeofday - start) / (1 SECOND)] seconds with [ts] T/s and [os] O/s.")

	saved_turfs = 0
	saved_objects = 0
