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
	var/list/obstructions
	
	var/static/list/area/areas_to_save = list()
	var/static/list/blocked_characters = list()

/area/initialize()
	. = ..()
	if(should_objects_be_saved || should_turfs_be_saved)
		SSpersistent_world.areas_to_save += src

/area/Destroy()
	. = ..()
	SSpersistent_world.areas_to_save -= src

/datum/controller/subsystem/persistent_world/Topic(href, list/href_list)
	if(!check_rights(R_ADMIN))
		return
	
	if(alert(usr, "Are you sure?", "Confirmation", "Cancel", "Yes, unblock [href_list["victim"]].") == "Cancel")
		return
	
	blocked_characters -= href_list["victim"]

/datum/controller/subsystem/persistent_world/proc/add_obstruction(id, message)
	LAZYSET(obstructions, id, message)

/datum/controller/subsystem/persistent_world/proc/resolve_obstruction(id)
	LAZYREMOVE(obstructions, id)

/datum/controller/subsystem/persistent_world/stat_entry()
	var/msg = "HOLD"
	if(saved_objects)
		var/ts = saved_turfs / ((world.timeofday-start) / (1 SECOND))
		var/os = saved_objects / ((world.timeofday-start) / (1 SECOND))
		msg = "T: [saved_turfs] O: [saved_objects] T/s: [ts] O/s: [os]"

	..(msg)

/datum/controller/subsystem/persistent_world/PreInit()
	. = ..()
	online = fexists("data/world.sav")

/datum/controller/subsystem/persistent_world/Initialize(start_timeofday)
	to_world_log("Loading persistent world")
	admin_notice(SPAN_DANGER("Loading persistent world"), R_DEBUG)
	load_map()
	load_all_businesses()
	callHook("load_world")
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
				
	from_save(S, blocked_characters)

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
	var/list/dchunk = data[1]
	var/data_chunk = 1

	var/list/turfs_data = list(list())
	var/list/tchunk = turfs_data[1]
	var/turfs_chunk = 1

	for(var/area/A as anything in areas_to_save)
		for(var/atom/V as anything in A)
			if(!V.dont_save)
				if(isturf(V))
					if(!A.should_turfs_be_saved)
						continue
					tchunk += full_turf_save(V)
					if((++saved_turfs % 40000) == 0)
						turfs_data += list(list())
						tchunk = turfs_data[++turfs_chunk]
				else if(A.should_objects_be_saved)
					dchunk += full_item_save(V)
					if((++saved_objects % 40000) == 0)
						data += list(list())
						dchunk = data[++data_chunk]
				CHECK_TICK_HIGH_PRIORITY
			

	to_save(S, data)
	to_save(S, turfs_data)
	to_save(S, blocked_characters)

	Master.processing = original_processing

	var/ts = saved_turfs / ((world.timeofday-start) / (1 SECOND))
	var/os = saved_objects / ((world.timeofday-start) / (1 SECOND))
	to_world("World saving took [(world.timeofday - start) / (1 SECOND)] seconds with [ts] T/s and [os] O/s.")

	saved_turfs = 0
	saved_objects = 0
