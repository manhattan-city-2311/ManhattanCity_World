/datum/wires/mines
	wire_count = 6
	random = 1
	holder_type = /obj/effect/mine

#define WIRE_DETONATE 	1
#define WIRE_TIMED_DET 	2
#define WIRE_DISARM	4
#define WIRE_DUMMY_1	8
#define WIRE_DUMMY_2	16
#define WIRE_BADDISARM	32

/datum/wires/mines/GetInteractWindow()
	. = ..()
	. += "<br>\n["Warning: detonation may occur even with proper equipment."]"
	return .

/datum/wires/mines/proc/explode()
	return

/datum/wires/mines/UpdateCut(var/index, var/mended)
	var/obj/effect/mine/C = holder

	switch(index)
		if(WIRE_DETONATE)
			C.visible_message("[icon2html(C, hearers(C))] *BEEE-*", "[icon2html(C, hearers(C))] *BEEE-*")
			C.explode()

		if(WIRE_TIMED_DET)
			C.visible_message("[icon2html(C, hearers(C))] *BEEE-*", "[icon2html(C, hearers(C))] *BEEE-*")
			C.explode()

		if(WIRE_DISARM)
			C.visible_message("[icon2html(C, hearers(C))] *click!*", "[icon2html(C, hearers(C))] *click!*")
			new C.mineitemtype(get_turf(C))
			spawn(0)
				qdel(C)
				return

		if(WIRE_DUMMY_1)
			return


		if(WIRE_DUMMY_2)
			return

		if(WIRE_BADDISARM)
			C.visible_message("[icon2html(C, hearers(C))] *BEEPBEEPBEEP*", "[icon2html(C, hearers(C))] *BEEPBEEPBEEP*")
			spawn(20)
				C.explode()
	return

/datum/wires/mines/UpdatePulsed(var/index)
	var/obj/effect/mine/C = holder
	if(IsIndexCut(index))
		return
	switch(index)
		if(WIRE_DETONATE)
			C.visible_message("[icon2html(C, hearers(C))] *beep*", "[icon2html(C, hearers(C))] *beep*")

		if(WIRE_TIMED_DET)
			C.visible_message("[icon2html(C, hearers(C))] *BEEPBEEPBEEP*", "[icon2html(C, hearers(C))] *BEEPBEEPBEEP*")
			spawn(20)
				C.explode()

		if(WIRE_DISARM)
			C.visible_message("[icon2html(C, hearers(C))] *ping*", "[icon2html(C, hearers(C))] *ping*")

		if(WIRE_DUMMY_1)
			C.visible_message("[icon2html(C, hearers(C))] *ping*", "[icon2html(C, hearers(C))] *ping*")

		if(WIRE_DUMMY_2)
			C.visible_message("[icon2html(C, hearers(C))] *beep*", "[icon2html(C, hearers(C))] *beep*")

		if(WIRE_BADDISARM)
			C.visible_message("[icon2html(C, hearers(C))] *ping*", "[icon2html(C, hearers(C))] *ping*")
	return

/datum/wires/mines/CanUse(var/mob/living/L)
	var/obj/effect/mine/M = holder
	return M.panel_open
