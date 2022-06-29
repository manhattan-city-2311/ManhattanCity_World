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
	id = "adrenaline"
	description = "Adrenaline is a hormone used as emergency drug to quickly increase BP by increasing HR and CO."
	overdose = 10

/datum/reagent/hormone/adrenaline/affect_blood(mob/living/carbon/human/M, alien, removed)
    M.add_chemical_effect(CE_PULSE, min(2 * volume, 40))

/datum/reagent/hormone/noradrenaline
	name = "Noradrenaline"
	id = "noradrenaline"
	description = "Noradrenaline is a hormone used as emergency drug in shock states to increase BP by vasoconstricting."
	overdose = 10

/datum/reagent/hormone/noradrenaline/affect_blood(mob/living/carbon/human/M, alien, removed)
	M.add_chemical_effect(CE_PRESSURE, min(2 * volume, 40))

/datum/reagent/hormone/dopamine
	name = "Dopamine"
	id = "dopamine"
	description = "Dopamine is a hormone used to treat hypotension by vasoconstricting. Can cause arrythmia."

/datum/reagent/hormone/dopamine/affect_blood(mob/living/carbon/human/M, alien, removed)
	M.add_chemical_effect(CE_PRESSURE,  min(3 * volume, 40))
	var/obj/item/organ/internal/heart/heart = M.internal_organs_by_name[O_HEART]
	if(prob(1) && heart.get_arrythmia_score() < 1)
		heart.make_common_arrythmia(1)

// METABOLISM
/datum/reagent/hormone/glucose
	name = "Glucose"
	id = "glucose"
	metabolism = 0 // reduced only by insulin.

// 1u insulin produce 0.1u glucose decrease.

/datum/reagent/hormone/insulin
	name = "Insulin"
	id = "insulin"
	metabolism = 0.1
	overdose = 1

/datum/reagent/hormone/insulin/affect_blood(mob/living/carbon/human/M, alien, removed)
	var/amount = min(M.bloodstr.get_reagent_amount("glucose"), 0.1)
	M.bloodstr.remove_reagent("glucose", amount)
	M.bloodstr.remove_reagent("potassium_hormone", max(amount * 10, 0.1))
	volume = max(0, amount * 10)
	M.adjustToxLoss(-amount * 15)

// 1u glucagone produces 0.1u glucose increase.
/datum/reagent/hormone/glucagone
	name = "Glucagone"
	id = "glucagone"

// MARKERS

/datum/reagent/hormone/marker/troponin_t
	name = "Troponin-T"
	id = "troponint"
/datum/reagent/hormone/marker/bilirubine
	name = "Bilirubine"
	id = "bilirubine"
/datum/reagent/hormone/marker/ast
	name = "AST"
	id = "ast"
/datum/reagent/hormone/marker/alt
	name = "ALT"
	id = "alt"
/datum/reagent/hormone/marker/crp
	name = "CRP"
	id = "crp"


// Ions.
// Wer convert normal reagents to hormone variant(to ions of reagent)

/datum/reagent/hormone/potassium
	name = "Potassium"
	id = "potassium_hormone"

/datum/reagent/hormone/potassium/affect_blood(mob/living/carbon/human/H, alien, removed)
	var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[O_HEART]
	var/amount = volume * 0.99
	amount -= H.bloodstr.get_reagent_amount("adrenaline") * 0.7
	amount -= H.bloodstr.get_reagent_amount("noradrenaline") * 0.5

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
	H.bloodstr.add_reagent("potassium_hormone", volume * 0.5)
	volume = 0