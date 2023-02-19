/obj/machinery/acm
	name = "cardiopulmonary bypass machine"
	icon = 'icons/obj/iv_drip.dmi'
	icon_state = "cpb_idle"
	anchored = 0
	density = 1
	var/mob/living/carbon/human/attached = null

	var/setting = NORMAL_MCV / 2 // mcv add rate.

	var/pumping_blood = FALSE
	var/oxygenating_blood = FALSE

	var/oxygen_setting = 50

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
		if(!do_after(usr, 25, src))
			return
		visible_message("\the [src] beeps as \the [usr] sets up the necessary telemetry.")
		if(!do_after(usr, 10, src))
			return
		visible_message("[usr] switches on the blood pump.")
		pumping_blood = TRUE
		update_icon()
		if(!do_after(usr, 10, src))
			return
		visible_message("[usr] turns on the artificial blood oxygenation.")
		oxygenating_blood = TRUE
		update_icon()
		if(!do_after(usr, 15, src))
			return
		visible_message("[usr] finishes setting up \the [src].")


/obj/machinery/acm/process()
	if(!attached)
		return

	if(!(get_dist(src, attached) <= 1 || !isturf(attached.loc)))
		visible_message("<span class='warning'>The [src] tubes are violently ripped out of [attached]!</span>")
		var/affected = "chest"
		attached.apply_damage(65, BRUTE, affected)
		attached.custom_pain("<span class='warning'>You feel like something was ripped straight out of your chest!</span>", 1, affecting = affected)
		attached = null
		pumping_blood = FALSE
		oxygenating_blood = FALSE
		update_icon()
		return
	if(pumping_blood)
		attached.mcv_add = max(setting, attached.mcv_add)
		if(prob(10))
			to_chat(attached, SPAN_DANGER("Some strange tubes pump blood in and out of your body, it's weird!"))
		if(prob(1))
			attached.internal_organs_by_name[O_HEART].make_common_arrythmia(rand(1,2))
	if(oxygenating_blood)
		attached.make_oxygen(oxygen_setting) // FIXME: possible overflow issues
		attached.remove_co2(oxygen_setting * 0.8)

/obj/machinery/acm/attack_hand(mob/user)
	var/setting = input(user, "Select a CPB setting", "Setting") as null|anything in list("Blood pumping", "Blood oxygenating", "Pumping setting")

	if(!setting)
		return
	
	switch(setting)
		if("Blood pumping")
			pumping_blood = !pumping_blood
			update_icon()
			visible_message("[icon2html(src, viewers(src))]\the [src] beeps as \the [usr] [pumping_blood ? "enables" : "disables"] blood pumping.")
		if("Blood oxygenating")
			oxygenating_blood = !oxygenating_blood
			update_icon()
			visible_message("[icon2html(src, viewers(src))]\the [src] beeps as \the [usr] [oxygenating_blood ? "enables" : "disables"] blood oxygenating.")
		if("Pumping setting")
			var/amount = input("Select pumping setting in mL/M", "Pumping setting") as null|num
			if(!amount)
				return
			
			amount = clamp(amount, 100, initial(setting))

			if(amount == setting)
				return 
	
			visible_message("[icon2html(src, viewers(src))]\the [src] beeps as \the [usr] [(amount > setting ? "increases" : "decreases")] blood pumping rate.")

			setting = amount 

	. = ..()
