GLOBAL_LIST_EMPTY(pagers)

/proc/send_pager_message(message, frequency)
	for(var/obj/item/pager/pager as anything in GLOB.pagers)
		if(pager.frequency == frequency)
			pager.receive_communication(message)

/obj/item/pager
	name = "pager"
	desc = "A special device used for communication in emergencies."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pager"
	var/frequency = PAGER_FREQUENCY_DEFAULT
	var/turned_on = FALSE

/obj/item/pager/initialize()
	. = ..()
	GLOB.pagers += src

/obj/item/pager/Destroy()
	. = ..()
	GLOB.pagers -= src

/obj/item/pager/attack_self(mob/user)
	var/message = input("What to send?", "Pager communication") as text|null

	if(!message)
		return
		
	send_communication(sanitize(message))

/obj/item/pager/proc/receive_communication(message)
	if(isliving(loc))
		to_chat(loc, SPAN_NOTICE("[src] beeps as receives message: '[message]'"))

/obj/item/pager/proc/send_communication(message)
	for(var/obj/item/pager/pager in GLOB.pagers)
		if(pager.frequency == frequency)
			pager.receive_communication(message)

/obj/item/pager/verb/switch_frequency()
	set name = "Set frequency"
	var/newfrequency = input("Set the frequency", "Frequency setting") as num|null
	if(!newfrequency)
		return
	frequency = clamp(newfrequency, 100, initial(frequency))

/obj/item/pager/medical
	frequency = PAGER_FREQUENCY_MEDICAL
