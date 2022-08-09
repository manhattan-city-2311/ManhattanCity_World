/datum/erp_action/cum
	category = ERP_ACTION_CATEGORY_SEX
	sbp = SBP_PENIS
	var/req

/datum/erp_action/cum/is_available(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	if(!(..()) || !req)
		return

	for(var/datum/erp_action/A in user2.current_erp_actions)
		if(A.active_id == req)
			return TRUE
	return FALSE

/datum/erp_action/cum/act(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	if(!..())
		return
	for(var/datum/erp_action/blowjob/B in user2.current_erp_actions)
		user2.current_erp_actions -= B
/datum/erp_action/cum/oral
	name = "Кончить внутрь"
	hidden = FALSE
	req = "blowjob"

/datum/erp_action/cum/oral/get_messages()
	return list(
		"@1 жмурится и издает протяжный стон, заливая спермой рот @2."
	)

/datum/erp_action/cum/oral/outside
	name = "Кончить на лицо"

/datum/erp_action/cum/oral/outside/get_messages()
	return list(
		"@1 сжимает ладони, и, спустя серию резких вздохов и стонов, заливает спермой лицо @2."
	)
