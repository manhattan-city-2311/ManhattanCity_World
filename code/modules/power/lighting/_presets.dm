/obj/machinery/light/flicker
	auto_flicker = TRUE

/obj/machinery/light/overhead_blue
	icon_state = "inv1"
	base_state = "inv"
	emissive_state = null
	brightness_range = 12
	brightness_power = 2
	brightness_color = LIGHT_COLOR_DARK_BLUE

/obj/machinery/light/floor
	icon_state = "floor1"
	base_state = "floor"
	emissive_state = "floor-emissive"
	light_type = /obj/item/weapon/light/bulb
	layer = TURF_LAYER+0.002
	plane = UNDER_MOB_PLANE
	brightness_range = 6
	brightness_power = 11
	brightness_color = LIGHT_COLOR_INCANDESCENT_TUBE
	on_wall = 0

/obj/machinery/light/invis
	icon_state = "inv1"
	base_state = "inv"
	emissive_state = null
	brightness_range = 8

// the smaller bulb light fixture

/obj/machinery/light/small
	icon_state = "bulb1"
	base_state = "bulb"
	emissive_state = "bulb-emissive"
	brightness_range = 4
	brightness_power = 10
	brightness_color = LIGHT_COLOR_INCANDESCENT_BULB
	desc = "A small lighting fixture."
	light_type = /obj/item/weapon/light/bulb

/obj/machinery/light/small/flicker
	auto_flicker = TRUE

/obj/machinery/light/flamp
	icon_state = "flamp1"
	base_state = "flamp"
	emissive_state = null
	construct_type = /obj/machinery/light_construct/flamp
	brightness_range = 8
	brightness_power = 4
	layer = OBJ_LAYER
	brightness_color = LIGHT_COLOR_INCANDESCENT_TUBE
	desc = "A floor lamp."
	light_type = /obj/item/weapon/light/bulb
	var/lamp_shade = 1
	anchored = FALSE

/obj/machinery/light/flamp/vars_to_save()
	return ..() + list("lamp_shade")

/obj/machinery/light/flamp/built/New()
	status = LIGHT_EMPTY
	lamp_shade = 0
	update(0)
	..()
/obj/machinery/light/flamp/update_icon()
	if(lamp_shade)
		base_state = "flampshade"
		switch(status)		// set icon_states
			if(LIGHT_OK)
				icon_state = "[base_state][on]"
			if(LIGHT_EMPTY)
				on = 0
				icon_state = "[base_state][on]"
			if(LIGHT_BURNED)
				on = 0
				icon_state = "[base_state][on]"
			if(LIGHT_BROKEN)
				on = 0
				icon_state = "[base_state][on]"
	else
		base_state = "flamp"
		. = ..()
/obj/machinery/light/flamp/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/wrench))
		anchored = !anchored
		playsound(src, W.usesound, 50, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")

	if(!lamp_shade)
		if(istype(W, /obj/item/weapon/lampshade))
			lamp_shade = 1
			qdel(W)
			update_icon()
			return

	else
		if(istype(W, /obj/item/weapon/screwdriver))
			playsound(src, W.usesound, 75, 1)
			user.visible_message("[user.name] removes [src]'s lamp shade.", \
				"You remove [src]'s lamp shade.", "You hear a noise.")
			lamp_shade = 0
			new /obj/item/weapon/lampshade(src.loc)
			update_icon()
			return
	. = ..()

/obj/machinery/light/flamp/has_power()
	var/area/A = get_area(src)
	if(lamp_shade)
		return A
	else
		return A && A.lightswitch

/obj/machinery/light/flamp/attack_ai(mob/user)
	attack_hand()

/obj/machinery/light/flamp/attack_hand(mob/user)
	if(lamp_shade)
		if(status == LIGHT_EMPTY)
			to_chat(user, "There is no [get_fitting_name()] in this light.")
			return

		if(on)
			on = 0
			update()
		else
			on = has_power()
			update()
	else
		. = ..()


/obj/machinery/light/flamp/shadeless // for mapping
	lamp_shade = 0

/obj/machinery/light/normal_lamp
	desc = "A floor lamp."
	icon = 'icons/obj/big_floodlight.dmi'
	icon_state = "flamp1"
	base_state = "flamp"
	emissive_state = null
	construct_type = /obj/machinery/light_construct/flamp
	light_range = 8
	light_power = 6
	brightness_range = 8
	brightness_power = 6
	layer = ABOVE_MOB_LAYER
	brightness_color = LIGHT_COLOR_HALOGEN
	light_type = /obj/item/weapon/light/bulb/street
	anchored = 1
	density = 1

/obj/item/weapon/light/bulb/street
	color = LIGHT_COLOR_INCANDESCENT_BULB
	brightness_color = LIGHT_COLOR_INCANDESCENT_BULB
	light_color = LIGHT_COLOR_INCANDESCENT_BULB
	brightness_range = 8
	brightness_power = 6

/obj/machinery/light/small/emergency
	light_type = /obj/item/weapon/light/bulb/red

/obj/machinery/light/spot
	name = "spotlight"
	light_type = /obj/item/weapon/light/tube/large


