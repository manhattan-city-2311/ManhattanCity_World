/datum/reagent/hormone
	color = "#ddcdcd"
	metabolism = 0.1
	reagent_state = LIQUID
	taste_description = "rush"
	overdose = 15

/datum/reagent/hormone/overdose(mob/M, alien)
	return
/datum/reagent/hormone/adrenaline
	name = "Adrenaline"
	id = CI_ADRENALINE
	description = "Adrenaline is a hormone used as emergency drug to quickly increase BP by increasing HR and CO."
	overdose = 10

/datum/reagent/hormone/adrenaline/affect_blood(mob/living/carbon/human/M, alien, removed)
	M.add_chemical_effect(CE_PULSE, min(2 * volume, 40))

/datum/reagent/hormone/noradrenaline
	name = "Noradrenaline"
	id = CI_NORADRENALINE
	description = "Noradrenaline is a hormone used as emergency drug in shock states to increase BP by vasoconstricting."
	overdose = 10

/datum/reagent/hormone/noradrenaline/affect_blood(mob/living/carbon/human/M, alien, removed)
	M.add_chemical_effect(CE_PRESSURE, min(2 * volume, 40))

/datum/reagent/hormone/dopamine
	name = "Dopamine"
	id = CI_DOPAMINE
	description = "Dopamine is a hormone used to treat hypotension by vasoconstricting. Can cause arrythmia."

// METABOLISM

/datum/reagent/hormone/glucose
	name = "Glucose"
	id = CI_GLUCOSE
	metabolism = 0 // reduced just by insulin.

// 1u insulin produce 0.1u glucose decrease.

/datum/reagent/hormone/insulin
	name = "Insulin"
	id = CI_INSULIN
	metabolism = 0.1
	overdose = 1
	price_tag = 12

/datum/reagent/hormone/insulin/affect_blood(mob/living/carbon/human/M, alien, removed)
	var/amount = min(M.bloodstr.get_reagent_amount(CI_GLUCOSE), 0.1)
	M.bloodstr.remove_reagent(CI_GLUCOSE, amount)
	M.bloodstr.remove_reagent(CI_POTASSIUM_HORMONE, max(amount * 10, 0.1))
	volume = max(0, amount * 10)
	M.adjustToxLoss(-amount * 15)

// 1u glucagone produces 0.1u glucose increase.
/datum/reagent/hormone/glucagone
	name = "Glucagone"
	id = CI_GLUCAGONE
	price_tag = 1.5
	metabolism = 0.8

// MARKERS

/datum/reagent/hormone/marker/troponin_t
	name = "Troponin-T"
	id = CI_TROPONIN_T

/datum/reagent/hormone/marker/bilirubine
	name = "Bilirubine"
	id = CI_BILIRUBINE

/datum/reagent/hormone/marker/ast
	name = "AST"
	id = CI_AST


/datum/reagent/hormone/marker/alt
	name = "ALT"
	id = CI_ALT

/datum/reagent/hormone/marker/crp
	name = "CRP"
	id = CI_CRP


// Ions.
// Wer converting normal reagents to hormone variant(to ions of reagent)


/datum/reagent/hormone/potassium
	name = "Potassium"
	id = CI_POTASSIUM_HORMONE

/datum/reagent/hormone/potassium/affect_blood(mob/living/carbon/human/H, alien, removed)
	var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[O_HEART]
	var/amount = volume * 0.99
	amount -= H.bloodstr.get_reagent_amount(CI_ADRENALINE) * 0.7
	amount -= H.bloodstr.get_reagent_amount(CI_NORADRENALINE) * 0.5

	if(amount < POTASSIUM_LEVEL_HBAD)
		return

	switch(amount)
		if(POTASSIUM_LEVEL_HBAD to POTASSIUM_LEVEL_HCRITICAL)
			heart.cardiac_output_modificators["potassium_level"] = 0.7
			heart.pulse_modificators["potassium_level"] = volume * 0.2
		if(POTASSIUM_LEVEL_HCRITICAL to POSITIVE_INFINITY)
			heart.cardiac_output_modificators["potassium_level"] = 0.65
			heart.pulse_modificators["potassium_level"] = volume * 0.4

/datum/reagent/potassium/affect_blood(mob/living/carbon/human/H, alien, removed)
	H.bloodstr.add_reagent(CI_POTASSIUM_HORMONE, volume * 0.5)
	volume = 0
