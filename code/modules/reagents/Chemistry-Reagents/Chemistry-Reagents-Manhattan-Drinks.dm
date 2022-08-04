


//Cyberpunk Reference

/datum/reagent/ethanol/silverhand
	name = "Johnny Silverhand"
	id = "silverhand"
	description = "Tequila Old Fashioned with a splash of cerveza and a chili garnish."
	taste_description = "nuked tower"
	color = "#361b05"
	strength = 25
	nutriment_factor = 1
	price_tag = 0.8

	glass_name = "Johnny Silverhand"
	glass_desc = "Somehow only looking at this drink make you feel like not enjoying all these corps at all."

/datum/chemical_reaction/drinks/silverhand
	name = "Johnny Silverhand"
	id = "silverhand"
	result = "silverhand"
	required_reagents = list("bitters" = 1, "melonliquor" = 2, "capsaicin" = 1, "orangejuice" = 1, "beer" = 3)
	result_amount = 8

/datum/reagent/ethanol/silverhand
	glass_icon_state = "silverhand"

/datum/reagent/ethanol/jackie
	name = "Jackie Welles"
	id = "jackie"
	description = "Tequila Old Fashioned with a splash of cerveza and a chili garnish."
	taste_description = "nuked tower"
	color = "#361b05"
	strength = 15
	nutriment_factor = 1
	price_tag = 0.6
	glass_special = list(DRINK_FIZZ)

	glass_name = "Jackie Welles"
	glass_desc = "A shot of vodka, lime juice, ginger beer, and most importantly... A splash of love."

/datum/chemical_reaction/drinks/jackie
	name = "Jackie Welles"
	id = "jackie"
	result = "jackie"
	required_reagents = list("vodka" = 2, "limejuice" = 1, "gingerale" = 1, "grenadine" = 1)
	result_amount = 5

/datum/reagent/ethanol/jackie
	glass_icon_state = "jackie"


//Личные коктейли для мёртвых ребят ~Danilcus

/datum/reagent/ethanol/dostoevsky
	name = "Admiral Dostoevsky"
	id = "dostoevsky"
	description = "Alcohol in more alcohol."
	taste_description = "strong sour cognac"
	color = "#e6811c"
	strength = 45
	nutriment_factor = 1
	price_tag = 0.7

	glass_name = "Admiral Dostoevsky"
	glass_desc = "По официальной версии, Адмирал ЭК Алексей Достоевский умер в 2311 г. от сердечного приступа - но по сектору досихпор ходит слушок, что правительство специально устранило неудобную верхушку ЭК, поставив на должность покорную шестёрку."

/datum/chemical_reaction/drinks/dostoevsky
	name = "Admiral Dostoevsky"
	id = "dostoevsky"
	result = "dostoevsky"
	required_reagents = list("cognac" = 2, "lemonjuice" = 3, "vodka" = 1, "beer" = 1) //2311 г.
	result_amount = 8

/datum/reagent/ethanol/dostoevsky
	glass_icon_state = "dostoevsky"