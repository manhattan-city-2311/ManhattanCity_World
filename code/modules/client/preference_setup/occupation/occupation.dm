/datum/category_item/player_setup_item/occupation
	name = "Профессии"
	sort_order = 1

/datum/category_item/player_setup_item/occupation/load_character(var/savefile/S)
	S["alternate_option"]	>> pref.alternate_option
	S["job_civilian_high"]	>> pref.job_civilian_high
	S["job_civilian_med"]	>> pref.job_civilian_med
	S["job_civilian_low"]	>> pref.job_civilian_low
	S["job_medsci_high"]	>> pref.job_medsci_high
	S["job_medsci_med"]		>> pref.job_medsci_med
	S["job_medsci_low"]		>> pref.job_medsci_low
	S["job_engsec_high"]	>> pref.job_engsec_high
	S["job_engsec_med"]		>> pref.job_engsec_med
	S["job_engsec_low"]		>> pref.job_engsec_low
	S["job_govlaw_high"]	>> pref.job_govlaw_high
	S["job_govlaw_med"]		>> pref.job_govlaw_med
	S["job_govlaw_low"]		>> pref.job_govlaw_low
	S["player_alt_titles"]	>> pref.player_alt_titles

/datum/category_item/player_setup_item/occupation/save_character(var/savefile/S)
	S["alternate_option"]	<< pref.alternate_option
	S["job_civilian_high"]	<< pref.job_civilian_high
	S["job_civilian_med"]	<< pref.job_civilian_med
	S["job_civilian_low"]	<< pref.job_civilian_low
	S["job_medsci_high"]	<< pref.job_medsci_high
	S["job_medsci_med"]		<< pref.job_medsci_med
	S["job_medsci_low"]		<< pref.job_medsci_low
	S["job_engsec_high"]	<< pref.job_engsec_high
	S["job_engsec_med"]		<< pref.job_engsec_med
	S["job_engsec_low"]		<< pref.job_engsec_low
	S["job_govlaw_high"]	<< pref.job_govlaw_high
	S["job_govlaw_med"]		<< pref.job_govlaw_med
	S["job_govlaw_low"]		<< pref.job_govlaw_low
	S["player_alt_titles"]	<< pref.player_alt_titles

/datum/category_item/player_setup_item/occupation/sanitize_character()
	pref.alternate_option	= sanitize_integer(pref.alternate_option, 0, 2, initial(pref.alternate_option))
	pref.job_civilian_high	= sanitize_integer(pref.job_civilian_high, 0, 65535, initial(pref.job_civilian_high))
	pref.job_civilian_med	= sanitize_integer(pref.job_civilian_med, 0, 65535, initial(pref.job_civilian_med))
	pref.job_civilian_low	= sanitize_integer(pref.job_civilian_low, 0, 65535, initial(pref.job_civilian_low))
	pref.job_medsci_high	= sanitize_integer(pref.job_medsci_high, 0, 65535, initial(pref.job_medsci_high))
	pref.job_medsci_med		= sanitize_integer(pref.job_medsci_med, 0, 65535, initial(pref.job_medsci_med))
	pref.job_medsci_low		= sanitize_integer(pref.job_medsci_low, 0, 65535, initial(pref.job_medsci_low))
	pref.job_engsec_high	= sanitize_integer(pref.job_engsec_high, 0, 65535, initial(pref.job_engsec_high))
	pref.job_engsec_med 	= sanitize_integer(pref.job_engsec_med, 0, 65535, initial(pref.job_engsec_med))
	pref.job_engsec_low 	= sanitize_integer(pref.job_engsec_low, 0, 65535, initial(pref.job_engsec_low))
	pref.job_govlaw_high	= sanitize_integer(pref.job_govlaw_high, 0, 65535, initial(pref.job_govlaw_high))
	pref.job_govlaw_med 	= sanitize_integer(pref.job_govlaw_med, 0, 65535, initial(pref.job_govlaw_med))
	pref.job_govlaw_low 	= sanitize_integer(pref.job_govlaw_low, 0, 65535, initial(pref.job_govlaw_low))

	if(!(pref.player_alt_titles)) pref.player_alt_titles = new()

	if(!SSjobs)
		return

	for(var/datum/job/job in SSjobs.occupations)
		var/alt_title = pref.player_alt_titles[job.title]
		if(alt_title && !(alt_title in job.alt_titles))
			pref.player_alt_titles -= job.title

/datum/category_item/player_setup_item/occupation/content(mob/user, limit = 18, list/splitJobs = list("Fire Chief"))
	if(!SSjobs)
		return

	. = list()
	. += "<tt><center>"
	. += "<b>Выберите шансы на занятие профессии</b><br>Недоступные профессии зачёркнуты.<br>"
	. += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more columns.
	. += "<table width='100%' cellpadding='1' cellspacing='0'>"
	var/index = -1

	//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
	var/datum/job/lastJob
	if (!SSjobs)		return
	for(var/datum/job/job in SSjobs.occupations)
		if(job.business)
			continue
		if((++index >= limit) || (job.title in splitJobs))
