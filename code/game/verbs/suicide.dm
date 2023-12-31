/mob/var/suiciding = 0

/mob/living/carbon/human/verb/suicide()
	set hidden = 1

	if (stat == DEAD)
		to_chat(src, "You're already dead!")
		return

	if (!ticker)
		to_chat(src, "You can't commit suicide before the game starts!")
		return

	if (suiciding)
		to_chat(src, "You're already committing suicide! Be patient!")
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "No")
		return
	var/confirm_canon
	if(config.canonicity)
		confirm_canon = alert("Are you SURE you want to commit suicide? This is a canon round. WARNING: This will delete your \
		character slot, you will never be able to play this character again, ALL of your persistent in-game money \
		relating to money, businesses, your political status, and appearance will be lost forever. \
		This is irreverseable!","Confirm Suicide", "Yes", "No")

	if(confirm_canon == "No")
		return

	if(config.canonicity)
		handle_delete_character()
	if(job)
		SSjobs.FreeRole(job)

	if(!canmove || restrained())	//just while I finish up the new 'fun' suiciding verb. This is to prevent metagaming via suicide
		to_chat(src, "You can't commit suicide whilst restrained! ((You can type Ghost instead however.))")
		return
	suiciding = 15
	does_not_breathe = 0			//Prevents ling-suicide zombies, or something
	var/obj/item/held_item = get_active_hand()
	if(held_item)
		var/damagetype = held_item.suicide_act(src)
		if(damagetype)
			log_and_message_admins("[key_name(src)] commited suicide using \a [held_item]")
			var/damage_mod = 1
			switch(damagetype) //Sorry about the magic numbers.
							   //brute = 1, burn = 2, tox = 4, oxy = 8
				if(15) //4 damage types
					damage_mod = 4

				if(6, 11, 13, 14) //3 damage types
					damage_mod = 3

				if(3, 5, 7, 9, 10, 12) //2 damage types
					damage_mod = 2

				if(1, 2, 4, 8) //1 damage type
					damage_mod = 1

				else //This should not happen, but if it does, everything should still work
					damage_mod = 1

			//Do 175 damage divided by the number of damage types applied.
			if(damagetype & BRUTELOSS)
				adjustBruteLoss(30/damage_mod)	//hack to prevent gibbing
				adjustOxyLoss(145/damage_mod)

			if(damagetype & FIRELOSS)
				adjustFireLoss(175/damage_mod)

			if(damagetype & TOXLOSS)
				adjustToxLoss(175/damage_mod)

			if(damagetype & OXYLOSS)
				adjustOxyLoss(175/damage_mod)

			//If something went wrong, just do normal oxyloss
			if(!(damagetype | BRUTELOSS) && !(damagetype | FIRELOSS) && !(damagetype | TOXLOSS) && !(damagetype | OXYLOSS))
				adjustOxyLoss(max(175 - getToxLoss() - getFireLoss() - getBruteLoss() - get_deprivation(), 0))

			updatehealth()
			return

		log_and_message_admins("[key_name(src)] commited suicide")

		var/datum/gender/T = gender_datums[get_visible_gender()]

		var/suicidemsg
		suicidemsg = pick("<span class='danger'>[src] is attempting to bite [T.his] tongue off! It looks like [T.he] [T.is] trying to commit suicide.</span>", \
		                     "<span class='danger'>[src] is jamming [T.his] thumbs into [T.his] eye sockets! It looks like [T.he] [T.is] trying to commit suicide.</span>", \
		                     "<span class='danger'>[src] is twisting [T.his] own neck! It looks like [T.he] [T.is] trying to commit suicide.</span>", \
		                     "<span class='danger'>[src] is holding [T.his] breath! It looks like [T.he] [T.is] trying to commit suicide.</span>")
		if(isSynthetic())
			suicidemsg = "<span class='danger'>[src] is attempting to switch [T.his] power off! It looks like [T.he] [T.is] trying to commit suicide.</span>"
		visible_message(suicidemsg)

		adjustOxyLoss(max(175 - getToxLoss() - getFireLoss() - getBruteLoss() - get_deprivation(), 0))
		updatehealth()

/mob/living/carbon/brain/verb/suicide()
	set hidden = 1

	if (stat == 2)
		to_chat(src, "You're already dead!")
		return

	if (!ticker)
		to_chat(src, "You can't commit suicide before the game starts!")
		return

	if (suiciding)
		to_chat(src, "You're already committing suicide! Be patient!")
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		viewers(loc) << "<span class='danger'>[src]'s brain is growing dull and lifeless. It looks like it's lost the will to live.</span>"
		spawn(50)
			death(0)
			suiciding = 0

/mob/living/silicon/ai/verb/suicide()
	set hidden = 1

	if (stat == 2)
		to_chat(src, "You're already dead!")
		return

	if (suiciding)
		to_chat(src, "You're already committing suicide! Be patient!")
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		viewers(src) << "<span class='danger'>[src] is powering down. It looks like they're trying to commit suicide.</span>"
		//put em at -175
		adjustOxyLoss(max(getMaxHealth() * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - get_deprivation(), 0))
		updatehealth()

/mob/living/silicon/robot/verb/suicide()
	set hidden = 1

	if (stat == 2)
		to_chat(src, "You're already dead!")
		return

	if (suiciding)
		to_chat(src, "You're already committing suicide! Be patient!")
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		viewers(src) << "<span class='danger'>[src] is powering down. It looks like they're trying to commit suicide.</span>"
		//put em at -175
		adjustOxyLoss(max(getMaxHealth() * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - get_deprivation(), 0))
		updatehealth()

/mob/living/silicon/pai/verb/suicide()
	set category = "pAI Commands"
	set desc = "Kill yourself and become a ghost (You will receive a confirmation prompt)"
	set name = "pAI Suicide"
	var/answer = input("REALLY kill yourself? This action can't be undone.", "Suicide", "No") in list ("Yes", "No")
	if(answer == "Yes")
		var/obj/item/device/paicard/card = loc
		card.removePersonality()
		var/turf/T = get_turf_or_move(card.loc)
		for (var/mob/M in viewers(T))
			M.show_message("<span class='notice'>[src] flashes a message across its screen, \"Wiping core files. Please acquire a new personality to continue using pAI device functions.\"</span>", 3, "<span class='notice'>[src] bleeps electronically.</span>", 2)
		death(0)
	else
		to_chat(src, "Aborting suicide attempt.")

/mob/living/carbon/human/proc/handle_delete_character()
	if(!mind || !mind.prefs)
		return 0

	if(!(unique_id == mind.prefs.unique_id))	// make sure it's the same character
		return 0

	if(!config.canonicity)
		return 0

	mind.prefs.delete_character()
	return 1
