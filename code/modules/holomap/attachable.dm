// to attach it to movable send attack_hand and Bumped to ./attachable/attack_hand&Bumped
// DO NOT ATTACH TO OBJ/ITEMS
/obj/machinery/station_map/attachable
	density = 0
	anchored = 0
	icon = null
	icon_state = null
	var/atom/movable/owner = null

/obj/machinery/station_map/attachable/Destroy()
	. = ..()
	SetOwner(null)

/obj/machinery/station_map/attachable/proc/SyncLocation(_, __, ___, needToBreak = FALSE)
	if(QDELETED(owner))
		SetOwner(null)
		return
	var/turf/T = get_turf(owner)
	if(T)
		loc = T

	if(!needToBreak)
		GLOB.moved_event.register(owner, src, PROC_REF(SyncLocation))

/obj/machinery/station_map/attachable/proc/SetOwner(atom/movable/target)
	if(owner != target)
		if(owner)
			GLOB.moved_event.unregister(owner, src, PROC_REF(SyncLocation))
			GLOB.destroyed_event.unregister(owner, src, /datum/proc/Destroy)

		if(target == null)
			owner = null
			return

		owner = target
		GLOB.destroyed_event.register(owner, src, /datum/proc/Destroy)
		SyncLocation(needToBreak = null)


/obj/machinery/station_map/attachable/update_icon()
	return
