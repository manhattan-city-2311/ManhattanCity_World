/datum/species/human
	name = SPECIES_HUMAN
	name_plural = "Humans"
	primitive_form = SPECIES_MONKEY
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	blurb = "A grotesque race that has allowed consumerism and money to overtake all other desires, Their for clay have led to class strife and ethical decay. \
	Their strict caste systems allowing them to slight and sneer at each other even as they oppress their servants that they create en-masse.<br><br> \
	And why not? Rightfully so, they rule the known universe."
	num_alternate_languages = 3
	species_language = LANGUAGE_SOL_COMMON
	secondary_langs = list(LANGUAGE_SOL_COMMON, LANGUAGE_TERMINUS)
	name_language = null // Use the first-name last-name generator rather than a language scrambler
	additional_wage = 0
	assisted_langs = list(LANGUAGE_EAL, LANGUAGE_SKRELLIAN, LANGUAGE_SKRELLIANFAR, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)
	min_age = 18
	max_age = 120
	slowdown = 1.2
	bandages_icon = 'icons/mob/bandage.dmi'
	health_hud_intensity = 1.5

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	has_organ = list(
		O_HEART =		/obj/item/organ/internal/heart,
		O_LUNGS =		/obj/item/organ/internal/lungs,
		O_VOICE = 		/obj/item/organ/internal/voicebox,
		O_LIVER =		/obj/item/organ/internal/liver,
		O_KIDNEYS =		/obj/item/organ/internal/kidneys,
		O_BRAIN =		/obj/item/organ/internal/brain,
		O_APPENDIX = 	/obj/item/organ/internal/appendix,
		O_SPLEEN = 		/obj/item/organ/internal/spleen,
		O_EYES =		/obj/item/organ/internal/eyes,
		O_STOMACH =		/obj/item/organ/internal/stomach,
		O_INTESTINE =	/obj/item/organ/internal/intestine
		)

/datum/species/human/get_bodytype(var/mob/living/carbon/human/H)
	return SPECIES_HUMAN