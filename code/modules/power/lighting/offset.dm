/obj/machinery/light
	var/offset_of_light_forward = 0 // Depends on direction
	var/offset_of_light_sides = 0
	var/tmp/atom/movable/light_spot/LocationOfLightSource

/obj/machinery/light/Destroy()
	qdel(LocationOfLightSource)
	. = ..()

/obj/machinery/light/proc/SetLightOffSet(_x, _y)
	offset_of_light_forward = _x
	offset_of_light_sides = _y
	LocationOfLightSource.offsetForward = offset_of_light_forward
	LocationOfLightSource.offsetSides = offset_of_light_sides
	update()

/obj/machinery/light/update()
	if(!LocationOfLightSource && (offset_of_light_forward != 0 || offset_of_light_sides != 0))
		LocationOfLightSource = new(src, offset_of_light_forward, offset_of_light_sides)
	. = ..()

/atom/movable/light_spot
	var/atom/movable/owner
	var/offsetForward = 0
	var/offsetSides = 0
	invisibility = INVISIBILITY_ABSTRACT

/atom/movable/light_spot/New(atom/movable/_owner, _offsetX, _offsetY)
	. = ..()
	offsetForward = _offsetX
	offsetSides = _offsetY
	owner = _owner
	if(owner)
		dropInto(owner)
		update_follow()
		//CALLBACK(src, .proc/update_follow)
		//register(var/atom/movable/mover, var/datum/listener, var/proc_call)

// /atom/movable/light_spot/Destroy()
// 	GLOB.moved_event.unregister(owner, src, .proc/update_follow)
// 	GLOB.dir_set_event.unregister(owner, src, .proc/update_follow)
// 	. = ..()

/atom/movable/light_spot/proc/update_location_RAW()
	var/_x = 1
	var/_y = 1
	dir = owner.dir
	if(dir == NORTH)
		_x = owner.x + offsetSides
		_y = owner.y + offsetForward
	else if(dir == SOUTH)
		_x = owner.x + offsetSides
		_y = owner.y - offsetForward
	else if(dir == EAST)
		_x = owner.x + offsetForward
		_y = owner.y + offsetSides
	else if(dir == WEST)
		_x = owner.x - offsetForward
		_y = owner.y + offsetSides
	Move(locate(_x, _y, z))
/atom/movable/light_spot/proc/update_follow(event_type) //update_follow([0,1,null]) 0 - Move 1 - Dir null - begining follow type
	// to_world(event_type)
	update_location_RAW()
	// if(event_type == null || event_type == 0)
	// 	GLOB.moved_event.register(owner, src, CALLBACK(src, .proc/update_follow, 0))
	// if(event_type == null || event_type == 1)
	// 	GLOB.dir_set_event.register(owner, src, CALLBACK(src, .proc/update_follow, 1))

/obj/machinery/light/Move()
	. = ..()
	if(LocationOfLightSource)
		LocationOfLightSource.update_follow()

/obj/machinery/light/set_dir(new_dir)
	. = ..()
	if(LocationOfLightSource)
		LocationOfLightSource.update_follow()
