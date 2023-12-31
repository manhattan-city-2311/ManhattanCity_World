var/datum/species/shapeshifter/promethean/prometheans

// Species definition follows.
/datum/species/shapeshifter/promethean

	name =             SPECIES_PROMETHEAN
	name_plural =      "Prometheans"
	blurb =            "What has Science done?"
	show_ssd =         "totally quiescent"
	death_message =    "rapidly loses cohesion, splattering across the ground..."
	knockout_message = "collapses inwards, forming a disordered puddle of goo."
	remains_type = /obj/effect/decal/cleanable/ash

	blood_color = "#05FF9B"
	flesh_color = "#05FFFB"

	hunger_factor =    0.2
	reagent_tag =      IS_SLIME
	mob_size =         MOB_SMALL
	bump_flag =        SLIME
	swap_flags =       MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags =       MONKEY|SLIME|SIMPLE_ANIMAL
	flags =            NO_SCAN | NO_SLIP | NO_MINOR_CUT | NO_HALLUCINATION | NO_INFECT
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | RADIATION_GLOWS | HAS_UNDERWEAR
	spawn_flags = SPECIES_IS_RESTRICTED | SPECIES_IS_WHITELISTED
	health_hud_intensity = 2
	num_alternate_languages = 3
	species_language = LANGUAGE_SPACER
	assisted_langs = list(LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)	// Prometheans are weird, let's just assume they can use basically any language.

	speech_bubble_appearance = "slime"

	male_cough_sounds = list('sound/effects/slime_squish.ogg')
	female_cough_sounds = list('sound/effects/slime_squish.ogg')

	min_age =		1
	max_age =		10

	additional_wage = 3

	gluttonous =	1
	virus_immune =	1
	blood_volume =	560
	brute_mod =		0.75
	burn_mod =		2
	oxy_mod =		0

	cloning_modifier = /datum/modifier/cloning_sickness/promethean

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 320 //Default 360
	heat_level_2 = 370 //Default 400
	heat_level_3 = 600 //Default 1000

	body_temperature =      310.15

	siemens_coefficient =   0.4
	rarity_value =          5

	genders = list(MALE, FEMALE, NEUTER, PLURAL)

	unarmed_types = list(/datum/unarmed_attack/slime_glomp)
	has_organ =     list(O_BRAIN = /obj/item/organ/internal/brain/slime) // Slime core.
	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest/unbreakable/slime),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/unbreakable/slime),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable/slime),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/unbreakable/slime),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unbreakable/slime),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/unbreakable/slime),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unbreakable/slime),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable/slime),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable/slime),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable/slime),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable/slime)
		)
	heat_discomfort_strings = list("You feel too warm.")
	cold_discomfort_strings = list("You feel too cool.")

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_eye_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/regenerate
		)

	valid_transform_species = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_DIONA, SPECIES_TESHARI, SPECIES_MONKEY)

	var/heal_rate = 0.5 // Temp. Regen per tick.

/datum/species/shapeshifter/promethean/New()
	..()
	prometheans = src

/datum/species/shapeshifter/promethean/equip_survival_gear(var/mob/living/carbon/human/H)
	var/boxtype = pick(typesof(/obj/item/weapon/storage/toolbox/lunchbox))
	var/obj/item/weapon/storage/toolbox/lunchbox/L = new boxtype(get_turf(H))
	var/mob/living/simple_mob/animal/passive/mouse/mouse = new (L)
	var/obj/item/weapon/holder/holder = new (L)
	mouse.forceMove(holder)
	holder.sync(mouse)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(L, slot_r_hand)
	else
		H.equip_to_slot_or_del(L, slot_in_backpack)

/datum/species/shapeshifter/promethean/hug(var/mob/living/carbon/human/H, var/mob/living/target)

	var/t_him = "them"
	if(ishuman(target))
		var/mob/living/carbon/human/T = target
		switch(T.identifying_gender)
			if(MALE)
				t_him = "him"
			if(FEMALE)
				t_him = "her"
	else
		switch(target.gender)
			if(MALE)
				t_him = "him"
			if(FEMALE)
				t_him = "her"

	H.visible_message("<span class='notice'>\The [H] glomps [target] to make [t_him] feel better!</span>", \
					"<span class='notice'>You glomp [target] to make [t_him] feel better!</span>")
	H.apply_stored_shock_to(target)

/datum/species/shapeshifter/promethean/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		if(H)
			H.gib()

/datum/species/shapeshifter/promethean/handle_environment_special(var/mob/living/carbon/human/H)

	var/turf/T = H.loc
	if(istype(T))
		var/obj/effect/decal/cleanable/C = locate() in T
		if(C)
			if(H.shoes || (H.wear_suit && (H.wear_suit.body_parts_covered & FEET)))
				return
			qdel(C)
			if (istype(T, /turf/simulated))
				var/turf/simulated/S = T
				S.dirt = 0
			H.nutrition += rand(15, 45)

	// Heal remaining damage.
	if(H.fire_stacks >= 0)
		if(H.getBruteLoss() || H.getFireLoss() || H.get_deprivation() || H.getToxLoss())
			H.adjustBruteLoss(-heal_rate)
			H.adjustFireLoss(-heal_rate)
			H.adjustOxyLoss(-heal_rate)
			H.adjustToxLoss(-heal_rate)
	else
		H.adjustToxLoss(2*heal_rate)	// Doubled because 0.5 is miniscule, and fire_stacks are capped in both directions

/datum/species/shapeshifter/promethean/get_blood_colour(var/mob/living/carbon/human/H)
	return (H ? rgb(H.r_skin, H.g_skin, H.b_skin) : ..())

/datum/species/shapeshifter/promethean/get_flesh_colour(var/mob/living/carbon/human/H)
	return (H ? rgb(H.r_skin, H.g_skin, H.b_skin) : ..())

/datum/species/shapeshifter/promethean/get_additional_examine_text(var/mob/living/carbon/human/H)

	if(!stored_shock_by_ref["\ref[H]"])
		return

	var/t_she = "She is"
	if(H.identifying_gender == MALE)
		t_she = "He is"
	else if(H.identifying_gender == PLURAL)
		t_she = "They are"
	else if(H.identifying_gender == NEUTER)
		t_she = "It is"

	switch(stored_shock_by_ref["\ref[H]"])
		if(1 to 10)
			return "[t_she] flickering gently with a little electrical activity."
		if(11 to 20)
			return "[t_she] glowing gently with moderate levels of electrical activity.\n"
		if(21 to 35)
			return "<span class='warning'>[t_she] glowing brightly with high levels of electrical activity.</span>"
		if(35 to POSITIVE_INFINITY)
			return "<span class='danger'>[t_she] radiating massive levels of electrical activity!</span>"
