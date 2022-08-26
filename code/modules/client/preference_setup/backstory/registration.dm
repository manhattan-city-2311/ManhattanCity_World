/datum/category_item/player_setup_item/registration
	name = "Регистрационные данные"
	sort_order = 1

/datum/category_item/player_setup_item/registration/load_character(savefile/S)
	S["records"] 				>> pref.records
	S["age"]					>> pref.age
	S["birth_day"]				>> pref.birth_day
	S["birth_month"]			>> pref.birth_month
	S["birth_year"]				>> pref.birth_year
	S["height"]					>> pref.height
	S["weight"]					>> pref.weight

/datum/category_item/player_setup_item/registration/save_character(savefile/S)
	S["records"] 				<< pref.records
	S["age"]					<< pref.age
	S["birth_day"]				<< pref.birth_day
	S["birth_month"]			<< pref.birth_month
	S["birth_year"]				<< pref.birth_year
	S["height"]					<< pref.height
	S["weight"]					<< pref.weight

/datum/category_item/player_setup_item/registration/delete_character(savefile/S)
	pref.records = get_records_blank()

/datum/category_item/player_setup_item/registration/sanitize_character()
	if(!pref.records)
		pref.records = get_records_blank()

/datum/category_item/player_setup_item/registration/copy_to_mob(mob/living/carbon/human/character)
	character.records 	  = pref.records.Copy()
	character.age 		  = pref.age
	character.birth_year  = pref.birth_year
	character.birth_month = pref.birth_month
	character.birth_day   = pref.birth_day
	character.height 	  = pref.height

/datum/category_item/player_setup_item/registration/content(mob/user)
	for(var/ID in pref.records)
		var/R = pref.records[ID]
		if(!R)
			. += "<b>[ID]</b>: <a href='?src=\ref[src];recedit=[ID]' class = 'requiredToBeFull'><i>Необходимо заполнить</i></a><br>"

		else if(islist(R))
			. += "<b>[ID]</b>:"
			var/list/L = R

			if(L.len == 2 && islist(L[1])) // list(list(...), ...) aka selectable
				//                                   Value  ---^
				. += "<a href='?src=\ref[src];receditlp=[ID];' [L[2] ? "" : "class = 'requiredToBeFull'"]>[L[2] || "<i>Заполнить</i>"]</a><br>"
				continue

			. += "<br/>"

			if(L.len && (!L[1]))
				. += "\t<a href='?src=\ref[src];recappend=[ID];' class = 'requiredToBeFull'><i>Необходимо добавить</i></a><br>"
				continue

			var/i = 1
			for(var/E in L)
				var/buttons = "<a href='?src=\ref[src];receditl=[ID];count=[i]'><i>Редактировать</i></a>"
				buttons += "<a href='?src=\ref[src];recerasel=[ID];count=[i]'><i>X</i></a>"

				. += "\t[E] [buttons]<br/>"
				++i

			. += "\t<a href='?src=\ref[src];recappend=[ID];'><i>Добавить</i></a><br>"

		else if(is_record_title(ID))
			. += "<h1>\[[R]\]<hr></h1>"
			continue
		else
			. += "<b>[ID]</b>: <a href='?src=\ref[src];recedit=[ID]'>[R]</a><br>"
	. += "<br>"
	. += "<b>Почтовый адрес:</b><br>"

	if(!pref.existing_character)
		. += "Почта: <a href='?src=\ref[src];email_domain=1'>[pref.email]</a><br>"
	else
		. += "Логин: [pref.email]<br>Пароль: [SSemails.get_persistent_email_password(pref.email)]<br>"

