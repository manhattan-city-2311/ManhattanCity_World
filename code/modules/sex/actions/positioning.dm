/datum/erp_action/get_up
	name = "Встать"
	category = ERP_ACTION_CATEGORY_POSITIONING
	self_action = TRUE

/datum/erp_action/get_up/is_available(mob/living/carbon/human/user1)
	if(!user1.erp_allow_position())
		return FALSE

	var/cur = user1.get_position_id()
	return cur != POS_STANDING && cur != POS_SITTING

/datum/erp_action/get_up/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	if(user1.get_position_id() == POS_KNEELING)
		return list(
			"@1 медленно и аккуратно поднимается на ноги.",
			"@1 подскакивает на ноги."
		)


/datum/erp_action/get_up/act(mob/living/carbon/human/user1)
	. = ..()
	if(!.)
		return

	if(user1.get_position_id() == POS_LYING && !user1.buckled)
		user1.resting = FALSE
	user1.erp_position = new /datum/erp_position/standing

/datum/erp_action/lie_back
	name = "Лечь на спину"
	category = ERP_ACTION_CATEGORY_POSITIONING
	self_action = TRUE

/datum/erp_action/lie_back/is_available(mob/living/carbon/human/user1)
	if(!user1.erp_allow_position())
		return FALSE

	var/cur = user1.get_position_id()
	return cur != POS_LYING

/datum/erp_action/lie_back/act(mob/living/carbon/human/user1)
	. = ..()
	if(!.)
		return

	user1.resting = TRUE
	user1.erp_position = new /datum/erp_position/lying

/datum/erp_action/lie_back/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	return list(
		"@1 аккуратно и плавно укладывается на спину.",
		"@1 плюхается на спину, развалившись в позе морской звёзды."
	)

/datum/erp_action/lie_front
	name = "Лечь на живот"
	category = ERP_ACTION_CATEGORY_POSITIONING
	self_action = TRUE

/datum/erp_action/liefront/is_available(mob/living/carbon/human/user1)
	if(!user1.erp_allow_position())
		return FALSE

	var/cur = user1.get_position_id()
	return cur != POS_LYING

/datum/erp_action/lie_front/act(mob/living/carbon/human/user1)
	. = ..()
	if(!.)
		return

	user1.resting = TRUE
	user1.erp_position = new /datum/erp_position/lying

/datum/erp_action/lie_front/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	return list(
		"@1 медленно и аккуратно чуть проползает вперёд, и укладывается на живот.",
		"@1 хлопается лицом вперёд, улеглись на живот."
	)

/datum/erp_action/kneel
	name = "Встать на колени"
	category = ERP_ACTION_CATEGORY_POSITIONING
	self_action = TRUE

/datum/erp_action/kneel/get_messages()
	return list(
		"@1 плавно и аккуратно опускается на колени перед @2.",
		"@1 проворно встаёт на колени перед @2."
	)

/datum/erp_action/kneel/is_available(mob/living/carbon/human/user1)
	if(!user1.erp_allow_position())
		return FALSE

	return user1.get_position_id() == POS_STANDING

/datum/erp_action/kneel/act(mob/living/carbon/human/user1)
	. = ..()
	if(!.)
		return
	user1.erp_position = new /datum/erp_position/kneeling

/datum/erp_action/kneel/fall
	name = "Рухнуть на колени"

/datum/erp_action/kneel/fall/get_messages(user1, user2)
	return list(
		"@1 позабыв осторожность обрушивается на пол, оказываясь [pronounce_helper(user2, "стоящим", "стоящей")] на коленях перед @2.",
		"@1 мгновенно хлопается на колени перед @2, раздаётся громкий стук."
	)

// TODO: optimize

/obj/structure/bed/buckle_mob(mob/living/M, forced, check_loc)
	. = ..()
	if(!ishuman(M))
		return
	spawn()
		var/mob/living/carbon/human/H = M
		if(!H.erp_position)
			return
		if(H.resting)
			H.erp_position = new /datum/erp_position/standing
		else
			H.erp_position = new /datum/erp_position/sitting
		H.show_erp_panel()
		H.erp_participient?.show_erp_panel()

/obj/structure/bed/unbuckle_mob(mob/living/M)
	. = ..()
	if(!ishuman(M))
		return
	spawn()
		var/mob/living/carbon/human/H = M
		if(!H.erp_position)
			return
		H.erp_position = new /datum/erp_position/standing
		H.show_erp_panel()
		H.erp_participient?.show_erp_panel()
