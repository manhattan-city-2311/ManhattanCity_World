////////////////////////////////////////////////////////////////////////////////
/// Syringes.
////////////////////////////////////////////////////////////////////////////////
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2
#define SYRINGE_PACKAGED 3

/obj/item/weapon/reagent_containers/syringe
	name = "syringe"
	desc = "A syringe."
	icon = 'icons/obj/syringe.dmi'
	item_state = "syringe_0"
	icon_state = "0"
	matter = list("glass" = 150)
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = list(1,2,2.5,3,4,5,10,15,20)
	volume = 20
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	sharp = 1
	unacidable = 1 //glass
	var/mode = SYRINGE_DRAW
	var/image/filling //holds a reference to the current filling overlay
	var/visible_name = "a syringe"
	var/time = 30
	var/drawing = 0
	var/pain = 5
	drop_sound = 'sound/items/drop/glass.ogg'
	var/starting_label
	var/package_state = "package"
	var/list/initial_reagents

/obj/item/weapon/reagent_containers/syringe/initialize()
	. = ..()
	spawn()
		for(var/I in initial_reagents)
			reagents.add_reagent(I, initial_reagents[I])
		update_icon()

/obj/item/weapon/reagent_containers/syringe/on_reagent_change()
	. = ..()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/pickup(mob/user)
	. = ..()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/dropped(mob/user)
	. = ..()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/attack_self(mob/user as mob)
	switch(mode)
		if(SYRINGE_DRAW)
			mode = SYRINGE_INJECT
		if(SYRINGE_INJECT)
			mode = SYRINGE_DRAW
		if(SYRINGE_BROKEN)
			return
		if(SYRINGE_PACKAGED)
			to_chat(user, SPAN_NOTICE("You unwrap \the [src]."))
			mode = SYRINGE_INJECT
	update_icon()

