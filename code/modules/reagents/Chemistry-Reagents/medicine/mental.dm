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

/datum/reagent/haloperidol
	name = "Haloperidol"
	id = "haloperidol"
	description = "A special drug used to negate psyschosis and agitation."
	taste_description = "sweetness"
	reagent_state = LIQUID
	color = "#94808a"
	metabolism = 0.01
	mrate_static = TRUE
	data = 0
	price_tag = 0.4
	overdose = 10

	tax_type = PHARMA_TAX


/datum/reagent/haloperidol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, "<span class='warning'>You feel agitated and unnerved again...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, "<span class='notice'>Your feel calm and relaxed...</span>")

/datum/reagent/haloperidol/overdose(mob/living/carbon/M, alien, removed)
	. = ..()
	to_chat(M, "<span class='warning'>You can't focus on anything...</span>")
	M.hallucination += 50