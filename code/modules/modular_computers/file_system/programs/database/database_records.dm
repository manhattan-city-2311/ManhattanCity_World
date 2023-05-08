/datum/computer_file/program/recordsrecordsControl
	filename = "mqlcontrol"
	filedesc = "MQL database control"
	extended_desc = "Program used to control MQL databases: setup, create, view raw data and logs"
	requires_ntnet = TRUE
	program_menu_icon = "gear"
	nanomodule_path = /datum/nano_module/program/recordsControl

/datum/nano_module/program/recordsControl
	name = "MQL database control"
	var/database
	var/username
	var/password
	var/selected_name
	var/datum/database/records/DB
	var/list/permissions
	var/loggedin = FALSE

/datum/nano_module/program/recordsControl/New(host)
{
	. = ..();
	DB = load_ic_database(RECORDS_DATABASE);
}

/datum/nano_module/program/recordsControl/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui, force_open = TRUE, datum/topic_state/state = default_state)
{
	var/list/data = program.get_header_data();

	data["username"] = username;
	data["password"] = password;
	data["loggedin"] = loggedin;

	if(loggedin)
	{
		var/list/records = list();

		if(selected_name && DB.has_entry(selected_name))
			records = DB.read(selected_name, username);

		var/rec = ""
		for(var/ID in records)
		{
			var/R = records[ID];
			else if(islist(R))
			{
				rec += "<b>[ID]</b>:";
				var/list/L = R;

				if(L.len == 2 && islist(L[1]))
					rec += "<a href='?src=\ref[src];receditlp=[ID];']>[L[2]]</a><br>";
					continue;

				rec += "<br/>";

				var/i = 1;
				for(var/E in L)
					var/buttons = "<a href='?src=\ref[src];receditl=[ID];count=[i]'><i>Редактировать</i></a>";
					buttons += "<a href='?src=\ref[src];recerasel=[ID];count=[i]'><i>X</i></a>";

					rec += "\t[E] [buttons]<br/>";
					++i;

				rec += "\t<a href='?src=\ref[src];recappend=[ID];'><i>Добавить</i></a><br>";
			}
			else if(is_record_title(ID))
			{
				rec += "<h1>\[[R]\]<hr></h1>";
				continue;
			}
			else
				rec += "<b>[ID]</b>: <a href='?src=\ref[src];recedit=[ID]'>[R]</a><br>";
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

/datum/nano_module/program/recordsControl/Topic(href, href_list)
{
	. = ..();
	if(.)
		return;

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
	if(href_list["login"])
	{
		var/datum/database/accounts/accountsDB = load_ic_database(DB.accounts_database);
		if(!accountsDB.access(username, password, database))
		{
			to_chat(usr, "Auth failure");
			return;
		}

		loggedin = TRUE;
		viewLogs = FALSE;
		return TOPIC_REFRESH;
	}
	if(href_list["logout"])
	{
		password = "";
		username = "";
		loggedin = FALSE;
		return TOPIC_REFRESH;
	}
}

