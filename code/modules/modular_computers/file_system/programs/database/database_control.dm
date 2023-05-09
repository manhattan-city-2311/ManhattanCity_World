/datum/computer_file/program/databaseControl
	filename = "mqlcontrol"
	filedesc = "MQL database control"
	extended_desc = "Program used to control MQL databases: setup, create, view raw data and logs"
	requires_ntnet = TRUE
	program_menu_icon = "gear"
	nanomodule_path = /datum/nano_module/program/databaseControl

/datum/nano_module/program/databaseControl
	name = "MQL database control"
	var/database
	var/username
	var/password
	var/datum/database/DB
	var/list/permissions
	var/loggedin = FALSE
	var/viewLogs = FALSE

/proc/json_encode_unescaped(list/L, first = TRUE)
{
	if(!islist(L))
		return "\"[L]\"";
	. = first ? "{" : "\[";

	var/list/temp = list();
	for(var/id in L)
	{
		if(LAZYACCESS(L, id))
			temp += "\"[id]\":[json_encode_unescaped(L[id], FALSE)]";
		else
			temp += json_encode_unescaped(id, FALSE);
	}
	. += jointext(temp, ",");

	.+= first ? "}" : "\]";
}

/datum/nano_module/program/databaseControl/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui, force_open = TRUE, datum/topic_state/state = default_state)
{
	var/list/data = program.get_header_data();

	data["database"] = database;
	data["username"] = username;
	data["password"] = password;
	data["loggedin"] = loggedin;

	if(loggedin)
	{
		data["viewLogs"] = DB.user_has_permission(username, password, PERMISSION_ACCESS_LOGS) ? -1 : viewLogs;
		data["logflags"] = icdatabaselogflag2text(DB.log_flag);
		data["isadmin"] = DB.user_has_permission(username, password, PERMISSION_ADMIN)

		if(viewLogs)
			data["logs"] = DB.logs;
		else if(DB.user_has_permission(username, password, PERMISSION_READ))
		{
			var/list/L = list();
			for(var/entry in DB.contents)
				L += "\"[entry]\" = [json_encode_unescaped(DB.read(entry, username))]";
			data["contents"] = L;
		}
	}

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open);
	if(!ui)
	{
		ui = new(user, src, ui_key, "database_control.tmpl", "MQL database control", 600, 600, state = state);
		ui.set_initial_data(data);
		ui.open();
	}
}

/datum/nano_module/program/databaseControl/Topic(href, href_list)
{
	. = ..();
	if(.)
		return;

	if(href_list["edit_database"])
	{
		database = html_encode(input(usr, "database",, database) as text); // I hope no one will hack it using delayed input
		return TOPIC_REFRESH;
	}
	if(href_list["edit_username"])
	{
		username = html_encode(input(usr, "username",, username) as text);
		return TOPIC_REFRESH;
	}
	if(href_list["edit_password"])
	{
		password = html_encode(input(usr, "password",, password) as text);
		return TOPIC_REFRESH;
	}
	if(href_list["view_logs"])
	{
		if(viewLogs != 0 || !permissions || !DB.user_has_permission(username, password, PERMISSION_ACCESS_LOGS))
			return;
			
		viewLogs = TRUE;
		return TOPIC_REFRESH;
	}
	if(href_list["login"])
	{
		DB = load_ic_database(database);
		if(!DB)
		{
			sleep(20);
			to_chat(usr, "The waiting interval for a request has been exceeded.");
			return;
		}

		var/datum/database/accounts/accountsDB = load_ic_database(DB.accounts_database);
		if(!accountsDB.access(username, password, database))
		{
			to_chat(usr, "Auth failure");
			DB = null;
			return;
		}

		loggedin = TRUE;
		viewLogs = FALSE;
		return TOPIC_REFRESH;
	}
	if(href_list["back"])
	{
		viewLogs = FALSE;
		return TOPIC_REFRESH;
	}
	if(href_list["logout"])
	{
		password = "";
		username = "";
		database = "";
		loggedin = FALSE;
		viewLogs = FALSE;
		return TOPIC_REFRESH;
	}
}

