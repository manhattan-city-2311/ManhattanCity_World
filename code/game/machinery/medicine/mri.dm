#define MRI_SOUND_CHANNEL 630

GLOBAL_LIST_INIT(mri_attracted_items, typecacheof(list(
    /obj/item/stack/material/iron,
    /obj/item/stack/material/lead,
    /obj/item/stack/material/gold,
    /obj/item/stack/material/silver,
    /obj/item/stack/material/platinum,
    /obj/item/stack/material/steel,
    /obj/item/weapon/melee,
    /obj/item/weapon/gun,
	/obj/item/device/transfer_valve,
	/obj/item/weapon/grenade,
	/obj/item/ammo_casing,
	/obj/item/ammo_magazine
	)))

#define list_find(L, needle, LIMITS...) L.Find(needle, LIMITS)

/obj/machinery/mri
	name = "magnetic resonance imager"
	desc = "Магнитно-резонансный томограф. ПОСТОЯННО НАМАГНИЧЕН, БЕЗОПАСНАЯ ДИСТАНЦИЯ - 3 МЕТРА."
	icon = 'icons/obj/mri.dmi'
	icon_state = "mri"
	dir = NORTH
	density = TRUE
	var/obj/structure/mri_tray/connected = null
	anchored = TRUE
	var/last_process
	var/list/attracted = list()
	var/obj/machinery/mri_console/console
	var/operating = FALSE
	var/mob_has_marker = FALSE

/obj/machinery/mri/initialize()
	. = ..()
	for(var/obj/machinery/mri_console/new_console in range(5, src))
		console = new_console

/obj/machinery/mri/process()

	//last_process += 1
	//if(!last_process == 3)
	//    return
	attracted.Cut()
	for(var/mob/living/carbon/human/H in range(2, src))
		var/list/contents_check = H.GetAllContents()
		for(var/A in contents_check)
			if(is_type_in_typecache(A, GLOB.mri_attracted_items))
				attracted += H
				break
	for(var/obj/item/I in range(2, src))
		if(is_type_in_typecache(I, GLOB.mri_attracted_items))
			attracted += I
			break
	if(attracted.len)
		for(var/obj/A in attracted)
			A.throw_at(src, 1, 3)
			src.visible_message("<span class='warning'>\The [A] gets pulled by [src]!</span>")
		for(var/mob/living/carbon/human/H in attracted)
			H.throw_at(src, 3, 3)
			src.visible_message("<span class='warning'>\The [H] gets flung towards [src]!</span>")

/obj/machinery/mri/proc/start_scan()
	operating = TRUE
	var/mob/living/carbon/human/occupant
	for(var/mob/living/carbon/human/H in src.contents)
		occupant = H
	playsound(src, 'sound/effects/mri.ogg', 50, channel = MRI_SOUND_CHANNEL)
	sleep(630)
	if(!operating)
		return
	new /obj/item/weapon/paper(loc, generate_printing_text(occupant), "MRI scan report")
	src.visible_message("<span class='notice'>\The [src] finishes scanning and prints out a report.</span>")
	stop_scan()

/obj/machinery/mri/proc/stop_scan()
	operating = FALSE
	src << sound(null, repeat = 0, wait = 0, channel = MRI_SOUND_CHANNEL)

/obj/machinery/mri/proc/check_for_marker(var/mob/living/carbon/human/occupant)
	mob_has_marker = FALSE
	if(occupant.reagents.has_reagent("marker"))
		mob_has_marker = TRUE

