/obj/structure
	icon = 'icons/obj/structures.dmi'
	w_class = ITEMSIZE_NO_CONTAINER

	var/climbable
	var/climb_delay = 3.5 SECONDS
	var/breakable
	var/parts
	var/list/climbers = list()
	var/block_turf_edges = FALSE // If true, turf edge icons will not be made on the turf this occupies.

	var/list/connections = list("0", "0", "0", "0")
	var/list/other_connections = list("0", "0", "0", "0")
	var/list/blend_objects = newlist() // Objects which to blend with
	var/list/noblend_objects = newlist() //Objects to avoid blending with (such as children of listed blend objects.
	blocks_emissive = EMISSIVE_BLOCK_GENERIC

/obj/structure/on_persistence_load()
	update_connections(1)
	update_icon()

/obj/structure/proc/dismantle()
	if(parts)
		new parts(loc)
	qdel(src)
	return

/obj/structure/proc/update_connections(propagate = 0)
	var/list/dirs = list()
	var/list/other_dirs = list()

	if(!anchored)
		return

	for(var/obj/structure/S in orange(src, 1))
		if(istype(S, src))
			if(S.anchored)
				if(propagate)
					S.update_connections()
					S.update_icon()
				dirs += get_dir(src, S)

	for(var/direction in cardinal)
		var/turf/T = get_step(src, direction)
		var/success = 0
		var/turf/simulated/wall/W = T
		if(istype(W))
			if(propagate)
				W.update_connections()
				W.update_icon()
			dirs += get_dir(src, T)
			other_dirs += get_dir(src, T)
		else
			for(var/obj/O in T)
				for(var/b_type in blend_objects)
					if(istype(O, b_type))
						success = 1
						for(var/obj/structure/S in T)
							if(istype(S, src))
								success = 0
						for(var/nb_type in noblend_objects)
							if(istype(O, nb_type))
								success = 0

					if(success)
						break
				if(success)
					break

			if(success)
				dirs += get_dir(src, T)
				other_dirs += get_dir(src, T)

	connections = dirs_to_corner_states(dirs)
	other_connections = dirs_to_corner_states(other_dirs)

/obj/structure/attack_hand(mob/user)
	if(breakable)
		if(HULK in user.mutations)
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			attack_generic(user,1,"smashes")
		else if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				attack_generic(user,1,"slices")

	if(climbers.len && !(user in climbers))
		user.visible_message("<span class='warning'>[user.name] shakes \the [src].</span>", \
					"<span class='notice'>You shake \the [src].</span>")
		structure_shaken()

	return ..()

/obj/structure/attack_tk()
	return

/obj/structure/ex_act(severity)
	switch(severity)
		if(1.0)
			dismantle()
			return
		if(2.0)
			if(prob(50))
				dismantle()
				return
		if(3.0)
			return

/obj/structure/New()
	..()
	if(climbable)
		verbs += /obj/structure/proc/climb_on

/obj/structure/proc/climb_on()

	set name = "Climb structure"
	set desc = "Climbs onto a structure."
	set category = "Object"
	set src in oview(1)

	do_climb(usr)

/obj/structure/MouseDrop_T(mob/target, mob/user)

	var/mob/living/H = user
	if(istype(H) && can_climb(H) && target == user)
		do_climb(target)
	else
		return ..()

/obj/structure/proc/can_climb(var/mob/living/user, post_climb_check=0) // this could probably include everything under the sun that would be a problem, including turf checks and other stuff. not sure why it's all spread out in different files or window checks.
	if (!climbable || !can_touch(user) || (!post_climb_check && (user in climbers)))
		return 0

	if (!user.Adjacent(src))
		to_chat(user, "<span class='danger'>You can't climb there, the way is blocked.</span>")
		return 0

	var/obj/occupied = turf_is_crowded()
	if(occupied)
		to_chat(user, "<span class='danger'>There's \a [occupied] in the way.</span>")
		return 0
	return 1

/obj/structure/proc/turf_is_crowded()
	var/turf/T = get_turf(src)
	if(!T || !istype(T) || istype(T, /turf/simulated/wall))
		return 0
	for(var/obj/O in T.contents)
		if(istype(O,/obj/structure))
			var/obj/structure/S = O
			if(S.climbable) continue
		if(O && O.density && !(O.flags & ON_BORDER)) //ON_BORDER structures are handled by the Adjacent() check.
			return O
	return 0

/obj/structure/proc/do_climb(var/mob/living/user)
	if (!can_climb(user))
		return

	usr.visible_message("<span class='warning'>[user] starts climbing onto \the [src]!</span>")
	climbers |= user

	if(!do_after(user,(issmall(user) ? climb_delay * 0.6 : climb_delay)))
		climbers -= user
		return

	if (!can_climb(user, post_climb_check=1))
		climbers -= user
		return

	usr.forceMove(get_turf(src))

	if (get_turf(user) == get_turf(src))
		usr.visible_message("<span class='warning'>[user] climbs onto \the [src]!</span>")
	climbers -= user

/obj/structure/proc/structure_shaken()
	for(var/mob/living/M in climbers)
		M.Weaken(1)
		to_chat(M, "<span class='danger'>You topple as you are shaken off \the [src]!</span>")
		climbers.Cut(1,2)

	for(var/mob/living/M in get_turf(src))
		if(M.lying) return //No spamming this on people.

		M.Weaken(3)
		to_chat(M, "<span class='danger'>You topple as \the [src] moves under you!</span>")

		if(prob(25))

			var/damage = rand(15,30)
			var/mob/living/carbon/human/H = M
			if(!istype(H))
				to_chat(H, "<span class='danger'>You land heavily!</span>")
				M.adjustBruteLoss(damage)
				return

			var/obj/item/organ/external/affecting

			switch(pick(list("ankle","wrist","head","knee","elbow")))
				if("ankle")
					affecting = H.get_organ(pick(BP_L_FOOT, BP_R_FOOT))
				if("knee")
					affecting = H.get_organ(pick(BP_L_LEG, BP_R_LEG))
				if("wrist")
					affecting = H.get_organ(pick(BP_L_HAND, BP_R_HAND))
				if("elbow")
					affecting = H.get_organ(pick(BP_L_ARM, BP_R_ARM))
				if("head")
					affecting = H.get_organ(BP_HEAD)

			if(affecting)
				to_chat(M, "<span class='danger'>You land heavily on your [affecting.name]!</span>")
				affecting.take_damage(damage, 0)
			else
				to_chat(H, "<span class='danger'>You land heavily!</span>")
				H.adjustBruteLoss(damage)

			H.UpdateDamageIcon()
			H.updatehealth()
	return

/obj/structure/proc/can_touch(var/mob/user)
	if (!user)
		return 0
	if(!Adjacent(user))
		return 0
	if (user.restrained() || user.buckled)
		to_chat(user, "<span class='notice'>You need your hands and legs free for this.</span>")
		return 0
	if (user.stat || user.paralysis || user.sleeping || user.lying || user.weakened)
		return 0
	if (isAI(user))
		to_chat(user, "<span class='notice'>You need hands for this.</span>")
		return 0
	return 1

/obj/structure/attack_generic(var/mob/user, var/damage, var/attack_verb)
	if(!breakable || damage < STRUCTURE_MIN_DAMAGE_THRESHOLD)
		return 0
	visible_message("<span class='danger'>[user] [attack_verb] the [src] apart!</span>")
	user.do_attack_animation(src)
	spawn(1) dismantle()
	return 1
