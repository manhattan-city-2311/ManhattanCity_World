/datum/erp_action/moan
	name = "Издать стон"
	self_action = TRUE
	category = ERP_ACTION_CATEGORY_SEX

/datum/erp_action/moan/get_messages(mob/living/carbon/human/user1)
	var/list/msgs1 = list(
		"@1 краснеет и по [pronounce_helper(user1)] телу проходит рой мурашек.",
		"@1 громко сглатывает.",
		"@1 рвано выдыхает через нос."
	)

	var/list/msgs2 = list(
		"С губ @1 срывается короткий стон, переходящий в выдох.",
		"@1 тяжело дышит, [pronounce_helper(user1)] тело сильно дрожит.",
		"@1 непроизвольно чуть дергает бёдрами.",
		"@1 издает серию коротких, прерывистых стонов."
	)

	var/list/msgs3 = list(
		"@1 очень тяжело и довольно прерывисто дышит в попытках задушить стон.",
		"@1 запрокидывает голову назад, приоткрыв рот, [pronounce_helper(user1)] глаза непроизвольно закатываются.",
		"@1 постанывает, прикусив губу.",
		"@1 жмуриться, и напрягает бедра."
	)

	if(user1.gender == FEMALE)
		switch(user1.pleasure)
			if(0 to FEMALE_NO_AROUSAL)
				return msgs1
			if(FEMALE_NO_AROUSAL to FEMALE_MEDIUM_AROUSAL)
				return msgs2
			if(FEMALE_MEDIUM_AROUSAL to POSITIVE_INFINITY)
				return msgs3
	else
		switch(user1.pleasure)
			if(0 to MALE_NO_AROUSAL)
				return msgs1
			if(MALE_NO_AROUSAL to MALE_MEDIUM_AROUSAL)
				return msgs2
			if(MALE_MEDIUM_AROUSAL to POSITIVE_INFINITY)
				return msgs3
