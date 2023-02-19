/datum/reagent/methohexital
	name = "Methohexital"
	id = "methohexital"
	description = "Methohexital is a general anaesthetic for surgical sedation."
	overdose = 10
	taste_description = "bitterness"
	reagent_state = SOLID
	color = "#6767e0"
	metabolism = REM * 0.5
	price_tag = 4

/datum/reagent/methohexital/affect_blood(mob/living/carbon/human/M, alien, removed)
	var/threshold = 1

	var/effective_dose = dose
	if(issmall(M))
		effective_dose *= 2

	if(effective_dose == metabolism)
		M.Confuse(2)
		M.drowsyness += 2
	else if(effective_dose < 2 * threshold)
		M.Weaken(30)
		M.eye_blurry = max(M.eye_blurry, 10)

/datum/reagent/methohexital/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_PULSE, max(-volume, -20))
