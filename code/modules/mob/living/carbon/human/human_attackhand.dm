/mob/living/carbon/human/proc/get_unarmed_attack(var/mob/living/carbon/human/target, var/hit_zone)
	for(var/datum/unarmed_attack/u_attack in species.unarmed_attacks)
		if(u_attack.is_usable(src, target, hit_zone))
			if(pulling_punches)
				var/datum/unarmed_attack/soft_variant = u_attack.get_sparring_variant()
				if(soft_variant)
					return soft_variant
			return u_attack
	return null

/mob/living/carbon/human/attack_hand(mob/living/M as mob)
	var/datum/gender/TT = gender_datums[M.get_visible_gender()]
	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if(H.hand)
			temp = H.organs_by_name["l_hand"]
		if(!temp || !temp.is_usable())
			to_chat(H, "<font color='red'>You can't use your hand.</font>")
			return
	M.break_cloak()

	..()

	// Should this all be in Touch()?
	if(istype(H))
		if(get_accuracy_penalty(H) && H != src)	//Should only trigger if they're not aiming well
			var/hit_zone = get_zone_with_miss_chance(H.zone_sel.selecting, src, get_accuracy_penalty(H))
			if(!hit_zone)
				H.do_attack_animation(src)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message("<font color='red'><B>[H] reaches for [src], but misses!</B></font>")
				return 0

		if(H != src && check_shields(0, null, H, H.zone_sel.selecting, H.name))
			H.do_attack_animation(src)
			return 0

		if(istype(H.gloves, /obj/item/clothing/gloves/boxing/hologlove))
			H.do_attack_animation(src)
			var/damage = rand(0, 9)
			if(!damage)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message("<font color='red'><B>[H] has attempted to punch [src]!</B></font>")
				return 0
			var/obj/item/organ/external/affecting = get_organ(ran_zone(H.zone_sel.selecting))
			var/armor_block = run_armor_check(affecting, "melee")
			var/armor_soak = get_armor_soak(affecting, "melee")

			if(HULK in H.mutations)
				damage += 5

			playsound(loc, "punch", 25, 1, -1)

			visible_message("<font color='red'><B>[H] has punched [src]!</B></font>")

			if(armor_soak >= damage)
				return

			apply_damage(damage, HALLOSS, affecting, armor_block, armor_soak)
			if(damage >= 9)
				visible_message("<font color='red'><B>[H] has weakened [src]!</B></font>")
				apply_effect(4, WEAKEN, armor_block)

			return

	if(istype(M,/mob/living/carbon))
		var/mob/living/carbon/C = M
		C.spread_disease_to(src, "Contact")

	switch(M.a_intent)
		if(I_HELP)
			if(istype(H) && (is_asystole() || is_vfib()))
				if (!cpr_time)
					return 0

				cpr_time = 0
				spawn(50)
					cpr_time = 1

				if(!H.check_has_mouth())
					to_chat(H, "<span class='warning'>You don't have a mouth, you cannot do mouth-to-mouth resustication!</span>")
					return
				if(!check_has_mouth())
					to_chat(H, "<span class='warning'>They don't have a mouth, you cannot do mouth-to-mouth resustication!</span>")
					return
				if((H.head && (H.head.body_parts_covered & FACE)) || (H.wear_mask && (H.wear_mask.body_parts_covered & FACE)))
					to_chat(H, "<span class='warning'>You need to remove your mouth covering for mouth-to-mouth resustication!</span>")
					return 0
				if((head && (head.body_parts_covered & FACE)) || (wear_mask && (wear_mask.body_parts_covered & FACE)))
					to_chat(H, "<span class='warning'>You need to remove \the [src]'s mouth covering for mouth-to-mouth resustication!</span>")
					return 0
				if (!H.internal_organs_by_name[O_LUNGS])
					to_chat(H, "<span class='danger'>You need lungs for mouth-to-mouth resustication!</span>")
					return

				var/acls_quality = M.get_skill(SKILL_ACLS)
				var/is_precordial_blow = acls_quality >= SKILL_AMATEUR && is_vfib()

				var/punches = is_precordial_blow ? rand(2, 5 + acls_quality) : rand(5, 9 + acls_quality)

				H.visible_message(SPAN_NOTICE("\The [H] is performing CPR on \the [src]."))
				var/obj/item/organ/internal/heart/heart = internal_organs_by_name[O_HEART]

				for(var/i in 1 to punches)
					if(!do_after(H, rand(max(0, 4 - acls_quality), 8), src))
						return

					if("CPR" in heart.pulse_modificators)
						heart.pulse_modificators["CPR"] += rand(15, 30) * (1 + acls_quality)
					else
						heart.pulse_modificators["CPR"] = rand(15, 30) * (1 + acls_quality)

					if(prob(1))
						var/obj/item/organ/external/chest = get_organ(BP_TORSO)
						chest?.fracture()

					var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
					if(!L)
						continue
					for(var/i2 in 1 to acls_quality)
						var/datum/gas_mixture/breath = H.get_breath_from_environment()
						var/fail = L.handle_breath(breath, 1)
						if(!fail && prob(20))
							to_chat(src, SPAN_NOTICE("You feel a breath of fresh air enter your lungs. It feels so good."))

				if(is_precordial_blow && is_vfib())
					H.visible_message(SPAN_NOTICE("\The [H] is performing precordial blow on \the [src]."))
					if(!do_after(H, 20, src))
						return
					if(!is_vfib())
						return
					H.visible_message(SPAN_NOTICE("\The [H] is performed precordial blow on \the [src]!"))

					if(prob(5))
						var/obj/item/organ/external/chest = get_organ(BP_TORSO)
						chest?.fracture()

		if(I_GRAB)
			if(M == src || anchored)
				return 0
			for(var/obj/item/weapon/grab/G in src.grabbed_by)
				if(G.assailant == M)
					to_chat(M, "<span class='notice'>You already grabbed [src].</span>")
					return
			if(w_uniform)
				w_uniform.add_fingerprint(M)

			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src)
			if(buckled)
				to_chat(M, "<span class='notice'>You cannot grab [src], [TT.he] is buckled in!</span>")
			if(!G)	//the grab will delete itself in New if affecting is anchored
				return
			M.put_in_active_hand(G)
			G.synch()
			LAssailant = M

			H.do_attack_animation(src)
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message("<span class='warning'>[M] has grabbed [src][(M.zone_sel.selecting == "l_hand" || M.zone_sel.selecting == "r_hand")? " by their hands!":" passively!"]</span>")
			return 1

		if(I_HURT)


			if(M.zone_sel.selecting == "mouth" && wear_mask && istype(wear_mask, /obj/item/weapon/grenade))
				var/obj/item/weapon/grenade/G = wear_mask
				if(!G.active)
					visible_message("<span class='danger'>\The [M] pulls the pin from \the [src]'s [G.name]!</span>")
					G.activate(M)
					update_inv_wear_mask()
				else
					to_chat(M, "<span class='warning'>\The [G] is already primed! Run!</span>")
				return

			if(!istype(H))
				attack_generic(H,rand(1,3),"punched")
				return

			if(H == src) // no more punching yourself to death
				return

			if(H.IsAntiGrief())
				to_chat(H, "<span class='danger'>You wish to do no harm. (You currently have anti-grief enabled either due to being a brand new player or grief-banned.)</span>")
				visible_message("<b>[H]</b> has raises their fist to punch [M], but lowers it, reconsidering.")
				return 0

			var/rand_damage = rand(1, 5)
			var/block = 0
			var/accurate = 0
			var/hit_zone = H.zone_sel.selecting
			var/obj/item/organ/external/affecting = get_organ(hit_zone)

			if(!affecting || affecting.is_stump())
				to_chat(M, "<span class='danger'>They are missing that limb!</span>")
				return 1

			switch(src.a_intent)
				if(I_HELP)
					// We didn't see this coming, so we get the full blow
					rand_damage = 5
					accurate = 1
				if(I_HURT, I_GRAB)
					// We're in a fighting stance, there's a chance we block
					if(src.canmove && src!=H && prob(20))
						block = 1

			if (M.grabbed_by.len)
				// Someone got a good grip on them, they won't be able to do much damage
				rand_damage = max(1, rand_damage - 2)

			if(src.grabbed_by.len || src.buckled || !src.canmove || src==H)
				accurate = 1 // certain circumstances make it impossible for us to evade punches
				rand_damage = 5

			// Process evasion and blocking
			var/miss_type = 0
			var/attack_message
			if(!accurate)
				/* ~Hubblenaut
					This place is kind of convoluted and will need some explaining.
					ran_zone() will pick out of 11 zones, thus the chance for hitting
					our target where we want to hit them is circa 9.1%.

					Now since we want to statistically hit our target organ a bit more
					often than other organs, we add a base chance of 20% for hitting it.

					This leaves us with the following chances:

					If aiming for chest:
						27.3% chance you hit your target organ
						70.5% chance you hit a random other organ
						 2.2% chance you miss

					If aiming for something else:
						23.2% chance you hit your target organ
						56.8% chance you hit a random other organ
						15.0% chance you miss

					Note: We don't use get_zone_with_miss_chance() here since the chances
						  were made for projectiles.
					TODO: proc for melee combat miss chances depending on organ?
				*/

				if(!hit_zone)
					attack_message = "[H] attempted to strike [src], but missed!"
					miss_type = 1

				if(prob(80))
					hit_zone = ran_zone(hit_zone, 70) //70% chance to hit what you're aiming at seems fair?
				if(prob(15) && hit_zone != BP_TORSO) // Missed!
					if(!src.lying)
						attack_message = "[H] attempted to strike [src], but missed!"
					else
						attack_message = "[H] attempted to strike [src], but [TT.he] rolled out of the way!"
						src.set_dir(pick(cardinal))
					miss_type = 1

			if(!miss_type && block)
				attack_message = "[H] went for [src]'s [affecting.name] but was blocked!"
				miss_type = 2

			// See what attack they use
			var/datum/unarmed_attack/attack = H.get_unarmed_attack(src, hit_zone)
			if(!attack)
				return 0

			H.do_attack_animation(src)
			if(!attack_message)
				attack.show_attack(H, src, hit_zone, rand_damage)
			else
				H.visible_message("<span class='danger'>[attack_message]</span>")

			playsound(loc, ((miss_type) ? (miss_type == 1 ? attack.miss_sound : 'sound/weapons/thudswoosh.ogg') : attack.attack_sound), 25, 1, -1)

			add_attack_logs(H,src,"Melee attacked with fists (miss/block)")

			if(miss_type)
				return 0

			var/real_damage = rand_damage
			var/hit_dam_type = attack.damage_type
			real_damage += attack.get_unarmed_damage(H)
			if(H.gloves)
				if(istype(H.gloves, /obj/item/clothing/gloves))
					var/obj/item/clothing/gloves/G = H.gloves
					real_damage += G.punch_force
					hit_dam_type = G.punch_damtype
					if(H.pulling_punches)	//SO IT IS DECREED: PULLING PUNCHES WILL PREVENT THE ACTUAL DAMAGE FROM RINGS AND KNUCKLES, BUT NOT THE ADDED PAIN
						hit_dam_type = AGONY
			real_damage *= damage_multiplier
			rand_damage *= damage_multiplier
			if(HULK in H.mutations)
				real_damage *= 2 // Hulks do twice the damage
				rand_damage *= 2
			real_damage = max(1, real_damage)

			var/armour = run_armor_check(hit_zone, "melee")
			var/soaked = get_armor_soak(hit_zone, "melee")
			// Apply additional unarmed effects.
			attack.apply_effects(H, src, armour, rand_damage, hit_zone)

			// Finally, apply damage to target
			apply_damage(real_damage, hit_dam_type, hit_zone, armour, soaked, sharp=attack.sharp, edge=attack.edge)

		if(I_DISARM)
			add_attack_logs(H,src,"Disarmed")

			M.do_attack_animation(src)

			if(w_uniform)
				w_uniform.add_fingerprint(M)
			var/obj/item/organ/external/affecting = get_organ(ran_zone(M.zone_sel.selecting))

			var/list/holding = list(get_active_hand() = 40, get_inactive_hand = 20)

			//See if they have any guns that might go off
			for(var/obj/item/weapon/gun/W in holding)
				if(W && prob(holding[W]))
					var/list/turfs = list()
					for(var/turf/T in view())
						turfs += T
					if(turfs.len)
						var/turf/target = pick(turfs)
						visible_message("<span class='danger'>[src]'s [W] goes off during the struggle!</span>")
						return W.afterattack(target,src)

			if(last_push_time + 30 > world.time)
				visible_message("<span class='warning'>[M] has weakly pushed [src]!</span>")
				return

			var/randn = rand(1, 100)
			last_push_time = world.time
			if(!(species.flags & NO_SLIP) && randn <= 25)
				var/armor_check = run_armor_check(affecting, "melee")
				apply_effect(3, WEAKEN, armor_check)
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				if(armor_check < 60)
					visible_message("<span class='danger'>[M] has pushed [src]!</span>")
				else
					visible_message("<span class='warning'>[M] attempted to push [src]!</span>")
				return

			if(randn <= 60)
				//See about breaking grips or pulls
				if(break_all_grabs(M))
					playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
					return

				//Actually disarm them
				for(var/obj/item/I in holding)
					if(I)
						drop_from_inventory(I)
						visible_message("<span class='danger'>[M] has disarmed [src]!</span>")
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
						return

			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			visible_message("<font color='red'> <B>[M] attempted to disarm [src]!</B></font>")
	return

