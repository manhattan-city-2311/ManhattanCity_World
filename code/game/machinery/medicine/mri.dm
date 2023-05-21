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
	icon = 'icons/obj/mri.dmi'
	icon_state = "mri"
	density = TRUE
	var/obj/structure/mri_tray/connected = null
	anchored = TRUE
	var/last_process
	var/list/attracted = list()
	var/obj/machinery/mri_console/console
	var/operating = FALSE
	var/mob_has_marker = FALSE
	var/locked = FALSE

/obj/machinery/mri/initialize()
	. = ..()
	for(var/obj/machinery/mri_console/new_console in range(5, src))
		console = new_console
		console.mri = src

/obj/machinery/mri/proc/handle_sound()
	playsound(src, 'sound/effects/mri.ogg', 100, channel = MRI_SOUND_CHANNEL)
	spawn(630)
		if(!operating)
			handle_sound()

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
			visible_message("<span class='warning'>\The [A] gets pulled by [src]!</span>")
		for(var/mob/living/carbon/human/H in attracted)
			H.throw_at(src, 3, 3)
			visible_message("<span class='warning'>\The [H] gets flung towards [src]!</span>")

/obj/machinery/mri/proc/start_scan()
	operating = TRUE
	handle_sound()
	icon_state = "mri_active"

/obj/machinery/mri/proc/stop_scan()
	operating = FALSE
	src << sound(null, repeat = 0, wait = 0, channel = MRI_SOUND_CHANNEL)
	icon_state = "mri"

/obj/machinery/mri/proc/check_for_marker(var/mob/living/carbon/human/occupant)
	mob_has_marker = FALSE
	if(occupant.reagents.has_reagent("marker"))
		mob_has_marker = TRUE

/obj/machinery/mri/Destroy()
	if(connected)
		qdel(connected)
		connected = null
	return ..()

/obj/machinery/mri/attack_hand(mob/user)
	if(src.connected)
		for(var/atom/movable/A as mob|obj in src.connected.loc)
			if(!A.anchored)
				A.forceMove(src)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		qdel(src.connected)
		src.connected = null
	else
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		src.connected = new /obj/structure/mri_tray( src.loc )
		step(src.connected, SOUTH)
		var/turf/T = get_step(src, SOUTH)
		if(list_find(T.contents, src.connected))
			src.connected.connected = src
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.connected.loc)
			src.connected.set_dir(SOUTH)
		else
			qdel(src.connected)
			src.connected = null
	src.add_fingerprint(user)
	return

/obj/machinery/mri/relaymove(mob/user as mob)
	if(user.stat)
		return
	src.connected = new /obj/structure/mri_tray( src.loc )
	step(src.connected, SOUTH)
	var/turf/T = get_step(src, SOUTH)
	if(list_find(T.contents, src.connected))
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
	icon = 'icons/obj/mri.dmi'
	icon_state = "tray"
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
	if(src.connected)
		for(var/atom/movable/A as mob|obj in src.loc)
			if(!A.anchored)
				A.forceMove(src.connected)
		src.connected.connected = null
		//src.connected.update()
		add_fingerprint(user)
		//SN src = null
		qdel(src)
		return
	return

/obj/structure/mri_tray/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || list_find(user.contents, src) || list_find(user.contents, O)))
		return
	if(!ismob(O) && !istype(O, /obj/structure/closet/body_bag))
		return
	if(!ismob(user) || user.stat || user.lying || user.stunned)
		return
	O.forceMove(src.loc)
	visible_message("<span class='warning'>\The [user] places [O] onto [src]!</span>")
	return



/obj/machinery/mri_console
	name = "magnetic resonance imager console"
	desc = "Used in pair with MRI."
	icon = 'icons/obj/modular_laptop.dmi'
	icon_state = "hybrid-open"
	var/obj/machinery/mri/mri = null

/obj/machinery/mri_console/proc/ask_confirmation(mob/user, datum/mri_scan/scan)
	var/action = alert(src, "Are you sure you want to begin this scan? It will take [scan.time / 10] seconds.", "", "Yes", "No")
	if(action == "Yes")
		return 1
	else
		return 0

/obj/machinery/mri_console/attack_hand(mob/user)
	. = ..()
	if(!mri)
		return
	if(mri.operating)
		to_chat(user, "<span class='warning'>You stop the MRI.</span>")
		mri.stop_scan()
		return

	var/list/scans = list()
	for(var/T in subtypesof(/datum/mri_scan))
		var/datum/mri_scan/S = new T
		scans[S.name] = S
	var/setting = input(user, "Select a scan to perform.", "MRI scan") as null|anything in scans

	if(!setting)
		return
	if(!ask_confirmation(user, scans[setting]))
		return

	var/mob/living/carbon/human/occupant
	for(var/mob/living/carbon/human/newoccupant in mri.contents)
		occupant = newoccupant
	scans[setting].perform_scan(mri, src, occupant)


/datum/mri_scan
	var/name = ""
	var/time

