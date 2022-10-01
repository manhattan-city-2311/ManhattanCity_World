/obj/effect/overlay
	name = "overlay"
	unacidable = 1
	var/i_attached
	//Added for possible image attachments to objects. For hallucinations and the like.

/obj/effect/overlay/beam//Not actually a projectile, just an effect.
	name="beam"
	icon='icons/effects/beam.dmi'
	icon_state="b_beam"
	var/tmp/atom/BeamSource
	New()
		..()
		spawn(10) qdel(src)

/obj/effect/overlay/palmtree_r
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm1"
	density = 1
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = 1

/obj/effect/overlay/palmtree_l
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm2"
	density = 1
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = 1

/obj/effect/overlay/coconut
	name = "Coconuts"
	icon = 'icons/misc/beach.dmi'
	icon_state = "coconuts"

/obj/effect/overlay/bluespacify
	name = "Bluespace"
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespacify"
	plane = ABOVE_PLANE

/obj/effect/overlay/wallrot
	name = "wallrot"
	desc = "Ick..."
	icon = 'icons/effects/wallrot.dmi'
	anchored = 1
	density = 1
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = 0

/obj/effect/overlay/wallrot/New()
	..()
	pixel_x += rand(-10, 10)
	pixel_y += rand(-10, 10)

/obj/effect/overlay/snow
	name = "snow"
	icon = 'icons/turf/overlays.dmi'
	icon_state = "snow"
	anchored = 1

// Todo: Add a version that gradually reaccumulates over time by means of alpha transparency. -Spades
/obj/effect/overlay/snow/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/shovel))
		user.visible_message("<span class='notice'>[user] begins to shovel away \the [src].</span>")
		if(do_after(user, 40))
			to_chat(user, "<span class='notice'>You have finished shoveling!</span>")
			qdel(src)
		return

/obj/effect/overlay/snow/floor
	icon_state = "snowfloor"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	mouse_opacity = 0 //Don't block underlying tile interactions

/obj/effect/overlay/snow/floor/edges
	icon_state = "snow_edges"

/obj/effect/overlay/snow/floor/surround
	icon_state = "snow_surround"

/obj/effect/overlay/snow/airlock
	icon_state = "snowairlock"
	layer = DOOR_CLOSED_LAYER+0.01

/obj/effect/overlay/snow/floor/pointy
	icon_state = "snowfloorpointy"

/obj/effect/overlay/snow/wall
	icon_state = "snowwall"
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER

/obj/effect/overlay/holographic
	mouse_opacity = FALSE
	anchored = TRUE
	plane = ABOVE_PLANE

// Similar to the tesla ball but doesn't actually do anything and is purely visual.
/obj/effect/overlay/energy_ball
	name = "energy ball"
	desc = "An energy ball."
	icon = 'icons/obj/tesla_engine/energy_ball.dmi'
	icon_state = "energy_ball"
	plane = PLANE_LIGHTING_ABOVE
	pixel_x = -32
	pixel_y = -32

/obj/effect/overlay/temp
	anchored = 1
	plane = MOB_PLANE
	layer = BELOW_MOB_LAYER
	mouse_opacity = 0
	var/duration = 10
	var/randomdir = TRUE

/obj/effect/overlay/temp/New()
	if(randomdir)
		dir = pick(GLOB.cardinal)

	flick("[icon_state]", src) //Because we might be pulling it from a pool, flick whatever icon it uses so it starts at the start of the icon's animation.

	spawn(duration)
		qdel(src)

/obj/effect/overlay/temp/dir_setting/bloodsplatter
	icon = 'icons/effects/bloodsplatter.dmi'
	duration = 5
	randomdir = FALSE
	color = "#C80000"
	var/splatter_type = "splatter"

/obj/effect/overlay/temp/dir_setting/bloodsplatter/New(loc, set_dir, blood_color)
	if(blood_color)
		color = blood_color
	if(set_dir in GLOB.cornerdirs)
		icon_state = "[splatter_type][pick(1, 2, 6)]"
	else
		icon_state = "[splatter_type][pick(3, 4, 5)]"
	..()
	var/target_pixel_x = 0
	var/target_pixel_y = 0
	switch(set_dir)
		if(NORTH)
			target_pixel_y = 16
		if(SOUTH)
			target_pixel_y = -16
		if(EAST)
			target_pixel_x = 16
		if(WEST)
			target_pixel_x = -16
		if(NORTHEAST)
			target_pixel_x = 16
			target_pixel_y = 16
		if(NORTHWEST)
			target_pixel_x = -16
			target_pixel_y = 16
		if(SOUTHEAST)
			target_pixel_x = 16
			target_pixel_y = -16
		if(SOUTHWEST)
			target_pixel_x = -16
			target_pixel_y = -16
	animate(src, pixel_x = target_pixel_x, pixel_y = target_pixel_y, alpha = 0, time = duration)

/obj/effect/overlay/temp/dir_setting/bloodsplatter/xenosplatter
	splatter_type = "xsplatter"

/obj/effect/overlay/vis
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	var/unused = 0 //When detected to be unused it gets set to world.time, after a while it gets removed
	var/cache_expiration = 2 MINUTES // overlays which go unused for 2 minutes get cleaned up
