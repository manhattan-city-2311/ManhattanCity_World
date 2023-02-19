/obj/machinery/defibrillator
	name = "manual external defibrillator"
	desc = "A very expensive and fragile device that are capable of defibrillation, cardioversion and heart pacing."
	icon = 'icons/obj/medicine.dmi'
	icon_state = "defib_machine"
	var/mode = "Defibrillation" //defibrillation, cardioversion, pacing

	var/joule_setting = 240

	var/shock_charged = FALSE

	var/pace_rate = 60
	var/pace_sync = FALSE
	var/pacing = FALSE

	var/obj/item/clothing/suit/electrode_pads/pads = new

	var/list/options = list()

/obj/machinery/defibrillator/process()
	if(pacing && pace_sync && pads)
		var/obj/item/organ/internal/heart/heart = pads.attached.internal_organs_by_name[O_HEART]
		heart.cpr += pace_rate
		playsound(get_turf(src), "bodyfall", 25, 1)

/obj/machinery/defibrillator/proc/announce(var/message)
	visible_message("<span class='notice'>[src] [pick("rattles", "dictates", "buzzes")]: [message]</span>")

/obj/machinery/defibrillator/proc/determine_shock_power(var/mode) //1 for defib, 2 for cardiovert
	if(mode == 1)
		joule_setting = pads.attached.weight * 4
	else
		joule_setting = round(pads.attached.weight * 0.75)
	announce("Shock power determined: [joule_setting].")

/obj/machinery/defibrillator/proc/deliver_shock(mob/user)
	if(!pads)
		announce("Resistance threshold met, check the pads connection.")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		shock_charged = FALSE
		return
	if(!pads.attached)
		announce("Unable to administer shock, check connection to the patient.")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		shock_charged = FALSE
		return
	if(pads.used)
		announce("Shock pads cannot provide enough surface contact, replace them with new ones.")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		shock_charged = FALSE
		return
	if(!user.skill_check(SKILL_MEDICAL, SKILL_AMATEUR))
		to_chat(user,"<span class='warning'>You don't know what to do with it!</span>")
		return

	visible_message("<span class='warning'>The [src] weeps: STAND BACK FROM THE PATIENT!</span>")
	sleep(20)
	pads.attached.visible_message("<span class='warning'>\The [pads.attached]'s body convulses violently!</span>")
	playsound(get_turf(src), "bodyfall", 50, 1)
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 50, 1, -1)
	pads.attached.apply_damage(rand(5, 20), BURN, BP_TORSO)
	//playsound(get_turf(src), 'sound/machines/defib_success.ogg', 50, 0)
	var/obj/item/organ/internal/heart/heart = pads.attached.internal_organs_by_name[O_HEART]
	if(pads.attached.is_vfib())
		heart.get_ow_arrythmia()?.weak(heart)
	else if(!pads.attached.is_asystole())
		heart.make_common_arrythmia(1)
	heart.cpr += rand(80, 120)
	shock_charged = FALSE
	log_and_message_admins("used \a [src] to electrocute [key_name(pads.attached)].")


/obj/machinery/defibrillator/proc/charge(mob/user)
	user.visible_message("<span class='notice'>\The [user] charges [src].</span>", "<span class='notice'>You charge the [src].</span>")
	playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)
	spawn(20)
		shock_charged = TRUE
		announce("Unit charged. Please administer shock.")

/obj/machinery/defibrillator/proc/cardiovert()
	if(!pads)
		announce("Resistance threshold met, check the pads connection.")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		shock_charged = FALSE
		return
	if(!pads.attached)
		announce("Unable to administer shock, check connection to the patient.")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		shock_charged = FALSE
		return
	if(pads.used)
		announce("Shock pads cannot provide enough surface contact, replace them with new ones.")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		shock_charged = FALSE
		return

	visible_message("<span class='warning'>The [src] weeps: STAND BACK FROM THE PATIENT!</span>")
	sleep(20)
	pads.attached.visible_message("<span class='notice'>\The [pads.attached]'s body convulses slightly.</span>")
	playsound(get_turf(src), "bodyfall", 50, 1)
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 50, 1, -1)
	pads.attached.apply_damage(rand(1, 5), BURN, BP_TORSO)
	//playsound(get_turf(src), 'sound/machines/defib_success.ogg', 50, 0)
	var/obj/item/organ/internal/heart/heart = pads.attached.internal_organs_by_name[O_HEART]
	heart.pulse_modificators["defibrillation"] = rand(20, 40)
	shock_charged = FALSE
	if(ARRYTHMIA_AFIB in heart.arrythmias)
		heart.arrythmias[ARRYTHMIA_AFIB].weak(heart)
	if(ARRYTHMIA_TACHYCARDIA in heart.arrythmias)
		heart.arrythmias[ARRYTHMIA_TACHYCARDIA].weak(heart)
	if(ARRYTHMIA_EXTRASYSTOLIC in heart.arrythmias)
		heart.arrythmias[ARRYTHMIA_EXTRASYSTOLIC].weak(heart)

