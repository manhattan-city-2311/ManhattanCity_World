/* Drugs */

/datum/reagent/drug
	var/high_msg_enabled = 1
	var/high_msg //If high_msg_enabled is set to true, a high msg will occur to the high msg probability
	var/high_msg_list = list("You feel incredibly happy all of a sudden!",
	"You're on top of the world!")
	taste_description = "something weird"
	var/high_message_chance = 10
	color = "#f2f2f2"
	scannable = 1
	overdose = REAGENTS_OVERDOSE

	price_tag = 0.2

	tax_type = DRUG_TAX


/datum/reagent/drug/affect_blood(mob/living/carbon/M)

	if(high_msg_enabled)
		if(prob(high_message_chance))
			high_msg = pick(high_msg_list)
			to_chat(M, "<span class='notice'>[high_msg]</span>")
	..()

//Space Drugs has been renamed to Ecstasy.
/datum/reagent/drug/ecstasy
	name = "Ecstasy"
	id = "ecstasy"
	description = "Also known as MDMA. An illegal chemical compound used as a drug."
	taste_description = "bitterness"
	taste_mult = 0.4
	reagent_state = LIQUID
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	high_msg_list = list("You don't quite know what up or down is anymore...",
	"Colors just seem much more amazing.",
	"You feel incredibly confident. No one can stop you.",
	"You clench your jaw involuntarily.",
	"You feel... unsteady.")

	price_tag = 0.9
	contraband_type = CONTRABAND_ECSTASY

/datum/reagent/drug/ecstasy/affect_blood(mob/living/carbon/M, alien, removed)
	if(alien == IS_DIONA)
		return

	var/drug_strength = 15
	if(alien == IS_SKRELL)
		drug_strength = drug_strength * 0.8

	if(alien == IS_SLIME)
		drug_strength = drug_strength * 1.2

	M.druggy = max(M.druggy, drug_strength)
	if(prob(10) && isturf(M.loc) && M.canmove && !M.restrained())
		step(M, pick(cardinal))
	if(prob(7))
		M.emote(pick("twitch", "drool", "giggle"))
	..()


/datum/reagent/drug/ecstasy/overdose(mob/living/M as mob)
	if(prob(20))
		M.hallucination = max(M.hallucination, 5)
	M.adjustBrainLoss(0.25*REM)
	M.adjustToxLoss(0.25*REM)
	..()



//Nicotene is found in cigarettes/cigars
/datum/reagent/drug/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "A highly addictive stimulant extracted from the tobacco plant. Sometimes can throw off breathalyzer results."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#685511" //brown
	high_msg_list = list("You feel so much more relaxed.",
	"Your mind feels a lot clearer.",
	"You feel like the stress is going away.",
	"You feel calm.",
	"You feel collected.")
	price_tag = 0.09

	tax_type = TOBACCO_TAX
	contraband_type = CONTRABAND_NICOTINE

datum/reagent/drug/nicotine/affect_blood(var/mob/living/carbon/M)
	M.AdjustStunned(-1)
	..()

/datum/reagent/drug/meth
	name = "Meth"
	id = "methamphetamine"
	description = "Reduces stun times by about 300%, speeds the user up, and allows the user to quickly recover stamina while dealing a small amount of Brain damage. If overdosed the subject will move randomly, laugh randomly, drop items and suffer from Toxin and Brain damage. If addicted the subject will constantly jitter and drool, before becoming dizzy and losing motor control and eventually suffer heavy toxin damage."
	reagent_state = LIQUID
	taste_description = "something faint and odious"
	high_msg_list = list("You feel hyper.",
	"You feel like you need to go faster.",
	"You feel like you can out-run the world.",
	"You feel very jittery and it's almost painful to stay still.",
	"Everything seems to be going in slow motion.",
	"Your feet are dying for some action right now.")

	price_tag = 2.2

	contraband_type = CONTRABAND_METH

/datum/reagent/drug/meth/affect_blood(mob/living/carbon/M)
	M.AdjustParalysis(-2)
	M.AdjustStunned(-2)
	M.AdjustWeakened(-2)
	M.add_chemical_effect(CE_PAINKILLER, 20)
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	if(prob(10))
		M.adjust_nutrition(-8)
	if(prob(5))
		M.emote(pick("twitch", "shiver"))
	..()


