/datum/bodypart
	var/id
	var/mob/living/carbon/human/owner
	var/gender = SBP_APPEAR_ON_FEMALE | SBP_APPEAR_ON_MALE
	var/contacts
	var/covered_by

/datum/bodypart/proc/is_covered()
	if(!covered_by)
		return FALSE
	for(var/obj/item/clothing/C in owner.get_equipped_items())
		if(C.body_parts_covered & covered_by)
			return TRUE
	return FALSE

/datum/bodypart/face
	id = SBP_FACE
	covered_by = HEAD

/datum/bodypart/oral
	id = SBP_ORAL
	covered_by = HEAD

/datum/bodypart/penis
	id = SBP_PENIS
	gender = SBP_APPEAR_ON_MALE
	covered_by = LOWER_TORSO

/datum/bodypart/nipples
	id = SBP_NIPPLES
	covered_by = UPPER_TORSO

/datum/bodypart/breasts
	id = SBP_BREASTS
	gender = SBP_APPEAR_ON_FEMALE
	covered_by = UPPER_TORSO

/datum/bodypart/anal
	id = SBP_ANAL
	covered_by = LOWER_TORSO

/datum/bodypart/vagina
	id = SBP_VAGINA
	gender = SBP_APPEAR_ON_FEMALE
	covered_by = LOWER_TORSO

/datum/bodypart/hands
	id = SBP_HANDS
