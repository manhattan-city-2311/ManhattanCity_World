/datum/category_item/player_setup_item/background
	name = "Предыстория персонажа"
	sort_order = 3

/datum/category_item/player_setup_item/background/load_character(savefile/S)
	S["home_system"]				>> pref.home_system
	S["citizenship"]				>> pref.citizenship
	S["religion"]					>> pref.religion
	S["economic_status"]			>> pref.economic_status
	S["social_class"]				>> pref.social_class
	S["crime_record"]				>> pref.crime_record
	S[	"health_record"]				>> pref.health_record
	S["job_record"]					>> pref.job_record
	S["criminal_status"]			>> pref.criminal_status

/datum/category_item/player_setup_item/background/save_character(savefile/S)
	S["home_system"]				<< pref.home_system
	S["citizenship"]				<< pref.citizenship
	S["religion"]					<< pref.religion
	S["economic_status"]			<< pref.economic_status
	S["social_class"]				<< pref.social_class
	S["crime_record"]				<< pref.crime_record
	S["health_record"]				<< pref.health_record
	S["job_record"]					<< pref.job_record
	S["criminal_status"]			<< pref.criminal_status

/datum/category_item/player_setup_item/background/delete_character(savefile/S)
	pref.home_system = null
	pref.citizenship = null
	pref.faction = null
	pref.religion = null
	pref.economic_status = null
	pref.social_class = null
	pref.crime_record = list()
	pref.health_record = list()
	pref.job_record = list()

	pref.faction = null
	pref.religion = null
	pref.criminal_status = "None"

/datum/category_item/player_setup_item/background/sanitize_character()
	if(!pref.home_system) pref.home_system = "Vetra"
	if(!pref.citizenship) pref.citizenship = "Blue Colony"
	pref.home_system = sanitize_inlist(pref.home_system, home_system_choices, initial(pref.home_system))
	pref.citizenship = sanitize_inlist(pref.citizenship, citizenship_choices, initial(pref.citizenship))
//	if(!pref.faction)     pref.faction =     "None"
	if(!pref.religion)    pref.religion =    "None"
	if(!pref.job_record) pref.job_record = list()

	if(!pref.criminal_status) pref.criminal_status = "None"

	pref.economic_status = get_economic_class(pref.money_balance)

	pref.economic_status = sanitize_inlist(pref.economic_status, ECONOMIC_CLASS, initial(pref.economic_status))

	if(!pref.social_class)
		pref.social_class = pref.economic_status

	pref.social_class = sanitize_inlist(pref.social_class, ECONOMIC_CLASS, initial(pref.social_class))

	for(var/datum/record/R in pref.crime_record)	// to ensure all records have ckey traces from now on.
		if(!R.own_key)
			R.own_key = pref.client_ckey


// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/background/copy_to_mob(mob/living/carbon/human/character)
	character.home_system		= pref.home_system
	character.citizenship		= pref.citizenship
	character.personal_faction	= pref.faction
	character.religion			= pref.religion

/datum/category_item/player_setup_item/background/content(mob/user)
	. += "<h1>Предыстория персонажа:</h1><hr>"
	if(!pref.existing_character)
		. += "Город Джеминус планеты Поллюкс, распологающийся в Синей колонии, в звёздной системе Ветра. Вы можете выбрать другую предысторию. Социальный класс и система не могут быть изменены после их изменения.</br><br>"

		. += "Минимальное количество дней для начала определённого класса:<br><br>"
		. += "Рабочий класс: 0 дней (200 кредитов)<br>"
		. += "Средний класс: [config.middle_class_age] дней (4000 кредитов)<br>"
		. += "Высший класс: [config.upper_class_age] дней (10000 кредитов)<br><br>"

		. += "<b>Экономический класс:</b> [pref.economic_status]<br>"
		. += "<b>Социальный класс:</b> <a href='?src=\ref[src];soc_class=1'>[pref.social_class]</a><br/>"
		. += "<b>Система рождения:</b> <a href='?src=\ref[src];home_system=1'>[pref.home_system]</a><br/>"

	else
		. += "<b>Социальный класс:</b> [pref.social_class]<br/>"
		. += "<b>Экономический класс:</b> [pref.economic_status]<br>"
		. += "<b>Система рождения:</b> [pref.home_system]<br/>"

	. += "Континентальное жительство: <a href='?src=\ref[src];citizenship=1'>[pref.citizenship]</a><br/>"
	. += "Религия: <a href='?src=\ref[src];religion=1'>[pref.religion]</a><br/>"

