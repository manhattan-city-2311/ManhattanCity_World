/datum/reagent/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	description = "Nitroglycerin is a drug used to reduce CO and increase coronary refill to reduce heart ischemia."
	taste_description = "oil"
	reagent_state = LIQUID
	color = "#808080"

/datum/reagent/nitroglycerin/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_CARDIAC_OUTPUT, clamp(1 - M.chem_doses[type] * 0.01, 0.6, 1))

/*
	var/obj/item/organ/internal/heart/H = M.internal_organs_by_name[O_HEART]
	if(!H)
		return

	H.ischemia = max(0, H.ischemia - volume / 2.5)
*/