/datum/mri_scan/proc/perform_scan(var/obj/machinery/mri/mri, var/obj/machinery/mri_console/mri_console, var/mob/living/carbon/human/occupant)
	mri.start_scan()
	spawn(time)
		if(!mri.operating)
			return
		mri.stop_scan()
		new /obj/item/weapon/paper(mri_console.loc, generate_printing_text(occupant), "[name]")

/datum/mri_scan/proc/generate_printing_text(var/mob/living/carbon/human/occupant)
	return

/datum/mri_scan/proc/format_header(var/mob/living/carbon/human/occupant)
	var/dat = ""
	dat += "<tr><td><strong>Scan Results For:</strong></td><td>[occupant.name]</td></tr>"
	dat += "<tr><td><strong>Scan performed at:</strong></td><td>[time_stamp()]</td></tr>"
	return dat

/datum/mri_scan/fullbodyexternal
	name = "Full external body scan"
	time = 1800

/datum/mri_scan/fullbodyexternal/generate_printing_text(var/mob/living/carbon/human/occupant)
	var/dat = ""
	dat += format_header(occupant)
	for(var/obj/item/organ/external/e in occupant.organs_by_name)
		dat += "<tr>"
		var/AN = ""
		var/open = ""
		var/infected = ""
		var/robot = ""
		var/imp = ""
		var/bled = ""
		var/splint = ""
		if(e.status & ORGAN_BLEEDING)
			bled = "Bleeding:"
		if(e.robotic >= ORGAN_ROBOT)
			robot = "Prosthetic:"
		if(e.open)
			open = "Open:"
		var/GL = e.germ_level
		if(INFECTION_LEVEL_ONE <= GL && GL <= (INFECTION_LEVEL_ONE + 200))
			infected = "Mild Infection:"
		if((INFECTION_LEVEL_ONE + 200) <= GL && GL <= (INFECTION_LEVEL_ONE + 300))
			infected = "Mild Infection+:"
		if((INFECTION_LEVEL_ONE + 300) <= GL && GL <= (INFECTION_LEVEL_ONE + 400))
			infected = "Mild Infection++:"
		if(INFECTION_LEVEL_TWO <= GL && GL <= (INFECTION_LEVEL_TWO + 200))
			infected = "Acute Infection:"
		if((INFECTION_LEVEL_TWO + 200) <= GL && GL <= (INFECTION_LEVEL_TWO + 300))
			infected = "Acute Infection+:"
		if((INFECTION_LEVEL_TWO + 300) <= GL && GL <= (INFECTION_LEVEL_THREE - 50))
			infected = "Acute Infection++:"
		if((INFECTION_LEVEL_THREE -49) <= GL && GL <= POSITIVE_INFINITY)
			infected = "Gangrene Detected:"

		var/unknown_body = 0

		if(unknown_body)
			imp += "Unknown body present:"
		if(!open && !infected && !imp)
			AN = "None:"
		if(!(e.status))
			dat += "<td>[e.name]</td><td>[e.burn_dam]</td><td>[e.brute_dam]</td><td>[robot][bled][AN][splint][open][infected][imp]</td>"
		else
			dat += "<td>[e.name]</td><td>-</td><td>-</td><td>Not Found</td>"
		dat += "</tr>"
	dat += "</table>"
	return dat

/datum/mri_scan/fullbodyinternal
	name = "Full internal body scan"
	time = 3000

/datum/mri_scan/fullbodyinternal/generate_printing_text(var/mob/living/carbon/human/occupant)
	var/dat = ""
	dat += format_header(occupant)
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
		var/GL = i.germ_level
		if(INFECTION_LEVEL_ONE <= GL && GL <= (INFECTION_LEVEL_ONE + 200))
			infection = "Mild Infection:"
		if((INFECTION_LEVEL_ONE + 200) <= GL && GL <= (INFECTION_LEVEL_ONE + 300))
			infection = "Mild Infection+:"
		if((INFECTION_LEVEL_ONE + 300) <= GL && GL <= (INFECTION_LEVEL_ONE + 400))
			infection = "Mild Infection++:"
		if(INFECTION_LEVEL_TWO <= GL && GL <= (INFECTION_LEVEL_TWO + 200))
			infection = "Acute Infection:"
		if((INFECTION_LEVEL_TWO + 200) <= GL && GL <= (INFECTION_LEVEL_TWO + 300))
			infection = "Acute Infection+:"
		if((INFECTION_LEVEL_TWO + 300) <= GL && GL <= (INFECTION_LEVEL_THREE - 50))
			infection = "Acute Infection++:"
		if((INFECTION_LEVEL_THREE -49) <= GL && GL <= POSITIVE_INFINITY)
			infection = "Necrosis Detected:"
		dat += "<tr>"
		dat += "<td>[i.name]</td><td>N/A</td><td>[i.damage]</td><td>[infection]:[mech][i_dead]</td><td></td>"
		dat += "</tr>"
	dat += "</table>"
	return dat

/datum/mri_scan/gastric
	name = "Gastric tract scan"
	time = 600
