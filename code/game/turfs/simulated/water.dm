/turf/simulated/floor/water
	name = "shallow water"
	desc = "A body of water.  It seems shallow enough to walk through, if needed."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "seashallow" // So it shows up in the map editor as water.
	var/water_state = "water_shallow"
	var/under_state = "rock"
	edge_blending_priority = -1
	movement_cost = 4
	var/depth = 1 // Higher numbers indicates deeper water.
	initial_flooring = /decl/flooring/water

	layer = WATER_FLOOR_LAYER

	var/reagent_type			//reagents other than water.
	var/reagent_chance

/turf/simulated/floor/water/initialize()
	. = ..()
	update_icon()

/turf/simulated/floor/water/update_icon()
	..() // To get the edges.

	icon_state = under_state // This isn't set at compile time in order for it to show as water in the map editor.
	var/image/water_sprite = image(icon = 'icons/turf/outdoors.dmi', icon_state = water_state, layer = WATER_LAYER)
	add_overlay(water_sprite)

	update_icon_edge()

/turf/simulated/floor/water/get_edge_icon_state()
	return "water_shallow"

/turf/simulated/floor/water/Entered(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living/carbon/human))
		var/mob/living/carbon/human/L = AM
		L.update_water()
		if(L.check_submerged() <= 0)
			return
		if(!istype(oldloc, /turf/simulated/floor/water))
			to_chat(L, "<span class='warning'>You get drenched in water from entering \the [src]!</span>")
	AM.water_act(5)

	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
		if(reagent_type && reagent_chance && H.can_inject(src, null, target_zone))
			if(prob(reagent_chance))
				H.reagents.add_reagent(reagent_type, reagent_chance)
	..()

/turf/simulated/floor/water/Exited(atom/movable/AM, atom/newloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_water()
		if(L.check_submerged() <= 0)
			return
		if(!istype(newloc, /turf/simulated/floor/water))
			to_chat(L, "<span class='warning'>You climb out of \the [src].</span>")
	..()

/turf/simulated/floor/water/deep
	name = "deep water"
	desc = "A body of water.  It seems quite deep."
	icon_state = "seadeep" // So it shows up in the map editor as water.
	under_state = "abyss"
	initial_flooring = /decl/flooring/water/deep
	edge_blending_priority = -2
	movement_cost = 8
	depth = 2

/turf/simulated/floor/water/pool
	name = "pool"
	desc = "Don't worry, it's not closed."
	under_state = "pool"

/turf/simulated/floor/water/pool
	name = "pool"
	desc = "Don't worry, it's not closed."
	under_state = "pool"

/turf/simulated/floor/water/deep/pool
	name = "deep pool"
	desc = "Don't worry, it's not closed."

/turf/simulated/floor/water/sewer
	name = "sewage water"
	color = "#049660"
	reagent_type = "toiletwater"
	reagent_chance = 5

/mob/living/proc/can_breathe_water()
	return FALSE

/mob/living/carbon/human/can_breathe_water()
	if(species)
		return species.can_breathe_water()
	return ..()

/mob/living/proc/check_submerged()
	if(buckled)
		return 0
	if(hovering)
		return 0
	if(locate(/obj/structure/catwalk) in get_turf(src))
		return 0
	var/turf/simulated/floor/water/T = loc
	if(istype(T))
		return T.depth
	return 0

// Use this to have things react to having water applied to them.
/atom/movable/proc/water_act(amount)
	return

/mob/living/water_act(amount)
	adjust_fire_stacks(-amount * 5)
	for(var/atom/movable/AM in contents)
		AM.water_act(amount)
	remove_modifiers_of_type(/datum/modifier/fire)
	inflict_water_damage(20 * amount) // Only things vulnerable to water will actually be harmed (slimes/prommies).

var/list/shoreline_icon_cache = list()

/turf/simulated/floor/water/shoreline
	name = "shoreline"
	desc = "The waves look calm and inviting."
	icon_state = "shoreline"
	water_state = "rock" // Water gets generated as an overlay in update_icon()
	depth = 0

/turf/simulated/floor/water/shoreline/corner
	icon_state = "shorelinecorner"

// Water sprites are really annoying, so let BYOND sort it out.
/turf/simulated/floor/water/shoreline/update_icon()
	underlays.Cut()
	cut_overlays()
	..() // Get the underlay first.
	var/cache_string = "[initial(icon_state)]_[water_state]_[dir]"
	if(cache_string in shoreline_icon_cache) // Check to see if an icon already exists.
		add_overlay(shoreline_icon_cache[cache_string])
	else // If not, make one, but only once.
		var/icon/shoreline_water = icon(src.icon, "shoreline_water", src.dir)
		var/icon/shoreline_subtract = icon(src.icon, "[initial(icon_state)]_subtract", src.dir)
		shoreline_water.Blend(shoreline_subtract,ICON_SUBTRACT)
		var/image/final = image(shoreline_water)
		final.layer = WATER_LAYER

		shoreline_icon_cache[cache_string] = final
		add_overlay(shoreline_icon_cache[cache_string])

/turf/simulated/floor/water/is_safe_to_enter(mob/living/L)
	if(L.get_water_protection() < 1)
		return FALSE
	return ..()
