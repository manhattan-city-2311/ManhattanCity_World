/mob/living/carbon/human/verb/interact()
	set name = "Взаимодействовать"
	set src in view(1)

	var/mob/living/carbon/human/user = usr

	var/p_interaction
	if(user.erp_datum)
		if(user.erp_datum != erp_datum)
			return
		if(user.erp_datum.can_leave())
			p_interaction = "Выйти из сессии"
	else
		p_interaction = erp_datum ? "Присоединится к сессии" : "Начать сессию"

	var/interaction = input(usr, "Выберите взаимодействие", "Взаимодействие") as anything|null in p_interaction

	if(!interaction)
		return
	
	switch(p_interaction)
		if("Начать сессию")
			join_erp_session(user.start_erp_session())
		if("Присоединится к сессии")
			user.join_erp_session(erp_datum.erp_session)
		if("Выйти из сессии")
			user.leave_erp_session()	