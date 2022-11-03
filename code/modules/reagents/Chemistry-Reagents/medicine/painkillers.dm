/datum/reagent/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = 60
	scannable = 1
	metabolism = 0.02
	mrate_static = TRUE
	price_tag = 0.05

	tax_type = PHARMA_TAX


/datum/reagent/paracetamol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 25)

/datum/reagent/paracetamol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.hallucination = max(M.hallucination, 2)

/datum/reagent/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "A simple, yet effective painkiller."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#CB68FC"
	overdose = 30
	scannable = 1
	metabolism = 0.02
	mrate_static = TRUE
	price_tag = 0.7

	tax_type = PHARMA_TAX
	var/pain_power = 300 //magnitide of painkilling effect
	var/effective_dose = 10 //how many units it need to process to reach max power
	var/soft_overdose = 15 //determines when it starts causing negative effects w/out actually causing OD
	var/additiction_coef = 0.8

/datum/reagent/tramadol/affect_blood(mob/living/carbon/M, alien, removed)
	var/effectiveness = 1
	if(M.chem_doses[type] < effective_dose) //some ease-in ease-out for the effect
		effectiveness = M.chem_doses[type]/effective_dose
	else if(volume < effective_dose)
		effectiveness = volume/effective_dose
	M.add_chemical_effect(CE_PAINKILLER, pain_power * effectiveness)
	handle_painkiller_overdose(M)
	var/boozed = isboozed(M)
	if(boozed)
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
		M.add_chemical_effect(CE_BREATHLOSS, 0.1 * boozed) //drinking and opiating makes breathing kinda hard

/datum/reagent/tramadol/overdose(mob/living/carbon/M, alien)
	..()
	M.hallucination = max(M.hallucination, 120)
	M.druggy = max(M.druggy, 10)
	M.add_chemical_effect(CE_PAINKILLER, pain_power*0.5) //extra painkilling for extra trouble
	M.add_chemical_effect(CE_BREATHLOSS, 0.6) //Have trouble breathing, need more air
	if(isboozed(M))
		M.add_chemical_effect(CE_BREATHLOSS, 0.2) //Don't drink and OD on opiates folks

/datum/reagent/tramadol/proc/handle_painkiller_overdose(mob/living/carbon/M)
	if(M.chem_doses[type] > soft_overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 1)
		if(prob(1))
			M.slurring = max(M.slurring, 10)
	if(M.chem_doses[type] > (overdose+soft_overdose)/2)
		if(prob(5))
			M.slurring = max(M.slurring, 20)
	if(M.chem_doses[type] > overdose)
		M.slurring = max(M.slurring, 30)
		if(prob(1))
			M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 5)

/datum/reagent/tramadol/proc/isboozed(mob/living/carbon/M)
	. = 0
	var/datum/reagents/ingested = M.ingested
	if(ingested)
		var/list/pool = M.reagents.reagent_list | ingested.reagent_list
		for(var/datum/reagent/ethanol/booze in pool)
			if(M.chem_doses[booze.type] < 2) //let them experience false security at first
				continue
			. = 1
			if(booze.strength < 40) //liquor stuff hits harder
				return 2

/datum/reagent/tramadol/opium
	name = "Opium"
	id = "opium"
	description = "Latex obtained from the opium poppy. An effective, but addictive painkiller."
	taste_description = "bitterness"
	color = "#63311b"
	overdose = 20
	soft_overdose = 10
	scannable = 0
	reagent_state = SOLID
	data = 0
	pain_power = 360
	var/drugdata = 0
	additiction_coef = 2.1

/datum/reagent/tramadol/opium/affect_blood(mob/living/carbon/M, alien, removed)
	var/effectiveness = 1
	if(volume < effective_dose) //reverse order compared to tramadol for quicker effect uppon injecting
		effectiveness = volume/effective_dose
	else if(M.chem_doses[type] < effective_dose)
		effectiveness = M.chem_doses[type]/effective_dose
	M.add_chemical_effect(CE_PAINKILLER, pain_power * effectiveness)
	handle_painkiller_overdose(M)
	var/boozed = isboozed(M)
	if(boozed)
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
		M.add_chemical_effect(CE_BREATHLOSS, 0.1 * boozed) //drinking and opiating makes breathing kinda hard

