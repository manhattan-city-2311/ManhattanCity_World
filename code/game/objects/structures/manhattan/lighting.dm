/obj/structure/neon_spline
	name = "neon spline"
	icon = 'icons/turf/flooring/decals.dmi'
	icon_state = "spline_fancy"
	plane = NEON_DECALS_PLANE
	light_power = 8
	light_range = 1.5
	anchored = TRUE

#define NEON_SPLINE(id, col) /obj/structure/neon_spline/##id {color = col ; light_color = col }

NEON_SPLINE(green 	 , LIGHT_COLOR_NEONGREEN)
NEON_SPLINE(blue 	 , LIGHT_COLOR_NEONBLUE)
NEON_SPLINE(pink 	 , LIGHT_COLOR_HOTPINK)
NEON_SPLINE(red  	 , LIGHT_COLOR_NEONRED)
NEON_SPLINE(purple	 , LIGHT_COLOR_PURPLE)
NEON_SPLINE(white	 , "#f0ffff")
NEON_SPLINE(orange	 , LIGHT_COLOR_NEONORANGE)
NEON_SPLINE(yellow	 , LIGHT_COLOR_NEONYELLOW)
NEON_SPLINE(lightblue, LIGHT_COLOR_NEONLIGHTBLUE)

#undef NEON_SPLINE
