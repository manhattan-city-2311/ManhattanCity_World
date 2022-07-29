/obj/item/organ/internal/stomach
	name = "stomach"
	icon_state = "stomach"
	organ_tag = O_STOMACH
	parent_organ = BP_TORSO

	unacidable = TRUE	// Don't melt when holding your acid, dangit.

	var/acidtype = "stomacid"	// Incase you want some stomach organ with, say, polyacid instead, or sulphuric.
	var/max_acid_volume = 30

	var/deadly_hold = TRUE	// Does the stomach do damage to mobs eaten by its owner? Xenos should probably have this FALSE.
	watched_hormones = list(
		"glucose"
	)
	var/absolutely_normal_glucose_level

/obj/item/organ/internal/stomach/influence_hormone(T, amount)
	if(ishormone(T, glucose))
		var/diff = amount - absolutely_normal_glucose_level
		var/produce_hormone_level = min(abs(diff) / 0.1, 1)
		if(diff > -0.1 && diff < 2)
			return

		if(diff > 0) // >normal
			free_up_to_hormone("insulin", produce_hormone_level)

/obj/item/organ/internal/stomach/New()
	..()
	absolutely_normal_glucose_level = rand(GLUCOSE_LEVEL_NORMAL + 0.1, GLUCOSE_LEVEL_HBAD - 0.55)
	if(reagents)
		reagents.maximum_volume = 30
	else
		create_reagents(30)

/obj/item/organ/internal/stomach/proc/handle_organ_proc_special()
	generate_hormone("insulin", 0.1, 15)
	if(owner && istype(owner, /mob/living/carbon/human))
		if(reagents)
			if(reagents.total_volume + 2 < max_acid_volume && prob(20))
				reagents.add_reagent(acidtype, rand(1,2))

			for(var/mob/living/L in owner.stomach_contents) // Splashes mobs inside with acid. Twice as effective as being splashed with the same acid outside the body.
				reagents.trans_to(L, 2, 2, 0)

		if(is_broken() && prob(1))
			owner.custom_pain("There's a twisting pain in your abdomen!",1)
			owner.vomit(FALSE, TRUE)

/obj/item/organ/internal/stomach/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!.) return

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
