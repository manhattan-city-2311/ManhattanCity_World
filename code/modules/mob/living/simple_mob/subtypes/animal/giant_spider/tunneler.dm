// Tunnelers have a special ability that allows them to charge at an enemy by tunneling towards them.
// Any mobs inbetween the tunneler's path and the target will be stunned if the tunneler hits them.
// The target will suffer a stun as well, if the tunneler hits them at the end. A successful hit will stop the tunneler.
// If the target moves fast enough, the tunneler can miss, causing it to overshoot.
// If the tunneler hits a solid wall, the tunneler will suffer a stun.

/mob/living/simple_mob/animal/giant_spider/tunneler
	desc = "Sandy and brown, it makes you shudder to look at it. This one has glittering yellow eyes."
	icon_state = "tunneler"
	icon_living = "tunneler"
	icon_dead = "tunneler_dead"

	maxHealth = 120
	health = 120

	melee_damage_lower = 10
	melee_damage_upper = 10

	poison_chance = 15
	poison_per_bite = 3
	poison_type = "serotrotium_v"

//	ai_holder_type = /datum/ai_holder/simple_mob/melee/tunneler

	player_msg = "You <b>can perform a tunneling attack</b> by clicking on someone from a distance.<br>\
	There is a noticable travel delay as you tunnel towards the tile the target was at when you started the tunneling attack.<br>\
	Any entities inbetween you and the targeted tile will be stunned for a brief period of time.<br>\
	Whatever is on the targeted tile when you arrive will suffer a potent stun.<br>\
	If nothing is on the targeted tile, you will overshoot and keep going for a few more tiles.<br>\
	If you hit a wall or other solid structure during that time, you will suffer a lengthy stun and be vulnerable to more harm."

	// Tunneling is a special attack, similar to the hunter's Leap.
	special_attack_min_range = 2
	special_attack_max_range = 6
	special_attack_cooldown = 10 SECONDS

	var/tunnel_warning = 0.5 SECONDS	// How long the dig telegraphing is.
	var/tunnel_tile_speed = 2			// How long to wait between each tile. Higher numbers result in an easier to dodge tunnel attack.

/mob/living/simple_mob/animal/giant_spider/tunneler/frequent
	special_attack_cooldown = 5 SECONDS

/mob/living/simple_mob/animal/giant_spider/tunneler/fast
	tunnel_tile_speed = 1

/mob/living/simple_mob/animal/giant_spider/tunneler/should_special_attack(atom/A)
	return


/mob/living/simple_mob/animal/giant_spider/tunneler/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

	// Save where we're gonna go soon.
	var/turf/destination = get_turf(A)
	var/turf/starting_turf = get_turf(src)

	// Telegraph to give a small window to dodge if really close.
	do_windup_animation(A, tunnel_warning)
	sleep(tunnel_warning) // For the telegraphing.

	// Do the dig!
	visible_message(SPAN("danger","\The [src] tunnels towards \the [A]!"))
	submerge()

	if(handle_tunnel(destination) == FALSE)
		set_AI_busy(FALSE)
		emerge()
		return FALSE

	// Did we make it?
	if(!(src in destination))
		set_AI_busy(FALSE)
		emerge()
		return FALSE

	var/overshoot = TRUE

	// Test if something is at destination.
	for(var/mob/living/L in destination)
		if(L == src)
			continue

		visible_message(SPAN("danger","\The [src] erupts from underneath, and hits \the [L]!"))
		playsound(L, 'sound/weapons/heavysmash.ogg', 75, 1)
		L.Weaken(3)
		overshoot = FALSE

	if(!overshoot) // We hit the target, or something, at destination, so we're done.
		set_AI_busy(FALSE)
		emerge()
		return TRUE

	// Otherwise we need to keep going.
	to_chat(src, SPAN("warning", "You overshoot your target!"))
	playsound(src, 'sound/weapons/punchmiss.ogg', 75, 1)
	var/dir_to_go = get_dir(starting_turf, destination)
	for(var/i = 1 to rand(2, 4))
		destination = get_step(destination, dir_to_go)

	if(handle_tunnel(destination) == FALSE)
		set_AI_busy(FALSE)
		emerge()
		return FALSE

	set_AI_busy(FALSE)
	emerge()
	return FALSE



// Does the tunnel movement, stuns enemies, etc.
/mob/living/simple_mob/animal/giant_spider/tunneler/proc/handle_tunnel(turf/destination)
	var/turf/T = get_turf(src) // Hold our current tile.

	// Regular tunnel loop.
	for(var/i = 1 to get_dist(src, destination))
		if(stat)
			return FALSE // We died or got knocked out on the way.
		if(loc == destination)
			break // We somehow got there early.

		// Update T.
		T = get_step(src, get_dir(src, destination))

		// Stun anyone in our way.
		for(var/mob/living/L in T)
			playsound(L, 'sound/weapons/heavysmash.ogg', 75, 1)
			L.Weaken(2)

		// Get into the tile.
		forceMove(T)

		// Visuals and sound.
		dig_under_floor(get_turf(src))
		playsound(src, 'sound/effects/break_stone.ogg', 75, 1)
		sleep(tunnel_tile_speed)

// For visuals.
/mob/living/simple_mob/animal/giant_spider/tunneler/proc/submerge()
	alpha = 0
	dig_under_floor(get_turf(src))
	new /obj/effect/temporary_effect/tunneler_hole(get_turf(src))

// Ditto.
/mob/living/simple_mob/animal/giant_spider/tunneler/proc/emerge()
	alpha = 255
	dig_under_floor(get_turf(src))
	new /obj/effect/temporary_effect/tunneler_hole(get_turf(src))

/mob/living/simple_mob/animal/giant_spider/tunneler/proc/dig_under_floor(turf/T)
	new /obj/item/weapon/ore/glass(T) // This will be rather weird when on station but the alternative is too much work.

/obj/effect/temporary_effect/tunneler_hole
	name = "hole"
	desc = "A collapsing tunnel hole."
	icon_state = "tunnel_hole"
	time_to_die = 1 MINUTE

/datum/modifier/tunneler_vulnerable
	name = "Vulnerable"
	desc = "You are vulnerable to more harm than usual."
	on_created_text = "<span class='warning'>You feel vulnerable...</span>"
	on_expired_text = "<span class='notice'>You feel better.</span>"
	stacks = MODIFIER_STACK_EXTEND

	incoming_damage_percent = 2
	evasion = -100
