#define RECORD_BIRTHDAY "ДАТА РОЖДЕНИЯ"
#define RECORD_HEIGHT "РОСТ (В СМ)"
#define RECORD_WEIGHT "ВЕС (В КГ)"
#define RECORD_LANGUAGES "ВЛАДЕЕТ ЯЗЫКАМИ"
#define RECORD_LAST_CHANGE "ПОСЛЕДНЕЕ ИЗМЕНЕНИЕ"

GLOBAL_VAR_CONST(PREF_YES, "Yes")
GLOBAL_VAR_CONST(PREF_NO, "No")
GLOBAL_VAR_CONST(PREF_ALL_SPEECH, "All Speech")
GLOBAL_VAR_CONST(PREF_NEARBY, "Nearby")
GLOBAL_VAR_CONST(PREF_ALL_EMOTES, "All Emotes")
GLOBAL_VAR_CONST(PREF_ALL_CHATTER, "All Chatter")
GLOBAL_VAR_CONST(PREF_SHORT, "Short")
GLOBAL_VAR_CONST(PREF_LONG, "Long")
GLOBAL_VAR_CONST(PREF_SHOW, "Show")
GLOBAL_VAR_CONST(PREF_HIDE, "Hide")
GLOBAL_VAR_CONST(PREF_FANCY, "Fancy")
GLOBAL_VAR_CONST(PREF_PLAIN, "Plain")
GLOBAL_VAR_CONST(PREF_PRIMARY, "Primary")
GLOBAL_VAR_CONST(PREF_ALL, "All")
GLOBAL_VAR_CONST(PREF_OFF, "Off")
GLOBAL_VAR_CONST(PREF_BASIC, "Basic")
GLOBAL_VAR_CONST(PREF_FULL, "Full")
GLOBAL_VAR_CONST(PREF_MIDDLE_CLICK, "middle click")
GLOBAL_VAR_CONST(PREF_SHIFT_MIDDLE_CLICK, "shift middle click")
GLOBAL_VAR_CONST(PREF_ALT_CLICK, "alt click")
GLOBAL_VAR_CONST(PREF_CTRL_CLICK, "ctrl click")
GLOBAL_VAR_CONST(PREF_CTRL_SHIFT_CLICK, "ctrl shift click")
GLOBAL_VAR_CONST(PREF_HEAR, "Hear")
GLOBAL_VAR_CONST(PREF_SILENT, "Silent")
GLOBAL_VAR_CONST(PREF_SHORTHAND, "Shorthand")
GLOBAL_VAR_CONST(PREF_WHITE, "White")
GLOBAL_VAR_CONST(PREF_DARK, "Dark")

#define SAVE_RESET -1

// Check if starts with '@'.
/proc/is_record_title(record)
	return starts_with(record, "@")

var/global/list/records_id_to_title = list()
/proc/generate_records_support()
	var/list/records = get_records_blank()
	
	var/curTitle
	for(var/id in records)
		if(is_record_title(id))
			curTitle = id
		else
			global.records_id_to_title[id] = curTitle

/world/New()
	. = ..()
	generate_records_support()

/proc/get_records_blank()
	return list(
		"@1" = "ОБЩИЕ ДАННЫЕ"
		, "ПОЛНОЕ ИМЯ" = null
		, RECORD_BIRTHDAY = "1/1/2311" // This has custom behaviour
		, RECORD_WEIGHT = null
		, RECORD_HEIGHT = null
		, "ЦВЕТ ВОЛОС" = null
		, "ЦВЕТ ГЛАЗ" = null
		, "ЭТНИЧНОСТЬ" = list(list("Меонец", "Марсианин (Тунеллер)", "Марсианин (Монсинец)", "Венерианец", "Селениан (Низший)", "Селениан (Высший)", "Землянин", "Фобос", "Цереровец", "Плутонец", "Цетит", "Спейсер (Центральный)", "Спейсер (Фронтир)", "Терранец", "Магнитовец", "Гайец (ЦПСС)", "Гайец (ГГК)"), null)
		, RECORD_LANGUAGES = list(null)
		, "СЕМЕЙНОЕ ПОЛОЖЕНИЕ" = list(list("Женат", "Не женат", "Замужем", "Не замужем"), null)
		, "РОДСТВЕННИКИ" = list()
		, "ОБРАЗОВАНИЕ" = null
		, "КВАЛИФИКАЦИЯ" = list(null)
		, "ЛИЦЕНЗИИ" = list(null),

		"@2" = "МЕДИЦИНСКАЯ СПРАВКА"
		, "ПРОТЕЗЫ, ИМПЛАНТЫ" = list()
		, "ПОСМЕРТНЫЕ ИНСТРУКЦИИ" = list(list("Кремация", "Сохранение в морге", "Традиционное погребение", "Передача родственникам"), null)
		, "ДОНОР ОРГАНОВ" = list(list("Да", "Нет"), "Да")
		, "АЛЛЕРГИИ" = list()
		, "ЗАКЛЮЧЕНИЕ ПСИХИАТРА" = null,

		"@3" = "ПОГРАНИЧНЫЙ КОНТРОЛЬ"
		, "МЕСТО РОЖДЕНИЯ" = null
		, "МЕСТО ПРОЖИВАНИЯ" = null
		, "ГРАЖДАНСТВО БЕЛЬМЕОНА" = list(list("Имеется", "В процессе получения", "Отсутствует"), null),

		"@4" = "ОТЧЕТ БЕЗОПАСНОСТИ"
		, "РЕГИСТРАЦИЯ" = list(list("Южный район", "Северный район"), null)
		, "КРИМИНАЛЬНЫЙ СТАТУС" = list(),

		RECORD_LAST_CHANGE = null
	)