/datum/reagent/drug/meth/overdose(var/mob/living/carbon/human/M as mob)
	if(M.canmove && !istype(M.loc, /atom/movable))
		for(var/i = 0, i < 4, i++)
			step(M, pick(cardinal))
	if(prob(20))
		M.emote("laugh")
	if(prob(20))
		M.adjust_nutrition(-20)
	if(prob(33))
		M.visible_message("<span class = 'danger'>[M]'s hands flip out and flail everywhere!</span>")
		var/obj/item/I = M.get_active_hand()
		if(I)
			M.drop_item()
	M.adjustToxLoss(1)
	M.adjustBrainLoss(pick(0.5, 0.6, 0.7, 0.8, 0.9, 1))
	..()

/datum/reagent/drug/meth/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	description = "A refined and altered meth-based chemical, used for motor-enhancement, manufactured and Licensed by Nanotrasen primarily for the PDF. \
	This restricted strand allows for higher dosages to be administered by the user, allowing a longer period of usage.Hyperzine is a highly effective, \
	long lasting, muscle stimulant. It is a purified form of meth licensed for use by PDF."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FF3300"
	overdose = REAGENTS_OVERDOSE * 0.5
	price_tag = 4

/datum/reagent/drug/cannabis
	name = "Cannabis"
	id = "cannabis"
	description = "A painkilling and toxin healing drug. THC is found in this, and is extracted from the cannabis plant."
	taste_description = "a strong-tasting plant"
	reagent_state = LIQUID
	color = "#32871d" //green
	high_msg_list = list("You feel so much more relaxed.",
	"You can't quite focus on anything.",
	"Colors around you seem much more intense.",
	"You could snack on something right now...",
	"You feel lightheaded and giggly.",
	"Everything seems so hilarious.",
	"You really could go for some takeout right now.",
	"You momentarily forget where you are.",
	"You have a mild urge to look over your shoulder.")

	price_tag = 1

	tax_type = CANNABIS_TAX
	contraband_type = CONTRABAND_CANNABIS

/datum/reagent/drug/cannabis/affect_blood(var/mob/living/carbon/M)
	M.adjustToxLoss(-2)
	M.druggy = max(M.druggy, 3)
	M.heal_organ_damage(6)
	M.adjustToxLoss(-1.5)
	M.adjustOxyLoss(-3)
	M.AdjustStunned(-1)
	if(prob(7))
		M.emote(pick("giggle"))
	..()
	if(prob(10))
		M.adjust_nutrition(-10)

/datum/reagent/drug/cannabis/overdose(var/mob/living/M as mob)
	if(prob(2))
		M.vomit()
	..()

/datum/reagent/drug/cocaine
	name = "Cocaine"
	id = "cocaine"
	description = "Cocaine, an illegal stimulant often consumed nasally in a powdered form."
	taste_description = "metallic and bitter"
	overdose = 15
	reagent_state = LIQUID
	calories_factor = -15
	color = "#FFFFFF" //white
	high_msg_list = list ("You feel euphoric!",
	"You feel like you can take on the world!",
	"You sniffle compulsively...",
	"You feel terrible.",
	"Your tongue feels very dry.",
	"Your eyes feel dry.")

	price_tag = 2

	contraband_type = CONTRABAND_COCAINE

/datum/reagent/drug/cocaine/affect_blood(var/mob/living/carbon/M)
	M.add_chemical_effect(CE_PAINKILLER,3)
	M.adjust_hydration(-15)
	if(prob(15))
		M.emote(pick("shiver", "sniff"))
		..()

/datum/reagent/drug/cocaine/overdose(var/mob/living/M as mob)
	if(prob(50))
		M.vomit()
		M.adjustToxLoss(10)
		M.adjustBrainLoss(5)
		..()


