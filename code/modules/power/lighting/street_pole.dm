/obj/machinery/light/street
	icon = 'icons/obj/street.dmi'
	icon_state = "streetlamp1"
	base_state = "streetlamp"
	desc = "A street lighting fixture."
	brightness_color = LIGHT_COLOR_CYAN
	brightness_range = 7
	brightness_power = 5
	plane = ABOVE_MOB_PLANE
	density = 1
	light_type = /obj/item/weapon/light/bulb
	on_wall = 0

/obj/machinery/light/normal_lamp2
	name = "street light"
	desc = "A street pole with big light tube up there. Be vigilant of an ambush."
	icon = 'icons/obj/manhattan/streetpoles.dmi'
	icon_state = "streetlight1"
	base_state = "streetlight"
	construct_type = /obj/machinery/light_construct/flamp
	light_range = 8
	light_power = 6
	brightness_range = 6
	brightness_power = 6
	pixel_x = -32
	bound_width = 13
	bound_height = 10
	bound_x = 10
	bound_y = 7
	blocks_emissive = EMISSIVE_BLOCK_UNIQUE
	layer = ABOVE_MOB_LAYER
	light_color = LIGHT_COLOR_BLUE
	light_type = /obj/item/weapon/light/bulb/street2
	anchored = 1
	density = 1
	offset_of_light_forward = 3
	offset_of_light_sides = 0

/obj/machinery/light/normal_lamp2/update_icon()
	return FALSE

/obj/item/weapon/light/bulb/street2
	color = LIGHT_COLOR_NEONBLUE
	brightness_color = LIGHT_COLOR_NEONBLUE
	light_color = LIGHT_COLOR_NEONBLUE
	brightness_range = 8
	brightness_power = 6.5
