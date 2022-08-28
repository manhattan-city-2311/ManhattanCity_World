/obj/machinery/street
	plane = LIGHTING_OBJS_PLANE
	layer = ABOVE_MOB_LAYER
	light_range = 4
	light_power = 2
	light_color = "#59FF9B"

/obj/machinery/street/traffic
	name = "traffic light"
	anchored = 1
	density = 0
	luminosity = 3
	plane = LIGHTING_OBJS_PLANE
	icon = 'icons/obj/traffic.dmi'
	icon_state = "off"
	var/broken
	var/shift = 0

/obj/machinery/street/traffic/initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

	broken = prob(5)

/obj/machinery/street/traffic/proc/update_light_color()
	if(icon_state != "off" && !light_range)
		set_light(initial(light_range))

	switch(icon_state)
		if("off")
			set_light(0)
		if("yellow")
			set_light(l_color = LIGHT_COLOR_NEONYELLOW)
		if("red")
			set_light(l_color = LIGHT_COLOR_NEONRED)
		if("green")
			set_light(l_color = LIGHT_COLOR_NEONGREEN)

/obj/machinery/street/traffic/process()
	. = ..()
	if(broken)
		icon_state = icon_state == "off" ? "yellow" : "off"
	else
		icon_state = list("red", "red", "yellow", "green", "green", "yellow")[(world.time / (5 SECONDS) + shift) % 6 + 1]

	update_light_color()

/obj/machinery/street/pedestrian
	name = "pedestrian signal"
	anchored = 1
	density = 1
	luminosity = 3
	icon = 'icons/obj/pedestrian.dmi'
	icon_state = "pede-ani"
