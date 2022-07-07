/* General medicine */

//STABILIZERS

/datum/reagent/metaprolol
	name = "Metaprolol"
	id = "metaprolol"
	description = "Metaprolol is a selective β1 receptor blocker medication. It is used to treat high blood pressure, chest pain due to poor blood flow to the heart, and a number of conditions involving an abnormally fast heart rate."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#f788bb"
	overdose = REAGENTS_OVERDOSE * 2
	metabolism = REM * 0.5
	scannable = 1
	price_tag = 0.5

	tax_type = PHARMA_TAX

/datum/reagent/metaprolol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_STABLE, 15)

/datum/reagent/acetral
	name = "Acetral"
	id = "acetral"
	description = "Acetral is a beta blocker medication for the treatment of hypertension and arrhythmias."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#68193e"
	overdose = REAGENTS_OVERDOSE * 2
	metabolism = REM * 0.5
	scannable = 1
	price_tag = 0.5

	tax_type = PHARMA_TAX

/datum/reagent/acetral/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_STABLE, 30)
		M.add_chemical_effect(CE_PAINKILLER, 10)

//ANTIBIOTICS
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
	name = "Cetrifiaxon"
	id = "cetrifiaxon"
	description = "Cetrifiaxon is an extremely strong antibiotic, toxic."
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

//ANTIARRYTHMICS
/datum/reagent/amiodarone
	name = "Amiodarone"
	id = "amiodarone"
	description = "Amiodarone is a light antiarrythmic. Safe for urban use."
	taste_description = "calmness"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#914347"
	overdose = 15
	scannable = 1
	tax_type = PHARMA_TAX

/datum/reagent/amiodarone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_ARRYTHMIC, 1)

/datum/reagent/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	description = "Nitroglycerin is a drug used to reduce CO and increase coronary refill to reduce heart ischemia."
	taste_description = "oil"
	reagent_state = LIQUID
	color = "#808080"

/datum/reagent/nitroglycerin/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_CARDIAC_OUTPUT, Clamp(1 - M.chem_doses[type] * 0.01, 0.6, 1))

	var/obj/item/organ/internal/heart/H = M.internal_organs_by_name[O_HEART]
	if(!H)
		return

	H.ischemia = max(0, H.ischemia - volume / 2.5)

/datum/reagent/atropine
	name = "Atropine"
	id = "atropine"
	description = "Atropine is a drug what increases HR. Used in severe bradycardia cases"
	reagent_state = LIQUID
	color = "#ff7766"

/datum/reagent/atropine/affect_blood(mob/living/carbon/human/H, alien, removed)
	..()
	H.add_chemical_effect(CE_PULSE, H.chem_doses[type] * 7.5)
	H.add_chemical_effect(CE_ARRYTHMIC, 1)

/datum/reagent/adenosine
	name = "Adenosine"
	id = "adenosine"
	description = "Adenosine is a drug used to produce controlled AV blockade."
	reagent_state = LIQUID
	color = "#aa7766"
	metabolism = 0.5

/datum/reagent/adenosine/affect_blood(mob/living/carbon/human/H, alien, removed)
	var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[O_HEART]
	if(!heart)
		return

	if(volume < 5)
		return
	// initial rush.
	if(H.chem_doses[type] < 5)
		H.make_heart_rate(-140 + sin(world.time / 20) * 60, "adenosine_av_blockage")
		return

	// TODO: rewrite this more compact
	if(ARRYTHMIA_AFIB in heart.arrythmias)
		var/required = 5 * heart.arrythmias[ARRYTHMIA_AFIB].strength
		if(volume >= required)
			heart.arrythmias[ARRYTHMIA_AFIB].weak(heart)
			volume -= required
		return
	if(ARRYTHMIA_TACHYCARDIA in heart.arrythmias)
		var/required = 5 * heart.arrythmias[ARRYTHMIA_TACHYCARDIA].strength
		if(volume >= required)
			heart.arrythmias[ARRYTHMIA_TACHYCARDIA].weak(heart)
			volume -= required
		return

/datum/reagent/lidocaine
	name = "Lidocaine"
	id = "lidocaine"
	description = "Lidocaine is a antiarrythmic and painkiller drug."
	reagent_state = LIQUID
	color = "#77aaaa"
	metabolism = REM
	overdose = 10