var/list/preferences_datums = list()

/datum/preferences
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id
	var/first_seen
	var/last_seen

	var/list/ips_associated	= list()
	var/list/cids_associated = list()
	var/list/characters_created = list()
	var/byond_join_date

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#010000"			//Whatever this is set to acts as 'reset' color and is thus unusable as an actual custom color
	var/be_special = 0					//Special role selection
	var/UI_style = "Midnight"
	var/UI_style_color = "#ffffff"
	var/UI_style_alpha = 255
	var/tooltipstyle = "Midnight"		//Style for popup tooltips
	var/client_fps = 100

	//character preferences
	var/real_name						//our character's name
//	var/be_random_name = 0				//whether we are a random name every round
	var/nickname						//our character's nickname
	var/age = 30						//age of character
	var/birth_day = 1					//day you were born
	var/birth_month	= 1					//month you were born
	var/birth_year						//year you were born
	// There's no birth year, as that's automatically calculated by your age.
	#define DEFAULT_SPAWNPOINT_NAME "City Arrivals Airbus"
	var/spawnpoint = DEFAULT_SPAWNPOINT_NAME //where this character will spawn (0-2).
	var/b_type = "O+"					//blood type (not-chooseable)
	var/backbag = 2					//backpack type
	var/pdachoice = 1					//PDA type
	var/h_style = "Short Hair"		//Hair type
	var/r_hair = 0						//Hair color
	var/g_hair = 0						//Hair color
	var/b_hair = 0						//Hair color
	var/grad_style = "none"				//Gradient style
	var/r_grad = 0						//Gradient color
	var/g_grad = 0						//Gradient color
	var/b_grad = 0						//Gradient color
	var/f_style = "Shaved"				//Face hair type
	var/lip_style						//Lips/Makeup Style
	var/lip_color						//Color of the makeup/lips
	var/r_facial = 0					//Face hair color
	var/g_facial = 0					//Face hair color
	var/b_facial = 0					//Face hair color
	var/s_tone = 0						//Skin tone
	var/r_skin = 0						//Skin color
	var/g_skin = 0						//Skin color
	var/b_skin = 0						//Skin color
	var/r_eyes = 0						//Eye color
	var/g_eyes = 0						//Eye color
	var/b_eyes = 0						//Eye color
	var/species = SPECIES_HUMAN         //Species datum to use.
	var/weight = 89
	var/calories = 420000			// Used for calculation of weight.
	var/nutrition = 300			// How hungry you are.
	var/hydration = 300
	var/species_preview                 //Used for the species selection window.
	var/list/alternate_languages = list() //Secondary language(s)
	var/list/language_prefixes = list() //Kanguage prefix keys
	var/list/gear						//Left in for Legacy reasons, will no longer save.
	var/list/gear_list = list()			//Custom/fluff item loadouts.
	var/gear_slot = 1					//The current gear save slot
	var/list/traits						//Traits which modifier characters for better or worse (mostly worse).

		//Some faction information.
	var/home_system = "Mars"           //System of birth.
	var/citizenship = "Mars"     //Current home system.
	var/faction = "Sol Central Government"                //General associated faction.
	var/religion = "None"               //Religious association.
	var/antag_faction = "None"			//Antag associated faction.
	var/antag_vis = "Shared"			//How visible antag association is to others.

	// Quirk list
	var/list/positive_quirks = list()
	var/list/negative_quirks = list()
	var/list/neutral_quirks = list()
	var/list/all_quirks = list()
	var/list/character_quirks = list()

	var/list/allowed_quirks = list()

		//Mob preview
	var/icon/preview_icon = null

		//Jobs, uses bitflags
	var/job_civilian_high = 0
	var/job_civilian_med = 0
	var/job_civilian_low = 0

	var/job_medsci_high = 0
	var/job_medsci_med = 0
	var/job_medsci_low = 0

	var/job_engsec_high = 0
	var/job_engsec_med = 0
	var/job_engsec_low = 0

	var/job_govlaw_high = 0
	var/job_govlaw_med = 0
	var/job_govlaw_low = 0

	// Money related

	var/money_balance = 0
	var/bank_pin
	var/bank_account

	var/datum/expense/expenses = list()

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = 1

	var/skillpoints = 8
	var/used_skillpoints = 0
	var/skill_specialization = null
	var/list/skills = list() // skills can range from 0 to 3

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data = list()
	var/list/rlimb_data = list()
	var/list/player_alt_titles = new()		// the default name of a job like "Doctor"

	var/list/body_markings = list() // "name" = "#rgbcolor"

	var/list/flavor_texts = list()
	var/list/flavour_texts_robot = list()

	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""

	var/list/records

	var/height = 180

	var/list/datum/record/police/crime_record = list()
	var/list/datum/record/hospital/health_record = list()
	var/list/datum/record/employment/job_record = list()

	var/exploit_record = ""

	// Antag and Prison stuff

	var/criminal_status = "None"

	var/disabilities = 0

	var/economic_status = "Working Class"
	var/social_class = "Working Class"

	var/uplinklocation = "PDA"
	var/email

	// OOC Metadata:
	var/metadata = ""
	var/list/ignored_players = list()

	var/client/client = null
	var/client_ckey = null
	var/unique_id

	// Communicator identity data
	var/communicator_visibility = 1

	//Silent joining for shenanigans
	var/silent_join = 0

	var/datum/category_collection/player_setup_collection/player_setup
	var/datum/browser/panel

	var/lastnews // Hash of last seen lobby news content.

	var/existing_character = 0 //when someone spawns with this character for the first time or confirms, it's set to 1.
	var/played = 0 //this will set to 1 once someone plays this character on a canon round.

	//Cooldowns for saving/loading. These are four are all separate due to loading code calling these one after another
	var/saveprefcooldown
	var/loadprefcooldown
	var/savecharcooldown
	var/loadcharcooldown

	var/cyber_control = FALSE //Allows players to use cyberware on spawn

	var/turf/location

	var/blood_level

	var/list/all_organ_damage = list()

	var/persistence_x
	var/persistence_y
	var/persistence_z

