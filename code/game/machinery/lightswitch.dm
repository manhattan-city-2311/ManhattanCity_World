// the light switch
// can have multiple per area
// can also operate on non-loc area through "otherarea" var
/obj/machinery/light_switch
	name = "light switch"
	desc = "It turns lights on and off. What are you, simple?"
	icon = 'icons/obj/power.dmi'
	icon_state = "light1"
	plane = WALL_OBJ_PLANE
	anchored = 1.0
	use_power = 1
	idle_power_usage = 10
	power_channel = LIGHT
	var/on = 1
	var/area/area = null
	var/otherarea = null
	var/image/overlay
	var/override_automatic_dir_pixel_offset = FALSE

/obj/machinery/light_switch/New()
	..()
	spawn(5)
		area = get_area(src)

		if(otherarea)
			area = locate(text2path("/area/[otherarea]"))

		if(!name)
			name = "light switch ([area.name])"

		on = area.lightswitch
		updateicon()
	if(!override_automatic_dir_pixel_offset)
		var/turf/here = get_turf(src)
		var/placing = 0
		for(var/checkdir in GLOB.cardinal)
			var/turf/T = get_step(here, checkdir)
			if(T.density)
				placing = checkdir
				break
			for(var/thing in T)
				var/atom/A = thing
				if(A.simulated && !A.CanPass(src, T))
					placing = checkdir
					break
		set_dir(turn(placing, 180))
		switch(placing)
			if(NORTH)
				pixel_x = 0
				pixel_y = 26
			if(SOUTH)
				pixel_x = 0
				pixel_y = -20
			if(EAST)
				pixel_x = 21
				pixel_y = 0
			if(WEST)
				pixel_x = -21
				pixel_y = 0

/obj/machinery/light_switch/proc/updateicon()
	cut_overlays()
	if(stat & NOPOWER)
		icon_state = "light-p"
		set_light(0)
	else
		icon_state = "light[on]"
		add_overlay(emissive_appearance(icon, "light-emission"))
		set_light(2, 0.1, on ? "#82FF4C" : "#F86060")

/obj/machinery/light_switch/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "A light switch. It is [on? "on" : "off"].")

/obj/machinery/light_switch/attack_hand(mob/user)

	on = !on

	area.lightswitch = on
	area.updateicon()

	for(var/obj/machinery/light_switch/L in area)
		L.on = on
		L.updateicon()

	area.power_change()

/obj/machinery/light_switch/power_change()

	if(!otherarea)
		if(powered(LIGHT))
			stat &= ~NOPOWER
		else
			stat |= NOPOWER

		updateicon()

/obj/machinery/light_switch/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	power_change()
	..(severity)