/obj/machinery/mri/proc/generate_printing_text(var/mob/living/carbon/human/occupant)
	var/dat = ""
	check_for_marker()
	if(src)
		dat = "<font color='blue'><b>MRI Scan Results:</b></font><br>" //Blah obvious
		if(istype(occupant)) //is there REALLY someone in there?
			var/extra_font = null
			extra_font = "<font color=[occupant.getBruteLoss() < 60 ? "blue" : "red"]>"
			dat += "[extra_font]\t-Brute Damage %: [occupant.getBruteLoss()]</font><br>"

			extra_font = "<font color=[occupant.getFireLoss() < 60 ? "blue" : "red"]>"
			dat += "[extra_font]\t-Burn Severity %: [occupant.getFireLoss()]</font><br>"

			dat += "<hr>"

			if(occupant.has_brain_worms())
				dat += "Large growth detected in frontal lobe, possibly cancerous. Surgical removal is recommended.<br>"

			if(occupant.vessel && mob_has_marker)
				var/blood_volume = round(occupant.vessel.get_reagent_amount("blood"))
				var/blood_max = occupant.species.blood_volume
				var/blood_percent =  blood_volume / blood_max
				blood_percent *= 100
				extra_font = "<font color=[blood_volume > 448 ? "blue" : "red"]>"
				dat += "[extra_font]\tBlood Level %: [blood_percent] ([blood_volume] units)</font><br>"
			else
				extra_font = "<font color=red>"
				dat += "[extra_font]\tNo blood marker found.</font><br>"

			dat += "<hr><table border='1'>"
			dat += "<tr>"
			dat += "<th>Organ</th>"
			dat += "<th>Burn Damage</th>"
			dat += "<th>Brute Damage</th>"
			dat += "<th>Other Wounds</th>"
			dat += "</tr>"

			for(var/obj/item/organ/external/e in occupant.organs_by_name)
				dat += "<tr>"
				var/AN = ""
				var/open = ""
				var/infected = ""
				var/robot = ""
				var/imp = ""
				var/bled = ""
				var/splint = ""
				var/internal_bleeding = ""
				var/lung_ruptured = ""
				var/o_dead = ""
				for(var/datum/wound/W in e.wounds) if(W.internal)
					internal_bleeding = "<br>Internal bleeding"
					break
				if(istype(e, /obj/item/organ/external/chest) && occupant.is_lung_ruptured())
					lung_ruptured = "Lung ruptured:"
				if(e.status & ORGAN_BLEEDING)
					bled = "Bleeding:"
				if(e.robotic >= ORGAN_ROBOT)
					robot = "Prosthetic:"
				if(e.status & ORGAN_DEAD)
					o_dead = "Necrotic:"
				if(e.open)
					open = "Open:"
				switch (e.germ_level)
					if (INFECTION_LEVEL_ONE to INFECTION_LEVEL_ONE + 200)
						infected = "Mild Infection:"
					if (INFECTION_LEVEL_ONE + 200 to INFECTION_LEVEL_ONE + 300)
						infected = "Mild Infection+:"
					if (INFECTION_LEVEL_ONE + 300 to INFECTION_LEVEL_ONE + 400)
						infected = "Mild Infection++:"
					if (INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO + 200)
						infected = "Acute Infection:"
					if (INFECTION_LEVEL_TWO + 200 to INFECTION_LEVEL_TWO + 300)
						infected = "Acute Infection+:"
					if (INFECTION_LEVEL_TWO + 300 to INFECTION_LEVEL_THREE - 50)
						infected = "Acute Infection++:"
					if (INFECTION_LEVEL_THREE -49 to INFINITY)
						infected = "Gangrene Detected:"

				var/unknown_body = 0

				if(unknown_body)
					imp += "Unknown body present:"
				if(!AN && !open && !infected & !imp)
					AN = "None:"
				if(!(e.status))
					dat += "<td>[e.name]</td><td>[e.burn_dam]</td><td>[e.brute_dam]</td><td>[robot][bled][AN][splint][open][infected][imp][internal_bleeding][lung_ruptured][o_dead]</td>"
				else
					dat += "<td>[e.name]</td><td>-</td><td>-</td><td>Not Found</td>"
				dat += "</tr>"
			for(var/obj/item/organ/internal/i in occupant.internal_organs_by_name)
				var/mech = ""
				var/i_dead = ""
				if(i.status & ORGAN_ASSISTED)
					mech = "Assisted:"
				if(i.robotic >= ORGAN_ROBOT)
					mech = "Mechanical:"
				if(i.status & ORGAN_DEAD)
					i_dead = "Necrotic:"
				var/infection = "None"
				switch (i.germ_level)
					if (INFECTION_LEVEL_ONE to INFECTION_LEVEL_ONE + 200)
						infection = "Mild Infection:"
					if (INFECTION_LEVEL_ONE + 200 to INFECTION_LEVEL_ONE + 300)
						infection = "Mild Infection+:"
					if (INFECTION_LEVEL_ONE + 300 to INFECTION_LEVEL_ONE + 400)
						infection = "Mild Infection++:"
					if (INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO + 200)
						infection = "Acute Infection:"
					if (INFECTION_LEVEL_TWO + 200 to INFECTION_LEVEL_TWO + 300)
						infection = "Acute Infection+:"
					if (INFECTION_LEVEL_TWO + 300 to INFECTION_LEVEL_THREE - 50)
						infection = "Acute Infection++:"
					if (INFECTION_LEVEL_THREE -49 to INFINITY)
						infection = "Necrosis Detected:"

				dat += "<tr>"
				dat += "<td>[i.name]</td><td>N/A</td><td>[i.damage]</td><td>[infection]:[mech][i_dead]</td><td></td>"
				dat += "</tr>"
			dat += "</table>"
			if(occupant.sdisabilities & BLIND)
				dat += "<font color='red'>Cataracts detected.</font><BR>"
			if(occupant.disabilities & NEARSIGHTED)
				dat += "<font color='red'>Retinal misalignment detected.</font><BR>"
		else
			dat += "\The [src] is empty."
	else
		dat = "<font color='red'> Error: No MRI detected.</font>"

	return dat