/datum/preferences/proc/is_records_filled()
	for(var/ID in records)
		if(!records[ID])
			return FALSE
		if(islist(records[ID]))
			var/list/L = records[ID]
			if(L.len && isnull(L[1]))
				return FALSE
	return TRUE

/proc/get_records_html(list/records, list/allowed)
	. = list()
	for(var/ID in records)
		if(allowed && !(ID in allowed))
			continue
		if(!records[ID])
			. += "<b>[ID]</b>: <i>НЕ ЗАПОЛНЕНО</i>"
			continue
		else if(islist(records[ID]))
			. += "<b>[ID]</b>:"
			var/list/L = records[ID]
			if(L.len && isnull(L[1])) // list(null) -> not filled
				. += "\t<i>НЕ ЗАПОЛНЕНО</i>"

			else if(!L.len) // empty list
				. += "\tN/A"

			else if(L.len == 2 && islist(L[1]))
				var/list/RV = .
				RV[RV.len] += "\t[L[2] || "<i>НЕ ЗАПОЛНЕНО</i>"]"

			else
				for(var/E in L)
					. += "\t[E]"
			continue

		if(is_record_title(ID))
			. += "<h1>\[[records[ID]]\]</h1><hr>" // newline [bold] newline
		else
			. += "<b>[ID]</b>: [records[ID]]"
	return jointext(., "<br>")

/datum/preferences/New(client/C)
	player_setup = new(src)
	set_biological_gender(pick(MALE, FEMALE))
	real_name = random_name(identifying_gender,species)
	b_type = RANDOM_BLOOD_TYPE
	records = get_records_blank()

	gear = list()
	gear_list = list()
	gear_slot = 1

	if(istype(C))
		client = C
		client_ckey = C.ckey
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			if(load_preferences())
				if(load_character())
					return

