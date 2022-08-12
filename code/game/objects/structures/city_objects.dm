/obj/machinery/street/
	plane = -10
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


/obj/machinery/street/pedestrian
	name = "pedestrian signal"
	anchored = 1
	density = 1
	luminosity = 3
	icon = 'icons/obj/pedestrian.dmi'
	icon_state = "pede-ani"
