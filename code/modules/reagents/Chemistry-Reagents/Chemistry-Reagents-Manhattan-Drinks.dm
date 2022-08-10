

// Deep Rock Galactic Reference

/datum/reagent/ethanol/oaf
	name = "Oily Oaf Brew"
	id = "oaf"
	description = "Alcohol in more alcohol."
	taste_description = "rich, buttery beer"
	color = "#c28800"
	strength = 40
	nutriment_factor = 2
	glass_icon_state = "oaf"

	glass_name = "Oily Oaf Brew"
	glass_desc = "The Oily Oaf. A classic. While one of the lighter drinks available, the rich, buttery aftertaste coupled with the low price tag means the Oaf is here to stay."

/datum/chemical_reaction/drinks/oaf
	name = "Oily Oaf Brew"
	id = "oaf"
	result = "oaf"
	required_reagents = list("cornoil" = 1, "manlydorf" = 2)
	result_amount = 3

/datum/reagent/ethanol/slammer
	name = "Glyphid Slammer"
	id = "slammer"
	description = "Alcohol in more alcohol."
	taste_description = "storng, bitter energy drink"
	color = "#c28800"
	strength = 40
	nutriment_factor = 2
	glass_icon_state = "slammer"

	glass_name = "Glyphid Slammer"
	glass_desc = "An adventurous mix of a cheap, powerful ale with an equally cheap, powerful energy drink. The result is almost, but not quite, entirely undrinkable. But it sure does put a spring in your step."

/datum/reagent/ethanol/slammer/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	..()
	M.drowsyness = max(0, M.drowsyness - 5)
	M.sleeping = max(0, M.sleeping - 5)

/datum/chemical_reaction/drinks/slammer
	name = "Glyphid Slammer"
	id = "slammer"
	result = "slammer"
	required_reagents = list("ale" = 1, "spacemountainwind" = 2)
	result_amount = 3

/datum/reagent/ethanol/leaf
	name = "Leaf Lover's Special"
	id = "leaf"
	description = "Alcohol in more alcohol."
	taste_description = "fresh mint"
	color = "#dbc286"
	strength = 500 //чел ты не пивас
	nutriment_factor = 1
	glass_icon_state = "leaf"

	glass_name = "Leaf Lover's Special"
	glass_desc = "The Leaf Lover is on this chart entirely to please Management. It'll kill your buzz faster than a pay cut, and leave you with the same empty feeling in your gut. Still, it can be handy on Inspection Day - just don't let anyone know you had one."

/datum/reagent/ethanol/leaf/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	..()
	M.dizziness = max(0, M.dizziness - 3)
	M.drowsyness = max(0, M.drowsyness - 3)
	M.slurring = max(0, M.slurring - 3)

/datum/chemical_reaction/drinks/leaf
	name = "Leaf Lover's Special"
	id = "leaf"
	result = "leaf"
	required_reagents = list("milk" = 1, "grapesoda" = 1)
	result_amount = 2

/datum/reagent/ethanol/arkenstout
	name = "Arkenstout"
	id = "arkenstout"
	description = "Alcohol in more alcohol."
	taste_description = "chilly chill"
	color = "#c28800"
	strength = 35
	nutriment_factor = 2
	glass_icon_state = "arkenstout"

	glass_name = "Arkenstout"
	glass_desc = "An ancient recipe going back millenia, tasting of honor, gold, and glory days of yore. Served best chilled to near absolute zero."

/datum/reagent/ethanol/arkenstout/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	..()
	M.bodytemperature = max(M.bodytemperature - 2 * TEMPERATURE_DAMAGE_COEFFICIENT, 215)
	if(prob(3))
		M.emote("shiver")
	holder.remove_reagent("capsaicin", 5)

/datum/chemical_reaction/drinks/arkenstout
	name = "Arkenstout"
	id = "arkenstout"
	result = "arkenstout"
	required_reagents = list("manlydorf" = 1, "frostoil" = 1, "ice" = 1)
	result_amount = 3

/datum/reagent/ethanol/blackout
	name = "Blackout Stout"
	id = "blackout"
	description = "Alcohol in more alcohol."
	taste_description = "strongest drink of your life"
	color = "#2e2000"
	strength = 10
	nutriment_factor = 1
	glass_icon_state = "blackout"

	glass_name = "Blackout Stout"
	glass_desc = "Renowned through space and time, a tankard of Blackout is enough to knock out almost anyone. A true test for the true drunkard."

/datum/reagent/ethanol/blackout/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	..()
	if(40 < dose && (prob(75)))
		M.drowsyness = max(0, M.drowsyness + 5)
		M.slurring = max(0, M.slurring + 4)
	if(100 < dose && (prob(75)))
		M.sleeping = max(0, M.sleeping + 2)

/datum/chemical_reaction/drinks/blackout
	name = "Blackout Stout"
	id = "blackout"
	result = "blackout"
	required_reagents = list("gargleblaster" = 1, "beer" = 1, "rum" = 1)
	result_amount = 3