/datum/reagent/tramadol/opium/handle_painkiller_overdose(mob/living/carbon/M)
	var/whole_volume = (volume + M.chem_doses[type]) // side effects are more robust (dose-wise) than in the case of *legal* painkillers usage
	if(whole_volume > soft_overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 1)
		M.druggy = max(M.druggy, 10)
		if(prob(1))
			M.slurring = max(M.slurring, 10)
	if(whole_volume > (overdose+soft_overdose)/2)
		M.eye_blurry = max(M.eye_blurry, 10)
		if(prob(5))
			M.slurring = max(M.slurring, 20)
	if(whole_volume > overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 2)
		M.slurring = max(M.slurring, 30)
		if(prob(1))
			M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 5)
	M.make_jittery(whole_volume * 0.5)

/datum/reagent/tramadol/opium/heroin
	name = "Heroin"
	id = "diamorphine"
	description = "An opioid most commonly used as a recreational drug for its euphoric effects. An extremely effective painkiller, yet is terribly addictive and notorious for its life-threatening side-effects."
	color = "#b79a8d"
	overdose = 15
	soft_overdose = 7.5
	pain_power = 660
	scannable = 0
	reagent_state = SOLID
	additiction_coef = 3

/datum/reagent/tramadol/opium/heroin/affect_blood(mob/living/carbon/M, alien, removed)
	..()
	M.add_chemical_effect(CE_SLOWDOWN, 1)
	M.hallucination = max(M.hallucination, 120)

/datum/reagent/tramadol/opium/heroin/handle_painkiller_overdose(mob/living/carbon/M)
	M.hallucination = max(M.hallucination, 150)
	var/whole_volume = (volume + M.chem_doses[type]) // side effects are more robust (dose-wise) than in the case of *legal* painkillers usage
	if(whole_volume > soft_overdose)
		M.hallucination = max(M.hallucination, 30)
		M.eye_blurry = max(M.eye_blurry, 10)
		M.drowsyness = max(M.drowsyness, 5)
		M.druggy = max(M.druggy, 10)
		M.add_chemical_effect(CE_SLOWDOWN, 2)
		if(prob(5))
			M.slurring = max(M.slurring, 20)
	else if(whole_volume > overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 3)
		M.slurring = max(M.slurring, 30)
		M.Weaken(5)
		if(prob(25))
			M.sleeping = max(M.sleeping, 3)
		M.add_chemical_effect(CE_BREATHLOSS, 0.2)
	M.make_jittery(whole_volume * 0.5)

/datum/reagent/tramadol/opium/kodein
	name = "Kodein"
	id = "kodein"
	description = "An mild opium alkaloid most commonly used as basis of other opiates."
	color = "#b79abd"
	overdose = 15
	soft_overdose = 7.5
	pain_power = 240
	scannable = 1
	reagent_state = SOLID
	additiction_coef = 3

/datum/reagent/tramadol/opium/heroin/krokodil
	name = "Krokodil"
	id = "krokodil"
	description = "A drug most commonly used as a cheap replacement of heroin."
	color = "#b7ba8d"
	overdose = 15
	soft_overdose = 7.5
	pain_power = 450
	scannable = 1
	reagent_state = SOLID
	additiction_coef = 2.6

/datum/reagent/tramadol/opium/morphine
	name = "Morphine"
	id = "morphine"
	description = "An opioid painkiller drug."
	color = "#aaaabb"
	overdose = 25
	soft_overdose = 15
	scannable = 1
	reagent_state = SOLID
	data = 0
	pain_power = 600
	additiction_coef = 2

/datum/reagent/tramadol/opium/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "An effective opiat painkiller. Don't mix with alcohol."
	taste_description = "bitterness"
	color = "#800080"
	overdose = 20
	pain_power = 560
	effective_dose = 2
	additiction_coef = 2