/datum/reagent/lidocaine/affect_blood(mob/living/carbon/human/H, alien, removed)
	H.add_chemical_effect(CE_ANTIARRYTHMIC, 2)
	H.add_chemical_effect(CE_PAINKILLER, 40)

/datum/reagent/lidocaine/overdose(mob/living/carbon/human/H, alien)
	if(prob(50))
		H.add_chemical_effect(CE_BREATHLOSS)

//ANALGESICS

/datum/reagent/aspirin
	name = "Aspirin"
	id = "aspirin"
	description = "Aspirin is a medication used to reduce pain, fever, or inflammation."
	taste_description = "bitterness"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#a7b8cc"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	tax_type = PHARMA_TAX

/datum/reagent/aspirin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_PAINKILLER, 10)

/datum/reagent/dylovene
	name = "Dylovene"
	id = "anti_toxin"
	description = "Dylovene is a broad-spectrum antitoxin."
	taste_description = "a roll of gauze"
	reagent_state = LIQUID
	color = "#00A000"
	scannable = 1
	price_tag = 0.5

	tax_type = PHARMA_TAX


/datum/reagent/dylovene/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.drowsyness = max(0, M.drowsyness - 6 * removed)
		M.hallucination = max(0, M.hallucination - 9 * removed)
		M.adjustToxLoss(-4 * removed)
		if(prob(10))
			M.remove_a_modifier_of_type(/datum/modifier/poisoned)

/datum/reagent/carthatoline
	name = "Carthatoline"
	id = "carthatoline"
	description = "Carthatoline is strong evacuant used to treat severe poisoning."
	reagent_state = LIQUID
	color = "#225722"
	scannable = 1
	price_tag = 0.7

	tax_type = PHARMA_TAX


/datum/reagent/carthatoline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(M.getToxLoss() && prob(10))
		M.vomit(1)
	M.adjustToxLoss(-8 * removed)
	if(prob(30))
		M.remove_a_modifier_of_type(/datum/modifier/poisoned)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/liver/L = H.internal_organs_by_name[O_LIVER]
		if(istype(L))
			if(L.robotic >= ORGAN_ROBOT)
				return
			if(L.damage > 0)
				L.damage = max(L.damage - 2 * removed, 0)

/datum/reagent/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0080FF"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	price_tag = 0.5

	tax_type = PHARMA_TAX


/datum/reagent/dexalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 6)
	else if(alien != IS_DIONA)
		M.adjustOxyLoss(-15 * removed)

	holder.remove_reagent("lexorin", 2 * removed)

/datum/reagent/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0040FF"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	price_tag = 0.8

	tax_type = PHARMA_TAX


/datum/reagent/dexalinp/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 9)
	else if(alien != IS_DIONA)
		M.adjustOxyLoss(-150 * removed)

	holder.remove_reagent("lexorin", 3 * removed)

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#8040FF"
	scannable = 1
	price_tag = 0.8

	tax_type = PHARMA_TAX

/datum/reagent/tricordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.adjustOxyLoss(-3 * removed)
		M.heal_organ_damage(1.5 * removed, 1.5 * removed)
		M.adjustToxLoss(-1.5 * removed)

/datum/reagent/tricordrazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		affect_blood(M, alien, removed * 0.4)

/datum/reagent/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	taste_description = "overripe bananas"
	reagent_state = LIQUID
	color = "#8080FF"
	metabolism = REM * 0.5
	mrate_static = TRUE
	scannable = 1
	price_tag = 1

	tax_type = PHARMA_TAX


/datum/reagent/cryoxadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-10 * removed)
		M.adjustOxyLoss(-10 * removed)
		M.heal_organ_damage(10 * removed, 10 * removed)
		M.adjustToxLoss(-10 * removed)

/datum/reagent/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	taste_description = "rotten bananas"
	reagent_state = LIQUID
	color = "#80BFFF"
	metabolism = REM * 0.5
	mrate_static = TRUE
	scannable = 1
	price_tag = 2

	tax_type = PHARMA_TAX


/datum/reagent/clonexadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-30 * removed)
		M.adjustOxyLoss(-30 * removed)
		M.heal_organ_damage(30 * removed, 30 * removed)
		M.adjustToxLoss(-30 * removed)

/* Painkillers */

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
	var/effective_dose = 0.5 //how many units it need to process to reach max power
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
	if(whole_volume > overdose)
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

/* Other medicine */