/obj/machinery/defibrillator/proc/change_pacing_rate(mob/user)
	var/pace_rate_new = input(user, "Select a pacing rate in beats per minute", "Pacing rate") as null|num
	pace_rate = clamp(pace_rate_new, 1, 300)
	user.visible_message("<span class='notice'>\The [user] changed the pacing rate of [src] to [pace_rate].</span>", "<span class='warning'>You change the pace rate of [src] to [pace_rate].</span>")

/obj/machinery/defibrillator/proc/sync_pacer()
	announce("Beginning pacer synchronization...")
	sleep(rand(20, 100))
	announce("Pacer synchronization complete. Automatic pacing startup...")
	pace_sync = TRUE
	sleep(10)
	pacing = TRUE
	announce("Pacing starting at a rate of [pace_rate].")

/obj/machinery/defibrillator/proc/switch_mode(mob/user)
	var/new_mode = input(user, "Which mode to switch to?", "Mode switching") as null|anything in list("Defibrillation", "Cardioversion", "Pacing")
	if(!new_mode)
		return

	shock_charged = FALSE
	pacing = FALSE
	pace_sync = FALSE
	mode = new_mode
	announce("Mode switched to: [new_mode].")

/obj/machinery/defibrillator/proc/detach_pads(mob/user)
	pads.forceMove(src.loc)
	pads = null
	user.visible_message("<span class='notice'>\The [user] removes the [src] pads.</span>", "<span class='warning'>You remove the defibrillator pads.</span>")

/obj/machinery/defibrillator/attack_hand(mob/user)
	. = ..()
	if(pads && pads.taken_out == FALSE)
		pads.taken_out = TRUE
		pads.loc = user.loc
		user.put_in_active_hand(pads)
		user.visible_message("<span class='notice'>\The [user] takes out the [src] pads.</span>", "<span class='warning'>You take out the defibrillator pads.</span>")
		return

	options.Cut()
	options += "Switch mode"
	if(pads)
		options += "Disconnect pads"
	switch(mode)
		if("Defibrillation")
			if(shock_charged)
				options += "Deliver shock"
			else
				options += "Charge for shock"
				options += "Determine shock power"
		if("Cardioversion")
			if(shock_charged)
				options += "Cardiovert"
			else
				options += "Charge for shock"
				options += "Determine cardioversion power"
		if("Pacing")
			options += "Change pacing rate"
			if(!pace_sync)
				options += "Synchronize pacer"
			if(pacing)
				options += "Stop pacing"
			if(!pacing && pace_sync)
				options += "Start pacing"
	var/setting = input(user, "What to do?", "MED") as null|anything in options
	switch(setting)
		if("Deliver shock")
			deliver_shock()
		if("Charge for shock")
			charge(user)
		if("Determine shock power")
			determine_shock_power(1)
		if("Determine cardioversion power")
			determine_shock_power(2)
		if("Cardiovert")
			cardiovert()
		if("Change pacing rate")
			change_pacing_rate(user)
		if("Synchronize pacer")
			sync_pacer()
		if("Stop pacing")
			pacing = FALSE
			announce("Pacer shutdown, re-synchronization required.")
			pace_sync = FALSE
		if("Start pacing")
			pacing = TRUE
			announce("Pacing starting at a rate of [pace_rate].")
		if("Switch mode")
			switch_mode(user)
		if("Disconnect pads")
			detach_pads(user)

/obj/machinery/defibrillator/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/clothing/suit/electrode_pads))
		var/obj/item/clothing/suit/electrode_pads/P = W
		if(P == pads)
			if(ismob(pads.loc))
				var/mob/M = pads.loc
				if(M.drop_from_inventory(pads, src))
					to_chat(user, "<span class='notice'>\The [pads] snap back into the main unit.</span>")
			else
				pads.forceMove(src)
			P.taken_out = FALSE
			P.attached = null
		else
			if(pads)
				pads.forceMove(src.loc)
			pads = P
			user.visible_message("<span class='notice'>\The [user] replaces the [src] pads.</span>", "<span class='warning'>You replace the defibrillator pads.</span>")
		return
	. = ..()


/obj/item/clothing/suit/electrode_pads
	name = "electrode pads"
	desc = "Special single-use sticky pads used for delivering shocks in an emergency."
	icon = 'icons/obj/medicine.dmi'
	icon_state = "defib_pads"
	var/used = FALSE
	var/taken_out = FALSE
	var/mob/living/carbon/human/attached = null

/obj/item/clothing/suit/electrode_pads/examine(mob/user)
	..()
	if(used)
		to_chat(user, "It was used.")

/obj/item/clothing/suit/electrode_pads/equipped(mob/user)
	..()
	attached = user

/obj/item/clothing/suit/electrode_pads/dropped(mob/user)
	..()
	attached = null
