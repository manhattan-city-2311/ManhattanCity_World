/datum/computer_file/program/recordsControl
	filename = "recordsViewer"
	filedesc = "Manhattan citizens records viewer"
	extended_desc = "Program used to view records of citizens"
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
	var/static/list/permissionToTitle = list(
		RECORDS_PERMISSION_WRITE_GENERIC = "@1",
		RECORDS_PERMISSION_WRITE_MEDICAL = "@2",
		RECORDS_PERMISSION_WRITE_BORDER_CONTROL = "@3",
		RECORDS_PERMISSION_WRITE_SECURITY = "@4"
	)

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
	data["database"] = DB.name;

	if(loggedin)
	{
		var/list/records = selected_name && DB.read(selected_name, username);

		var/list/recordsData = list();
		for(var/ID in records)
		{
			var/R = records[ID];

			var/list/subdata = list(
				"canedit" = global.records_id_to_title[ID],
				"label" = ID,
				(is_record_title(ID) ? "title" : "value") = R
			)

			if(islist(R))
			{
				var/list/L = R;

				if(L.len == 2 && islist(L[1]))
					subdata["value"] = L[2];
					continue;

				var/list/value = list();
				for(var/E in L)
					value += E;
				subdata["listvalue"] = value;
			}

			recordsData += list(subdata);
		}

		if(recordsData.len)
			data["records"] = recordsData;

		var/list/names = list();
		for(var/name in DB.contents)
			names += name;
		data["names"] = names;
		data["selected_name"] = selected_name;

	}

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open);
	if(!ui)
	{
		ui = new(user, src, ui_key, "database_records.tmpl", "Citizens records", 600, 600, state = state);
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
		var/list/rawPermissions = accountsDB.access(username, password, database);

		if(!rawPermissions)
		{
			to_chat(usr, "Auth failure");
			return;
		}

		permissions = list();
		for(var/I in rawPermissions)
			if(I in permissionToTitle)
				permissions += permissionToTitle[I];

		loggedin = TRUE;
		return TOPIC_REFRESH;
	}
	if(href_list["logout"])
	{
		password = "";
		username = "";
		loggedin = FALSE;
		return TOPIC_REFRESH;
	}
	if(href_list["select_name"])
	{
		selected_name = href_list["select_name"];
		return TOPIC_REFRESH;
	}
}

