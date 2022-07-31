//microscope code itself
/obj/machinery/microscope
	name = "microscope"
	desc = "A highly advanced microscope capable of zooming up to 3000x."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "microscope"
	anchored = 1
	density = 1

	var/obj/item/weapon/reagent_containers/glass/beaker/vial/vial
	var/report_num = 0

/obj/machinery/microscope/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(vial)
		to_chat(user, SPAN_WARNING("Microscope is already loaded with blood."))
		return

	if(istype(W, /obj/item/weapon/reagent_containers/glass/beaker/vial))
		var/obj/item/weapon/reagent_containers/RC = W
		if(RC.reagents.reagent_list.len > 1)
			to_chat(user, SPAN_NOTICE("Contents contain impurities."))
			return

		to_chat(user, SPAN_NOTICE("You have inserted [W] in the microscope."))
		user.unEquip(W)
		W.forceMove(src)
		vial = W
		update_icon()

/obj/machinery/microscope/proc/check_analysis(var/datum/analysis/analysis, volume_test = TRUE)
	if(!vial)
		return FALSE
	if(volume_test && vial.reagents.total_volume < analysis.required_amount)
		return FALSE
	return TRUE

/obj/machinery/microscope/attack_hand(mob/user)
	if(!vial)
		to_chat(user, SPAN_NOTICE("Please insert vial to analyze contents."))
		return

	var/list/analysis_list = list()
	for(var/T in subtypesof(/datum/analysis))
		analysis_list += new T()
	var/list/analysis_names = list()
	for(var/datum/analysis/A in analysis_list)
		if(!check_analysis(A))
			analysis_list -= A
			qdel(A)
		else
			analysis_names += A.name

	var/dest_analysis = input(user, "Select required analysis.", "Analysis.") as null|anything in analysis_names
	if(!dest_analysis)
		return
	var/datum/analysis/analysis
	for(var/datum/analysis/A in analysis_list)
		if(A.name == dest_analysis)
			analysis = A
			break
	if(!analysis)
		return

	vial.reagents.remove_any(analysis.removed_amount)

	if(!check_analysis(analysis, volume_test = FALSE))
		return
	visible_message("<span class='notice'>\The [src] beeps and begins to analyze the sample.</span>")
	sleep(analysis.time)
	new /obj/item/weapon/paper(loc, analysis.analyze(vial.reagents.get_master_reagent()), dest_analysis)
	visible_message("<span class='notice'>\The [src] rattles and prints out a report.</span>")

/obj/machinery/microscope/proc/remove_vial(var/mob/living/remover)
	if(!istype(remover) || remover.incapacitated() || !Adjacent(remover))
		return
	if(!vial)
		to_chat(remover, "<span class='warning'>\The [src] does not have a vial in it.</span>")
		return
	to_chat(remover, "<span class='notice'>You remove \the [vial] from \the [src].</span>")
	vial.forceMove(get_turf(src))
	remover.put_in_hands(vial)
	vial = null
	update_icon()

/obj/machinery/microscope/AltClick()
	remove_vial(usr)

/obj/machinery/microscope/MouseDrop(var/atom/other)
	if(usr == other)
		remove_vial(usr)
	else
		return ..()

/obj/machinery/microscope/update_icon()
	icon_state = "microscope"
	if(vial)
		icon_state += "slide"