/turf/proc/ReplaceWithLattice()
	src.ChangeTurf(get_base_turf_by_area(src))
	spawn()
		new /obj/structure/lattice( locate(src.x, src.y, src.z) )

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L)
		qdel(L)

// Called after turf replaces old one
/turf/proc/post_change()
	levelupdate()

	var/turf/simulated/open/above = GetAbove(src)
	if(istype(above))
		above.update_icon()

	var/turf/simulated/below = GetBelow(src)
	if(istype(below))
		below.update_icon() // To add or remove the 'ceiling-less' overlay.

//Creates a new turf
/turf/proc/ChangeTurf(turf/N, tell_universe=1, force_lighting_update = 0)
	if (!N)
		return

	// This makes sure that turfs are not changed to space when one side is part of a zone
	if(N == /turf/space)
		var/turf/below = GetBelow(src)
		if(istype(below) && !istype(below,/turf/space))
			N = /turf/simulated/open

	var/old_opacity = opacity
	var/old_dynamic_lighting = dynamic_lighting
	var/old_affecting_lights = affecting_lights
	var/old_lighting_overlay = lighting_overlay
	var/old_corners = corners
	var/old_dangerous_objects = dangerous_objects
	var/old_ao_neighbors = ao_neighbors

	//to_world("Replacing [src.type] with [N]")

	if(ispath(N, /turf/simulated/floor))
		var/turf/simulated/W = new N( locate(src.x, src.y, src.z) )

		if (istype(W, /turf/simulated/floor))
			W.RemoveLattice()

		if(tell_universe)
			universe.OnTurfChange(W)

		W.levelupdate()
		W.update_icon(1)
		W.post_change()
		. = W

	else

		var/turf/W = new N( locate(src.x, src.y, src.z) )

		if(tell_universe)
			universe.OnTurfChange(W)

		W.levelupdate()
		W.update_icon(1)
		W.post_change()
		W.ao_neighbors = old_ao_neighbors
		. =  W

	recalc_atom_opacity()

	dangerous_objects = old_dangerous_objects

	if(lighting_overlays_initialised)
		lighting_overlay = old_lighting_overlay
		affecting_lights = old_affecting_lights
		corners = old_corners
		if((old_opacity != opacity) || (dynamic_lighting != old_dynamic_lighting))
			reconsider_lights()
		if(dynamic_lighting != old_dynamic_lighting)
			if(dynamic_lighting)
				lighting_build_overlay()
			else
				lighting_clear_overlay()

/turf/ChangeTurf(var/turf/N, var/tell_universe=1, var/force_lighting_update = 0, var/preserve_outdoors = FALSE)
	var/old_density = density
	var/old_opacity = opacity
	. = ..()
	if(.)
		turf_changed_event.raise_event(src, old_density, density, old_opacity, opacity)
