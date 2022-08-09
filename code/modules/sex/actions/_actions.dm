var/global/list/datum/erp_action/erp_actions_cache

/proc/initialize_erp_actions()
	if(global.erp_actions_cache)
		return

	global.erp_actions_cache = list()

	for(var/T in subtypesof(/datum/erp_action))
		var/datum/erp_action/A = new T
		global.erp_actions_cache["[A.type]"] = A

/datum/erp_action
	var/name
	var/action_type = ERP_ACTION_NORMAL

	var/category = ERP_ACTION_CATEGORY_ROMANCE

	var/self_action = FALSE

	var/list/allowed_poses

	var/list/base_pleasure = list(0, 0)

	var/duration = 20

	var/sbp
	var/needs_access

	var/active_id

	var/hidden = FALSE

/datum/erp_action/proc/get_poses(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	. = list(user1.get_position_id())
	if(user2)
		. += user2.get_position_id()

/datum/erp_action/proc/height_picker(mob/living/carbon/human/user1, mob/living/carbon/human/user2, list/source)
	var/diff = user1.height - user2.height
	if(diff > 10)
		return source[3]
	if(diff < -10)
		return source[1]
	return source[2]

/datum/erp_action/proc/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2, number)
	return

/datum/erp_action/proc/pronounce_helper(mob/user, f1 = "его", f2 = "её")
	return user.gender == MALE ? f1 : f2

/datum/erp_action/proc/is_available(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	if(!name)
		return
	if(allowed_poses)
		var/allowed = FALSE
		var/list/poses = get_poses(user1, user2)
		for(var/list/L in allowed_poses)
			if(poses ~= L)
				allowed = TRUE
				break
		if(!allowed)
			return FALSE
	if(sbp && user1)
		if(!(needs_access in user1.sbps) || user1.sbps[sbp].is_covered())
			return FALSE
	if(needs_access && user2)
		if(!(needs_access in user2.sbps) || user2.sbps[needs_access].is_covered())
			return FALSE
	return TRUE

/datum/erp_action/proc/pick_message(mob/user1, mob/user2)
	return pick(get_messages(user1, user2))

/datum/erp_action/proc/get_action_text(mob/user1, mob/user2)
	. = pick_message(user1, user2)
	. = replacetext_char(., "@1", "[icon2html(user1, viewers(user1))][user1]")
	. = replacetext_char(., "@2", "[icon2html(user2, viewers(user1))][user2]")

/mob/living/carbon/human
	var/currently_erp_acting = FALSE
	var/list/current_erp_actions = list()

/datum/erp_action/proc/get_stage(mob/living/carbon/human/user)
	return user.current_erp_actions[src]

/datum/erp_action/proc/advance_stage(mob/living/carbon/human/user)
	++user.current_erp_actions[src]

/datum/erp_action/proc/act(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	if(!self_action)
		if(user1.currently_erp_acting)
			return

		user1.currently_erp_acting = TRUE
		if(!do_after(user1, duration, user2))
			user1.currently_erp_acting = FALSE
			return FALSE
		user1.currently_erp_acting = FALSE

	if(active_id)
		var/found
		for(var/datum/erp_action/A in user1.current_erp_actions)
			if(A.active_id == active_id)
				found = A
				break
		if(!found)
			for(var/datum/erp_action/A in user1.current_erp_actions)
				if(A.sbp == sbp)
					return
			for(var/datum/erp_action/A in user2.current_erp_actions)
				if(needs_access & A.sbp)
					return
		user1.current_erp_actions -= found
		user1.current_erp_actions[src] = 0

	var/message = get_action_text(user1, user2)
	if(message)
		user1.visible_message(SPAN_PLEASURE(message))

	user1.pleasure += base_pleasure[1]
	user2.pleasure += base_pleasure[2]

	return TRUE
