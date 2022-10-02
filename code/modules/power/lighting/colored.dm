// Coloured lighting because fabulous
/obj/machinery/light/colored
	name = "light fixture"
	icon = 'icons/obj/coloredlights.dmi'
	base_state = "yellow"		// base description and icon_state
	icon_state = "yellow1"
	emissive_state = "emissive"
	desc = "A lighting fixture."
	brightness_range = 8
	brightness_power = 6
	light_color = LIGHT_COLOR_HALOGEN

/*/obj/machinery/light/colored/update_icon()
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
			on = 0*/

/obj/machinery/light/colored/update_icon()
	if(on_wall)
		pixel_y = 0
		pixel_x = 0
		var/turf/T = get_step(get_turf(src), dir)
		if(istype(T, /turf/simulated/wall))
			if(dir == NORTH) // 1
				pixel_y = 15
			else if(dir == EAST) // 4
				pixel_x = 6
				pixel_y = 6
			else if(dir == WEST) // 8
				pixel_x = -6
				pixel_y = 6
			//
/*			var/directionToCheck = dir
			if(directionToCheck % 4 == 0)
				var/turf/Tbottom
				var/turf/Tupper
				if(directionToCheck == EAST)
					Tbottom = get_step(get_turf(src), SOUTHEAST)
					Tupper = get_step(get_turf(src), NORTHEAST)
				else if(directionToCheck == WEST)
					Tbottom = get_step(get_turf(src), SOUTHWEST)
					Tupper = get_step(get_turf(src), NORTHWEST)
				if(icondebugenabled)
					to_world("B[!Tbottom.contains_dense_objects()] U[Tupper.contains_dense_objects()]")
				if(!istype(Tbottom, /turf/simulated/wall) && istype(Tupper, /turf/simulated/wall)) // if(!Tbottom.contains_dense_objects() && Tupper.contains_dense_objects())
					pixel_y = 15
					//  |  |
					// >\__/<
					// pixel_y = 18
					//
			else
				var/turf/Tleft
				var/turf/Tright
				if(directionToCheck == NORTH)
					Tleft = get_step(get_turf(src), NORTHWEST)
					Tright = get_step(get_turf(src), NORTHEAST)
				else if(directionToCheck == SOUTH)
					Tleft = get_step(get_turf(src), SOUTHWEST)
					Tright = get_step(get_turf(src), SOUTHEAST)
				if(icondebugenabled)
					to_world("L[!Tleft.contains_dense_objects()] R[Tright.contains_dense_objects()]")
					to_world("L[Tleft.contains_dense_objects()] R[!Tright.contains_dense_objects()]")
				if(!istype(Tleft, /turf/simulated/wall) && istype(Tright, /turf/simulated/wall)) // if(!Tleft.contains_dense_objects() && Tright.contains_dense_objects())
					pixel_x = 6
//					pixel_y = 6
				else if(istype(Tleft, /turf/simulated/wall) && !istype(Tright, /turf/simulated/wall)) // if(Tleft.contains_dense_objects() && !Tright.contains_dense_objects())
					pixel_x = -6
//					pixel_y = 6
					//  |  |
					//  \__/
					//   ^^
					// pixel_x = +/- 10
*/

	cut_overlays()
	switch(status)
		if(LIGHT_OK)
			icon_state = (on ? "[base_state]1" : "off")
			if(on && emissive_state)
				add_overlay(emissive_appearance(icon, emissive_state))
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

/obj/machinery/light/colored/white
	base_state = "white"		// base description and icon_state
	icon_state = "white1"
	light_color = "#f0ffff"
