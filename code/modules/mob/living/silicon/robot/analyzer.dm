//
//Robotic Component Analyser, basically a health analyser for robots
//
/obj/item/device/robotanalyzer
	name = "cyborg analyzer"
	icon_state = "robotanalyzer"
	item_state = "analyzer"
	desc = "A hand-held scanner able to diagnose robotic injuries."
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEMSIZE_SMALL
	throw_speed = 5
	throw_range = 10
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 1, TECH_ENGINEERING = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 200)
	var/mode = 1;

/obj/item/device/robotanalyzer/attack(mob/living/M as mob, mob/living/user as mob)
	do_scan(M, user)

/obj/item/device/robotanalyzer/proc/do_scan(mob/living/M as mob, mob/living/user as mob)
	if((CLUMSY in user.mutations) && prob(50))
		user << text("<font color='red'>You try to analyze the floor's vitals!</font>")
		for(var/mob/O in viewers(M, null))
			O.show_message("<font color='red'>[user] has analyzed the floor's vitals!</font>", 1)
		user.show_message(SPAN_INFO("Analyzing Results for The floor:\n\t Overall Status: Healthy"), 1)
		user.show_message(SPAN_INFO("\t Damage Specifics: [0]-[0]-[0]-[0]"), 1)
		user.show_message(SPAN_INFO("Key: Suffocation/Toxin/Burns/Brute"), 1)
		user.show_message(SPAN_INFO("Body Temperature: ???"), 1)
		return

	var/scan_type
	if(istype(M, /mob/living/silicon/robot))
		scan_type = "robot"
	else if(istype(M, /mob/living/carbon/human))
		scan_type = "prosthetics"
	else
		to_chat(user, "<font color='red'>You can't analyze non-robotic things!</font>")
		return

	user.visible_message("<span class='notice'>\The [user] has analyzed [M]'s components.</span>","<span class='notice'>You have analyzed [M]'s components.</span>")
	switch(scan_type)
		if("robot")
			var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
			var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()
			user.show_message(SPAN_INFO("Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "fully disabled" : "[M.health - M.halloss]% functional"]"))
			user.show_message("\t Key: <font color='#FFA500'>Electronics</font>/<font color='red'>Brute</font>", 1)
			user.show_message("\t Damage Specifics: <font color='#FFA500'>[BU]</font> - <font color='red'>[BR]</font>")
			if(M.tod && M.stat == DEAD)
				user.show_message(SPAN_INFO("Time of Disable: [M.tod]"))
			var/mob/living/silicon/robot/H = M
			var/list/damaged = H.get_damaged_components(1,1,1)
			user.show_message(SPAN_INFO("Localized Damage:"),1)
			if(length(damaged)>0)
				for(var/datum/robot_component/org in damaged)
					user.show_message(text("<span class='info'>\t []: [][] - [] - [] - []</span>",	\
					capitalize(org.name),					\
					(org.installed == -1)	?	"<font color='red'><b>DESTROYED</b></font> "							:"",\
					(org.electronics_damage > 0)	?	"<font color='#FFA500'>[org.electronics_damage]</font>"	:0,	\
					(org.brute_damage > 0)	?	"<font color='red'>[org.brute_damage]</font>"							:0,		\
					(org.toggled)	?	"Toggled ON"	:	"<font color='red'>Toggled OFF</font>",\
					(org.powered)	?	"Power ON"		:	"<font color='red'>Power OFF</font>"),1)
			else
				user.show_message(SPAN_INFO("\t Components are OK."),1)
			if(H.emagged && prob(5))
				user.show_message("<font color='red'>\t ERROR: INTERNAL SYSTEMS COMPROMISED</font>",1)
			user.show_message(SPAN_INFO("Operating Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)"), 1)

		if("prosthetics")

			var/mob/living/carbon/human/H = M
			to_chat(user, "<span class='notice'>Analyzing Results for \the [H]:</span>")
			if(H.isSynthetic())
				to_chat(user, "System instability: <font color='green'>[H.getToxLoss()]</font>")
			to_chat(user, "Key: <font color='#FFA500'>Electronics</font>/<font color='red'>Brute</font>")
			to_chat(user, "<span class='notice'>External prosthetics:</span>")
			var/organ_found
			if(H.internal_organs_by_name.len)
				for(var/obj/item/organ/external/E in H.organs_by_name)
					if(!(E.robotic >= ORGAN_ROBOT))
						continue
					organ_found = 1
					to_chat(user, "[E.name]: <font color='red'>[E.brute_dam]</font> <font color='#FFA500'>[E.burn_dam]</font>")
			if(!organ_found)
				to_chat(user, "No prosthetics located.")
			to_chat(user, "<hr>")
			to_chat(user, "<span class='notice'>Internal prosthetics:</span>")
			organ_found = null
			if(H.internal_organs_by_name.len)
				for(var/obj/item/organ/O in H.internal_organs_by_name)
					if(!(O.robotic >= ORGAN_ROBOT))
						continue
					organ_found = 1
					to_chat(user, "[O.name]: <font color='red'>[O.damage]</font>")
			if(!organ_found)
				to_chat(user, "No prosthetics located.")

	src.add_fingerprint(user)
	return
