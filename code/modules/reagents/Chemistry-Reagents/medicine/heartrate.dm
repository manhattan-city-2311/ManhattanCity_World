/datum/reagent/atropine
	name = "Atropine"
	id = "atropine"
	description = "Atropine is a drug what increases HR."
	reagent_state = LIQUID
	color = "#ff7766"

/datum/reagent/atropine/affect_blood(mob/living/carbon/human/H, alien, removed)
	..()
	H.add_chemical_effect(CE_PULSE, volume * 7.5)
	H.add_chemical_effect(CE_ANTIARRYTHMIC, 1)

/datum/reagent/esmolol
	name = "Esmolol"
	id = "esmolol"
	description = "Esmolol is β1-selective beta-blocker with very short duration of action."

	metabolism = REM * 2

	overdose = 10

/datum/reagent/esmolol/affect_blood(mob/living/carbon/human/H, alien, removed)
	..()
	H.add_chemical_effect(CE_BETABLOCKER, round(7.5 * volume))
	H.add_chemical_effect(CE_PULSE, H.chem_doses[type] * -7.5)

/datum/reagent/esmolol/overdose(mob/living/carbon/human/H, alien)
	H.add_chemical_effect(CE_PULSE, H.chem_doses[type] * -10)