/datum/database/accounts
	name = ACCOUNTS_DATABASE
	log_flag = IC_DATABASE_LOG_WRITE
	contents = list(
		"system" = list(
			"name" = "N/A",
			"password" = "8ee1575550cacf8dfcda098d7792d246", // imagine attack on md5 for obtaining access to every database
			"permissions" = list(PERMISSION_SYSTEM_ADMIN)
		)
	)

/datum/database/accounts/proc/add_entry(username, name, password, permissions = list(), account = "system")
{
	if(has_entry(username))
		return;

	var/list/entry = list(
		"name" = name,
		"password" = md5(password),
		"permissions" = permissions
	);
	write(username, entry, account);
}

/datum/database/accounts/proc/add_permission(username, permissions, account = "system")
{
	if(!(username in contents))
		return "Entry not found";
	if(!islist(permissions))
		permissions = list(permissions);

	var/list/entry = contents[username];
	for(var/P in permissions)
		if(findtext(P, PERMISSION_SYSTEM_ADMIN))
			return "Unknown error";

	entry["permissions"] += permissions;
	write(username, entry, account);
	log_custom("Added [jointext(permissions, "|")] permissions", account);
}

/datum/database/accounts/proc/remove_permission(username, permissions, account = "system")
{
	if(!(username in contents))
		return "Entry not found";
	if(!islist(permissions))
		permissions = list(permissions);

	var/list/entry = contents[username];
	entry["permissions"] -= permissions;
	write(username, entry, account);
	log_custom("Removed [jointext(permissions, "|")] permissions", account);
}

/datum/database/accounts/proc/change_password(username, password, account = "system")
{
	if(!(username in contents))
		return "Entry not found";

	var/list/entry = contents[username];
	entry["password"] = md5(password);
	write(username, entry, account);
	log_custom("Changed password (md5 = [password])", account);
}

/datum/database/accounts/proc/access(username, password, dbname)
{
	if(!has_entry(username))
		return FALSE;
	var/list/entry = read(username);
	if(md5(password) != entry["password"])
		return FALSE;
		
	if(PERMISSION_SYSTEM_ADMIN in entry["permissions"])
		return PERMISSION_SYSTEM_ADMIN;

	for(var/P in entry["permissions"])
		if(starts_with(P, dbname))
			LAZYADD(., P);
}

/datum/database/records
	name = RECORDS_DATABASE
	log_flag = IC_DATABASE_LOG_EVERYTHING

// Where's write/read subroutins?
// Well, REFERENCES SON