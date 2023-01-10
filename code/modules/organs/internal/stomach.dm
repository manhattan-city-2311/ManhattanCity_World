/obj/item/organ/internal/stomach
	name = "stomach"
	icon_state = "stomach"
	organ_tag = O_STOMACH
	parent_organ = BP_TORSO

	watched_hormones = list(
		CI_GLUCOSE
	)
	var/absolutely_normal_glucose_level

/obj/item/organ/internal/stomach/influence_hormone(T, amount)
	if(T == CI_GLUCOSE)
		var/diff = amount - absolutely_normal_glucose_level
		var/produce_hormone_level = min(abs(diff) / 0.1, 1)
		if(diff > -0.1 && diff < 2)
			return

		if(diff > 0) // >normal
			free_up_to_hormone(CI_INSULIN, produce_hormone_level)
			absorb_hormone(CI_GLUCAGONE, POSITIVE_INFINITY, hold = TRUE)
		else if(diff < 0) // <normal
			free_up_to_hormone(CI_GLUCAGONE, produce_hormone_level)
			absorb_hormone(CI_INSULIN, POSITIVE_INFINITY, hold = TRUE)

/obj/item/organ/internal/stomach/initialize()
	. = ..()
	absolutely_normal_glucose_level = rand(GLUCOSE_LEVEL_NORMAL_LOW + 5, GLUCOSE_LEVEL_HBAD - 5)
	if(reagents)
		reagents.maximum_volume = 3500
	else
		create_reagents(3500)


/obj/item/organ/internal/stomach/Process()
	..()
	// wer simulate glucose-nutrition system by this..
	// TODO: detach this from stomach, remove this copy-paste from insulin code.
	absorb_hormone(CI_GLUCOSE, DEFAULT_HUNGER_FACTOR)
	absorb_hormone(CI_POTASSIUM_HORMONE, max(DEFAULT_HUNGER_FACTOR * 5, 0.1))

	generate_hormone(CI_INSULIN, 0.1, 15)
	generate_hormone(CI_GLUCAGONE, 0.1, 15)

	if(owner && is_broken() && prob(2))
		owner.custom_pain("There's a twisting pain in your abdomen!",1)
		owner.vomit(FALSE, TRUE)

/obj/item/organ/internal/stomach/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!.)
		return

	//Bacterial Gastroenteritis
	if (. >= INFECTION_LEVEL_ONE)
		if(prob(1))
			owner.custom_pain("There's a twisting pain in your abdomen!",1)
			owner.apply_effect(2, AGONY, 0)
	if (. >= INFECTION_LEVEL_TWO)
		if(prob(1) && owner.getToxLoss() < owner.getMaxHealth()*0.2)
			owner.adjustToxLoss(3)
			owner.vomit(FALSE, TRUE)

/obj/item/organ/internal/stomach/xeno
	color = "#555555"
