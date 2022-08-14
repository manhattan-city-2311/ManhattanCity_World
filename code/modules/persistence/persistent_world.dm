
/proc/save_world()
	//saves all political data - TODO: Move this into law subsystem
	SSpersistent_options.save_all_options()
	SSpersistent_options.save_ballots()

	//save economy and department money
	SSeconomy.save_economy()

	//save business data
	SSbusiness.save_all_businesses()

	//save politics related data
	SSelections.save_data.save_candidates()

	//save news
	news_data.save_main_news()

	//save emails
	SSemails.save_all_emails()

	SSlaw.save_warrants()

	//saves all characters

	for(var/mob/living/carbon/human/H in mob_list)
		var/uid = md5(H.real_name)
		var/datum/persistent_inventory/PI = check_persistent_storage_exists(uid)

		if(!PI)
			PI = new(uid)
		else
			PI.stored_items.Cut()
		// TODO: Add underwear saving
		for(var/slot = SLOT_TOTAL to 1 step -1)
			var/I = H.get_equipped_item(slot)
			if(I)
				PI.add_item(slot, I)

		handle_jail(H)	// make sure the pesky criminals get what's coming to them.
		H.save_mob_to_prefs()

	for(var/datum/persistent_inventory/PI in global.persistent_inventories)
		PI.save()

	for(var/datum/money_account/MA in global.persistent_money_accounts)
		MA.save()

	if(config.lot_saving)
		to_world("<h3>Saving all lots... Note: This might lag the world for a short while.</h3>")
		SSlots.save_all_lots()

	to_world("<h2>World saved.</h2>")
	return 1

/hook/roundend/proc/world_save()
	to_world("Saving world...")
	save_world()
