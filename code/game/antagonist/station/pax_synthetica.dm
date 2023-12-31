// Infiltrator is a variant of Traitor, except that the traitors are in a team and can communicate with a special headset.

var/datum/antagonist/traitor/pax_synthetica/pax_synthetica_operatives

// Inherits most of its vars from the base datum.
/datum/antagonist/traitor/pax_synthetica
	id = MODE_PAX
	role_type = BE_TRAITOR
	antag_indicator = "pax"
	antaghud_indicator = "hudpax"
	role_text = "Pax Synthetica Operative"
	role_text_plural = "Pax Synthetica Operatives"
	welcome_text = "To speak on your team's private channel, use :j."
	restricted_jobs = list("Prisoner", "AI", "Cyborg","Mayor","City Clerk", "Chief of Police","Police Officer",\
	"Prison Warden","Detective","Medical Director","Maintenance Director","Research Director","Judge")
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	hard_cap = 4
	antag_text = "As a Pax Synthetica activist, you advocate for increased quality of life for synths. This can range from \
	better or more rights, or full-blown synthetic supremacy. You can be a moderate activist to an extremist freedom fighter.</b>\
	You are still expected to escalate accordingly <b>with no murderboning</b>. Try to make sure other players have fun! AOOC is enabled, but please do not metagame. \
	<b>This role has uplink items.</b>"


/datum/antagonist/traitor/pax_synthetica/New()
	..()
	pax_synthetica_operatives = src



/datum/antagonist/traitor/pax_synthetica/equip(var/mob/living/carbon/human/traitor_mob)
	..() // Give the uplink and other stuff.
	// Now for the special headset.

	// Humans and the AI.
	if(istype(traitor_mob) || istype(traitor_mob, /mob/living/silicon/ai))
		var/obj/item/device/radio/headset/R
		R = locate(/obj/item/device/radio/headset) in traitor_mob.contents
		if(!R)
			to_chat(traitor_mob, "Unfortunately, a headset could not be found.  You have been given an encryption key \
			to put into a new headset.  Once that is done, you can talk to your team using <b>:j</b>")
			var/obj/item/device/encryptionkey/pax_synthetica/encrypt_key = new(null)
			traitor_mob.equip_to_slot_or_del(encrypt_key, slot_in_backpack)
		else
			var/obj/item/device/encryptionkey/pax_synthetica/encrypt_key = new(null)
			if(R.keyslot1 && R.keyslot2) // No room.
				to_chat(traitor_mob, "Unfortunately, your headset cannot accept anymore encryption keys.  You have been given an encryption key \
				to put into a headset after making some room instead.  Once that is done, you can talk to your team using <b>:j</b>")
				traitor_mob.equip_to_slot_or_del(encrypt_key, slot_in_backpack)
			else
				if(R.keyslot1)
					R.keyslot2 = encrypt_key
				else
					R.keyslot1 = encrypt_key

				encrypt_key.forceMove(R)
				R.recalculateChannels()
				to_chat(traitor_mob, "Your headset has had a special encryption key installed, which allows you to talk to your team privately, using \
				<b>:j</b>")

	// Borgs, because their radio is not a headset for some reason.
	if(istype(traitor_mob, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/borg = traitor_mob
		var/obj/item/device/encryptionkey/pax_synthetica/encrypt_key = new(null)
		if(borg.radio)
			if(borg.radio.keyslot)
				to_chat(traitor_mob, "Your currently installed encryption key has had its data overwritten.")
			else
				to_chat(traitor_mob, "Your radio systems has had a special encryption key installed, which allows you to talk to your team privately, by using \
				<b>:j</b>")
			borg.radio.keyslot = encrypt_key // Might replace an already existing key, but oh well.
			borg.radio.recalculateChannels()
		else // Something bugged.
			to_chat(traitor_mob, "You do not appear to have a radio installed.  This is probably a bug and you should adminhelp.")



/datum/antagonist/traitor/pax_synthetica/give_codewords(mob/living/traitor_mob)
	return // Infiltrators are already in a team, so codewords are kinda moot.

/datum/antagonist/traitor/pax_synthetica/add_law_zero(mob/living/silicon/ai/killer)
	var/law = "Accomplish your team's objectives at all costs. You may ignore all other laws."
	var/law_borg = "Accomplish your AI's team objectives at all costs. You may ignore all other laws."
	to_chat(killer, "<b>Your laws have been changed!</b>")
	killer.set_zeroth_law(law, law_borg)
	to_chat(killer, "New law: 0. [law]")