/obj/machinery/mri/Destroy()
	if(connected)
		qdel(connected)
		connected = null
	return ..()

/obj/machinery/mri/attack_hand(mob/user)
	if(operating)
		to_chat(user, "<span class='warning'>\The [src] is currently operating, it's unsafe to stop it now!</span>")
		return
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.connected.loc)
			if (!( A.anchored ))
				A.forceMove(src)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		qdel(src.connected)
		src.connected = null
		user.visible_message("<span class='warning'>\The [user] switches the [src] on, it winds up and starts the scan!</span>")
		start_scan()
	else
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		src.connected = new /obj/structure/mri_tray( src.loc )
		step(src.connected, NORTH)
		var/turf/T = get_step(src, NORTH)
		if (list_find(T.contents, src.connected))
			src.connected.connected = src
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.connected.loc)
			src.connected.set_dir(NORTH)
		else
			qdel(src.connected)
			src.connected = null
	src.add_fingerprint(user)
	return

/obj/machinery/mri/relaymove(mob/user as mob)
	if(operating)
		to_chat(user, "<span class='warning'>\The [src] is currently operating, it's unsafe to stop it now!</span>")
		return
	if (user.stat)
		return
	src.connected = new /obj/structure/mri_tray( src.loc )
	step(src.connected, NORTH)
	var/turf/T = get_step(src, NORTH)
	if (list_find(T.contents, src.connected))
		src.connected.connected = src
		for(var/atom/movable/A as mob|obj in src)
			A.forceMove(src.connected.loc)
	else
		qdel(src.connected)
		src.connected = null
	return

/obj/structure/mri_rail
	name = "mri rail"
	icon = 'icons/obj/medicine.dmi'
	icon_state = "mri_rail"
	density = 0
	anchored = TRUE

/obj/structure/mri_tray
	name = "mri tray"
	desc = "Apply patient before closing."
	icon = 'icons/obj/medicine.dmi'
	icon_state = "mri_seat"
	density = TRUE
	layer = BELOW_MOB_LAYER
	var/obj/machinery/mri/connected = null
	anchored = TRUE
	throwpass = 1

/obj/structure/mri_tray/Destroy()
	if(connected && connected.connected == src)
		connected.connected = null
	connected = null
	return ..()

/obj/structure/mri_tray/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.loc)
			if (!( A.anchored ))
				A.forceMove(src.connected)
		src.connected.connected = null
		//src.connected.update()
		add_fingerprint(user)
		//SN src = null
		qdel(src)
		return
	return

/obj/structure/mri_tray/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || list_find(user.contents, src) || list_find(user.contents, O)))
		return
	if (!ismob(O) && !istype(O, /obj/structure/closet/body_bag))
		return
	if (!ismob(user) || user.stat || user.lying || user.stunned)
		return
	O.forceMove(src.loc)
	if (user != O)
		for(var/mob/B in viewers(user, 3))
			if ((B.client && !( B.blinded )))
				to_chat(B, "<span class='warning'>\The [user] places [O] onto [src]!</span>")
	return



/obj/machinery/mri_console
	name = "magnetic resonance imager console"