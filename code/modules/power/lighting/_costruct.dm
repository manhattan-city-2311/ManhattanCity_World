var/global/list/light_type_cache = list()
/proc/get_light_type_instance(var/light_type)
	. = light_type_cache[light_type]
	if(!.)
		. = new light_type
		light_type_cache[light_type] = .

/obj/machinery/light_construct
	name = "light fixture frame"
	desc = "A light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-stage1"
	anchored = 1
	plane = ABOVE_MOB_PLANE
	var/stage = 1
	var/fixture_type = /obj/machinery/light
	var/sheets_refunded = 2
	table_drag = TRUE

/obj/machinery/light_construct/New(atom/newloc, obj/machinery/light/fixture = null)
	..(newloc)
	if(fixture)
		fixture_type = fixture.type
		fixture.transfer_fingerprints_to(src)
		set_dir(fixture.dir)
		stage = 2
	update_icon()

/obj/machinery/light_construct/update_icon()
	switch(stage)
		if(1)
			icon_state = "tube-construct-stage1"
		if(2)
			icon_state = "tube-construct-stage2"
		if(3)
			icon_state = "tube-empty"

/obj/machinery/light_construct/examine(mob/user)
	if(!..(user, 2))
		return

	switch(src.stage)
		if(1)
			to_chat(user, "It's an empty frame.")
			return
		if(2)
			to_chat(user, "It's wired.")
			return
		if(3)
			to_chat(user, "The casing is closed.")
			return

/obj/machinery/light_construct/attackby(obj/item/weapon/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (istype(W, /obj/item/weapon/wrench))
		if (src.stage == 1)
			playsound(src, W.usesound, 75, 1)
			to_chat(usr, "You begin deconstructing [src].")
			if (!do_after(usr, 30 * W.toolspeed))
				return
			new /obj/item/stack/material/steel( get_turf(src.loc), sheets_refunded )
			user.visible_message("[user.name] deconstructs [src].", \
				"You deconstruct [src].", "You hear a noise.")
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 75, 1)
			qdel(src)
		if (src.stage == 2)
			to_chat(usr, "You have to remove the wires first.")
			return

		if (src.stage == 3)
			to_chat(usr, "You have to unscrew the case first.")
			return

	if(istype(W, /obj/item/weapon/wirecutters))
		if (src.stage != 2) return
		src.update_icon()
		src.stage = 1
		new /obj/item/stack/cable_coil(get_turf(src.loc), 1, "red")
		user.visible_message("You removes the wiring from [src].", \
			"You remove the wiring from [src].", "You hear a noise.")
		playsound(src.loc, W.usesound, 50, 1)
		return

	if(istype(W, /obj/item/stack/cable_coil))
		if (src.stage != 1) return
		var/obj/item/stack/cable_coil/coil = W
		if (coil.use(1))
			src.stage = 2
			src.update_icon()
			user.visible_message("You adds wires to [src].", \
				"You add wires to [src].")
		return

	if(istype(W, /obj/item/weapon/screwdriver))
		if(!anchored && src.stage == 1)
			playsound(src.loc, W.usesound, 75, 1)
			to_chat(usr, "You start to screw [src] into place.")
			if(do_after(user, 20 * W.toolspeed))
				anchored = TRUE
				user.visible_message("You screw [src] into place.")
				return

		else if(anchored && src.stage == 1)
			playsound(src, W.usesound, 75, 1)
			to_chat(usr, "You start to unscrew [src] into place.")
			if(do_after(user, 20 * W.toolspeed))
				user.visible_message("You unfasten [src].")
				anchored = FALSE
				return
		else if (src.stage == 2)
			src.stage = 3
			src.update_icon()
			user.visible_message("You closes [src]'s casing.", \
				"You close [src]'s casing.", "You hear a noise.")
			playsound(src, W.usesound, 75, 1)

			var/obj/machinery/light/newlight = new fixture_type(src.loc, src, anchored)
			newlight.set_dir(turn(dir, 180))

			src.transfer_fingerprints_to(newlight)
			qdel(src)
			return
	..()

/obj/machinery/light_construct/verb/rotate_counterclockwise()
	set name = "Rotate Frame Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return FALSE

	if(anchored)
		to_chat(usr, "It is fastened to the wall therefore you can't rotate it!")
		return FALSE

	src.set_dir(turn(src.dir, 90))

	to_chat(usr, "<span class='notice'>You rotate the [src] to face [dir2text(dir)]!</span>")

	return


/obj/machinery/light_construct/verb/rotate_clockwise()
	set name = "Rotate Frame Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return FALSE

	if(anchored)
		to_chat(usr, "It is fastened to the wall therefore you can't rotate it!")
		return FALSE

	src.set_dir(turn(src.dir, 270))

	to_chat(usr, "<span class='notice'>You rotate the [src] to face [dir2text(dir)]!</span>")

	return

/obj/machinery/light_construct/small
	name = "small light fixture frame"
	desc = "A small light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "bulb-construct-stage1"
	anchored = 1
	plane = ABOVE_MOB_PLANE
	stage = 1
	fixture_type = /obj/machinery/light/small
	sheets_refunded = 1

/obj/machinery/light_construct/flamp
	name = "floor light fixture frame"
	desc = "A floor light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flamp-construct-stage1"
	anchored = 1
	layer = OBJ_LAYER
	plane = ABOVE_MOB_PLANE
	stage = 1
	fixture_type = /obj/machinery/light/flamp
	sheets_refunded = 2

/obj/machinery/light_construct/flamp/update_icon()
	switch(stage)
		if(1)
			icon_state = "flamp-construct-stage1"
		if(2)
			icon_state = "flamp-construct-stage2"
		if(3)
			icon_state = "flamp-empty"

/obj/machinery/light_construct/floor
	name = "small floor light frame"
	desc = "A floor light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "floor0"
	anchored = 1
	plane = ABOVE_MOB_PLANE
	stage = 1
	fixture_type = "floor"
	sheets_refunded = 1
