
var/list/floor_light_cache = list()

/obj/machinery/floor_light
	name = "floor light"
	icon = 'icons/obj/machines/floor_light.dmi'
	icon_state = "base"
	desc = "A backlit floor panel."
	layer = TURF_LAYER+0.001
	anchored = 0
	use_power = 2
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT
	matter = list(DEFAULT_WALL_MATERIAL = 2500, "glass" = 2750)

	var/on
	var/damaged
	var/default_light_range = 4
	var/default_light_power = 2
	var/default_light_colour = "#FFFFFF"

	unique_save_vars = list("on", "damaged")

/obj/machinery/floor_light/prebuilt
	anchored = 1
	on = 1

/obj/machinery/floor_light/prebuilt/New()
	update_brightness()

/obj/machinery/floor_light/prebuilt/red
	default_light_colour = COLOR_RED

/obj/machinery/floor_light/prebuilt/green
	default_light_colour = COLOR_GREEN

/obj/machinery/floor_light/prebuilt/yellow
	default_light_colour = COLOR_YELLOW

/obj/machinery/floor_light/prebuilt/orange
	default_light_colour = COLOR_ORANGE

/obj/machinery/floor_light/prebuilt/purple
	default_light_colour = COLOR_PURPLE

/obj/machinery/floor_light/prebuilt/pink
	default_light_colour = COLOR_PINK

/obj/machinery/floor_light/prebuilt/white
	default_light_colour = COLOR_WHITE


/obj/machinery/floor_light/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/weapon/screwdriver))
		anchored = !anchored
		visible_message("<span class='notice'>\The [user] has [anchored ? "attached" : "detached"] \the [src].</span>")
	else if(istype(W, /obj/item/weapon/weldingtool) && (damaged || (stat & BROKEN)))
		var/obj/item/weapon/weldingtool/WT = W
		if(!WT.remove_fuel(0, user))
			to_chat(user, "<span class='warning'>\The [src] must be on to complete this task.</span>")
			return
		playsound(src.loc, WT.usesound, 50, 1)
		if(!do_after(user, 20 * WT.toolspeed))
			return
		if(!src || !WT.isOn())
			return
		visible_message("<span class='notice'>\The [user] has repaired \the [src].</span>")
		stat &= ~BROKEN
		damaged = null
		update_brightness()
	else if(W.force && user.a_intent == "hurt")
		attack_hand(user)
	return

/obj/machinery/floor_light/attack_hand(var/mob/user)

	if(user.a_intent == I_HURT && !issmall(user))
		if(!isnull(damaged) && !(stat & BROKEN))
			visible_message("<span class='danger'>\The [user] smashes \the [src]!</span>")
			playsound(src, "shatter", 70, 1)
			stat |= BROKEN
		else
			visible_message("<span class='danger'>\The [user] attacks \the [src]!</span>")
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
			if(isnull(damaged)) damaged = 0
		update_brightness()
		return
	else

		if(!anchored)
			to_chat(user, "<span class='warning'>\The [src] must be screwed down first.</span>")
			return

		if(stat & BROKEN)
			to_chat(user, "<span class='warning'>\The [src] is too damaged to be functional.</span>")
			return

		if(stat & NOPOWER)
			to_chat(user, "<span class='warning'>\The [src] is unpowered.</span>")
			return

		on = !on
		if(on) use_power = 2
		visible_message("<span class='notice'>\The [user] turns \the [src] [on ? "on" : "off"].</span>")
		update_brightness()
		return

/obj/machinery/floor_light/process()
	var/need_update
	if((!anchored || broken()) && on)
		use_power = 0
		on = 0
		need_update = 1
	else if(use_power && !on)
		use_power = 0
		need_update = 1
	if(need_update)
		update_brightness()

/obj/machinery/floor_light/proc/update_brightness()
	if(on && use_power == 2)
		if(light_range != default_light_range || light_power != default_light_power || light_color != default_light_colour)
			set_light(default_light_range, default_light_power, default_light_colour)
	else
		use_power = 0
		if(light_range || light_power)
			set_light(0)

	active_power_usage = ((light_range + light_power) * 10)
	update_icon()

/obj/machinery/floor_light/update_icon()
	overlays.Cut()
	if(use_power && !broken())
		if(isnull(damaged))
			var/cache_key = "floorlight-[default_light_colour]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("on")
				I.color = default_light_colour
				I.layer = layer+0.001
				floor_light_cache[cache_key] = I
			overlays |= floor_light_cache[cache_key]
		else
			if(damaged == 0) //Needs init.
				damaged = rand(1,4)
			var/cache_key = "floorlight-broken[damaged]-[default_light_colour]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("flicker[damaged]")
				I.color = default_light_colour
				I.layer = layer+0.001
				floor_light_cache[cache_key] = I
			overlays |= floor_light_cache[cache_key]

/obj/machinery/floor_light/proc/broken()
	return (stat & (BROKEN|NOPOWER))

/obj/machinery/floor_light/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(50))
				qdel(src)
			else if(prob(20))
				stat |= BROKEN
			else
				if(isnull(damaged))
					damaged = 0
		if(3)
			if(prob(5))
				qdel(src)
			else if(isnull(damaged))
				damaged = 0
	return

/obj/machinery/floor_light/Destroy()
	var/area/A = get_area(src)
	if(A)
		on = 0
	. = ..()
