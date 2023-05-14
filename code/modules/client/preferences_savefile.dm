#define SAVEFILE_VERSION_MIN	8
#define SAVEFILE_VERSION_MAX	11

//handles converting savefiles to new formats
//MAKE SURE YOU KEEP THIS UP TO DATE!
//If the sanity checks are capable of handling any issues. Only increase SAVEFILE_VERSION_MAX,
//this will mean that savefile_version will still be over SAVEFILE_VERSION_MIN, meaning
//this savefile update doesn't run everytime we load from the savefile.
//This is mainly for format changes, such as the bitflags in toggles changing order or something.
//if a file can't be updated, return 0 to delete it and start again
//if a file was updated, return 1
/datum/preferences/proc/savefile_update()
	if(savefile_version < 8)	//lazily delete everything + additional files so they can be saved in the new format
		for(var/ckey in preferences_datums)
			var/datum/preferences/D = preferences_datums[ckey]
			if(D == src)
				var/delpath = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/"
				if(delpath && fexists(delpath))
					fdel(delpath)
				break
		return 0

	if(savefile_version == SAVEFILE_VERSION_MAX)	//update successful.
		save_preferences()
		save_character()
		return 1
	return 0

/datum/preferences/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)	return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"
	savefile_version = SAVEFILE_VERSION_MAX

/datum/preferences/proc/load_preferences()
	if(!path)
		return 0

	if(world.time < loadprefcooldown)
		if(istype(client))
			to_chat(client, "<span class='warning'>You're attempting to load your preferences a little too fast. Wait half a second, then try again.</span>")
		return 0
	loadprefcooldown = world.time + PREF_SAVELOAD_COOLDOWN

	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"

	S["version"] >> savefile_version
	//Conversion
	if(!savefile_version || !isnum(savefile_version) || savefile_version < SAVEFILE_VERSION_MIN || savefile_version > SAVEFILE_VERSION_MAX)
		if(!savefile_update())  //handles updates
			savefile_version = SAVEFILE_VERSION_MAX
			save_preferences()
			save_character()
			return 0

	player_setup.load_preferences(S)
	return 1

/datum/preferences/proc/save_preferences()
	if(!path)				return 0

	if(world.time < saveprefcooldown)
		if(istype(client))
			to_chat(client, "<span class='warning'>You're attempting to save your preferences a little too fast. Wait half a second, then try again.</span>")
		return 0
	saveprefcooldown = world.time + PREF_SAVELOAD_COOLDOWN

	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"

	S["version"] << savefile_version
	player_setup.save_preferences(S)
	return 1

/datum/preferences/proc/load_character(slot)
	if(!path)				return 0

	if(world.time < loadcharcooldown) //This is before the check to see if the filepath exists to ensure that BYOND can't get hung up on read attempts when the hard drive is a little slow
		if(istype(client))
			to_chat(client, "<span class='warning'>You're attempting to load your character a little too fast. Wait half a second, then try again.</span>")
		return "SLOW THE FUCK DOWN" //the reason this isn't null is to make sure that people don't have their character slots overridden by random chars if they accidentally double-click a slot
	loadcharcooldown = world.time + PREF_SAVELOAD_COOLDOWN

	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"
	if(!slot)	slot = default_slot
	if(slot != SAVE_RESET) // SAVE_RESET will reset the slot as though it does not exist, but keep the current slot for saving purposes.
		slot = sanitize_integer(slot, 1, config.character_slots, initial(default_slot))
		if(slot != default_slot)
			default_slot = slot
			S["default_slot"] << slot
	else
		S["default_slot"] << default_slot

	if(slot != SAVE_RESET)
		S.cd = "/character[slot]"
		player_setup.load_character(S)
	else
		player_setup.load_character(S)
		S.cd = "/character[default_slot]"

	player_setup.load_character(S)
	load_persistence(S)
	return 1

/datum/preferences/proc/save_character()
	if(!path)				return 0

	if(world.time < savecharcooldown)
		if(istype(client))
			to_chat(client, "<span class='warning'>You're attempting to save your character a little too fast. Wait half a second, then try again.</span>")
		return 0
	savecharcooldown = world.time + PREF_SAVELOAD_COOLDOWN

	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/character[default_slot]"

	player_setup.save_character(S)
	save_persistence(S)
	return 1

/datum/preferences/proc/load_persistence(savefile/S)
	from_save(S, bank_account)
	from_save(S, bank_pin)
	from_save(S, persistence_x)
	from_save(S, persistence_y)
	from_save(S, persistence_z)
	from_save(S, records)

/datum/preferences/proc/save_persistence(savefile/S)
	to_save(S, bank_account)
	to_save(S, bank_pin)
	to_save(S, persistence_x)
	to_save(S, persistence_y)
	to_save(S, persistence_z)
	to_save(S, records)

/datum/preferences/proc/delete_persistence(savefile/S)
	bank_account = initial(bank_account)
	bank_pin     = initial(bank_pin)
	persistence_x= initial(persistence_x)
	persistence_y= initial(persistence_y)
	persistence_z= initial(persistence_z)

	delete_persistent_inventory(md5(real_name))

	save_persistence(S)

/datum/preferences/proc/delete_character()
	if(!path)
		return 0

	if(world.time < savecharcooldown)
		if(istype(client))
			to_chat(client, "<span class='warning'>You're attempting to save your character a little too fast. Wait half a second, then try again.</span>")
		return 0
	savecharcooldown = world.time + PREF_SAVELOAD_COOLDOWN

	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/character[default_slot]"

	delete_persistence(S)
	player_setup.delete_character(S)

	return 1

/datum/preferences/proc/sanitize_preferences()
	player_setup.sanitize_setup()
	return 1

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN
