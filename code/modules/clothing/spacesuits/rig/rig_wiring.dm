/datum/wires/rig
	random = 1
	holder_type = /obj/item/weapon/rig
	wire_count = 5

#define RIG_AI_OVERRIDE 1
#define RIG_SYSTEM_CONTROL 2
#define RIG_INTERFACE_LOCK 4
#define RIG_INTERFACE_SHOCK 8
/*
 * Rig security can be snipped to disable ID access checks on rig.
 * Rig AI override can be pulsed to toggle whether or not the AI can take control of the suit.
 * System control can be pulsed to toggle some malfunctions.
 * Interface lock can be pulsed to toggle whether or not the interface can be accessed.
 */

/datum/wires/rig/UpdateCut(var/index, var/mended)
	var/obj/item/weapon/rig/rig = holder
	switch(index)
		if(RIG_INTERFACE_SHOCK)
			rig.electrified = mended ? 0 : -1
			rig.shock(usr,100)

/datum/wires/rig/UpdatePulsed(var/index)

	var/obj/item/weapon/rig/rig = holder
	switch(index)
		if(RIG_AI_OVERRIDE)
			rig.ai_override_enabled = !rig.ai_override_enabled
			rig.visible_message("A small red light on [rig] [rig.ai_override_enabled?"goes dead":"flickers on"].")
		if(RIG_SYSTEM_CONTROL)
			rig.malfunctioning += 10
			if(rig.malfunction_delay <= 0)
				rig.malfunction_delay = 20
			rig.shock(usr,100)
		if(RIG_INTERFACE_LOCK)
			rig.interface_locked = !rig.interface_locked
			rig.visible_message("\The [rig] clicks audibly as the software interface [rig.interface_locked?"darkens":"brightens"].")
		if(RIG_INTERFACE_SHOCK)
			if(rig.electrified != -1)
				rig.electrified = 30
			rig.shock(usr,100)

/datum/wires/rig/CanUse(var/mob/living/L)
	var/obj/item/weapon/rig/rig = holder
	if(rig.open)
		return 1
	return 0