/obj/item/weapon/reagent_containers/syringe/attack_hand()
	..()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/afterattack(obj/target, mob/user, proximity)
	if(!proximity || !target.reagents)
		return

	if(mode == SYRINGE_BROKEN)
		to_chat(user, SPAN_WARNING("This syringe is broken!"))
		return

	if(user.a_intent == I_HURT && ismob(target))
		if((CLUMSY in user.mutations) && prob(50))
			target = user
		syringestab(target, user)
		return

	var/injtime = time // Calculated 'true' injection time (as added to by hardsuits and whatnot), 66% of this goes to warmup, then every 33% after injects 5u
	switch(mode)
		if(SYRINGE_DRAW)
			if(!reagents.get_free_space())
				to_chat(user, "<span class='warning'>The syringe is full.</span>")
				mode = SYRINGE_INJECT
				return

			if(ismob(target))//Blood!
				if(reagents.has_reagent(CI_BLOOD))
					to_chat(user, "<span class='notice'>There is already a blood sample in this syringe.</span>")
					return

				if(istype(target, /mob/living/carbon))
					var/amount = reagents.get_free_space()
					var/mob/living/carbon/T = target
					if(!T.dna)
						to_chat(user, "<span class='warning'>You are unable to locate any blood. (To be specific, your target seems to be missing their DNA datum).</span>")
						return
					if(NOCLONE in T.mutations) //target done been et, no more blood in him
						to_chat(user, "<span class='warning'>You are unable to locate any blood.</span>")
						return

					if(T.isSynthetic())
						to_chat(user, "<span class = 'warning'>You can't draw blood from a synthetic!</span>")
						return

					if(drawing)
						to_chat(user, "<span class='warning'>You are already drawing blood from [T.name].</span>")
						return

					var/datum/reagent/B
					drawing = 1
					if(istype(T, /mob/living/carbon/human))
						var/mob/living/carbon/human/H = T
						if(H.species && !H.should_have_organ(O_HEART))
							H.reagents.trans_to_obj(src, amount)
						else
							if(ismob(H) && H != user)
								if(!do_mob(user, target, time))
									drawing = 0
									return
							B = T.take_blood(src, amount)
							drawing = 0
					else
						if(!do_mob(user, target, time))
							drawing = 0
							return
						B = T.take_blood(src,amount)
						drawing = 0

					if (B)
						reagents.reagent_list += B
						reagents.update_total()
						on_reagent_change()
						reagents.handle_reactions()
					to_chat(user, "<span class='notice'>You take a blood sample from [target].</span>")
					for(var/mob/O in viewers(4, user))
						O.show_message("<span class='notice'>[user] takes a blood sample from [target].</span>", 1)

			else //if not mob
				if(!target.reagents.total_volume)
					to_chat(user, "<span class='notice'>[target] is empty.</span>")
					return

				if(!target.is_open_container() && !istype(target, /obj/structure/reagent_dispensers) && !istype(target, /obj/item/slime_extract) && !istype(target, /obj/item/weapon/reagent_containers/food))
					to_chat(user, "<span class='notice'>You cannot directly remove reagents from this object.</span>")
					return

				var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
				to_chat(user, "<span class='notice'>You fill the syringe with [trans] units of the solution.</span>")
				update_icon()


			if(!reagents.get_free_space())
				mode = SYRINGE_INJECT
				update_icon()

		if(SYRINGE_INJECT)
			if(!reagents.total_volume)
				to_chat(user, "<span class='notice'>The syringe is empty.</span>")
				mode = SYRINGE_DRAW
				return
			if(istype(target, /obj/item/weapon/implantcase/chem))
				return

			if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/weapon/reagent_containers/food) && !istype(target, /obj/item/slime_extract) && !istype(target, /obj/item/clothing/mask/smokable/cigarette) && !istype(target, /obj/item/weapon/storage/fancy/cigarettes))
				to_chat(user, "<span class='notice'>You cannot directly fill this object.</span>")
				return
			if(!target.reagents.get_free_space())
				to_chat(user, "<span class='notice'>[target] is full.</span>")
				return

			var/mob/living/carbon/human/H = target
			if(istype(H))
				var/obj/item/organ/external/affected = H.get_organ(user.zone_sel.selecting)
				if(!affected)
					to_chat(user, "<span class='danger'>\The [H] is missing that limb!</span>")
					return
				else if(affected.robotic >= ORGAN_ROBOT)
					to_chat(user, "<span class='danger'>You cannot inject a robotic limb.</span>")
					return

			var/cycle_time = injtime*0.33 //33% of the time slept between 5u doses
			var/warmup_time = cycle_time //If the target is another mob, this gets overwritten

			if(ismob(target) && target != user)
				warmup_time = injtime*0.66 // Otherwise 66% of the time is warmup

				if(istype(H))
					if(H.wear_suit)
						if(istype(H.wear_suit, /obj/item/clothing/suit/space))
							injtime = injtime * 2
						else if(!H.can_inject(user, 1))
							return

				else if(isliving(target))
					var/mob/living/M = target
					if(!M.can_inject(user, 1))
						return

				if(injtime == time)
					user.visible_message("<span class='warning'>[user] is trying to inject [target] with [visible_name]!</span>","<span class='notice'>You begin injecting [target] with [visible_name].</span>")
				else
					user.visible_message("<span class='warning'>[user] begins hunting for an injection port on [target]'s suit!</span>","<span class='notice'>You begin hunting for an injection port on [target]'s suit!</span>")

			//The warmup
			user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
			if(!do_after(user,warmup_time,target))
				return

			var/trans = 0
			var/contained = reagentlist()
			if(ismob(target))
				trans += reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_BLOOD)
			else
				trans += reagents.trans_to_obj(target, amount_per_transfer_from_this)
			update_icon()
			if(!reagents.total_volume || !do_after(user,cycle_time,target))
				return

			if (reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
				mode = SYRINGE_DRAW
				update_icon()
			if(trans)
				to_chat(user, "<span class='notice'>You inject [trans] units of the solution. The syringe now contains [src.reagents.total_volume] units.</span>")
				if(ismob(target))
					add_attack_logs(user,target,"Injected with [src.name] containing [contained], trasferred [trans] units")
			else
				to_chat(user, "<span class='notice'>The syringe is empty.</span>")
			if (reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
				mode = SYRINGE_DRAW
				update_icon()

/obj/item/weapon/reagent_containers/syringe/update_icon()
	overlays.Cut()

	if(mode == SYRINGE_BROKEN)
		icon_state = "broken"
		return

	var/rounded_vol = reagents.total_volume == 1 || round(reagents.total_volume, 5)
	icon_state = "[rounded_vol]"
	item_state = "syringe_[rounded_vol]"

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "syringe10")
		filling.icon_state = "syringe[rounded_vol]"
		filling.color = reagents.get_color()
		overlays += filling

	if(mode == SYRINGE_PACKAGED && package_state)
		overlays += package_state
		return

	if(ismob(loc))
		switch(mode)
			if(SYRINGE_DRAW)
				overlays += "draw"
			if(SYRINGE_INJECT)
				overlays += "inject"

/obj/item/weapon/reagent_containers/syringe/proc/syringestab(mob/living/carbon/target as mob, mob/living/carbon/user as mob)
	if(istype(target, /mob/living/carbon/human))

		var/mob/living/carbon/human/H = target

		var/target_zone = ran_zone(check_zone(user.zone_sel.selecting, target))
		var/obj/item/organ/external/affecting = H.get_organ(target_zone)

		if (!affecting || affecting.is_stump())
			to_chat(user, "<span class='danger'>They are missing that limb!</span>")
			return

		var/hit_area = affecting.name

		if((user != target) && H.check_shields(7, src, user, "\the [src]"))
			return

		if (target != user && H.getarmor(target_zone, "melee") > 5 && prob(50))
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text("<font color='red'><B>[user] tries to stab [target] in \the [hit_area] with [src.name], but the attack is deflected by armor!</B></font>"), 1)
			user.remove_from_mob(src)
			qdel(src)

			add_attack_logs(user,target,"Syringe harmclick")

			return

		user.visible_message("<span class='danger'>[user] stabs [target] in \the [hit_area] with [src.name]!</span>")

		if(affecting.take_damage(3))
			H.UpdateDamageIcon()

	else
		user.visible_message("<span class='danger'>[user] stabs [target] with [src.name]!</span>")
		target.take_organ_damage(3)// 7 is the same as crowbar punch



	var/syringestab_amount_transferred = reagents.total_volume //nerfed by popular demand --- no
	var/contained = reagents.get_reagents()
	var/trans = reagents.trans_to_mob(target, syringestab_amount_transferred, CHEM_BLOOD)
	if(isnull(trans)) trans = 0
	add_attack_logs(user,target,"Stabbed with [src.name] containing [contained], trasferred [trans] units")
	break_syringe(target, user)

