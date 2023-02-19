/datum/reagent/labetolol
	name = "Labetolol"
	id = "labetolol"
	description = "Labetolol is a medication used in hypertensive emergencies."
	overdose = 10

/datum/reagent/labetolol/affect_blood(mob/living/carbon/human/M, alien, removed)
	M.add_chemical_effect(CE_PRESSURE, max(-volume, -40))
