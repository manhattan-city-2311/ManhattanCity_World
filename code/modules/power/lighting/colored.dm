// Coloured lighting because fabulous
/obj/machinery/light/colored
	name = "light fixture"
	icon = 'icons/obj/coloredlights.dmi'
	base_state = "yellow"		// base description and icon_state
	icon_state = "yellow1"
	desc = "A lighting fixture."
	brightness_range = 8
	brightness_power = 6
	light_color = LIGHT_COLOR_HALOGEN

/obj/machinery/light/colored/update_icon()
	. = ..()
	switch(status)
		if(LIGHT_OK)
			icon_state = (on ? "[base_state]1" : "off")
		if(LIGHT_EMPTY)
			icon_state = "empty"
			on = 0
		if(LIGHT_BURNED)
			icon_state = "tube-burned"
			on = 0
		if(LIGHT_BROKEN)
			icon_state = "tube-broken"
			on = 0

/obj/machinery/light/colored/orange
	base_state = "orange"		// base description and icon_state
	icon_state = "orange1"
	light_color = LIGHT_COLOR_ORANGE

/obj/machinery/light/colored/purple
	base_state = "purple"		// base description and icon_state
	icon_state = "purple1"
	light_color = LIGHT_COLOR_PURPLE

/obj/machinery/light/colored/red
	base_state = "red"		// base description and icon_state
	icon_state = "red1"
	light_color = LIGHT_COLOR_RED

/obj/machinery/light/colored/pink
	base_state = "pink"		// base description and icon_state
	icon_state = "pink1"
	light_color = LIGHT_COLOR_PINK

/obj/machinery/light/colored/blue
	base_state = "blue"		// base description and icon_state
	icon_state = "blue1"
	light_color = LIGHT_COLOR_BLUE

/obj/machinery/light/colored/green
	base_state = "green"		// base description and icon_state
	icon_state = "green1"
	light_color = LIGHT_COLOR_GREEN
