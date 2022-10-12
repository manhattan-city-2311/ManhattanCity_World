////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/pill
	name = "pill"
	desc = "A pill."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "pill"

	var/base_state = "pill"

	possible_transfer_amounts = null
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	volume = 200



/obj/item/weapon/reagent_containers/pill/New()
	..()
	if(!icon_state)
		icon_state = "[base_state][rand(1, 20)]"

/obj/item/weapon/reagent_containers/pill/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(!H.check_has_mouth())
				to_chat(user, "Where do you intend to put \the [src]? You don't have a mouth!")
				return
			var/obj/item/blocked = H.check_mouth_coverage()
			if(blocked)
				to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
				return

			to_chat(M, "<span class='notice'>You swallow \the [src].</span>")
			M.drop_from_inventory(src) //icon update
			if(reagents.total_volume)
				reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
			qdel(src)
			return 1

	else if(istype(M, /mob/living/carbon/human))

		var/mob/living/carbon/human/H = M
		if(!H.check_has_mouth())
			to_chat(user, "Where do you intend to put \the [src]? \The [H] doesn't have a mouth!")
			return
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
			return

		user.visible_message("<span class='warning'>[user] attempts to force [M] to swallow \the [src].</span>")

		user.setClickCooldown(user.get_attack_speed(src))
		if(!do_mob(user, M))
			return

		user.drop_from_inventory(src) //icon update
		user.visible_message("<span class='warning'>[user] forces [M] to swallow \the [src].</span>")

		var/contained = reagentlist()
		add_attack_logs(user,M,"Fed a pill containing [contained]")

		if(reagents && reagents.total_volume)
			reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		qdel(src)

		return 1

	return 0

/obj/item/weapon/reagent_containers/pill/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	if(target.is_open_container() && target.reagents)
		if(!target.reagents.total_volume)
			to_chat(user, "<span class='notice'>[target] is empty. Can't dissolve \the [src].</span>")
			return
		to_chat(user, "<span class='notice'>You dissolve \the [src] in [target].</span>")

		add_attack_logs(user,null,"Spiked [target.name] with a pill containing [reagentlist()]")

		reagents.trans_to(target, reagents.total_volume)
		for(var/mob/O in viewers(2, user))
			O.show_message("<span class='warning'>[user] puts something in \the [target].</span>", 1)

		qdel(src)

	return

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills

/obj/item/weapon/reagent_containers/pill/paracetamol
	name = "Paracetamol pill"
	desc = "Paracetamol! A painkiller for the ages. Chewables! Contains 15 ml of Paracetamol."
	icon_state = "pill2"

/obj/item/weapon/reagent_containers/pill/paracetamol/New()
	..()
	reagents.add_reagent("paracetamol", 15)


/obj/item/weapon/reagent_containers/pill/tramadol
	name = "Tramadol pill"
	desc = "A simple painkiller. Contains 15 ml of Tramadol."
	icon_state = "pill10"

/obj/item/weapon/reagent_containers/pill/tramadol/New()
	..()
	reagents.add_reagent("tramadol", 15)


/obj/item/weapon/reagent_containers/pill/oxycodone
	name = "Oxycodone pill"
	desc = "A strong painkiller. Contains 15 ml of Oxycodone."
	icon_state = "pill8"

/obj/item/weapon/reagent_containers/pill/oxycodone/New()
	..()
	reagents.add_reagent("oxycodone", 15)


/obj/item/weapon/reagent_containers/pill/amiodarone
	name = "Amiodarone pill"
	desc = "A simple antiarrhythmic drug. Contains 15 ml of Amiodarone."
	icon_state = "pill5"

/obj/item/weapon/reagent_containers/pill/amiodarone/New()
	..()
	reagents.add_reagent("amiodarone", 15)


/obj/item/weapon/reagent_containers/pill/haloperidol
	name = "Haloperidol pill"
	desc = "An antipsychotic drug. Contains 15 ml of Haloperidol."
	icon_state = "pill13"

/obj/item/weapon/reagent_containers/pill/haloperidol/New()
	..()
	reagents.add_reagent("haloperidol", 15)


/obj/item/weapon/reagent_containers/pill/amicile
	name = "Amicile pill"
	desc = "A semi-synthetic antibiotic. Contains 15 ml of Amicile."
	icon_state = "pill6"

/obj/item/weapon/reagent_containers/pill/amicile/New()
	..()
	reagents.add_reagent("amicile", 15)


/obj/item/weapon/reagent_containers/pill/methylphenidate
	name = "Methylphenidate pill"
	desc = "Improves the ability to concentrate. Contains 15 ml of Methylphenidate."
	icon_state = "pill8"

/obj/item/weapon/reagent_containers/pill/methylphenidate/New()
	..()
	reagents.add_reagent("methylphenidate", 15)


/obj/item/weapon/reagent_containers/pill/citalopram
	name = "Citalopram pill"
	desc = "Mild anti-depressant. Contains 15 ml of Citalopram."
	icon_state = "pill8"

/obj/item/weapon/reagent_containers/pill/citalopram/New()
	..()
	reagents.add_reagent("citalopram", 15)

/obj/item/weapon/reagent_containers/pill/penicillin
	name = "penicillin pill"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space. Contains 15 ml of penicillin."
	icon_state = "pill19"

/obj/item/weapon/reagent_containers/pill/penicillin/New()
	..()
	reagents.add_reagent("penicillin", 15)


/obj/item/weapon/reagent_containers/pill/carbon
	name = "Carbon pill"
	desc = "Used to neutralise chemicals in the stomach. Contains 15 ml of Carbon."
	icon_state = "pill7"

/obj/item/weapon/reagent_containers/pill/carbon/New()
	..()
	reagents.add_reagent("carbon", 15)


/obj/item/weapon/reagent_containers/pill/iron
	name = "Iron pill"
	desc = "Used to aid in blood regeneration after bleeding. Contains 15 ml of Iron."
	icon_state = "pill4"

/obj/item/weapon/reagent_containers/pill/iron/New()
	..()
	reagents.add_reagent("iron", 15)


/obj/item/weapon/reagent_containers/pill/zoom
	name = "Zoom pill"
	desc = "Zoooom!"
	icon_state = "pill18"

/obj/item/weapon/reagent_containers/pill/zoom/New()
	..()
	reagents.add_reagent("impedrezene", 10)
	reagents.add_reagent("synaptizine", 5)
	reagents.add_reagent("methamphetamine", 5)

/obj/item/weapon/reagent_containers/pill/diet
	name = "diet pill"
	desc = "Guaranteed to get you slim!"
	icon_state = "pill9"

/obj/item/weapon/reagent_containers/pill/diet/New()
	..()
	reagents.add_reagent("lipozine", 2)


/obj/item/weapon/reagent_containers/pill/cocaine
	name = "cocaine chunk"
	desc = "A small chunk of cocaine, you should cut this with a knife."
	icon_state = "pill9"

/obj/item/weapon/reagent_containers/pill/cocaine/New()
	..()
	reagents.add_reagent("cocaine", 15)
