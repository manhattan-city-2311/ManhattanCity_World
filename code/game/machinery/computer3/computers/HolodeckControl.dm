/obj/machinery/computer3/HolodeckControl
	default_prog = /datum/file/program/holodeck


// Todo: I personally would like to add a second holodeck in the theater for making appropriate playgrounds.
// perhaps a holodeck association keyfile?
// One more thing while I'm here
// C3 allows multiple computers to run this program, but it was designed on the assumption that only one would, ever
// I am not going to add or remove anything right now, I'm just porting it


/datum/file/program/holodeck
	name = "Holodeck Control Console"
	desc = "Used to control a nearby holodeck."
	active_state = "holocontrol"
	var/area/linkedholodeck = null
	var/area/target = null
	var/active = 0
	var/list/holographic_items = list()
	var/damaged = 0
	var/last_change = 0
	var/emagged = 0


/datum/file/program/holodeck/interact()
	if(!interactable())
		return
	var/dat = "<h3>Current Loaded Programs</h3>"
	dat += "<A href='?src=\ref[src];emptycourt'>((Empty Court))</A><BR>"
	dat += "<A href='?src=\ref[src];boxingcourt'>((Boxing Court))</A><BR>"
	dat += "<A href='?src=\ref[src];basketball'>((Basketball Court))</A><BR>"
	dat += "<A href='?src=\ref[src];thunderdomecourt'>((Thunderdome Court))</A><BR>"
	dat += "<A href='?src=\ref[src];beach'>((Beach))</A><BR>"
//	dat += "<A href='?src=\ref[src];turnoff'>((Shutdown System))</A><BR>"

	dat += "<span class='notice'>Please ensure that only holographic weapons are used in the holodeck if a combat simulation has been loaded.</span><BR>"

	if(emagged)
		dat += "<A href='?src=\ref[src];burntest'>(<font color=red>Begin Atmospheric Burn Simulation</font>)</A><BR>"
		dat += "Ensure the holodeck is empty before testing.<BR>"
		dat += "<BR>"
		dat += "<A href='?src=\ref[src];wildlifecarp'>(<font color=red>Begin Wildlife Simulation</font>)</A><BR>"
		dat += "Ensure the holodeck is empty before testing.<BR>"
		dat += "<BR>"
		if(issilicon(usr))
			dat += "<A href='?src=\ref[src];AIoverride'>(<font color=green>Re-Enable Safety Protocols?</font>)</A><BR>"
		dat += "Safety Protocols are <font class='bad'>DISABLED</font><BR>"
	else
		if(issilicon(usr))
			dat += "<A href='?src=\ref[src];AIoverride'>(<font color=red>Override Safety Protocols?</font>)</A><BR>"
		dat += "<BR>"
		dat += "Safety Protocols are <font class='good'>ENABLED</font><BR>"

	popup.set_content(dat)
	popup.open()
	return

/datum/file/program/holodeck/Topic(var/href, var/list/href_list)
	if(!interactable() || ..(href,href_list))
		return

	if("emptycourt" in href_list)
		target = locate(/area/holodeck/source_emptycourt)
		if(target)
			loadProgram(target)

	else if("boxingcourt" in href_list)
		target = locate(/area/holodeck/source_boxingcourt)
		if(target)
			loadProgram(target)

	else if("basketball" in href_list)
		target = locate(/area/holodeck/source_basketball)
		if(target)
			loadProgram(target)

	else if("thunderdomecourt" in href_list)
		target = locate(/area/holodeck/source_thunderdomecourt)
		if(target)
			loadProgram(target)

	else if("beach" in href_list)
		target = locate(/area/holodeck/source_beach)
		if(target)
			loadProgram(target)

	else if("turnoff" in href_list)
		target = locate(/area/holodeck/source_plating)
		if(target)
			loadProgram(target)

	else if("burntest" in href_list)
		if(!emagged)
			return
		target = locate(/area/holodeck/source_burntest)
		if(target)
			loadProgram(target)

	else if("wildlifecarp" in href_list)
		if(!emagged)
			return
		target = locate(/area/holodeck/source_wildlife)
		if(target)
			loadProgram(target)

	else if("AIoverride" in href_list)
		if(!issilicon(usr))
			return
		emagged = !emagged
		if(emagged)
			message_admins("[key_name_admin(usr)] overrode the holodeck's safeties")
			log_game("[key_name(usr)] overrided the holodeck's safeties")
		else
			message_admins("[key_name_admin(usr)] restored the holodeck's safeties")
			log_game("[key_name(usr)] restored the holodeck's safeties")

	interact()
	return