/*******
			if((index < limit) && (lastJob != null))
				//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
				//the last job's selection color and blank buttons that do nothing. Creating a rather nice effect.
				for(var/i = 0, i < (limit - index), i++)
					. += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'>//>&nbsp</a></td><td><a>&nbsp</a></td></tr>"
*******/
			. += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		. += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"
		var/rank = job.title
		lastJob = job
		if(jobban_isbanned(user, rank))
			. += "<del>[rank]</del></td><td><b> \[ОГРАНИЧЕНО]</b></td></tr>"
			continue
		if(!job.player_old_enough(user.client))
			var/available_in_days = job.available_in_days(user.client)
			. += "<del>[rank]</del></td><td> \[ДОСТУПНО ЧЕРЕЗ [(available_in_days)] ДНЕЙ]</td></tr>"
			continue
		if(job.hard_whitelisted && !is_hard_whitelisted(user, job))
			. += "<del>[rank]</del></td><td><b> \[ПОД БЕЛЫМ СПИСКОМ]</b></td></tr>"
			continue
		if(job.minimum_character_age && user.client && (user.client.prefs.age < job.minimum_character_age))
			. += "<del>[rank]</del></td><td> \[МИНИМАЛЬНЫЙ ВОЗРАСТ ПЕРСОНАЖА: [job.minimum_character_age]]</td></tr>"
			continue
		if((pref.job_civilian_low & ASSISTANT) && job.type != /datum/job/assistant)
			. += "<font color=grey>[rank]</font></td><td></td></tr>"
			continue
		if((rank in command_positions) || (rank == "AI"))//Bold head jobs
			. += "<b>[rank]</b>"
		else
			. += "[rank]"

		. += "</td><td width='40%'>"

		. += "<a href='?src=\ref[src];set_job=[rank]'>"

		if(job.type == /datum/job/assistant)//Assistant is special
			if(pref.job_civilian_low & ASSISTANT)
				. += " <font color=55cc55>\[Yes]</font>"
			else
				. += " <font color=black>\[No]</font>"
			if(job.alt_titles) //Blatantly cloned from a few lines down.
				. += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'>&nbsp</td><td><a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[pref.GetPlayerAltTitle(job)]\]</a></td></tr>"
			. += "</a></td></tr>"
			continue

		if(pref.GetJobDepartment(job, 1) & job.flag)
			. += " <font color=55cc55>\[Высокий]</font>"
		else if(pref.GetJobDepartment(job, 2) & job.flag)
			. += " <font color=eecc22>\[Средний]</font>"
		else if(pref.GetJobDepartment(job, 3) & job.flag)
			. += " <font color=cc5555>\[Низкий]</font>"
		else
			. += " <font color=black>\[НИКОГДА]</font>"
		if(job.alt_titles)
			. += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'>&nbsp</td><td><a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[pref.GetPlayerAltTitle(job)]\]</a></td></tr>"
		. += "</a></td></tr>"
	. += "</td'></tr></table>"
	. += "</center></table><center>"

	switch(pref.alternate_option)
		if(GET_RANDOM_JOB)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Получать случайную профессию, если выбранная профессия недоступна</a></u>"
		if(BE_ASSISTANT)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Быть ассистентом, если выбранная профессия недоступна</a></u>"
		if(RETURN_TO_LOBBY)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Вернуться в лобби, если выбранная профессия недоступна</a></u>"

	. += "<a href='?src=\ref[src];reset_jobs=1'>\[Сбросить]</a></center>"
	. += "</tt>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/occupation/OnTopic(href, href_list, user)
	if(href_list["reset_jobs"])
		ResetJobs()
		return TOPIC_REFRESH

	else if(href_list["job_alternative"])
		if(pref.alternate_option == GET_RANDOM_JOB || pref.alternate_option == BE_ASSISTANT)
			pref.alternate_option += 1
		else if(pref.alternate_option == RETURN_TO_LOBBY)
			pref.alternate_option = 0
		return TOPIC_REFRESH

	else if(href_list["select_alt_title"])
		var/datum/job/job = locate(href_list["select_alt_title"])
		if (job)
			var/choices = list(job.title) + job.alt_titles
			var/choice = input("Выберите титул для [job.title].", "Выбор титула", pref.GetPlayerAltTitle(job)) as anything in choices|null
			if(choice && CanUseTopic(user))
				SetPlayerAltTitle(job, choice)
				return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)

	else if(href_list["set_job"])
		if(SetJob(user, href_list["set_job"])) return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)

	return ..()

