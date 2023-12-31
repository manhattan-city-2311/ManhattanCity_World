/datum/admins/proc/view_persistent_data()
	set category = "Persistence"
	set name = "View Persistent Map Data"
	set desc = "Shows a list of persistent data for this round. Allows modification by admins."

	SSpersistence.show_info(usr)

/client/proc/toggle_canon()
	set name = "Toggle Canon"
	set desc = "Allows you to determine if the round is canon and if "
	set category = "Persistence"

	if(!holder)
		to_chat(usr, "<font color='red'>Only admins can use this command!</font>")
		return

	if(config)
		if(config.canonicity)
			config.canonicity = 0
			for (var/mob/T as mob in mob_list)
				to_chat(T, "<br><center><b><font size=4>This round is no longer canon.<br> Character data will not be saved this round.</font></b><br></center><br>")
			message_admins("Admin [key_name_admin(usr)] has made the round non-canon and disabled saving.", 1)
		else
			config.canonicity = 1
			for (var/mob/T as mob in mob_list)
				T << "<br><center><span class='notice'><b><font size=4>This round is now canon.<br> Character data will be saved.</font></b><br></span></center><br>"
			message_admins("Admin [key_name_admin(usr)] has made the round canon and enabled end-round saving.", 1)

/client/proc/save_all_characters()
	set name = "Save All Characters"
	set desc = "Saves all characters, assuming the round is canon."
	set category = "Persistence"

	if(!holder)
		to_chat(usr, "<font color='red'>Only admins can use this command!</font>")
		return 0

	if(!config.canonicity) //if we're not canon in config or by gamemode, nothing will save.
		to_chat(usr, "<font color='red'>The round is not canon!</font>")
		return 0

	for(var/mob/living/carbon/human/H in mob_list) //only humans, we don't really save AIs or robots.
		if(!H.save_mob_to_prefs())
			message_admins("ERROR: Unable to save all characters.", 1)
			return 0

	return 1

/client/proc/save_department_accounts()
	set name = "Save Department Accounts"
	set desc = "Saves all department accounts, assuming the round is canon."
	set category = "Persistence"


	if(!SSeconomy)
		to_chat(usr, "<font color='red'>The economy does not currently exist yet.</font>")
		return 0

	if(!holder)
		to_chat(usr, "<font color='red'>Only admins can use this command!</font>")
		return 0

	if(!config.canonicity) //if we're not canon in config or by gamemode, nothing will save.
		to_chat(usr, "<font color='red'>The round is not canon!</font>")
		return 0

	SSeconomy.save_economy()
	message_admins("Admin [key_name_admin(usr)] has saved all dept accs through verb.", 1)

	return 1

/client/proc/load_department_accounts()
	set name = "Load Department Accounts"
	set desc = "Loads all department accounts."
	set category = "Persistence"

	if(!SSeconomy)
		to_chat(usr, "<font color='red'>The economy does not currently exist yet.</font>")
		return 0

	if(!holder)
		to_chat(usr, "<font color='red'>Only admins can use this command!</font>")
		return 0

	SSeconomy.load_economy()
	message_admins("Admin [key_name_admin(usr)] has loaded all dept accs through verb.", 1)
	return 1

/client/proc/debug_news()
	set category = "Persistence"
	set name = "Debug News"
	set desc = "Propaganda begins here."

	if(!holder)
		to_chat(usr, "<font color='red'>Only admins can use this command!</font>")
		return 0

	debug_variables(news_data)


/client/proc/backup_all_lots()
	set category = "Persistence"
	set name = "Backup Lots"
	set desc = "Makes backups of all lots in game."

	if(!holder)
		to_chat(usr,"<font color='red'>Only admins can use this command!</font>")
		return 0

	if(SSlots)
		SSlots.backup_all_lots()
		to_chat(usr,"<b>Lot data has been backed up!</b>")

	else
		to_chat(usr,"<b>Could not find lots controller, has it booted yet?</b>")