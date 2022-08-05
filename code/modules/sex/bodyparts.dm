/datum/bodypart
	var/id
	var/mob/living/carbon/human/owner
	var/gender = SBP_APPEAR_ON_FEMALE | SBP_APPEAR_ON_MALE
	var/contacts
	var/covered_by

/datum/bodypart/proc/is_covered()
	if(!covered_by)
		return FALSE
	if(owner.get_covered_body_parts() & covered_by)
		return TRUE
	for(var/obj/item/underwear/U in owner.worn_underwear)
		if(U.required_free_body_parts & covered_by)
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
	var/length = 16

/datum/bodypart/nipples
	id = SBP_NIPPLES
	covered_by = UPPER_TORSO

/datum/bodypart/breasts
	id = SBP_BREASTS
	gender = SBP_APPEAR_ON_FEMALE
	covered_by = UPPER_TORSO
	var/size = BREASTS_C_CUP

/datum/bodypart/anal
	id = SBP_ANAL
	covered_by = LOWER_TORSO

/datum/bodypart/vagina
	id = SBP_VAGINA
	gender = SBP_APPEAR_ON_FEMALE
	covered_by = LOWER_TORSO

/datum/bodypart/hands
	id = SBP_HANDS