/datum/preferences/proc/ZeroSkills(var/forced = 0)
	for(var/V in SKILLS) for(var/datum/skill/S in SKILLS[V])
		if(!skills.Find(S.ID) || forced)
			skills[S.ID] = SKILL_UNSKILLED

/datum/preferences/proc/CalculateSkillPoints()
	//skillpoints = 0
	used_skillpoints = 0
	for(var/V in SKILLS)
		for(var/datum/skill/S in SKILLS[V])
			//used_skillpoints += S.costs[skills[S.ID]]
			//if(skills[S.ID] >= newvalue)
			switch(skills[S.ID])
				if(SKILL_UNSKILLED)
					used_skillpoints += 0
				if(SKILL_AMATEUR)
					//if(check_skillpoints(1))
					used_skillpoints += 1
				if(SKILL_TRAINED)
					// secondary skills cost les
					if(S.secondary)
						//if(check_skillpoints(1))
						used_skillpoints += 1
					else
						//if(check_skillpoints(3))
						used_skillpoints += 3
				if(SKILL_PROFESSIONAL)
					// secondary skills cost les
					if(S.secondary)
						//if(check_skillpoints(3))
						used_skillpoints += 3
					else
						//if(check_skillpoints(6))
						used_skillpoints += 6

	//skillpoints -= used_skillpoints

/datum/preferences/proc/CanAfford(value)
	switch(value)
		if(SKILL_UNSKILLED)
			return TRUE
		if(SKILL_AMATEUR)
			if(check_skillpoints(1))
				return TRUE
		if(SKILL_TRAINED)
			if(check_skillpoints(3))
				return TRUE
		if(SKILL_PROFESSIONAL)
			if(check_skillpoints(6))
				return TRUE
	return FALSE

/mob/proc/skill_check(skill,level)
	if(!client || !client.prefs) return FALSE
	var/answer = (client.prefs.skills[skill] >= level ? TRUE : FALSE)
	return answer

/datum/preferences/proc/check_skillpoints(amount)
	var/test_skillpoints = skillpoints - used_skillpoints - amount
	return test_skillpoints >= 0

/datum/preferences/proc/GetSkillClass(points)
	return CalculateSkillClass(points, age)

/proc/CalculateSkillClass(points, age)
	if(points <= 0) return "Unconfigured"
	// skill classes describe how your character compares in total points
	points -= min(round((age - 20) / 2.5), 4) // every 2.5 years after 20, one extra skillpoint
	if(age > 30)
		points -= round((age - 30) / 5) // every 5 years after 30, one extra skillpoint
	switch(points)
		if(-1000 to 3)
			return "Terrifying"
		if(4 to 6)
			return "Below Average"
		if(7 to 10)
			return "Average"
		if(11 to 14)
			return "Above Average"
		if(15 to 18)
			return "Exceptional"
		if(19 to 24)
			return "Genius"
		if(24 to 1000)
			return "God"

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)	return

	if(!get_mob_by_key(client_ckey))
		to_chat(user, "<span class='danger'>No mob exists for the given client!</span>")
		close_load_dialog(user)
		return

	var/dat = "<html><body><center>"

	if(path)
		dat += "<a href='?src=\ref[src];load=1'>Загрузить слот</a> - "
		dat += "<a href='?src=\ref[src];save=1'>Сохранить слот</a> - "
//		dat += "<a href='?src=\ref[src];reload=1'>Перезагрузить слот</a> - "
		if(!existing_character)
			dat += "<a href='?src=\ref[src];resetslot=1'>Сбросить слот</a> - "
		dat += "<a href='?src=\ref[src];deleteslot=1'>Удалить слот</a>"
	else
		dat += "Please create an account to save your preferences."

	dat += "<br>"
	dat += player_setup.header()
	dat += "<br><HR></center>"
	dat += player_setup.content(user)

	dat += "</html></body>"
	//user << browse(dat, "window=preferences;size=635x736")
	var/datum/browser/popup = new(user, "Character Setup","Character Setup", 800, 800, src)
	popup.set_content(dat)
	popup.open()

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(!user)	return

	if(!istype(user, /mob/new_player))	return

	if(href_list["preference"] == "open_whitelist_forum")
		if(config.forumurl)
			user << link(config.forumurl)
		else
			to_chat(user, "<span class='danger'>The forum URL is not set in the server configuration.</span>")
			return
	ShowChoices(usr)
	return 1