/datum/reagent/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "Synaptizine is used to treat various diseases."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#99CCFF"
	metabolism = REM * 0.05
	overdose = REAGENTS_OVERDOSE
	scannable = 1


	price_tag = 0.8

	tax_type = PHARMA_TAX

/datum/reagent/synaptizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.drowsyness = max(M.drowsyness - 5, 0)
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	holder.remove_reagent("mindbreaker", 5)
	M.hallucination = max(0, M.hallucination - 10)
	M.adjustToxLoss(5 * removed) // It used to be incredibly deadly due to an oversight. Not anymore!
	M.add_chemical_effect(CE_PAINKILLER, 20)



/datum/reagent/hyperzine/affect_blood(mob/living/carbon/M, alien, removed)
	if(alien == IS_TAJARA)
		removed *= 1.25
	..()
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)

/datum/reagent/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FFFF66"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	price_tag = 0.8

	tax_type = PHARMA_TAX

/datum/reagent/alkysine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.adjustBrainLoss(-30 * removed)
	M.add_chemical_effect(CE_PAINKILLER, 10)

/datum/reagent/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Heals eye damage"
	taste_description = "dull toxin"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	price_tag = 0.6

	tax_type = PHARMA_TAX


/datum/reagent/imidazoline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.eye_blurry = max(M.eye_blurry - 5, 0)
	M.AdjustBlinded(-5)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
		if(istype(E))
			if(E.robotic >= ORGAN_ROBOT)
				return
			if(E.damage > 0)
				E.damage = max(E.damage - 5 * removed, 0)
			if(E.damage <= 5 && E.organ_tag == O_EYES)
				H.sdisabilities &= ~BLIND

/datum/reagent/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#561EC3"
	overdose = 15
	scannable = 1
	price_tag = 0.8

	tax_type = PHARMA_TAX


/datum/reagent/peridaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs_by_name)
			if(I.robotic >= ORGAN_ROBOT)
				continue
			if(I.damage > 0) //Peridaxon heals only non-robotic organs
				I.damage = max(I.damage - removed, 0)
			if(I.damage <= 5 && I.organ_tag == O_EYES)
				H.eye_blurry = min(M.eye_blurry + 10, 250) //Eyes need to reset, or something
				H.sdisabilities &= ~BLIND

/datum/reagent/osteodaxon
	name = "Osteodaxon"
	id = "osteodaxon"
	description = "An experimental drug used to heal bone fractures."
	reagent_state = LIQUID
	color = "#C9BCE3"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	price_tag = 0.8

	tax_type = PHARMA_TAX


/datum/reagent/osteodaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.heal_organ_damage(3 * removed, 0)	//Gives the bones a chance to set properly even without other meds
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			if(O.status & ORGAN_BROKEN)
				O.mend_fracture()		//Only works if the bone won't rebreak, as usual
				H.custom_pain("You feel a terrible agony tear through your bones!",60)
				H.AdjustWeakened(1)		//Bones being regrown will knock you over

/datum/reagent/myelamine
	name = "Myelamine"
	id = "myelamine"
	description = "Used to rapidly clot internal hemorrhages by increasing the effectiveness of platelets."
	reagent_state = LIQUID
	color = "#4246C7"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	var/repair_strength = 3
	price_tag = 0.7

	tax_type = PHARMA_TAX


/datum/reagent/myelamine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.eye_blurry += min(M.eye_blurry + (repair_strength * removed), 250)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/wound_heal = removed * repair_strength
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			for(var/datum/wound/W in O.wounds)
				if(W.bleeding())
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.wounds -= W
				if(W.internal)
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.wounds -= W

/datum/reagent/respirodaxon
	name = "Respirodaxon"
	id = "respirodaxon"
	description = "Used to repair the tissue of the lungs and similar organs."
	taste_description = "metallic"
	reagent_state = LIQUID
	color = "#4444FF"
	metabolism = REM * 1.5
	overdose = 10
	overdose_mod = 1.75
	scannable = 1

	tax_type = PHARMA_TAX

/datum/reagent/respirodaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/repair_strength = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		repair_strength = 0.6
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs_by_name)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_LUNGS, O_VOICE, O_GBLADDER)))
				continue
			if(I.damage > 0)
				I.damage = max(I.damage - 4 * removed * repair_strength, 0)
				H.Confuse(2)
		if(M.reagents.has_reagent("gastirodaxon") || M.reagents.has_reagent("peridaxon"))
			if(H.losebreath >= 15 && prob(H.losebreath))
				H.Stun(2)
			else
				H.losebreath = CLAMP(H.losebreath + 3, 0, 20)
		else
			H.losebreath = max(H.losebreath - 4, 0)

