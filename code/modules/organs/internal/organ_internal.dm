/****************************************************
				INTERNAL ORGANS DEFINES
****************************************************/
/obj/item/organ/internal
	var/list/datum/organ_disease/diseases
	var/list/hormones // list of amount of hormones by type.
	var/list/influenced_hormones // list of hormones, what process in proc/influence_hormone
	var/list/watched_hormones // list of hormones, what always process in influence_hormone

	var/list/waste_hormones = list(
		CI_POTASSIUM_HORMONE = 0.02
	)

	var/oxygen_consumption = 0

/obj/item/organ/internal/rejuvenate(ignore_prosthetic_prefs)
	..()
	hormones = initial(hormones)

/obj/item/organ/internal/initialize()
	..()
	if(!owner)
		return

	oxygen_consumption = oxygen_consumption * owner.k
	if(owner.client?.prefs.all_organ_damage)
		damage = owner.client.prefs.all_organ_damage[name]

/obj/item/organ/internal/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;add_organ_disease=\ref[src]'>Add disease</option>
		"}

/obj/item/organ/internal/proc/influence_hormone(T, amount)
	return

/obj/item/organ/internal/proc/make_hormone(T, amount)
	if(!owner)
		return
	owner.bloodstr.add_reagent(T, amount, safety = TRUE)

/obj/item/organ/internal/proc/make_up_to_hormone(T, amount)
	if(!owner)
		return
	var/cur_amount = owner.bloodstr.get_reagent_amount(T)
	if(amount <= cur_amount)
		return
	make_hormone(T, amount - cur_amount)

/obj/item/organ/internal/proc/free_hormone(T, amount)
	if(!owner || !(LAZYISIN(hormones, T)))
		return
	var/to_use = min(amount, hormones[T])
	make_hormone(T, to_use)
	hormones[T] -= to_use

/obj/item/organ/internal/proc/free_up_to_hormone(T, amount)
	if(!owner)
		return
	var/cur_amount = owner.bloodstr.get_reagent_amount(T)
	if(amount <= cur_amount)
		return
	free_hormone(T, amount - cur_amount)

/obj/item/organ/internal/proc/generate_hormone(T, amount, max = POSITIVE_INFINITY)
	if(!owner)
		return
	var/cur_amount = LAZYACCESS(hormones, T)
	amount = min(cur_amount + amount, max) - cur_amount
	if(amount <= 0)
		return

	LAZYINITLIST(hormones)
	if(T in hormones)
		hormones[T] += amount
	else
		hormones[T] = amount

	for(var/T1 in SANITIZE_LIST(waste_hormones))
		make_hormone(T1, waste_hormones[T1] * amount * 0.01)

/obj/item/organ/internal/proc/absorb_hormone(T, amount, desired = 0, hold = FALSE)
	if(!owner)
		return
	if(!desired)
		desired = owner.bloodstr.get_reagent_amount(T) // TODO: remove this hack.
	var/to_absorb = min(desired, owner.bloodstr.get_reagent_amount(T), amount)
	owner.bloodstr.remove_reagent(T, to_absorb)
	if(hold)
		LAZYINITLIST(hormones)
		if(T in hormones)
			hormones[T] += to_absorb
		else
			hormones[T] = to_absorb

/obj/item/organ/internal/die()
	..()
	if((status & ORGAN_DEAD) && dead_icon)
		icon_state = dead_icon

/obj/item/organ/internal/Destroy()
	if(owner)
		owner.internal_organs_by_name.Remove(src)
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		while(null in owner.internal_organs_by_name)
			owner.internal_organs_by_name -= null
		var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
		if(istype(E)) E.internal_organs -= src
	return ..()

/obj/item/organ/internal/remove_rejuv()
	if(owner)
		owner.internal_organs_by_name -= src
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		while(null in owner.internal_organs_by_name)
			owner.internal_organs_by_name -= null
		var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
		if(istype(E)) E.internal_organs -= src
	..()

/obj/item/organ/internal/robotize()
	..()
	name = "prosthetic [initial(name)]"
	icon_state = "[initial(icon_state)]_prosthetic"
	if(dead_icon)
		dead_icon = "[initial(dead_icon)]_prosthetic"

/obj/item/organ/internal/mechassist()
	..()
	name = "assisted [initial(name)]"
	icon_state = "[initial(icon_state)]_assisted"
	if(dead_icon)
		dead_icon = "[initial(dead_icon)]_assisted"

// Brain is defined in brain.dm
/obj/item/organ/internal/handle_germ_effects()
	. = ..() //Should be an interger value for infection level
	if(!.)
		return

	var/antibiotics = LAZYACCESS0(owner.chem_effects, CE_ANTIBIOTIC)

	if(. >= INFECTION_LEVEL_TWO && antibiotics < ANTIBIO_NORM) //INFECTION_LEVEL_TWO
		if (prob(3))
			take_damage(1, silent = prob(30))

	if(. >= INFECTION_LEVEL_THREE && antibiotics < ANTIBIO_OD)	//INFECTION_LEVEL_THREE
		if (prob(50))
			take_damage(1, silent = prob(15))

/obj/item/organ/internal/Process()
	..()
	if(!owner)
		return

	for(var/datum/organ_disease/OD in SANITIZE_LIST(diseases))
		if(OD.can_gone())
			diseases -= OD
			qdel(OD)
			break
		OD.update()

	for(var/T in SANITIZE_LIST(influenced_hormones))
		if(owner.bloodstr.has_reagent(T))
			influence_hormone(T, min(owner.bloodstr.get_reagent_amount(T), 15))
	for(var/T in SANITIZE_LIST(watched_hormones))
		influence_hormone(T, min(owner.bloodstr.get_reagent_amount(T), 15))
	for(var/T in SANITIZE_LIST(waste_hormones))
		make_hormone(T, waste_hormones[T])

	if(!vital && damage && owner.bloodstr.get_reagent_amount(CI_GLUCOSE) > GLUCOSE_LEVEL_L2BAD)
		var/regen = min(0.02, damage)
		absorb_hormone(CI_GLUCOSE, regen)
		damage = max(0, damage - regen * 12)

	owner.consume_oxygen(oxygen_consumption)