/datum/reagent/ethanol/blonde
	name = "Blackreach Blonde"
	id = "blonde"
	description = "Alcohol in more alcohol."
	taste_description = "sweet berries"
	color = "#d9239c"
	strength = 35
	nutriment_factor = 2
	glass_icon_state = "blonde"

	glass_name = "Blackreach Blonde"
	glass_desc = "The party-goer's choice. Charming, fizzy, and fruity, the Blackreach Blonde is known to put a smile on anyone's face."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/ethanol/blonde/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	..()
	if(prob(dose * 0.20))
		M.emote(pick("spin", "flip", "floorspin"))
	if(prob(dose * 0.10))
		to_chat(M, "<span class='danger'>You feel an uncontrollable urge to dance!</span>")

/datum/chemical_reaction/drinks/blonde
	name = "Blackreach Blonde"
	id = "blonde"
	result = "blonde"
	required_reagents = list("wine" = 1, "beer" = 1, "melonliquor" = 1)
	result_amount = 3

/datum/reagent/ethanol/flintlock
	name = "Flintlocke's Delight"
	id = "flintlock"
	description = "Alcohol in more alcohol."
	taste_description = "salty gunpowder"
	color = "#c28800"
	strength = 30
	nutriment_factor = 1
	glass_icon_state = "flintlock"

	glass_name = "Flintlocke's Delight"
	glass_desc = "How does it work? Eldritch magic? Genetic tampering? Nobody knows! Suffice to say, Flintlocke's Delight is a favorite of demolitionists everywhere. Also, it tastes great - if you got a love for gunpowder, anyway."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/ethanol/flintlock/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	..()
	if(prob(dose * 0.20))
//		explosion(M.loc, 0, 0, 0, 1, 0) //Мемная хуйня которая громочет на всю карту
		playsound(M.loc, pick('sound/effects/explosion1.ogg', 'sound/effects/explosion2.ogg', 'sound/effects/explosion3.ogg', 'sound/effects/explosion4.ogg', 'sound/effects/explosion5.ogg', 'sound/effects/explosion6.ogg'), 80, 1)
		var/target = get_ranged_target_turf(M.loc, pick(1, 2, 4, 8), rand(1, 4))
		M.throw_at(target, 3, 4)

/datum/chemical_reaction/drinks/flintlock
	name = "Flintlocke's Delight"
	id = "flintlock"
	result = "flintlock"
	required_reagents = list("amasec" = 1, "beer" = 1, "b52" = 1)
	result_amount = 3


//Cyberpunk Reference

/datum/reagent/ethanol/silverhand
	name = "Johnny Silverhand"
	id = "silverhand"
	description = "Tequila Old Fashioned with a splash of cerveza and a chili garnish."
	taste_description = "nuked tower"
	color = "#361b05"
	strength = 25
	nutriment_factor = 1
	glass_icon_state = "silverhand"

	glass_name = "Johnny Silverhand"
	glass_desc = "Somehow only looking at this drink make you feel like not enjoying all these corps at all."

/datum/chemical_reaction/drinks/silverhand
	name = "Johnny Silverhand"
	id = "silverhand"
	result = "silverhand"
	required_reagents = list("bitters" = 1, "melonliquor" = 2, "capsaicin" = 1, "orangejuice" = 1, "beer" = 3)
	result_amount = 8

/datum/reagent/ethanol/silverhand/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return

	if(30 < dose  && (dose == metabolism || prob(15)))
		to_chat(M, "<span class='danger'>Your insides feel uncomfortably hot!</span>")
	if(prob(15))
		to_chat(M, "<span class='danger'>Fuck Arasaka!</span>")

/datum/reagent/ethanol/jackie
	name = "Jackie Welles"
	id = "jackie"
	description = "A proud son of Terra and an even prouder son of Mama Welles."
	taste_description = "sweet vodka"
	color = "#e04370"
	strength = 35
	nutriment_factor = 1
	glass_icon_state = "jackie"

	glass_name = "Jackie Welles"
	glass_desc = "A shot of vodka, lime juice, ginger beer, and most importantly... A splash of love."
	glass_special = list(DRINK_FIZZ)

/datum/chemical_reaction/drinks/jackie
	name = "Jackie Welles"
	id = "jackie"
	result = "jackie"
	required_reagents = list("vodka" = 2, "limejuice" = 1, "gingerale" = 1, "grenadine" = 1)
	result_amount = 5


//Личные коктейли для мёртвых ребят ~Danilcus

/datum/reagent/ethanol/dostoevsky
	name = "Admiral Dostoevsky"
	id = "dostoevsky"
	description = "Alcohol in more alcohol."
	taste_description = "strong sour cognac"
	color = "#e6811c"
	strength = 20
	nutriment_factor = 1
	glass_icon_state = "dostoevsky"

	glass_name = "Admiral Dostoevsky"
	glass_desc = "По официальной версии, Адмирал ЭК Алексей Достоевский умер в 2311 г. от сердечного приступа - но по сектору досихпор ходит слушок, что правительство специально устранило неудобную верхушку ЭК, поставив на должность покорную шестёрку."

/datum/chemical_reaction/drinks/dostoevsky
	name = "Admiral Dostoevsky"
	id = "dostoevsky"
	result = "dostoevsky"
	required_reagents = list("cognac" = 2, "lemonjuice" = 3, "vodka" = 1, "beer" = 1) //2311 г.
	result_amount = 8