var/global/list/ic_databases = list();

/client/proc/debug_databases()
{
	debug_variables(global.ic_databases);
}

/hook/save_world/proc/save_ic_databases()
{
	var/savefile/S = new("data/databases.sav");
	to_save(S, ic_databases);
}

/hook/load_world/proc/load_ic_databases()
{
	if(fexists("data/databases.sav"))
	{
		var/savefile/S = new("data/databases.sav");
		from_save(S, ic_databases);
		return;
	}

	for(var/T in subtypesof(/datum/database))
	{
		var/datum/database/D = new T;
		global.ic_databases[D.name] = D;
	}
}

/proc/load_ic_database(id)
{
	return ic_databases[id];
}

/proc/icdatabaselogflag2text(flag)
{
	. = list();

	if(flag & IC_DATABASE_LOG_READ)
		. += "LOG_READ";
	if(flag & IC_DATABASE_LOG_WRITE)
		. += "LOG_WRITE";

	return length(.) ? jointext(., "|") : "NONE";
}

/proc/text2icdatabaselogflag(text)
{
	var/list/L = splittext(text, "|")
	
	. = 0
	if("LOG_READ" in L)
		. |= IC_DATABASE_LOG_READ
	if("LOG_WRITE" in L)
		. |= IC_DATABASE_LOG_WRITE

	return .;
}

// Ingame database
/datum/database
	var/name = "Database"
	var/contents = list()
	var/log_flag = 0
	var/list/logs = list()
	var/accounts_database = ACCOUNTS_DATABASE

/datum/database/proc/get_accounts_database()
{
	return load_ic_database(accounts_database);
}

/datum/database/proc/log_custom(data, account)
{
	logs += "\[[stationdate2text()] [stationtime2text()]\] [account] | [data]";
}

/datum/database/proc/log_read(id, account = "system")
{
	log_custom("READ [id]", account);
}

/datum/database/proc/log_write(id, account = "system")
{
	if(!(id in contents))
		log_custom("ADD [id]", account);
	else
		log_custom("WRITE [id]", account);
}

/datum/database/proc/has_entry(id)
{
	return id in contents;
}

/datum/database/proc/read(id, account = "system", silent = FALSE)
{
	if(!silent && (log_flag & IC_DATABASE_LOG_READ))
		log_read(id, account);
	return contents[id];
}

/datum/database/proc/write(id, val, account = "system", silent = FALSE)
{
	if(!silent && (log_flag & IC_DATABASE_LOG_WRITE))
		log_write(id, val, account);
	contents[id] = val;
}

/datum/database/proc/remove(id, account = "system", silent = FALSE)
{
	contents -= id;
	log_custom("REMOVE [id]", account);
}

/datum/database/proc/user_has_permission(user, password, permission)
{
	var/list/permissions = get_accounts_database().access(user, password, name);
	if(!permissions)
		return

	if(permissions == PERMISSION_SYSTEM_ADMIN)
		return TRUE
	return "[name][permission]" in permissions
}