/datum/category_item/player_setup_item/background/OnTopic(href, list/href_list, mob/user)
	var/suitable_classes = get_available_classes(user.client)
	if(href_list["choice"])
		switch(href_list["choice"])
			if("remove_criminal_record")
				var/datum/record/record = locate(href_list["record"])
				pref.crime_record -= record

				return TOPIC_REFRESH

	if(href_list["soc_class"])
		var/new_class = input(user, "Выберите стартовый социальный класс. Это будет влиять на количество денег с которым вы начинаете, вашу позицию в революции и прочих событиях.", "Character Preference", pref.social_class)  as null|anything in suitable_classes
		if(new_class && CanUseTopic(user))
			pref.social_class = new_class
			return TOPIC_REFRESH

	else if(href_list["home_system"])
		var/choice = input(user, "Выберите родную систему.", "Character Preference", pref.home_system) as null|anything in home_system_choices
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Выберите родную систему.", "Character Preference")  as text|null, MAX_NAME_LEN)
			if(raw_choice && CanUseTopic(user))
				pref.home_system = raw_choice
		else
			pref.home_system = choice
		return TOPIC_REFRESH

	else if(href_list["citizenship"])
		var/choice = input(user, "Выберите ваше гражданство.", "Character Preference", pref.citizenship) as null|anything in citizenship_choices
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		pref.citizenship = choice
		return TOPIC_REFRESH
/*
	else if(href_list["faction"])
		var/choice = input(user, "Please choose a faction to work for.", "Character Preference", pref.faction) as null|anything in faction_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter a faction.", "Character Preference")  as text|null, MAX_NAME_LEN)
			if(raw_choice)
				pref.faction = raw_choice
		else
			pref.faction = choice
		return TOPIC_REFRESH
*/
	else if(href_list["religion"])
		var/choice = input(user, "Выберите религию.", "Character Preference", pref.religion) as null|anything in religion_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Выберите религию.", "Character Preference")  as text|null, MAX_NAME_LEN)
			if(raw_choice)
				pref.religion = sanitize(raw_choice)
		else
			pref.religion = choice
		return TOPIC_REFRESH

	else if(href_list["set_medical_records"])
		var/new_medical = sanitize(input(user,"Введите медицинскую информацию.","Character Preference", html_decode(pref.med_record)) as message|null, MAX_RECORD_LENGTH, extra = 0)
		if(!isnull(new_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.med_record = new_medical
		return TOPIC_REFRESH

	else if(href_list["set_general_records"])
		var/new_general = sanitize(input(user,"Введите информацию для нанимателей.","Character Preference", html_decode(pref.gen_record)) as message|null, MAX_RECORD_LENGTH, extra = 0)
		if(!isnull(new_general) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.gen_record = new_general
		return TOPIC_REFRESH

	else if(href_list["set_security_records"])
		var/sec_medical = sanitize(input(user,"Введите информацию службы безопасности.","Character Preference", html_decode(pref.sec_record)) as message|null, MAX_RECORD_LENGTH, extra = 0)
		if(!isnull(sec_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.sec_record = sec_medical
		return TOPIC_REFRESH

	else if(href_list["edit_criminal_record"])
		EditCriminalRecord(user)

		return TOPIC_REFRESH


	else if(href_list["set_criminal_record"])

		var/laws_list = get_law_names()
		var/crime = input(user, "Выберите преступление.", "Edit Criminal Records", null) as null|anything in laws_list
		var/sec = sanitize(input(user,"Выберите информацию службы безопасности.","Character Preference", html_decode(pref.sec_record)) as message|null, MAX_RECORD_LENGTH, extra = 0)
		if(isnull(sec)) return

		var/year = 0
		var/month = get_game_month()
		var/day = get_game_day()

		if(!pref.existing_character)
			year = input(user, "Как много лет назад? Например - 3 года назад. Введите 0 для текущего года", "Edit Criminal Year", year) as num|null
			if(year > pref.age) return

			month = input(user, "В каком месяце?", "Edit Month", month) as num|null
			if(!get_month_from_num(month)) return
			if(!year && month > get_game_month()) return

			day = input(user, "В каком дне?", "Edit Day", day) as num|null
			if((month in THIRTY_DAY_MONTHS) && month > 30 || (month in THIRTY_ONE_DAY_MONTHS) && month > 31 || (month in TWENTY_EIGHT_DAY_MONTHS) && month > 28) return
			if(!year && month == get_game_month() && day > get_game_day()) return

		if(!isnull(crime) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			var/officer_name = random_name(pick("male","female"), SPECIES_HUMAN)

			pref.crime_record += make_new_record(/datum/record/police, crime, officer_name, user.ckey, "[day]/[month]/[get_game_year() - year]", sec)

		return TOPIC_HANDLED

	return ..()

/datum/category_item/player_setup_item/background/proc/EditCriminalRecord(mob/user)
	var/HTML = "<meta charset='UTF-8'><body>"
	HTML += "<center>"
	HTML += "<b>Edit Criminal Record</b> <hr />"
	HTML += "<br></center>"

	HTML += "<br><a href='?src=\ref[src];set_criminal_record=1'>Добавить запись о преступлении</a><br>"

	for(var/datum/record/C in pref.crime_record)
		if(!pref.existing_character)
			HTML += "\n<b>[C.name]</b>: [C.details] - [C.author] <i>([C.date_added])</i> <a href='?src=\ref[src];choice=remove_criminal_record;record=\ref[C]'>Remove</a><br>"
		else
			HTML += "\n<b>[C.name]</b>: [C.details] - [C.author] <i>([C.date_added])</i><br>"

	HTML += "<hr />"

	user << browse(HTML, "window=crim_record;size=430x300")

	onclose(user, "crim_record")
	return