/datum/reagent/gastirodaxon
	name = "Gastirodaxon"
	id = "gastirodaxon"
	description = "Used to repair the tissues of the digestive system."
	taste_description = "chalk"
	reagent_state = LIQUID
	color = "#8B4513"
	metabolism = REM * 1.5
	overdose = 10
	overdose_mod = 1.75
	scannable = 1

	tax_type = PHARMA_TAX

/datum/reagent/gastirodaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/repair_strength = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		repair_strength = 0.6
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs_by_name)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_APPENDIX, O_STOMACH, O_INTESTINE, O_NUTRIENT, O_PLASMA, O_POLYP)))
				continue
			if(I.damage > 0)
				I.damage = max(I.damage - 4 * removed * repair_strength, 0)
				H.Confuse(2)
		if(M.reagents.has_reagent("hepanephrodaxon") || M.reagents.has_reagent("peridaxon"))
			if(prob(10))
				H.vomit(1)
			else if(H.nutrition > 30)
				M.adjust_nutrition(-removed * 30)
		else
			H.adjustToxLoss(-10 * removed) // Carthatoline based, considering cost.

/datum/reagent/hepanephrodaxon
	name = "Hepanephrodaxon"
	id = "hepanephrodaxon"
	description = "Used to repair the common tissues involved in filtration."
	taste_description = "glue"
	reagent_state = LIQUID
	color = "#D2691E"
	metabolism = REM * 1.5
	overdose = 10
	overdose_mod = 1.75
	scannable = 1

	tax_type = PHARMA_TAX

/datum/reagent/hepanephrodaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/repair_strength = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		repair_strength = 0.4
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs_by_name)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_LIVER, O_KIDNEYS, O_APPENDIX, O_ACID, O_HIVE)))
				continue
			if(I.damage > 0)
				I.damage = max(I.damage - 4 * removed * repair_strength, 0)
				H.Confuse(2)
		if(M.reagents.has_reagent("cordradaxon") || M.reagents.has_reagent("peridaxon"))
			if(prob(5))
				H.vomit(1)
			else if(prob(5))
				to_chat(H, "<span class='danger'>Something churns inside you.</span>")
				H.adjustToxLoss(10 * removed)
				H.vomit(0, 1)
		else
			H.adjustToxLoss(-12 * removed) // Carthatoline based, considering cost.

/datum/reagent/cordradaxon
	name = "Cordradaxon"
	id = "cordradaxon"
	description = "Used to repair the specialized tissues involved in the circulatory system."
	taste_description = "rust"
	reagent_state = LIQUID
	color = "#FF4444"
	metabolism = REM * 1.5
	overdose = 10
	overdose_mod = 1.75
	scannable = 1

	tax_type = PHARMA_TAX

/datum/reagent/cordradaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/repair_strength = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		repair_strength = 0.6
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs_by_name)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_HEART, O_SPLEEN, O_RESPONSE, O_ANCHOR, O_EGG)))
				continue
			if(I.damage > 0)
				I.damage = max(I.damage - 4 * removed * repair_strength, 0)
				H.Confuse(2)
		if(M.reagents.has_reagent("respirodaxon") || M.reagents.has_reagent("peridaxon"))
			H.losebreath = CLAMP(H.losebreath + 1, 0, 10)
		else
			H.adjustOxyLoss(-30 * removed) // Deals with blood oxygenation.

/datum/reagent/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn can cure all genetic abnomalities via a catalytic process."
	taste_description = "acid"
	reagent_state = SOLID
	color = "#004000"
	overdose = REAGENTS_OVERDOSE
	price_tag = 0.7

	tax_type = PHARMA_TAX


