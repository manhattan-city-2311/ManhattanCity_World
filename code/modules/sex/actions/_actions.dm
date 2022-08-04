var/global/list/datum/erp_action/erp_actions_cache

/proc/initialize_erp_actions()
	if(global.erp_actions_cache)
		return

	global.erp_actions_cache = list()

	for(var/T in subtypesof(/datum/erp_action))
		var/datum/erp_action/A = new T
		global.erp_actions_cache[A.name] = A

/datum/erp_action
	var/name = "FIXME ACTION"
	var/action_type = ERP_ACTION_NORMAL

	var/category = ERP_ACTION_CATEGORY_ROMANCE

	var/self_action = FALSE

	var/allowed_poses

	var/list/base_pleasure = list(0, 0)

	var/sbp
	var/needs_access

/datum/erp_action/proc/height_picker(mob/living/carbon/human/user1, mob/living/carbon/human/user2, list/source)
	var/diff = user1.height - user2.height
	if(diff > 10)
		return source[3]
	if(diff < -10)
		return source[1]
	return source[2]

/datum/erp_action/proc/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	CRASH("Not implemented")

/datum/erp_action/proc/pronouns_helper(mob/user, f1 = "он", f2 = "она")
	return user.gender == MALE ? f1 : f2

/datum/erp_action/proc/is_available(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	if(allowed_poses)
		var/allowed = FALSE
		for(var/L in allowed_poses)
			if(user1.get_position_id() == L[1] && user2.get_position_id() == L[2])
				allowed = TRUE
				continue
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
