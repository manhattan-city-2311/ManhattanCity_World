/datum/reagent/adenosine
	name = "Adenosine"
	id = "adenosine"
	description = "Adenosine is a drug used to produce controlled AV blockade."
	reagent_state = LIQUID
	color = "#aa7766"
	metabolism = 1.5

/datum/reagent/adenosine/affect_blood(mob/living/carbon/human/H, alien, removed)
	var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[O_HEART]
	if(!heart)
		return

	if(volume < 5)
		return
	// initial rush.
	if(H.chem_doses[type] < 5)
		H.make_heart_rate(-heart.pulse - 150, "adenosine_av_blockage")
		heart.change_heart_rate(0)

	// TODO: rewrite this more compact
	if(ARRYTHMIA_AFIB in heart.arrythmias)
		var/required = 2 * heart.arrythmias[ARRYTHMIA_AFIB].severity
		if(volume >= required)
			heart.arrythmias[ARRYTHMIA_AFIB].weak(heart)
			volume -= required
	if(ARRYTHMIA_TACHYCARDIA in heart.arrythmias)
		var/required = 2 * heart.arrythmias[ARRYTHMIA_TACHYCARDIA].severity
		if(volume >= required)
			heart.arrythmias[ARRYTHMIA_TACHYCARDIA].weak(heart)
			volume -= required

/datum/reagent/lidocaine
	name = "Lidocaine"
	id = "lidocaine"
	description = "Lidocaine is a antiarrythmic and painkiller drug."
	reagent_state = LIQUID
	color = "#77aaaa"
	metabolism = REM
	overdose = 10

/datum/reagent/lidocaine/affect_blood(mob/living/carbon/human/H, alien, removed)
	H.add_chemical_effect(CE_ANTIARRYTHMIC, 3)
	H.add_chemical_effect(CE_PAINKILLER, 40)

/datum/reagent/lidocaine/overdose(mob/living/carbon/human/H, alien)
	if(prob(50))
		H.add_chemical_effect(CE_BREATHLOSS)

/datum/reagent/amiodarone
	name = "Amiodarone"
	id = "amiodarone"
	description = "Amiodarone is a light antiarrythmic medication. Safe for urban use."
	taste_description = "calmness"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#914347"
	overdose = 15
	scannable = 1
	tax_type = PHARMA_TAX

/datum/reagent/amiodarone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_ANTIARRYTHMIC, 2)