/datum/reagent/drug/crack
	name = "Crack"
	id = "crack"
	description = "Crack is a cheaper, less pure version of cocaine, still having simiar properties. It also has more negative OD effects."
	taste_description = "like car fuel"
	overdose = 15
	reagent_state = LIQUID
	calories_factor = -8
	color = "#FFFFFF" //white
	high_msg_list = list ("You sniffle a bit.",
	"You have a mild... headache",
	"You feel a bit sick...",
	"You feel hyper and confident",
	"You feel terrible.")

	price_tag = 1.5

	contraband_type = CONTRABAND_CRACK

/datum/reagent/drug/crack/affect_blood(var/mob/living/carbon/M)
	M.add_chemical_effect(CE_PAINKILLER,1)
	M.adjustBrainLoss(0.30)
	if(prob(15))
		M.emote(pick("shiver", "sniff"))
		..()

/datum/reagent/drug/crack/overdose(var/mob/living/M as mob)
	M.adjustToxLoss(1)
	M.drowsyness = max(M.drowsyness, 10)
	if(prob(50))
		M.vomit()
		M.adjustToxLoss(30)
		M.adjustBrainLoss(25)
		..()


/datum/reagent/drug/stimm	//Homemade Hyperzine
	name = "Stimm"
	id = "stimm"
	description = "A homemade stimulant with some serious side-effects."
	taste_description = "sweetness"
	taste_mult = 1.8
	color = "#d0583a" //pale brownish-orange
	metabolism = REM * 3
	overdose = 10
	calories_factor = -2
	high_msg_list = list ("You feel your heart pounding in your chest.",
	"You shudder so violently that it hurts",
	"You blink rapidly to wet your drying eyes")

	price_tag = 1.8

	contraband_type = CONTRABAND_STIMM

/datum/reagent/drug/stimm/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_TAJARA)
		removed *= 1.25
	..()
	if(prob(15))
		M.emote(pick("twitch", "blink_r", "shiver"))
	if(prob(15))
		M.take_organ_damage(6 * removed, 0)
	M.add_chemical_effect(CE_SPEEDBOOST, 1)

/datum/reagent/drug/dmt
	name = "Dimethyltryptamine"
	id = "dimethyltryptamine"
	description = "An intense psychedelic with a short duration of action."
	taste_description = "plastic"
	taste_mult = 1.8
	color = "#d4bc8e"
	metabolism = REM * 5
	high_msg_list = list ("The clockwork elves are watching you.",
	"Join us in the spirit world...",
	"You feel a deep sense of belonging.")

	price_tag = 1

	contraband_type = CONTRABAND_DMT

/datum/reagent/drug/dmt/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_TAJARA)
		removed *= 1.25
	..()
	if(prob(15))
		M.emote(pick("deathgasp", "sigh", "smile"))

	var/drug_strength = 300

	if(alien == IS_SKRELL)
		drug_strength *= 0.8

	if(alien == IS_SLIME)
		drug_strength *= 1.2

	M.hallucination = max(M.hallucination, drug_strength)

/datum/reagent/drug/ayahuasca
	name = "Ayahuasca"
	id = "ayahuasca"
	description = "A brew of jungle herbs that produce an intense spiritual experience."
	taste_description = "bitter herbs"
	metabolism = REM * 1.25
	color = "#5e3d22" //slightly muted milk-chocolatey brown
	high_msg_list = list ("Your stomach grumbles violently.",
	"You feel at one with the universe.",
	"You feel in tune with the vibrations of the cosmos.",
	"Let the spirits take you...")

	price_tag = 1

	contraband_type = CONTRABAND_AYAHUASCA

/datum/reagent/drug/ayahuasca/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_TAJARA)
		removed *= 1.25
	..()
	if(prob(15))
		M.emote(pick("deathgasp", "moan", "smile", "groan"))

	var/drug_strength = 60

	if(alien == IS_SKRELL)
		drug_strength *= 0.8

	if(alien == IS_SLIME)
		drug_strength *= 1.2

	M.hallucination = max(M.hallucination, drug_strength)

/datum/reagent/drug/bathsalts
	name = "Bath Salts"
	id = "bath_salts"
	description = "A pale drug resembling epsom salts. Not for human consumption."
	taste_description = "bitterness and salt"
	metabolism = REM * 0.5
	overdose = 20
	color = "#FFFFFF" //white
	high_msg_list = list ("You feel unstoppable!",
	"Tasty! Crazy? No I'm crazy...",
	"Need some more bath salts...")

	price_tag = 1

	contraband_type = CONTRABAND_BATHSALTS

