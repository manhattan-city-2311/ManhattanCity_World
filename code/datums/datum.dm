//
// datum defines!
// Note: Adding vars to /datum adds a var to EVERYTHING! Don't go overboard.
//

/datum
	var/list/status_traits
	//var/list/datum_components //for /datum/components
	var/list/comp_lookup //it used to be for looking up components which had registered a signal but now anything can register
	var/gc_destroyed //Time when this object was destroyed.
	var/weakref/weakref // Holder of weakref instance pointing to this datum
	var/is_processing		//If is processing, may or may not have the name of the list it's in.
	var/list/active_timers  //for SStimer
	var/datum_flags = NONE
	var/list/signal_procs
	//var/signal_enabled = FALSE

#ifdef TESTING
	var/tmp/running_find_references
	var/tmp/last_find_references = 0
#endif

/datum/proc/qdel_self()
	qdel(src)

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return the appropriate QDEL_HINT; in most cases this is QDEL_HINT_QUEUE.
/datum/proc/Destroy(force=FALSE)
	//clear timers
	var/list/timers = active_timers
	active_timers = null
	for(var/datum/timedevent/timer as anything in timers)
		if(!timer.spent)
			qdel(timer)

	weakref = null // Clear this reference to ensure it's kept for as brief duration as possible.

	tag = null
	SSnanoui.close_uis(src)
	return QDEL_HINT_QUEUE

/datum/proc/_SendSignal(sigtype, list/arguments)
	var/target = comp_lookup[sigtype]
	if(!length(target))
		var/datum/C = target
		//if(!C.signal_enabled)
		//	return NONE
		var/datum/callback/CB = C.signal_procs[src][sigtype]
		return CB.InvokeAsync(arglist(arguments))
	. = NONE
	for(var/I in target)
		var/datum/C = I
		//if(!C.signal_enabled)
		//	continue
		var/datum/callback/CB = C.signal_procs[src][sigtype]
		. |= CB.InvokeAsync(arglist(arguments))