/datum/category_item/player_setup_item/occupation/proc/SetPlayerAltTitle(datum/job/job, new_title)
	// remove existing entry
	pref.player_alt_titles -= job.title
	// add one if it's not default
	if(job.title != new_title)
		pref.player_alt_titles[job.title] = new_title

/datum/category_item/player_setup_item/occupation/proc/SetJob(mob/user, role)
	var/datum/job/job = SSjobs.GetJob(role)
	if(!job)
		return 0

	if(job.type == /datum/job/assistant)
		if(pref.job_civilian_low & job.flag)
			pref.job_civilian_low &= ~job.flag
		else
			pref.job_civilian_low |= job.flag
		return 1

	if(pref.GetJobDepartment(job, 1) & job.flag)
		SetJobDepartment(job, 1)
	else if(pref.GetJobDepartment(job, 2) & job.flag)
		SetJobDepartment(job, 2)
	else if(pref.GetJobDepartment(job, 3) & job.flag)
		SetJobDepartment(job, 3)
	else//job = Never
		SetJobDepartment(job, 4)

	return 1

/datum/category_item/player_setup_item/occupation/proc/SetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)	return 0
	switch(level)
		if(1)//Only one of these should ever be active at once so clear them all here
			pref.job_civilian_high = 0
			pref.job_medsci_high = 0
			pref.job_engsec_high = 0
			pref.job_govlaw_high = 0
			return 1
		if(2)//Set current highs to med, then reset them
			pref.job_civilian_med |= pref.job_civilian_high
			pref.job_medsci_med |= pref.job_medsci_high
			pref.job_engsec_med |= pref.job_engsec_high
			pref.job_govlaw_med |= pref.job_govlaw_high
			pref.job_civilian_high = 0
			pref.job_medsci_high = 0
			pref.job_engsec_high = 0
			pref.job_govlaw_high = 0

	switch(job.department_flag)
		if(CIVILIAN)
			switch(level)
				if(2)
					pref.job_civilian_high = job.flag
					pref.job_civilian_med &= ~job.flag
				if(3)
					pref.job_civilian_med |= job.flag
					pref.job_civilian_low &= ~job.flag
				else
					pref.job_civilian_low |= job.flag
		if(MEDSCI)
			switch(level)
				if(2)
					pref.job_medsci_high = job.flag
					pref.job_medsci_med &= ~job.flag
				if(3)
					pref.job_medsci_med |= job.flag
					pref.job_medsci_low &= ~job.flag
				else
					pref.job_medsci_low |= job.flag
		if(ENGSEC)
			switch(level)
				if(2)
					pref.job_engsec_high = job.flag
					pref.job_engsec_med &= ~job.flag
				if(3)
					pref.job_engsec_med |= job.flag
					pref.job_engsec_low &= ~job.flag
				else
					pref.job_engsec_low |= job.flag

		if(GOVLAW)
			switch(level)
				if(2)
					pref.job_govlaw_high = job.flag
					pref.job_govlaw_med &= ~job.flag
				if(3)
					pref.job_govlaw_med |= job.flag
					pref.job_govlaw_low &= ~job.flag
				else
					pref.job_govlaw_low |= job.flag
	return 1

/datum/category_item/player_setup_item/occupation/proc/ResetJobs()
	pref.job_civilian_high = 0
	pref.job_civilian_med = 0
	pref.job_civilian_low = 0

	pref.job_medsci_high = 0
	pref.job_medsci_med = 0
	pref.job_medsci_low = 0

	pref.job_engsec_high = 0
	pref.job_engsec_med = 0
	pref.job_engsec_low = 0

	pref.job_govlaw_high = 0
	pref.job_govlaw_med = 0
	pref.job_govlaw_low = 0

	pref.player_alt_titles.Cut()

/datum/preferences/proc/GetPlayerAltTitle(datum/job/job)
	return (job.title in player_alt_titles) ? player_alt_titles[job.title] : job.title

/datum/preferences/proc/GetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)	return 0
	switch(job.department_flag)
		if(CIVILIAN)
			switch(level)
				if(1)
					return job_civilian_high
				if(2)
					return job_civilian_med
				if(3)
					return job_civilian_low
		if(MEDSCI)
			switch(level)
				if(1)
					return job_medsci_high
				if(2)
					return job_medsci_med
				if(3)
					return job_medsci_low
		if(ENGSEC)
			switch(level)
				if(1)
					return job_engsec_high
				if(2)
					return job_engsec_med
				if(3)
					return job_engsec_low

		if(GOVLAW)
			switch(level)
				if(1)
					return job_govlaw_high
				if(2)
					return job_govlaw_med
				if(3)
					return job_govlaw_low
	return 0
