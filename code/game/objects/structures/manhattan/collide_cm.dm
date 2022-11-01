/atom/proc/Collided(atom/movable/AM)
	return

/// Called when an atom has been hit by a movable atom via movement
/atom/movable/Collided(atom/movable/AM)
	if(isliving(AM) && !anchored)
		var/target_dir = get_dir(AM, src)
		var/turf/target_turf = get_step(loc, target_dir)
		Move(target_turf)