/datum/category_item/player_setup_item/registration/OnTopic(href, list/href_list, mob/user)
	if(href_list["recedit"])
		var/ID = href_list["recedit"]
		if(!(ID in pref.records) || jobban_isbanned(user, "Records") || !CanUseTopic(user))
			return TOPIC_NOACTION

		var/nr

		nr = sanitize(input(user, "[ID]", "Записи", pref.records[ID]) as null|message, 500, extra = 0)

		if(!nr)
			return TOPIC_NOACTION

		switch(ID)
			if(RECORD_BIRTHDAY)
				var/global/regex/regex = regex(@"^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$")
				if(!regex.Find(nr))
					return TOPIC_NOACTION

				nr = ValidateDate(nr) // Before FindDate because we need validated date

				var/list/dates = FindDate(nr)

				pref.birth_day   = text2num(dates[1])
				pref.birth_month = text2num(dates[2])
				pref.birth_year  = text2num(dates[3])
				pref.age 		 = global.game_year - pref.birth_year
			if(RECORD_HEIGHT)
				pref.height = clamp(text2num(nr), 150, 200)
				nr = "[pref.height]"
			if(RECORD_WEIGHT)
				pref.weight = clamp(text2num(nr), 40, 120)
				nr = "[pref.weight]"

		pref.records[ID] = nr

		return TOPIC_REFRESH

	if(href_list["receditl"])
		var/ID = href_list["receditl"]
		var/count = text2num(href_list["count"])
		if(!(ID in pref.records) \
			|| !CanUseTopic(user) \
			|| count < 1 \
			|| count > pref.records[ID].len \
			|| !islist(pref.records[ID]) \
			|| jobban_isbanned(user, "Records"))
			return TOPIC_NOACTION

		var/nr = sanitize(input(user, "[ID]", "Записи", pref.records[ID][count]) as null|message, 500, extra = 0)
		if(!nr)
			return TOPIC_NOACTION
		pref.records[ID][count] = nr

		return TOPIC_REFRESH

	if(href_list["recerasel"])
		var/ID = href_list["recerasel"]
		var/count = text2num(href_list["count"])

		if(!(ID in pref.records) \
			|| !CanUseTopic(user) \
			|| count < 1 \
			|| count > pref.records[ID].len \
			|| !islist(pref.records[ID]) \
			|| jobban_isbanned(user, "Records"))
			return TOPIC_NOACTION
		var/list/R = pref.records[ID]
		R.Remove(R[count])

		return TOPIC_REFRESH

	if(href_list["receditlp"])
		var/ID = href_list["receditlp"]
		if(!(ID in pref.records) \
			|| !CanUseTopic(user) \
			|| !islist(pref.records[ID]) \
			|| !islist(pref.records[ID][1]) \
			|| jobban_isbanned(user, "Records"))
			return TOPIC_NOACTION
		var/list/choices = pref.records[ID][1]
		var/lc = length(choices)
		if(lc < 2)
			return
		else if(lc > 2)
			pref.records[ID][2] = input(user, "[ID]", "Записи", pref.records[ID][2]) in choices
		else
			var/current = choices.Find(pref.records[ID][2])
			pref.records[ID][2] = choices[current % 2 + 1]
		return TOPIC_REFRESH
	if(href_list["recappend"])
		var/ID = href_list["recappend"]

		if(!(ID in pref.records) \
			|| !CanUseTopic(user) \
			|| !islist(pref.records[ID]) \
			|| jobban_isbanned(user, "Records"))
			return TOPIC_NOACTION

		var/nr = sanitize(input(user, "[ID]", "Записи") as null|message, 500, extra = 0)
		if(!nr)
			return TOPIC_NOACTION

		var/list/L = pref.records[ID]
		if(L.len == 1 && isnull(L[1]))
			L[1] = nr
		else
			pref.records[ID] += nr

		return TOPIC_REFRESH
	if(href_list["email_domain"])
		var/list/domains = using_map.usable_email_tlds
		var/prefix = input(user, "Выберите имя пользователя почты вашего персонажа.", "Email Username")  as text|null
		if(!prefix)
			return

		var/domain = input(user, "Выберите домен вашей почты.", "Домен почты.") as null|anything in domains
		if(!domain)
			return

		var/full_email = "[prefix]@[domain]"

		if(full_email && SSemails.check_persistent_email(full_email))
			alert(user, "Эта почта уже существует.")
			return

		if(full_email && !SSemails.check_persistent_email(pref.email))
			SSemails.new_persistent_email(full_email)


		fcopy("data/persistent/emails/[pref.email].sav","data/persistent/emails/[full_email].sav")
		fdel("data/persistent/emails/[pref.email].sav")
		SSemails.change_persistent_email_address(pref.email, full_email)

		pref.email = "[prefix]@[domain]"


		return TOPIC_REFRESH
	return ..()
