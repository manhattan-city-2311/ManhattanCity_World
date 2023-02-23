/obj/machinery/street
	plane = LIGHTING_OBJS_PLANE
	layer = ABOVE_MOB_LAYER
	density = 1
	light_range = 4
	light_power = 2
	light_color = "#59FF9B"

/obj/machinery/street/traffic
	name = "traffic light"
	anchored = 1
	luminosity = 3
	plane = LIGHTING_OBJS_PLANE
	icon = 'icons/obj/traffic.dmi'
	icon_state = "off"
	var/broken
	var/shift = 0
	var/global/list/states = list("red", "red", "yellow", "green", "green", "yellow")

/obj/machinery/street/traffic/initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

	broken = prob(5)

/obj/machinery/street/traffic/process()
	if(broken)
		icon_state = icon_state == "off" ? "yellow" : "off"
	else
		icon_state = states[(world.time / (5 SECONDS) + shift) % 6 + 1]

/obj/machinery/street/pedestrian
	name = "pedestrian signal"
	anchored = 1
	luminosity = 3
	icon = 'icons/obj/pedestrian.dmi'
	icon_state = "pede-ani"