/datum/preferences/Topic(href, list/href_list)
	if(..())
		return 1

	if(href_list["save"])
		if(!is_records_filled())
			spawn()
				alert(usr, "Стоп, стоп, стоп. Прежде чем зайти в игру, персонаж обязан обладать документацией. Пожалуйста, заполните \[РЕГИСТРАЦИОННЫЕ ДАННЫЕ].")
			return
		if(!existing_character)
			if(alert(usr, "Если вы сейчас сохраните персонажа, то вы НЕ СМОЖЕТЕ ИЗМЕНИТЬ ЕГО В ДАЛЬНЕЙШЕМ. Все изменения придется устанавливать в течение игровых сессий. ВЫ ТОЧНО УВЕРЕНЫ, ЧТО ОТПРАВЛЯЕТЕ ПЕРСОНАЖА В МАНХЭТТЕН ТАКИМ, КАКИМ ОН БЫЛ ВАМИ ЗАДУМАН?", "!!! ВНИМАНИЕ !!!", "Да", "Нет, нужно отредактировать") != "Да")
				return
		save_preferences()
		save_character()
		make_existing()
/*
	else if(href_list["reload"])
		load_preferences()
		load_character()
		sanitize_preferences()
*/
	else if(href_list["load"])
		if(!IsGuestKey(usr.key))
			open_load_dialog(usr)
			return 1
	else if(href_list["changeslot"])
		load_character(text2num(href_list["changeslot"]))
		sanitize_preferences()
		close_load_dialog(usr)
	else if(href_list["resetslot"])
		if(existing_character)
			return
		if("No" == alert("This will reset the current slot. Continue?", "Reset current slot?", "No", "Yes"))
			return 0
		load_character(SAVE_RESET)
		sanitize_preferences()
	else if(href_list["deleteslot"])
		if("Нет" == alert("Если вы удалите персонажа, то вы не сможете более на нём играть, и это необратимо. Продолжить?", "Удалить персонажа?", "Нет", "Да"))
			return 0
		delete_character()
	else
		return 0

	ShowChoices(usr)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, icon_updates = TRUE)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()

	// This needs to happen before anything else becuase it sets some variables.
	character.set_species(species)
	// Special Case: This references variables owned by two different datums, so do it here.
//	if(be_random_name)
//		real_name = random_name(identifying_gender,species)


	// Ask the preferences datums to apply their own settings to the new mob
	player_setup.copy_to_mob(character)

	if(icon_updates)
		character.force_update_limbs()
		character.update_icons_body()
		character.update_mutations()
		character.update_underwear()
		character.update_hair()

/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat = "<body><center>"

	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<h1>Выбор персонажа<h1><br>"
		dat += "<b>В данный момент используется: </b>"
		if(real_name in SSpersistent_world.blocked_characters)
			dat += "<a href='?src=\ref[src];changeslot=[default_slot]'><span class='requiredToBeFull'>[real_name]</span></a><br>"
		else
			dat += "<a href='?src=\ref[src];changeslot=[default_slot]'>[real_name]</a><br>"
		dat += "Выберите слот для загрузки:<hr>"
		var/name
		for(var/i=1, i<= config.character_slots, i++)
			S.cd = "/character[i]"
			S["real_name"] >> name
			if(!name)
				name = "Пустой слот #[i]"
			
			if(name in SSpersistent_world.blocked_characters)
				name = "<span class='requiredToBeFull'>[name]</span>"
			dat += "<a href='?src=\ref[src];changeslot=[i]'>[name]</a><br>"

	dat += "</center></body>"
	//user << browse(dat, "window=saves;size=300x390")
	panel = new(user, "Character Slots", "Character Slots", 300, 420, src)
	panel.set_content(dat)
	panel.open()

/datum/preferences/proc/close_load_dialog(mob/user)
	//user << browse(null, "window=saves")
	panel.close()

/datum/preferences/proc/make_existing()
	existing_character = 1
	return 1

/datum/preferences/proc/make_editable()
	existing_character = 0
	return 1


/datum/preferences/proc/is_synth() // lets us know if this is a non-FBP synth
	if(O_BRAIN in organ_data)
		switch(organ_data[O_BRAIN])
			if("mechanical")
				return PREF_FBP_POSI
			if("digital")
				return PREF_FBP_SOFTWARE

	return FALSE

/datum/preferences/proc/is_fbp() // lets us know if this is a non-FBP synth
	if(O_BRAIN in organ_data)
		switch(organ_data[O_BRAIN])
			if("assisted")
				return PREF_FBP_CYBORG

	return FALSE
