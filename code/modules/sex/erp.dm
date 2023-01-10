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

/mob/living/carbon/human/proc/erp_allow_position()
	return TRUE

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
		if(!A.self_action)
			if(A.name && A.is_available(src, erp_participient))
				. += ID

/mob/living/carbon/human/proc/get_available_self_actions()
	initialize_erp_actions()
	. = list()
	for(var/ID in global.erp_actions_cache)
		var/datum/erp_action/A = global.erp_actions_cache[ID]
		if(A.self_action)
			if(A.name && A.is_available(src, erp_participient))
				. += ID

/mob/living/carbon/human/proc/can_leave_erp()
	return TRUE

// TODO: Quit messages while performing some actions
/mob/living/carbon/human/proc/quit_erp(force = FALSE)
	if(can_leave_erp() && !force)
		return

	if(erp_participient)
		erp_participient.erp_participient = null
		erp_participient.quit_erp()
		erp_participient = null

	erp_position = null

/mob/living/carbon/human/proc/get_erp_description()
	var/height_msg
	switch(height)
		if(0 to 155)
			height_msg = "очень низкого"
		if(155 to 160)
			height_msg = "низкого"
		if(160 to 175)
			height_msg = "среднего"
		if(175 to 185)
			height_msg = "высокого"
		if(185 to POSITIVE_INFINITY)
			height_msg = "очень высокого"

	var/body_build_msg
	switch(weight / (((height / 100.0) ** 2) || -1))
		if(NEGATIVE_INFINITY to 0)
			body_build_msg = "стройного"
		if(0 to 16)
			body_build_msg = "скелетного"
		if(16 to 18.5)
			body_build_msg = "худощавого"
		if(18.5 to 21)
			body_build_msg = "стройного"
		if(21 to 25)
			body_build_msg = "изгибистого"
		if(25 to 30)
			body_build_msg = "пухловатого"
		if(30 to 35)
			body_build_msg = "увестистого"
		if(35 to 45)
			body_build_msg = "очень увесистого"

	if(gender == FEMALE)
		. = "Это "
		. += age > 35 ? "женщина" : "девушка"
		. += ", не старше [round(age, 5)], [height_msg] роста, [body_build_msg] телосложения. "
		if(SBP_BREASTS in sbps)
			. += "У неё "
			var/datum/bodypart/breasts/B = sbps[SBP_BREASTS]
			switch(B.size)
				if(BREASTS_A_CUP)
					. += "практически незаметная, крохотная"
				if(BREASTS_B_CUP)
					. += "небольшая"
				if(BREASTS_C_CUP)
					. += "приятной формы, средненькая"
				if(BREASTS_D_CUP)
					. += "довольно объемная, но не слишком"
				if(BREASTS_E_CUP)
					. += "объемная, даже большая"
				if(BREASTS_F_CUP)
					. += "большая, выпирающая"
				if(BREASTS_G_CUP)
					. += "очень большая, даже громадная"
			. += " грудь. Она "
		switch(pleasure)
			if(NEGATIVE_INFINITY to FEMALE_NO_AROUSAL)
				. += "не возбуждена."
			if(FEMALE_NO_AROUSAL to FEMALE_MEDIUM_AROUSAL)
				. += "немного возбуждена."
			if(FEMALE_MEDIUM_AROUSAL to POSITIVE_INFINITY)
				. += "сильно возбуждена."
	else
		. = "Это "
		. += age > 35 ? "мужчина" : "парень"
		. += ", не старше [round(age, 5)] лет, [height_msg] роста, [body_build_msg] телосложения. "
		var/datum/bodypart/penis/P = sbps[SBP_PENIS]
		if(!P.is_covered())
			. += "Его член "

			switch(pleasure)
				if(NEGATIVE_INFINITY to FEMALE_NO_AROUSAL)
					. += "мягкий, "
				if(FEMALE_NO_AROUSAL to FEMALE_MEDIUM_AROUSAL)
					. += "полутвёрдый, "
				if(FEMALE_MEDIUM_AROUSAL to POSITIVE_INFINITY)
					. += "стоит колом, "
			switch(P.length)
				if(0 to 8)
					. += "крохотной"
				if(8 to 12)
					. += "маленькой"
				if(12 to 16)
					. += "средней"
				if(16 to 18)
					. += "большой"
				if(18 to POSITIVE_INFINITY)
					. += "огромной"
			. += " длины, средний в обхвате."


/mob/living/carbon/human/proc/get_self_pleasure_message()
	if(gender == FEMALE)
		switch(pleasure)
			if(NEGATIVE_INFINITY to FEMALE_NO_AROUSAL)
				return "Внизу сухо. Если сейчас в вас попытаются войти - вам будет больно, очень."
			if(FEMALE_NO_AROUSAL to FEMALE_MEDIUM_AROUSAL)
				return "Ваши соски твердеют, вы намокаете внизу. Если постараетесь, то сможете быстро успокоиться."
			if(FEMALE_MEDIUM_AROUSAL to POSITIVE_INFINITY)
				return "Ваши соски стоят торчком и даже могут быть видны через лёгкую одежду. Внизу вы полностью намокли и там немного тянет."
	else
		switch(pleasure)
			if(NEGATIVE_INFINITY to MALE_NO_AROUSAL)
				return "Вы не чувствуете какого-либо возбуждения."
			if(MALE_NO_AROUSAL to MALE_MEDIUM_AROUSAL)
				return "Вы чувствуете тяжесть в паху."
			if(MALE_MEDIUM_AROUSAL to POSITIVE_INFINITY)
				return "Вас немного ведёт. Ваше дыхание загнано, а член стоит колом."

/mob/living/carbon/human/proc/orgasm()
	last_orgasm = world.time

	if(gender == MALE)
		to_chat(src, SPAN_PLEASURE(pick(MALE_ORGASM_MESSAGES)))
	else
		to_chat(src, SPAN_PLEASURE(pick(FEMALE_ORGASM_MESSAGES)))