/obj/item/weapon/reagent_containers/syringe/proc/break_syringe(mob/living/carbon/target, mob/living/carbon/user)
	mode = SYRINGE_BROKEN
	if(target)
		add_blood(target)
	if(user)
		add_fingerprint(user)
	update_icon()

/obj/item/weapon/reagent_containers/syringe/ld50_syringe
	name = "Lethal Injection Syringe"
	desc = "A syringe used for lethal injections."
	amount_per_transfer_from_this = 50
	volume = 50
	visible_name = "a giant syringe"
	time = 300

/obj/item/weapon/reagent_containers/syringe/ld50_syringe/afterattack(obj/target, mob/user, flag)
	if(mode == SYRINGE_DRAW && ismob(target)) // No drawing 50 units of blood at once
		to_chat(user, "<span class='notice'>This needle isn't designed for drawing blood.</span>")
		return
	if(user.a_intent == "hurt" && ismob(target)) // No instant injecting
		to_chat(user, "<span class='notice'>This syringe is too big to stab someone with it.</span>")
	..()

////////////////////////////////////////////////////////////////////////////////
/// Syringes. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/syringe/antitoxin
	name = "Syringe (anti-toxin)"
	desc = "Contains anti-toxins."

/obj/item/weapon/reagent_containers/syringe/antitoxin/New()
	..()
	reagents.add_reagent("anti_toxin", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/weapon/reagent_containers/syringe/antiviral
	name = "Syringe (penicillin)"
	desc = "Contains antiviral agents."

/obj/item/weapon/reagent_containers/syringe/antiviral/New()
	..()
	reagents.add_reagent("penicillin", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/weapon/reagent_containers/syringe/drugs
	name = "Syringe"
	desc = "A syringe filled with a weird-colored substance"

/obj/item/weapon/reagent_containers/syringe/drugs/New()
	..()
	reagents.add_reagent("ecstasy",  5)
	reagents.add_reagent("mindbreaker",  5)
	reagents.add_reagent("cryptobiolin", 5)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/weapon/reagent_containers/syringe/ld50_syringe/choral/New()
	..()
	reagents.add_reagent("chloralhydrate", 50)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/weapon/reagent_containers/syringe/steroid
	name = "Syringe (anabolic steroids)"
	desc = "Contains drugs for muscle growth."

/obj/item/weapon/reagent_containers/syringe/steroid/New()
	..()
	reagents.add_reagent("adrenaline",5)
	reagents.add_reagent("hyperzine",10)

/obj/item/weapon/reagent_containers/syringe/adrenaline
	name = "syringe (adrenaline 15ml)"
	mode = SYRINGE_PACKAGED
	initial_reagents = list(CI_ADRENALINE = 15)
	volume = 15

/obj/item/weapon/reagent_containers/syringe/noradrenaline
	name = "syringe (noradrenaline 15ml)"
	mode = SYRINGE_PACKAGED
	initial_reagents = list(CI_NORADRENALINE = 15)
	volume = 15

/obj/item/weapon/reagent_containers/syringe/atropine
	name = "syringe (atropine 15ml)"
	mode = SYRINGE_PACKAGED
	initial_reagents = list("atropine" = 15)
	volume = 15
/obj/item/weapon/reagent_containers/syringe/morphine
	name = "syringe (morphine 7.5ml)"
	amount_per_transfer_from_this = 2.5
	mode = SYRINGE_PACKAGED
	initial_reagents = list("morphine" = 7.5)
	volume = 7.5