/datum/reagent/ryetalyn/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/needs_update = M.mutations.len > 0

	M.mutations = list()
	M.disabilities = 0
	M.sdisabilities = 0

	// Might need to update appearance for hulk etc.
	if(needs_update && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_mutations()

/datum/reagent/ethylredoxrazine
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	taste_description = "bitterness"
	reagent_state = SOLID
	color = "#605048"
	overdose = REAGENTS_OVERDOSE
	price_tag = 0.5

	tax_type = PHARMA_TAX


/datum/reagent/ethylredoxrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.SetConfused(0)
	if(M.ingested)
		for(var/datum/reagent/R in M.ingested.reagent_list)
			if(istype(R, /datum/reagent/ethanol))
				R.remove_self(removed * 5)
	if(M.bloodstr)
		for(var/datum/reagent/R in M.bloodstr.reagent_list)
			if(istype(R, /datum/reagent/ethanol))
				R.remove_self(removed * 15)

/datum/reagent/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	description = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#408000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	price_tag = 0.4
	tax_type = PHARMA_TAX


/datum/reagent/hyronalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.radiation = max(M.radiation - 30 * removed, 0)

/datum/reagent/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#008000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	price_tag = 0.4

	tax_type = PHARMA_TAX


/datum/reagent/arithrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.radiation = max(M.radiation - 70 * removed, 0)
	M.adjustToxLoss(-10 * removed)
	if(prob(60))
		M.take_organ_damage(4 * removed, 0)

/datum/reagent/penicillin
	name = "penicillin"
	id = "penicillin"
	description = "An all-purpose antiviral agent."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C1C1C1"
	metabolism = REM * 0.25
	mrate_static = TRUE
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	price_tag = 0.3

	tax_type = PHARMA_TAX

/datum/reagent/penicillin/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed * 0.8) // Not 100% as effective as injections, though still useful.

/datum/reagent/penicillin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_ANTIBIOTIC, dose >= overdose ? ANTIBIO_OD : ANTIBIO_NORM)

/datum/reagent/immunosuprizine
	name = "Immunosuprizine"
	id = "immunosuprizine"
	description = "An experimental medicine believed to have the ability to prevent any organ rejection."
	taste_description = "flesh"
	reagent_state = SOLID
	color = "#7B4D4F"
	metabolism = 0.01
	overdose = 20
	overdose_mod = 1.5
	scannable = 1

/*/datum/reagent/immunosuprizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/strength_mod = 1 * M.species.chem_strength_heal

	if(alien == IS_DIONA)	// It's a tree.
		strength_mod = 0.25

	if(alien == IS_SLIME)	// Diffculty bonding with internal cellular structure.
		strength_mod = 0.75

	if(alien == IS_SKRELL)	// Natural inclination toward toxins.
		strength_mod = 1.5

	if(alien == IS_UNATHI)	// Natural regeneration, robust biology.
		strength_mod = 1.75

	if(alien == IS_TAJARA)	// Highest metabolism.
		strength_mod = 2

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(alien != IS_DIONA)
			H.adjustToxLoss((30 / strength_mod) * removed)

		var/list/organtotal = list()
		organtotal |= H.organs_by_name
		organtotal |= H.internal_organs_by_name

		for(var/obj/item/organ/I in organtotal)	// Don't mess with robot bits, they don't reject.
			if(I.robotic >= ORGAN_ROBOT)
				organtotal -= I

		if(dose >= 15)
			for(var/obj/item/organ/I in organtotal)
				if(I.transplant_data && prob(round(15 * strength_mod)))	// Reset the rejection process, toggle it to not reject.
					I.rejecting = 0
					I.can_reject = FALSE

		if(H.reagents.has_reagent("penicillin") || H.reagents.has_reagent("corophizine"))	// Chemicals that increase your immune system's aggressiveness make this chemical's job harder.
			for(var/obj/item/organ/I in organtotal)
				if(I.transplant_data)
					var/rejectmem = I.can_reject
					I.can_reject = initial(I.can_reject)
					if(rejectmem != I.can_reject)
						H.adjustToxLoss((15 / strength_mod))
						I.take_damage(1)
*/
/datum/reagent/corophizine
	name = "Corophizine"
	id = "corophizine"
	description = "A wide-spectrum antibiotic drug. Powerful and uncomfortable in equal doses."
	taste_description = "burnt toast"
	reagent_state = LIQUID
	color = "#FFB0B0"
	mrate_static = TRUE
	overdose = 10
	scannable = 1

	tax_type = PHARMA_TAX


/datum/reagent/corophizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_ANTIBIOTIC, ANTIBIO_SUPER)

	//Based roughly on Levofloxacin's rather severe side-effects
	if(prob(20))
		M.Confuse(5)
	if(prob(20))
		M.Weaken(5)
	if(prob(20))
		M.make_dizzy(5)
	if(prob(20))
		M.hallucination = max(M.hallucination, 10)

	//One of the levofloxacin side effects is 'spontaneous tendon rupture', which I'll immitate here. 1:1000 chance, so, pretty darn rare.
	if(ishuman(M) && rand(1,1000) == 1)
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/eo = pick(H.organs_by_name) //Misleading variable name, 'organs' is only external organs
		eo.fracture()

