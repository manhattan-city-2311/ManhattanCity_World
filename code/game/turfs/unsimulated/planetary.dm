// This is a wall you surround the area of your "planet" with, that makes the atmosphere inside stay within bounds, even if canisters
// are opened or other strange things occur.

/turf/unsimulated/wall/planetary
	name = "railroading"
	desc = "Choo choo!"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = 1
	density = 1
	alpha = 0


/turf/unsimulated/wall/planetary/initialize()
	..()
	SSplanets.addTurf(src)

/turf/unsimulated/wall/planetary/Destroy()
	SSplanets.removeTurf(src)
	..()

// Wiki says it's 92.6 kPa, composition 18.1% O2 80.8% N2 1.1% trace.  We're gonna pretend trace is actually nitrogen.
/turf/unsimulated/wall/planetary/pollux

//High Alt Sif
/turf/unsimulated/wall/planetary/pollux/alt

// Fairly close to Mars in terms of temperature and pressure.
/turf/unsimulated/wall/planetary/magni

/turf/unsimulated/wall/planetary/desert
