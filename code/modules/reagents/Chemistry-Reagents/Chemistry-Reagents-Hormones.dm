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
	description = "Adrenaline is a hormone used as emergency drug to quickly increase BP by increase HR and CO."
	overdose = 10

/datum/reagent/hormone/adrenaline/affect_blood(mob/living/carbon/human/M, alien, removed)
    M.add_chemical_effect(CE_PAINKILLER, min(2 * volume, 40))

/datum/reagent/hormone/noradrenaline
	name = "Noradrenaline"
	description = "Noradrenaline is a hormone used as emergency drug in shock states to increase BP by vasoconstricting."
	overdose = 10

/datum/reagent/hormone/dopamine
	name = "Dopamine"
	description = "Dopamine is a hormone used to treat hypotension by vasoconstricting. Can cause arrythmia."

// METABOLISM
/datum/reagent/hormone/glucose
	name = "Glucose"
	metabolism = 0 // reduced only by insulin.

// 1u insulin produce 0.1u glucose decrease.

/datum/reagent/hormone/insulin
	name = "Insulin"
	metabolism = 0.1
	overdose = 1

/datum/reagent/hormone/insulin/affect_blood(mob/living/carbon/human/M, alien, removed)
	var/amount = min(M.bloodstr.get_reagent_amount(/datum/reagent/hormone/glucose), 0.1)
	M.bloodstr.remove_reagent(/datum/reagent/hormone/glucose, amount)
	M.bloodstr.remove_reagent(/datum/reagent/hormone/potassium, max(amount * 10, 0.1))
	volume = max(0, amount * 10)
	M.adjustToxLoss(-amount * 15)

// 1u glucagone produces 0.1u glucose increase.
/datum/reagent/hormone/glucagone
	name = "Glucagone"

// MARKERS

/datum/reagent/hormone/marker/troponin_t
	name = "Troponin-T"
/datum/reagent/hormone/marker/bilirubine
	name = "Bilirubine"
/datum/reagent/hormone/marker/ast
	name = "AST"
/datum/reagent/hormone/marker/alt
	name = "ALT"
/datum/reagent/hormone/marker/crp
	name = "CRP"


// Ions.
// Wer convert normal reagents to hormone variant(to ions of reagent)

/datum/reagent/hormone/potassium
	name = "Potassium"

/datum/reagent/hormone/potassium/affect_blood(mob/living/carbon/human/H, alien, removed)
	var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[O_HEART]
	var/amount = volume * 0.99
	amount -= H.bloodstr.get_reagent_amount(/datum/reagent/hormone/adrenaline) * 0.7
	amount -= H.bloodstr.get_reagent_amount(/datum/reagent/hormone/noradrenaline) * 0.5

	if(amount < POTASSIUM_LEVEL_HBAD)
		return

	switch(amount)
		if(POTASSIUM_LEVEL_HBAD to POTASSIUM_LEVEL_HCRITICAL)
			heart.cardiac_output_modificators["potassium_level"] = 0.7
			if(prob(10) && heart.get_arrythmia_score() < 1)
				heart.make_common_arrythmia(1)

			heart.pulse_modificators["potassium_level"] = -volume * 10
		if(POTASSIUM_LEVEL_HCRITICAL to INFINITY)
			heart.cardiac_output_modificators["potassium_level"] = 0.65
			if(prob(20) && !(heart.get_ow_arrythmia()))
				heart.make_common_arrythmia(rand(1, ARRYTHMIA_SEVERITY_OVERWRITING))
			heart.pulse_modificators["potassium_level"] = -volume * 8

/datum/reagent/potassium/affect_blood(mob/living/carbon/human/H, alien, removed)
	H.bloodstr.add_reagent(/datum/reagent/hormone/potassium, volume * 0.5)
	volume = 0