/datum/reagent/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	description = "Sterilizes wounds in preparation for surgery and thoroughly removes blood."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	touch_met = 5

	tax_type = PHARMA_TAX


/datum/reagent/sterilizine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.germ_level -= min(removed*20, M.germ_level)
	for(var/obj/item/I in M.contents)
		I.was_bloodied = null
	M.was_bloodied = null

/datum/reagent/sterilizine/touch_obj(var/obj/O)
	O.germ_level -= min(volume*20, O.germ_level)
	O.was_bloodied = null

/datum/reagent/sterilizine/touch_turf(var/turf/T)
	T.germ_level -= min(volume*20, T.germ_level)
	for(var/obj/item/I in T.contents)
		I.was_bloodied = null
	for(var/obj/effect/decal/cleanable/C in T)
		qdel(C)

/datum/reagent/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "Leporazine can be use to stabilize an individuals body temperature."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	price_tag = 0.7


	tax_type = PHARMA_TAX


/datum/reagent/leporazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	taste_description = "bitterness"
	reagent_state = SOLID
	color = "#669900"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	price_tag = 0.3

	tax_type = PHARMA_TAX


/datum/reagent/rezadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.adjustCloneLoss(-20 * removed)
	M.adjustOxyLoss(-2 * removed)
	M.heal_organ_damage(20 * removed, 20 * removed)
	M.adjustToxLoss(-20 * removed)
	if(dose > 3)
		M.status_flags &= ~DISFIGURED
	if(dose > 10)
		M.make_dizzy(5)
		M.make_jittery(5)

/* Antidepressants */

#define ANTIDEPRESSANT_MESSAGE_DELAY 50*600*100

/datum/reagent/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "Improves the ability to concentrate."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#BF80BF"
	metabolism = 0.01
	mrate_static = TRUE
	data = 0
	price_tag = 0.7

	tax_type = PHARMA_TAX


/datum/reagent/methylphenidate/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, "<span class='warning'>You lose focus...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, "<span class='notice'>Your mind feels focused and undivided.</span>")

/datum/reagent/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Stabilizes the mind a little."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FF80FF"
	metabolism = 0.01
	mrate_static = TRUE
	data = 0
	price_tag = 0.4

	tax_type = PHARMA_TAX

/datum/reagent/citalopram/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, "<span class='warning'>Your mind feels a little less stable...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, "<span class='notice'>Your mind feels stable... a little stable.</span>")

/datum/reagent/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Stabilizes the mind greatly, but has a chance of adverse effects."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FF80BF"
	metabolism = 0.01
	mrate_static = TRUE
	data = 0
	price_tag = 0.3

	tax_type = PHARMA_TAX


/datum/reagent/paroxetine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, "<span class='warning'>Your mind feels much less stable...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			if(prob(90))
				to_chat(M, "<span class='notice'>Your mind feels much more stable.</span>")
			else
				to_chat(M, "<span class='warning'>Your mind breaks apart...</span>")
				M.hallucination += 200

/datum/reagent/qerr_quem
	name = "Qerr-quem"
	id = "querr_quem"
	description = "A potent stimulant and anti-anxiety medication, made for the Qerr-Katish."
	taste_description = "mint"
	reagent_state = LIQUID
	color = "#e6efe3"
	metabolism = 0.01
	mrate_static = TRUE
	data = 0
	price_tag = 0.5

	tax_type = PHARMA_TAX


/datum/reagent/qerr_quem/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, "<span class='warning'>You feel antsy, your concentration wavers...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, "<span class='notice'>You feel invigorated and calm.</span>")

// This exists to cut the number of chemicals a merc borg has to juggle on their hypo.
/datum/reagent/healing_nanites
	name = "Restorative Nanites"
	id = "healing_nanites"
	description = "Miniature medical robots that swiftly restore bodily damage."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#555555"
	metabolism = REM * 4 // Nanomachines gotta go fast.
	scannable = 1
	price_tag = 2

	tax_type = PHARMA_TAX


/datum/reagent/healing_nanites/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(2 * removed, 2 * removed)
	M.adjustOxyLoss(-4 * removed)
	M.adjustToxLoss(-2 * removed)
	M.adjustCloneLoss(-2 * removed)

