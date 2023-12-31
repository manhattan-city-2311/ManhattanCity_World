/datum/wires/alarm
	holder_type = /obj/machinery/alarm
	wire_count = 5
	var/datum/wire_hint/lock_hint
	var/datum/wire_hint/power_hint
	var/datum/wire_hint/ai_control_hint

var/const/AALARM_WIRE_IDSCAN = 1
var/const/AALARM_WIRE_POWER = 2
var/const/AALARM_WIRE_SYPHON = 4
var/const/AALARM_WIRE_AI_CONTROL = 8
var/const/AALARM_WIRE_AALARM = 16

/datum/wires/alarm/make_wire_hints()
	lock_hint = new("The Air Alarm is locked.", "The Air Alarm is unlocked.")
	power_hint = new("The Air Alarm is offline.", "The Air Alarm is working properly!")
	ai_control_hint = new("The 'AI control allowed' light is off.", "The 'AI control allowed' light is on.")

/datum/wires/alarm/Destroy()
	lock_hint = null
	power_hint = null
	ai_control_hint = null
	return ..()

/datum/wires/alarm/CanUse(var/mob/living/L)
	var/obj/machinery/alarm/A = holder
	if(A.panel_open)
		return 1
	return 0

/datum/wires/alarm/GetInteractWindow()
	var/obj/machinery/alarm/A = holder
	. += ..()
	. += lock_hint.show(A.locked)
	. += power_hint.show(A.shorted || (A.stat & (NOPOWER|BROKEN)))
	. += ai_control_hint.show(A.aidisabled)

/datum/wires/alarm/UpdateCut(var/index, var/mended)
	var/obj/machinery/alarm/A = holder
	switch(index)
		if(AALARM_WIRE_IDSCAN)
			if(!mended)
				A.locked = 1
				//to_world("Idscan wire cut")

		if(AALARM_WIRE_POWER)
			A.shock(usr, 50)
			A.shorted = !mended
			A.update_icon()
			//to_world("Power wire cut")

		if (AALARM_WIRE_AI_CONTROL)
			if (A.aidisabled == !mended)
				A.aidisabled = mended
				//to_world("AI Control Wire Cut")

		if(AALARM_WIRE_SYPHON)
			if(!mended)
				A.mode = 3 // AALARM_MODE_PANIC
				A.apply_mode()
				//to_world("Syphon Wire Cut")

		if(AALARM_WIRE_AALARM)
			if (A.alarm_area.atmosalert(2, A))
				A.post_alert(2)
			A.update_icon()

/datum/wires/alarm/UpdatePulsed(var/index)
	var/obj/machinery/alarm/A = holder
	switch(index)
		if(AALARM_WIRE_IDSCAN)
			A.locked = !A.locked
		//	to_world("Idscan wire pulsed")

		if (AALARM_WIRE_POWER)
		//	to_world("Power wire pulsed")
			if(A.shorted == 0)
				A.shorted = 1
				A.update_icon()

			spawn(12000)
				if(A.shorted == 1)
					A.shorted = 0
					A.update_icon()


		if (AALARM_WIRE_AI_CONTROL)
		//	to_world("AI Control wire pulsed")
			if (A.aidisabled == 0)
				A.aidisabled = 1
			A.updateDialog()
			spawn(100)
				if (A.aidisabled == 1)
					A.aidisabled = 0

		if(AALARM_WIRE_SYPHON)
		//	to_world("Syphon wire pulsed")
			if(A.mode == 1) // AALARM_MODE_SCRUB
				A.mode = 3 // AALARM_MODE_PANIC
			else
				A.mode = 1 // AALARM_MODE_SCRUB
			A.apply_mode()

		if(AALARM_WIRE_AALARM)
		//	to_world("Aalarm wire pulsed")
			if (A.alarm_area.atmosalert(0, A))
				A.post_alert(0)
			A.update_icon()
