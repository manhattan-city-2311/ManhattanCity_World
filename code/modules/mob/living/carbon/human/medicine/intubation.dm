/mob/living/carbon/human
	var/intubated = FALSE

/obj/item/intubation_tube
	name = "intubation tube"
	desc = "Used to provide air in case of blocked patient airway or lack of functionality in lungs."
	icon = 'icons/obj/medicine.dmi'
	icon_state = "int_tube"
	var/lubed = FALSE
	var/pain = 30
	var/list/lubes = list(
		"silicon" = 20,
		"water" = 5,
		"lube" = 25
	)

/obj/item/intubation_tube/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	if(!ishuman(M))
		return
	if(M.intubated)
		to_chat(user, "<span class='warning'>\The [M] is already intubated!</span>")
		return

	user.visible_message("<span class='warning'>[user] starts intubating [M]!</span>")
	if(lubed)
		M.custom_pain("<span class='notice'>You feel a tube gently lowered down your throat.</span>", pain, affecting = /obj/item/organ/external/head)
	else
		M.custom_pain("<span class='warning'>You feel a dry tube violently shoved up your throat!.</span>", pain * 2, affecting = /obj/item/organ/external/head)
	if(!do_after(usr, 50, src))
		return
	user.visible_message("<span class='warning'>[user] intubates [M]!</span>")
	M.intubated = TRUE
	qdel(src)

/obj/item/intubation_baloon
	name = "intubation bag"
	desc = "A special baloon-like bag for manual intubation."
	icon = 'icons/obj/medicine.dmi'
	icon_state = "int_bag_idle"
	var/mob/living/carbon/human/patient = null
	var/bagging = FALSE

/obj/item/intubation_baloon/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	if(!ishuman(M))
		return
	if(!M.intubated)
		to_chat(user, "<span class='warning'>\The [M] is not intubated!</span>")
		return
	if(bagging)
		return
	visible_message("<span class='warning'>[user] starts bagging [M]!</span>")
	bagging = TRUE
	patient = M
	update_icon()
	bag_loop()

/obj/item/intubation_baloon/proc/bag_loop()
	if(!do_after(usr, rand(20, 30), src))
		bagging = FALSE
		update_icon()
		return
	var/obj/item/organ/internal/lungs/lungs = patient.internal_organs_by_name[O_LUNGS]
	lungs.handle_breath(1)
	if(bagging)
		bag_loop()
	else
		bagging = FALSE
		update_icon()

/obj/item/intubation_baloon/update_icon()
	if(!bagging)
		icon_state = "int_bag_idle"
	else
		icon_state = "int_bag_bagging"

/obj/machinery/lung_ventilator
	name = "lung ventilation system"
	desc = "Ventilators help a patient breathe by assisting the lungs to inhale and exhale air."
	icon = 'icons/obj/iv_drip.dmi'
	icon_state = "av_idle"
	var/respiratory_rate = 15
	var/respiratory_volume = 0.013
	var/mob/living/carbon/human/attached = null
	var/turned_on = FALSE

/obj/machinery/lung_ventilator/update_icon()
	if(!turned_on)
		icon_state = "av_idle"
	else
		icon_state = "av_pumping"

/obj/machinery/lung_ventilator/MouseDrop(over_object, src_location, over_location)
	..()
	if(!isliving(usr))
		return

	if(attached)
		visible_message("[attached] is detached from \the [src]")
		attached = null
		turned_on = FALSE
		update_icon()
		return

	if(in_range(src, usr) && ishuman(over_object) && get_dist(over_object, src) <= 1)
		var/mob/living/carbon/human/human = over_object
		if(!human.intubated)
			to_chat(usr, "<span class='warning'>\The [human] is not intubated!</span>")
			return
		visible_message("[usr] starts setting up \the [src] for attachment to \the [over_object].")
		if(!do_after(usr, 50, over_object))
			return
		visible_message("[usr] attaches \the [src] to the breathing tube in \the [over_object]'s mouth.")
		attached = over_object
		update_icon()
		if(!do_after(usr, 25, src))
			return
		visible_message("\the [src] beeps as \the [usr] sets up the necessary telemetry.")
		if(!do_after(usr, 40, src))
			return
		visible_message("[usr] configurates the [src].")
		turned_on = TRUE
		respiratory_rate = 15
		respiratory_volume = 0.013
		if(!do_after(usr, 15, src))
			return
		visible_message("[usr] finishes setting up \the [src].")

/obj/machinery/lung_ventilator/process()
	if(!attached)
		return

	var/obj/item/organ/internal/lungs/lungs = attached.internal_organs_by_name[O_LUNGS]

	if(!(get_dist(src, attached) <= 1 || !isturf(attached.loc)))
		visible_message("<span class='warning'>The [src] tube is violently ripped out of [attached]!</span>")
		var/affected = "head"
		attached.apply_damage(25, BRUTE, affected)
		lungs.take_damage(25, 1)
		attached.custom_pain("<span class='warning'>You feel like something was ripped straight out of your throat!</span>", 5, affecting = affected)
		attached = null
		turned_on = FALSE
		update_icon()
		return
	if(turned_on)
		lungs.handle_breath(1)
