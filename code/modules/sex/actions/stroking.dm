/datum/erp_action/back_stroke
	name = "Поглаживание по спине"
	category = ERP_ACTION_CATEGORY_FOREPLAY
	sbp = SBP_HANDS

/datum/erp_action/back_stroke/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	if(user2.get_covered_body_parts() & UPPER_TORSO)
		return list(
			"@1 мягко проводит рукой по спине @2, возможно немного ниже приличного.",
			"@1 выводит пальцами круги на спине @2.",
			"@1 прикасается ладонью к спине @2, проводя вверх-вниз."
		)
	else
		return list(
			"@1 нежно касается кожи на спине @2, посылая по [pronounce_helper(user2, "его", "её")] телу табуны мурашек.",
			"@1 чуть сжимает и ведёт пальцами по коже спины @2.",
			"@1 выводит узоры на коже спины @2."
		)

/datum/erp_action/hips_stroke
	name = "Поглаживания по бёдрам"
	category = ERP_ACTION_CATEGORY_FOREPLAY
	sbp = SBP_HANDS

/datum/erp_action/hips_stroke/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	if(user2.get_covered_body_parts() & LOWER_TORSO)
		return list(
			"@1 касается талии @2, проводит рукой вниз, и вот [pronounce_helper(user2)] рука уже покоится на бедре @2.",
			"@1 плотно сжимает бедра @2.",
			"@1 кладёт свои ладони на бедра @2 и водит по ним вверх-вниз."
		)
	else
		return list(
			"@1 кладёт свою руку на бедро @2, медленно оглаживая кожу.",
			"@1 укладывает свои ладони на бедра @2, плотно сжимая мягкую плоть.",
			"@1 впивается пальцами в кожу бёдер @2."
		)

/datum/erp_action/hair_stroke
	name = "Игра с волосами"
	category = ERP_ACTION_CATEGORY_FOREPLAY
	sbp = SBP_HANDS

/datum/erp_action/hair_stroke/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	return list(
		"@1 кладёт руку на голову @2.",
		"@1 проводит рукой по волосам @2.",
		"@1 плавно сжимает волосы на голове @2."
	)

/datum/erp_action/ass_stroke
	name = "Игра с задницей"
	category = ERP_ACTION_CATEGORY_FOREPLAY
	sbp = SBP_HANDS
	//needs_access = SBP_ASS

/datum/erp_action/ass_stroke/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	if(user2.get_covered_body_parts() & LOWER_TORSO)
		return list(
			"@1 звонко шлёпает @2 по попе!",
			"@1 сжимает ягодицу @2 сквозь ткань одежды.",
			"@1 проводит рукой по попке @2."
		)
	else
		return list(
			"@1 сжимает задницу @2 ладонями, ощупывая мягкую кожу.",
			"@1 впивается пальцами в кожу ягодиц @2.",
			"@1 похлопывает по голой попе @2."
		)

/datum/erp_action/nipples_stroke
	name = "Игра с сосками"
	category = ERP_ACTION_CATEGORY_FOREPLAY
	sbp = SBP_HANDS
	needs_access = SBP_NIPPLES

/datum/erp_action/nipples_stroke/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	if(user2.get_covered_body_parts() & UPPER_TORSO)
		return list(
			"@1 прикасается к груди @2, в районе сосков и чуть нажимает.",
			"@1 проводит пальцами по скрытым одеждой соскам @2."
		)
	else
		return list(
			"@1 сжимает соски @2, и держит их между своих пальцев.",
			"@1 пощипывает [prob(50) ? "левый" : "правый"] сосок @2.",
			"@1 сжимает и крутит между пальцев соски @2, чуть оттягивая их.",
		)

/datum/erp_action/breasts_stroke
	name = "Игра с грудью"
	category = ERP_ACTION_CATEGORY_FOREPLAY
	sbp = SBP_HANDS
	needs_access = SBP_BREASTS

/datum/erp_action/nipples_stroke/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	if(user2.get_covered_body_parts() & UPPER_TORSO)
		return list(
			"@1 сжимает мягкие полушария через препятствие в виде ткани.",
			"@1 мягко массирует грудь @2 через одежду.",
			"@1 плотно сжимает грудь @2 через ткань."
		)
	else
		return list(
			"@1 разводит нежные полушария @2 в стороны а потом снова сводит вместе.",
			"@1 массирует чувствительную грудь @2.",
			"@1 надавливает на грудь @2, поминая её словно кот.",
		)
