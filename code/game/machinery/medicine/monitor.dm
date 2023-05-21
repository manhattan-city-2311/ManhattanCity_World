/obj/machinery/monitor
	name = "\improper Heart monitor"
	icon = 'icons/obj/medicine.dmi'
	icon_state = "monitor"
	anchored = FALSE
	density = FALSE
	var/mob/living/carbon/human/attached

/obj/machinery/monitor/MouseDrop(mob/living/carbon/human/over_object, src_location, over_location)
	if(!CanMouseDrop(over_object))
		return

	if(attached)
		visible_message("\The [attached] is taken off \the [src]")
		attached = null
	else if(over_object)
		if(!ishuman(over_object))
			return
		if(!do_after(usr, 30, over_object))
			return
		visible_message("\The [usr] connects \the [over_object] up to \the [src].")
		attached = over_object
		START_PROCESSING(SSobj, src)

	update_icon()

/obj/machinery/monitor/Destroy()
	STOP_PROCESSING(SSobj, src)
	attached = null
	. = ..()

/obj/machinery/monitor/update_icon()
	overlays.Cut()
	if(!attached)
		icon_state = "monitor"
		return

	var/obj/item/organ/internal/heart/H = attached.internal_organs_by_name[O_HEART]

	if(!H)
		icon_state = "monitor-asystole"
		return

	var/datum/arrythmia/owa = H.get_ow_arrythmia()
	if(owa)
		icon_state = "monitor-[owa.id]"
	else
		switch(H.pulse)
			if(NEGATIVE_INFINITY to 1)
				icon_state = "monitor-asystole"
			if(1 to 40)
				icon_state = "monitor-normal0"
			if(40 to 90)
				icon_state = "monitor-normal1"
			if(90 to 140)
				icon_state = "monitor-normal2"
			if(140 to 190)
				icon_state = "monitor-normal3"
			if(190 to POSITIVE_INFINITY)
				icon_state = "monitor-normal4"

	if(attached.mpressure < BLOOD_PRESSURE_L2BAD || attached.mpressure > BLOOD_PRESSURE_H2BAD)
		overlays += image(icon, "monitor-r")
	if(attached.get_blood_saturation() < 0.80)
		overlays += image(icon, "monitor-c")
	if(attached.get_blood_perfusion() < 0.7)
		overlays += image(icon, "monitor-y")

/obj/machinery/monitor/process()
	if(!attached)
		return PROCESS_KILL
	if(!(attached in range(get_turf(src), 1)))
		attached = null
		return PROCESS_KILL

	update_icon()

/obj/machinery/monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!attached)
		return
	var/obj/item/organ/internal/heart/H = attached?.internal_organs_by_name[O_HEART]
	var/list/data = list()
	data["name"] = "[attached]"
	if(H)
		data["hr"] = H.pulse
		data["rythme"] = H.get_rythme_fluffy()
	else
		data["hr"] = "UNKNOWN"
	data["bp"] = attached.get_blood_pressure_fluffy()
	var/mPressure = attached.mpressure
	if(NEGATIVE_INFINITY <= mPressure && mPressure <= BLOOD_PRESSURE_L2BAD)
		data["bp_s"] = "bad"
	if(BLOOD_PRESSURE_L2BAD <= mPressure && mPressure <= (BLOOD_PRESSURE_NORMAL - 30))
		data["bp_s"] = "average"
	if(BLOOD_PRESSURE_HBAD <= mPressure && mPressure <= BLOOD_PRESSURE_H2BAD)
		data["bp_s"] = "average"
	if(BLOOD_PRESSURE_H2BAD <= mPressure && mPressure <= POSITIVE_INFINITY)
		data["bp_s"] = "bad"

	switch(attached.get_blood_perfusion())
		if(0 to 0.6)
			data["perfusion_s"] = "bad"
		if(0.6 to 0.8)
			data["perfusion_s"] = "average"
	//if(H)
		//data["ischemia"] = H.ischemia
	data["saturation"] = round(min(attached.get_blood_saturation() * 100, 99))
	data["perfusion"] = round(attached.get_blood_perfusion() * 100)
	data["status"] = (attached.stat == CONSCIOUS) ? "CONSCIOUS" : "UNCONSCIOUS"

	data["ecg"] = list()

	var/obj/item/organ/internal/brain/brain = attached.internal_organs_by_name[O_BRAIN]
	if(attached.stat == DEAD || !brain)
		data["ecg"] += list("Neurological activity not present")
	else
		data["ecg"] += list("Neurological system activity: [100 - round(100 * CLAMP01(brain.damage / brain.max_damage))]% of normal")

	//if(H.ischemia)
	//	data["ecg"] += list("Ischemia [round(H.ischemia, 0.5)]%")
	data["ecg"] += list("GVR: [round(attached.gvr)] N·s·m<sup>-5</sup>")
	data["ecg"] += list("MCV: [round(attached.mcv)/1000] L/m")
	data["ecg"] += list("CO: [H.pulse ? round(attached.get_cardiac_output()) : "?"] ml")

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "monitor.tmpl", "Monitor", 450, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

/obj/machinery/monitor/attack_hand(mob/user)
	ui_interact(user)
/obj/machinery/monitor/examine(mob/user)
	ui_interact(user)
