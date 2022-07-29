/datum/reagent/amicile
	name = "Amicile"
	id = "amicile"
	description = "Amicile is a light antibiotic with few side effects."
	taste_description = "dryness"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#a7b8cc"
	overdose = 15
	scannable = 1
	tax_type = PHARMA_TAX

/datum/reagent/amicile/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_ANTIBIOTIC, volume * 2)

/datum/reagent/cetrifiaxon
	name = "Cetrifiaxone"
	id = "cetrifiaxone"
	description = "Cetrifiaxone is an extremely strong antibiotic, toxic."
	taste_description = "cell genocide"
	taste_mult = 5
	reagent_state = LIQUID
	color = "#0077ff"
	overdose = 15
	scannable = 1
	tax_type = PHARMA_TAX

/datum/reagent/cetrifiaxon/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	M.add_chemical_effect(CE_ANTIBIOTIC, volume * 4)
	M.adjustToxLoss(0.02 * M.chem_doses[type])