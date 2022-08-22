SUBSYSTEM_DEF(persistent_world)
	name = "Persistent world"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_PERSISTENT_WORLD
	var/online = FALSE
	var/i
	var/start

	// Probably very bad idea, but other variants are far worse.
	var/loading

	var/list/obj/queue = list()

/datum/controller/subsystem/persistent_world/stat_entry()
	if(!statclick)
		statclick = new/obj/effect/statclick/debug(null, "Initializing...", src)
	
	var/msg = "Q: [queue.len]"
	if(i)
		msg += " i: [i] [100 * (i / queue.len)]% V: [i / ((world.timeofday-start) / (1 SECOND))] O/s"
	stat("\[[state_letter()]][name]", statclick.update(msg))

/datum/controller/subsystem/persistent_world/PreInit()
	. = ..()
	online = fexists("data/world.sav")

/datum/controller/subsystem/persistent_world/Initialize(start_timeofday)
	to_world_log("Loading persistent world")
	admin_notice(SPAN_DANGER("Loading persistent world"), R_DEBUG)
	load_map()
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
		CHECK_TICK_HIGH_PRIORITY
	loading = FALSE

/obj/Destroy()
	. = ..()
	SSpersistent_world.queue -= src

/datum/controller/subsystem/persistent_world/proc/save_map()
	start = world.timeofday
	fdel("data/world.sav")
	var/savefile/S = new("data/world.sav")

	var/original_processing = Master.processing
	Master.processing = FALSE

	var/list/data = list()
	var/list/current_run = queue
	//var/list/turfs_data = list()
	for(var/obj/O as anything in current_run)
		++i
		if(!QDELETED(O) && isturf(O.loc))
			data += full_item_save(O)
			CHECK_TICK_HIGH_PRIORITY

	i = 0

	to_save(S, data)
	//to_save(S, turfs_data)

	Master.processing = original_processing

	to_world("World saving took [(world.timeofday - start) / (1 SECOND)] seconds.")
