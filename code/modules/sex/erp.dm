/mob/living/carbon/human
	var/pleasure = 0
	var/last_orgasm = 0
	var/datum/erp_position/erp_position
	var/mob/living/carbon/human/erp_participient
	var/list/datum/bodypart/sbps

/mob/living/carbon/human/initialize()
	. = ..()
	sbps = list()
	for(var/T in subtypesof(/datum/bodypart))
		var/datum/bodypart/SBP = new T
		if(!(SBP.gender & (gender == MALE ? SBP_APPEAR_ON_MALE : SBP_APPEAR_ON_FEMALE)))
			continue
		SBP.owner = src
		sbps[SBP.id] = SBP

/mob/living/carbon/human/proc/get_position_id()
	return erp_position?.id

/mob/living/carbon/human/proc/initialize_erp(mob/living/carbon/human/H, force = FALSE)
	if(resting)
		erp_position = new /datum/erp_position/lying
	else if(buckled)
		erp_position = new /datum/erp_position/sitting
	else
		erp_position = new /datum/erp_position/standing
	erp_participient = H

/mob/living/carbon/human/proc/get_available_actions()
	initialize_erp_actions()
	. = list()
	for(var/ID in global.erp_actions_cache)
		var/datum/erp_action/A = global.erp_actions_cache[ID]
		if(A.is_available(src, erp_participient))
			. += ID

/mob/living/carbon/human/proc/can_leave_erp()
	return TRUE

// TODO: Quit messages while performing some actions
/mob/living/carbon/human/proc/quit_erp(force = FALSE)
	if(can_leave_erp() && !force)
		return

	erp_position = null
	erp_participient?.quit_erp()
	erp_participient = null

/mob/living/carbon/human/proc/get_pleasure_message()
	if(gender == FEMALE)
		switch(pleasure)
			if(-INFINITY to 50)
				return "Внизу сухо. Если сейчас в вас попытаются войти - вам будет больно. Очень."
			if(50 to 80)
				return "Ваши соски твердеют, вы намокаете внизу. Если постараетесь, то сможете быстро успокоиться."
			if(80 to INFINITY)
				return "Ваши соски стоят торчком и даже могут быть видны через лёгкую одежду. Внизу вы полностью намокли и там немного тянет."
	else
		switch(pleasure)
			if(-INFINITY to 50)
				return "Вы не чувствуете какого-либо возбуждения."
			if(50 to 80)
				return "Вы чувствуете тяжесть в паху."
			if(80 to INFINITY)
				return "Вас немного ведёт. Ваше дыхание загнано, а член стоит колом."

/mob/living/carbon/human/proc/handle_erp()
	var/isMale = gender == MALE
	var/can_orgasm = world.time > (last_orgasm + (isMale ? MALE_RECOVERY_PERIOD : FEMALE_RECOVERY_PERIOD))
	if(!can_orgasm)
		return

	if(pleasure > (isMale ? MALE_ORGASM_CAP : FEMALE_ORGASM_CAP))
		orgasm()

/mob/living/carbon/human/proc/orgasm()
	last_orgasm = world.time

	if(gender == MALE)
		to_chat(src, SPAN_PLEASURE(pick(MALE_ORGASM_MESSAGES)))
	else
		to_chat(src, SPAN_PLEASURE(pick(FEMALE_ORGASM_MESSAGES)))
