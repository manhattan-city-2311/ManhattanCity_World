/obj/machinery/acm
	name = "cardiopulmonary bypass machine"
	icon = 'icons/obj/iv_drip.dmi'
	icon_state = "cpb_idle"
	anchored = 0
	density = 0
	var/mob/living/carbon/human/attached = null
	var/obj/item/weapon/tank/oxygen_tank = null

	var/setting = NORMAL_MCV // mcv add rate.

	var/pumping_blood = FALSE
	var/oxygenating_blood = FALSE

/obj/machinery/acm/update_icon()
	if(pumping_blood)
		icon_state = "cpb_pumping"
	else
		icon_state = "cpb_idle"

/obj/machinery/acm/MouseDrop(over_object, src_location, over_location)
	..()
	if(!isliving(usr))
		return

	if(attached)
		visible_message("[attached] is detached from \the [src]")
		attached = null
		pumping_blood = FALSE
		oxygenating_blood = FALSE
		update_icon()
		return

	if(in_range(src, usr) && ishuman(over_object) && get_dist(over_object, src) <= 1)
		visible_message("[usr] starts setting up \the [src] for attachment to \the [over_object].")
		if(!do_after(usr, 50, over_object))
			return
		visible_message("[usr] attaches \the [src] tubes to the aorta in \the [over_object]'s chest cavity.")
		attached = over_object
		update_icon()
		if(!do_after(usr, 25, src))
			return
		visible_message("\the [src] beeps as \the [usr] sets up the necessary telemetry.")
		if(!do_after(usr, 10, src))
			return
		visible_message("[usr] switches on the blood pump.")
		pumping_blood = TRUE
		if(!do_after(usr, 10, src))
			return
		visible_message("[usr] turns on the artificial blood oxygenation.")
		oxygenating_blood = TRUE
		if(!do_after(usr, 15, src))
			return
		visible_message("[usr] finishes setting up the [src].")


/obj/machinery/acm/process()
	set background = 1

	if(!attached)
		return

	if(!(get_dist(src, attached) <= 1 && isturf(attached.loc)))
		visible_message("<span class='warning'>The [src] tubes are violently ripped out of [attached]!</span>")
		var/affected = "chest"
		attached:apply_damage(65, BRUTE, affected)
		attached.custom_pain("<span class='warning'>You feel like something was ripped straight out of your chest!</span>", 1, affecting = affected)
		attached = null
		pumping_blood = FALSE
		oxygenating_blood = FALSE
		update_icon()
		return
	if(pumping_blood)
		attached.mcv_add += setting
		if(prob(10))
			attached.custom_pain("<span class='warning'>Some strange tubes pump blood in and out of your body, it's weird!</span>", 1, affecting = "chest")
	if(oxygenating_blood && oxygen_tank.air_contents.remove(0.0005))
		var/obj/item/organ/internal/lungs/L = attached?.internal_organs_by_name[O_LUNGS]
		L.handle_breath()


/obj/machinery/acm/attack_hand(mob/user)
	. = ..()