/mob/living/carbon/human/proc/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, inrange, params)
	return

/mob/living/carbon/human/attack_generic(var/mob/user, var/damage, var/attack_message, var/armor_type = "melee", var/armor_pen = 0, var/a_sharp = 0, var/a_edge = 0)

	if(!damage)
		return

	add_attack_logs(user,src,"Melee attacked with fists (miss/block)",admin_notify = FALSE) //No admin notice since this is usually fighting simple animals
	src.visible_message("<span class='danger'>[user] has [attack_message] [src]!</span>")
	user.do_attack_animation(src)

	var/dam_zone = pick(organs_by_name)
	var/obj/item/organ/external/affecting = get_organ(ran_zone(dam_zone))
	var/armor_block = run_armor_check(affecting, armor_type, armor_pen)
	var/armor_soak = get_armor_soak(affecting, armor_type, armor_pen)
	apply_damage(damage, BRUTE, affecting, armor_block, armor_soak, sharp = a_sharp, edge = a_edge)
	updatehealth()
	return 1

//Used to attack a joint through grabbing
/mob/living/carbon/human/proc/grab_joint(var/mob/living/user, var/def_zone)
	var/has_grab = 0
	for(var/obj/item/weapon/grab/G in list(user.l_hand, user.r_hand))
		if(G.affecting == src && G.state == GRAB_NECK)
			has_grab = 1
			break

	if(!has_grab)
		return 0

	if(!def_zone) def_zone = user.zone_sel.selecting
	var/target_zone = check_zone(def_zone)
	if(!target_zone)
		return 0
	var/obj/item/organ/external/organ = get_organ(check_zone(target_zone))
	if(!organ || organ.dislocated > 0 || organ.dislocated == -1) //don't use is_dislocated() here, that checks parent
		return 0

	if(user.IsAntiGrief())
		to_chat(user, "<span class='danger'>Actually, that might be painful - I'll stop.</span>")
		return 0

	user.visible_message("<span class='warning'>[user] begins to dislocate [src]'s [organ.joint]!</span>")
	if(do_after(user, 100))
		organ.dislocate(1)
		src.visible_message("<span class='danger'>[src]'s [organ.joint] [pick("gives way","caves in","crumbles","collapses")]!</span>")
		return 1
	return 0

