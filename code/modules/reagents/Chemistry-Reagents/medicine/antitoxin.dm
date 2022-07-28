/datum/reagent/sodium_bicarbonate
	name = "Sodium Bicarbonate"
	id = "sodiumbicarbonate"
	description = "Sodium Bicarbonate increases buffer stores of serum bicarbonate, used in treatment of hyperkaliemia and toxicity."

/datum/reagent/sodium_bicarbonate/affect_blood(mob/living/carbon/human/M, alien, removed)
	M.add_chemical_effect(CE_ANTITOX, min(volume * 2, 20))
	M.bloodstr.remove_reagent("potassium_hormone", max(volume * 2, 0.1))