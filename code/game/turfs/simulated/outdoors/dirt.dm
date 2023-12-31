/turf/simulated/floor/outdoors/dirt
	name = "dirt"
	desc = "Quite dirty!"
	icon_state = "dirt-dark"
	edge_blending_priority = 2
	turf_layers = list(/turf/simulated/floor/outdoors/rocks)
	initial_flooring = /decl/flooring/dirt
	can_build_onto = 1
	var/grass_chance = 20
	var/tree_chance = 2
	var/list/grass_types = list(
		/obj/structure/flora/ausbushes/sparsegrass,
		/obj/structure/flora/ausbushes/fullgrass
		)
	var/dug = FALSE				//FALSE = has not yet been dug, TRUE = has already been dug
	var/pit_sand = 1
	var/storedindex = 0			//amount of stored items
	var/mob/living/gravebody	//is there a body in the pit?
	var/obj/structure/closet/coffin/gravecoffin //or maybe a coffin?
	var/pitcontents = list()
	var/obj/dugpit/mypit
	var/unburylevel = 0


/turf/simulated/floor/outdoors/dirt/initialize()
	if(prob(50))
		icon_state = "[initial(icon_state)]2"
		//edge_blending_priority++

	if(grass_chance && prob(grass_chance))
		var/has_grass = FALSE

		if (locate(/obj/structure/flora) in contents)
			has_grass = TRUE

		if(!has_grass)
			var/grass_type = pick(grass_types)
			new grass_type(src)
	. = ..()

/turf/simulated/floor/outdoors/dirt/indoors

/turf/simulated/floor/outdoors/dirt/manhattan
	icon = 'icons/turf/auto_strata_grass.dmi'
	icon_state = "grass_0_mud"
	initial_flooring = /decl/flooring/dirt/manhattan

/turf/simulated/floor/outdoors/dirt/manhattan/initialize()

	if(grass_chance && prob(grass_chance))
		var/has_grass = FALSE

		if (locate(/obj/structure/flora) in contents)
			has_grass = TRUE

		if(!has_grass)
			var/grass_type = pick(grass_types)
			new grass_type(src)
	. = ..()

/turf/simulated/floor/outdoors/dirt/manhattan/alt
	icon = 'icons/turf/auto_strata_grass.dmi'
	name = "mud"
	icon_state = "grass_0_mud_alt"
	initial_flooring = /decl/flooring/dirt/manhattan/mud