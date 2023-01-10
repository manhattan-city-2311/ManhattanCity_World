/obj/machinery/iv_drip
	name = "\improper IV drip"
	icon = 'icons/obj/iv_drip.dmi'
	anchored = 0
	density = 0

	unique_save_vars = list("id")

	var/transfer_volume = 2


/obj/machinery/iv_drip/var/mob/living/carbon/human/attached = null
/obj/machinery/iv_drip/var/mode = 1 // 1 is injecting, 0 is taking blood.
/obj/machinery/iv_drip/var/obj/item/weapon/reagent_containers/beaker = null

/obj/machinery/iv_drip/update_icon()
	if(attached)
		icon_state = "hooked"
	else
		icon_state = ""

	overlays = null

	if(beaker)
		var/datum/reagents/reagents = beaker.reagents
		if(reagents.total_volume)
			var/image/filling = image('icons/obj/iv_drip.dmi', src, "reagent")

			var/percent = round((reagents.total_volume / beaker.volume) * 100)
			switch(percent)
				if(0 to 9)		filling.icon_state = "reagent0"
				if(10 to 24) 	filling.icon_state = "reagent10"
				if(25 to 49)	filling.icon_state = "reagent25"
				if(50 to 74)	filling.icon_state = "reagent50"
				if(75 to 79)	filling.icon_state = "reagent75"
				if(80 to 90)	filling.icon_state = "reagent80"
				if(91 to POSITIVE_INFINITY)	filling.icon_state = "reagent100"

			filling.icon += reagents.get_color()
			overlays += filling

/obj/machinery/iv_drip/MouseDrop(over_object, src_location, over_location)
	..()
	if(!isliving(usr))
		return

	if(attached)
		visible_message("[attached] is detached from \the [src]")
		attached = null
		update_icon()
		return

	if(in_range(src, usr) && ishuman(over_object) && get_dist(over_object, src) <= 1)
		visible_message("[usr] attaches \the [src] to \the [over_object].")
		attached = over_object
		update_icon()


/obj/machinery/iv_drip/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/reagent_containers))
		if(!isnull(beaker))
			to_chat(user, "There is already a reagent container loaded!")
			return

		user.drop_item()
		W.loc = src
		beaker = W
		to_chat(user, "You attach \the [W] to \the [src].")
		update_icon()
		if(istype(beaker, /obj/item/weapon/reagent_containers/blood))
			// speed up transfer on blood packs
			transfer_volume = 40
		else
			transfer_volume = initial(transfer_volume)
		return

	if(istype(W, /obj/item/weapon/screwdriver))
		playsound(src, W.usesound, 50, 1)
		to_chat(user, "<span class='notice'>You start to dismantle the IV drip.</span>")
		if(do_after(user, 15))
			to_chat(user, "<span class='notice'>You dismantle the IV drip.</span>")
			var/obj/item/stack/rods/A = new /obj/item/stack/rods(src.loc)
			A.amount = 6
			if(beaker)
				beaker.loc = get_turf(src)
				beaker = null
			qdel(src)
		return
	else
		return ..()


/obj/machinery/iv_drip/process()
	set background = 1

	if(attached)

		if(!(get_dist(src, attached) <= 1 && isturf(attached.loc)))
			visible_message("<span class='warning'>The needle is violently ripped out of [attached]!</span>")
			var/affected = pick("r_arm", "l_arm")
			attached:apply_damage(15, BRUTE, affected)
			attached.custom_pain("<span class='warning'>You feel something ripped out of your arm!</span>", 1, affecting = affected)
			attached = null
			update_icon()
			return

	if(attached && beaker)
		// Give blood
		if(mode)
			if(beaker.volume > 0)
				beaker.reagents.trans_to_mob(attached, transfer_volume, CHEM_BLOOD)
				update_icon()

		// Take blood
		else
			var/amount = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			amount = min(amount, 4)
			// If the beaker is full, ping
			if(amount == 0)
				if(prob(5)) visible_message("\The [src] pings.")
				return

			var/mob/living/carbon/human/T = attached

			if(!istype(T)) return
			if(!T.dna)
				return
			if(NOCLONE in T.mutations)
				return

			if(!T.should_have_organ(O_HEART))
				return

			// If the human is losing too much blood, beep.
			if(attached.get_blood_volume() < BLOOD_PERFUSION_SAFE * 1.05)
				visible_message("<span class='warning'>The IV drip beeps loudly!</span>")

			var/datum/reagent/B = T.take_blood(beaker,amount)

			if(B)
				beaker.reagents.reagent_list |= B
				beaker.reagents.update_total()
				beaker.on_reagent_change()
				beaker.reagents.handle_reactions()
				update_icon()

/obj/machinery/iv_drip/attack_hand(mob/user as mob)
	if(beaker)
		beaker.loc = get_turf(src)
		beaker = null
		update_icon()
	else
		return ..()


/obj/machinery/iv_drip/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Mode"
	set src in view(1)

	if(!istype(usr, /mob/living))
		to_chat(usr, "<span class='warning'>You can't do that.</span>")
		return

	if(usr.stat)
		return

	mode = !mode
	to_chat(usr, "The IV drip is now [mode ? "injecting" : "taking blood"].")

/obj/machinery/iv_drip/examine(mob/user)
	..(user)
	if(!(user in view(2)) && user != src.loc) return

	to_chat(user, "The IV drip is [mode ? "injecting" : "taking blood"].")

	if(beaker)
		if(beaker.reagents && beaker.reagents.reagent_list.len)
			to_chat(usr, "<span class='notice'>Attached is \a [beaker] with [beaker.reagents.total_volume]ml of liquid.</span>")
		else
			to_chat(usr, "<span class='notice'>Attached is an empty [beaker].</span>")
	else
		to_chat(usr, "<span class='notice'>No chemicals are attached.</span>")

	to_chat(usr, "<span class='notice'>[attached ? attached : "No one"] is attached.</span>")

/obj/machinery/iv_drip/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(height && istype(mover) && (mover.checkpass(PASSTABLE) || mover.elevation != elevation)) //allow bullets, beams, thrown objects, mice, drones, and the like through.
		return 1
	return ..()
