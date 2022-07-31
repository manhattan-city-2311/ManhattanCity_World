GLOBAL_LIST_EMPTY(pagers)

/proc/send_pager_message(var/message, var/frequency)
	for(var/obj/item/pager/pager in GLOB.pagers)
		if(pager.frequency == frequency)
			pager.receive_communication(message)

/obj/item/pager
	name = "pager"
	desc = "A special device used for communication in emergencies."
	var/frequency = PAGER_FREQUENCY_DEFAULT
	var/turned_on = FALSE

/obj/item/pager/initialize()
	..()
	GLOB.pagers += src

/obj/item/pager/Destroy()
	GLOB.pagers -= src
	..()

/obj/item/pager/attack_self(mob/user)
	. = ..()
	var/message = sanitize(input("What to send?", "Pager communication"))
	send_communication(message)

/obj/item/pager/proc/receive_communication(message)
	var/mob/living/L = null
	if(loc && isliving(loc))
		L = loc

	to_chat(L, "[src] gets a message, '[message]'")

/obj/item/pager/proc/send_communication(message)
	for(var/obj/item/pager/pager in GLOB.pagers)
		if(pager.frequency == frequency)
			pager.receive_communication(message)

/obj/item/pager/verb/switch_frequency()
	set name = "Set frequency"
	var/newfrequency = input("Set the frequency", "Frequency setting") as null|num
	if(!newfrequency)
		return
	frequency = clamp(newfrequency, 100, initial(frequency))

/obj/item/pager/medical
	frequency = PAGER_FREQUENCY_DEFAULT