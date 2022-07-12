//UPDATE TRIGGERS, when the chunk (and the surrounding chunks) should update.

// TURFS

/proc/updateVisibility(atom/A, var/opacity_check = 1)
	if(ticker)
		for(var/datum/visualnet/VN in visual_nets)
			VN.updateVisibility(A, opacity_check)

/turf
	var/list/image/obfuscations

/turf/drain_power()
	return -1

/turf/simulated/Destroy()
	updateVisibility(src)
	return ..()

/turf/simulated/New()
	..()
	updateVisibility(src)


// STRUCTURES

/obj/structure/Destroy()
	updateVisibility(src)
	return ..()

/obj/structure/New()
	..()
	updateVisibility(src)

// EFFECTS

/obj/effect/Destroy()
	updateVisibility(src)
	return ..()

/obj/effect/New()
	..()
	updateVisibility(src)

// DOORS