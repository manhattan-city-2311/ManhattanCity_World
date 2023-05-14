/area
	luminosity           = FALSE
	var/dynamic_lighting = TRUE

/area/New()
	. = ..()

	if(!dynamic_lighting)
		luminosity = TRUE