//Breaks all grips and pulls that the mob currently has.
/mob/living/carbon/human/proc/break_all_grabs(mob/living/carbon/user)
	var/success = 0
	if(pulling)
		visible_message("<span class='danger'>[user] has broken [src]'s grip on [pulling]!</span>")
		success = 1
		stop_pulling()

	if(istype(l_hand, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/lgrab = l_hand
		if(lgrab.affecting)
			visible_message("<span class='danger'>[user] has broken [src]'s grip on [lgrab.affecting]!</span>")
			success = 1
		spawn(1)
			qdel(lgrab)
	if(istype(r_hand, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/rgrab = r_hand
		if(rgrab.affecting)
			visible_message("<span class='danger'>[user] has broken [src]'s grip on [rgrab.affecting]!</span>")
			success = 1
		spawn(1)
			qdel(rgrab)
	return success

/*
	We want to ensure that a mob may only apply pressure to one organ of one mob at any given time. Currently this is done mostly implicitly through
	the behaviour of do_after() and the fact that applying pressure to someone else requires a grab:
	If you are applying pressure to yourself and attempt to grab someone else, you'll change what you are holding in your active hand which will stop do_mob()
	If you are applying pressure to another and attempt to apply pressure to yourself, you'll have to switch to an empty hand which will also stop do_mob()
	Changing targeted zones should also stop do_mob(), preventing you from applying pressure to more than one body part at once.
*/
/mob/living/carbon/human/proc/apply_pressure(mob/living/user, var/target_zone)
	var/obj/item/organ/external/organ = get_organ(target_zone)
	if(!organ || !(organ.status & ORGAN_BLEEDING) || (organ.robotic >= ORGAN_ROBOT))
		return 0

	if(organ.applied_pressure)
		to_chat(user, "<span class='warning'>Someone is already applying pressure to [user == src? "your [organ.name]" : "[src]'s [organ.name]"].</span>")
		return 0

	var/datum/gender/TU = gender_datums[user.get_visible_gender()]

	if(user == src)
		user.visible_message("\The [user] starts applying pressure to [TU.his] [organ.name]!", "You start applying pressure to your [organ.name]!")
	else
		user.visible_message("\The [user] starts applying pressure to [src]'s [organ.name]!", "You start applying pressure to [src]'s [organ.name]!")
	spawn(0)
		organ.applied_pressure = user

		//apply pressure as long as they stay still and keep grabbing
		do_mob(user, src, INFINITY, target_zone, progress = 0)

		organ.applied_pressure = null

		if(user == src)
			user.visible_message("\The [user] stops applying pressure to [TU.his] [organ.name]!", "You stop applying pressure to your [organ]!")
		else
			user.visible_message("\The [user] stops applying pressure to [src]'s [organ.name]!", "You stop applying pressure to [src]'s [organ.name]!")

	return 1