/datum/reagent/drug/bathsalts/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	var/drug_strength = 120

	if(alien == IS_SKRELL)
		drug_strength *= 0.8

	if(alien == IS_SLIME)
		drug_strength *= 1.2

	if(prob(15))
		M.emote(pick("scream", "moan", "twitch", "groan", "twitch_s", "vomit", "shiver", "stare", "pale"))

	M.adjustBrainLoss(0.30)
	M.hallucination = max(M.hallucination, drug_strength)
	M.druggy = max(M.druggy, drug_strength)
	if(prob(10) && isturf(M.loc) && !istype(M.loc, /turf/space) && M.canmove && !M.restrained())
		step(M, pick(cardinal))

/datum/reagent/drug/bathsalts/overdose(var/mob/living/M as mob)
	M.adjustToxLoss(1)
	M.drowsyness = max(M.drowsyness, 10)
	if(prob(50))
		M.vomit()
		M.adjustToxLoss(5)
		M.adjustBrainLoss(10)
		..()

/datum/reagent/drug/lsd
	name ="Lysergic acid diethylamide"
	id = "lsd"
	description = "A hallucinogenic drug that induces altered thoughts and perception."
	taste_description = "nothing"
	color = "#b8b8b8" //light grey
	high_msg_list = list ("The floor is melting...",
	"Wow, everything seems so much brighter.",
	"Everything seems to be shifting.")

	price_tag = 1

	contraband_type = CONTRABAND_LSD

/datum/reagent/drug/lsd/affect_blood(mob/living/carbon/M, alien, removed)
	if(alien == IS_DIONA)
		return

	var/drug_strength = 80

	if(alien == IS_SKRELL)
		drug_strength *= 0.8

	if(alien == IS_SLIME)
		drug_strength *= 1.2

	M.hallucination = max(M.hallucination, drug_strength)

/datum/reagent/drug/jenkem
	name = "Jenkem"
	id = "jenkem"
	description = "Jenkem is a prison drug made from fermenting feces in a solution of urine. Extremely disgusting."
	reagent_state = LIQUID
	color = "#644600"
	taste_description = "the inside of a toilet... or worse"
	high_msg_list = list("You smell the aroma of a particularly dirty restroom.",
	"Your stommach grumbles unpleasantly.",
	"The taste of excrement sits uncomfortably in your mouth.")

/datum/reagent/drug/jenkem/affect_blood(var/mob/living/M as mob)
	M.drowsyness = max(M.drowsyness, 5)
	M.adjustToxLoss(1)
	if(prob(10))
		M.emote(pick("twitch_s","drool","moan"))
		M.adjustToxLoss(3)
		..()

/datum/reagent/drug/psilocybin
	name = "Psilocybin"
	id = "psilocybin"
	description = "A strong psychotropic derived from certain species of mushroom."
	taste_description = "mushroom"
	color = "#E700E7"
	metabolism = REM * 0.5
	price_tag = 0.8
	contraband_type = CONTRABAND_PSILOCYBIN

/datum/reagent/drug/psilocybin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	var/threshold = 1
	if(alien == IS_SKRELL)
		threshold = 1.2

	if(alien == IS_SLIME)
		threshold = 0.8

	M.druggy = max(M.druggy, 30)

	var/effective_dose = dose
	if(issmall(M)) effective_dose *= 2
	if(effective_dose < 1 * threshold)
		M.apply_effect(3, STUTTER)
		M.make_dizzy(5)
		if(prob(5))
			M.emote(pick("twitch", "giggle"))
	else if(effective_dose < 2 * threshold)
		M.apply_effect(3, STUTTER)
		M.make_jittery(5)
		M.make_dizzy(5)
		M.druggy = max(M.druggy, 35)
		if(prob(10))
			M.emote(pick("twitch", "giggle"))
	else
		M.apply_effect(3, STUTTER)
		M.make_jittery(10)
		M.make_dizzy(10)
		M.druggy = max(M.druggy, 40)
		if(prob(15))
			M.emote(pick("twitch", "giggle"))