/datum/file/program/holodeck/Reset()
	emergencyShutdown()

/datum/file/program/holodeck/process()
	if(active)
		if(!checkInteg(linkedholodeck))
			damaged = 1
			target = locate(/area/holodeck/source_plating)
			if(target)
				loadProgram(target)
			active = 0
			for(var/mob/M in range(10,src))
				M.show_message("The holodeck overloads!")

			for(var/turf/T in linkedholodeck)
				if(prob(30))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(2, 1, T)
					s.start()
				T.ex_act(3)
				//T.hotspot_expose(1000,500,1)

		for(var/item in holographic_items)
			if(!(get_turf(item) in linkedholodeck))
				derez(item, 0)

/datum/file/program/holodeck/proc/derez(var/obj/obj , var/silent = 1)
	holographic_items.Remove(obj)

	if(obj == null)
		return

	if(isobj(obj))
		var/mob/M = obj.loc
		if(ismob(M))
			M.remove_from_mob(obj)

	if(!silent)
		var/obj/oldobj = obj
		obj.visible_message("The [oldobj.name] fades away!")
	qdel(obj)

/datum/file/program/holodeck/proc/checkInteg(var/area/A)
	for(var/turf/T in A)
		if(istype(T, /turf/space))
			return 0
	return 1

/datum/file/program/holodeck/proc/togglePower(var/toggleOn = 0)
	if(toggleOn)
		var/area/targetsource = locate(/area/holodeck/source_emptycourt)
		holographic_items = targetsource.copy_contents_to(linkedholodeck)

		spawn(30)
			for(var/obj/effect/landmark/L in linkedholodeck)
				if(L.name=="Atmospheric Test Start")
					spawn(20)
						var/turf/T = get_turf(L)
						var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
						s.set_up(2, 1, T)
						s.start()
						if(T)
							T.temperature = 5000
							//T.hotspot_expose(50000,50000,1)
		active = 1
	else
		for(var/item in holographic_items)
			derez(item)
		var/area/targetsource = locate(/area/holodeck/source_plating)
		targetsource.copy_contents_to(linkedholodeck , 1)
		active = 0

/datum/file/program/holodeck/proc/loadProgram(var/area/A)
	if(world.time < (last_change + 25))
		if(world.time < (last_change + 15))//To prevent super-spam clicking, reduced process size and annoyance -Sieve
			return
		for(var/mob/M in range(3,src))
			M.show_message("<span class='warning'>ERROR. Recalibrating projetion apparatus.</span>")
			last_change = world.time
			return

	last_change = world.time
	active = 1

	for(var/item in holographic_items)
		derez(item)

	for(var/obj/effect/decal/cleanable/blood/B in linkedholodeck)
		qdel(B)

	for(var/mob/living/simple_mob/animal/space/carp/C in linkedholodeck)
		qdel(C)

	holographic_items = A.copy_contents_to(linkedholodeck , 1)

	if(emagged)
		for(var/obj/item/weapon/holo/esword/H in linkedholodeck)
			H.damtype = BRUTE

	spawn(30)
		for(var/obj/effect/landmark/L in linkedholodeck)
			if(L.name=="Atmospheric Test Start")
				spawn(20)
					var/turf/T = get_turf(L)
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(2, 1, T)
					s.start()
					if(T)
						T.temperature = 5000
						//T.hotspot_expose(50000,50000,1)
			if(L.name=="Holocarp Spawn")
				new /mob/living/simple_mob/animal/space/carp(L.loc)


/datum/file/program/holodeck/proc/emergencyShutdown()
	//Get rid of any items
	for(var/item in holographic_items)
		derez(item)
	//Turn it back to the regular non-holographic room
	target = locate(/area/holodeck/source_plating)
	if(target)
		loadProgram(target)

	var/area/targetsource = locate(/area/holodeck/source_plating)
	targetsource.copy_contents_to(linkedholodeck , 1)
	active = 0
