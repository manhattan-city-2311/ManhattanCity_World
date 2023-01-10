/mob/proc/flash_weakest_pain()
	flick("weakest_pain", pain)

/mob/proc/flash_pain()
	flick("pain", pain)

/mob/var/list/pain_stored = list()
/mob/var/last_pain_message = ""
/mob/var/next_pain_time = 0

/mob/living/carbon/var/shock_stage = 0
/mob/living/carbon/var/pain_coeff = 1 / 50
/mob/living/carbon/proc/add_shock_from_pain(pain)
	shock_stage += pain * pain_coeff

/mob/living/carbon/var/list/messages_throttles = list()
/mob/living/carbon/proc/throttle_message(id, message, bold, font_size, span, delay = 70)
	var/last_message = LAZYACCESS0(messages_throttles, id)

	if(world.time < (last_message + delay))
		return FALSE

	if(span)
		message = SPAN(span, message)
	if(font_size)
		message = "<font size = [font_size]>[message]</font>"
	if(bold)
		message = "<b>[message]</b>"

	to_chat(src, message)

	messages_throttles[id] = world.time

	return TRUE


/mob/living/carbon/proc/custom_pain(message, power, force, obj/item/organ/external/affecting, nohalloss, flash_pain)
	power -= LAZYACCESS0(chem_effects, CE_PAINKILLER)
	flash_pain -= LAZYACCESS0(chem_effects, CE_PAINKILLER)
	if(stat || !can_feel_pain() || (power <= 0 && flash_pain <= 0))//!message
		return 0

	var/disp_emote

	// Excessive halloss is horrible, just give them enough to make it visible.
	if(!nohalloss && (power || flash_pain))//Flash pain is so that handle_pain actually makes use of this proc to flash pain.
		if(affecting)
			var/actual_flash
			affecting.add_pain(ceil(power/2))
			if(power > flash_pain)
				actual_flash = power
			else
				actual_flash = flash_pain

			switch(actual_flash)
				if(1 to 40)
					flash_weakest_pain()
					disp_emote = pick("groan", "whimper")
					emote()
				if(40 to 80)
					flash_weak_pain()
					disp_emote = pick("scream", "cry", "groan", "whimper")
					if(stuttering < 10)
						stuttering += 5
				if(80 to POSITIVE_INFINITY)
					flash_pain()
					disp_emote = pick("scream", "cry", "agony")
					if(stuttering < 10 && rand(25))
						stuttering += 10
					if(prob(2))
						Stun(5)//makes you drop what you're holding.
						shake_camera(src, 20, 3)
		else
			adjustHalLoss(ceil(power/2))

		add_shock_from_pain(power + flash_pain)

	// Anti message spam checks
	if((force || (message != last_pain_message) || (world.time >= next_pain_time)) && message)
		last_pain_message = message

		if(power >= 50)
			to_chat(src, "<b><font size=3>[message]</font></b>")
		else
			to_chat(src, "<b>[message]</b>")
		if(disp_emote)
			emote(disp_emote)

	next_pain_time = world.time + (70 - power) SECONDS

/mob/living/carbon/human/var/total_pain = 0
/mob/living/carbon/human/proc/handle_pain()
	if(stat)
		return
	if(!can_feel_pain())
		return

	total_pain = 0

	var/maxdam = 0
	var/obj/item/organ/external/damaged_organ = null
	for(var/obj/item/organ/external/E in organs_by_name)
		if(!E.can_feel_pain())
			continue
		var/dam = E.get_pain()
		if(dam > maxdam)
			damaged_organ = E
			maxdam = dam

		total_pain += dam

	// Damage to internal organs hurts a lot.
	for(var/obj/item/organ/I in internal_organs)
		if((I.status & ORGAN_DEAD) || I.robotic >= ORGAN_ROBOT)
			continue
		if(I.damage > 2 && prob(2))
			var/obj/item/organ/external/parent = get_organ(I.parent_organ)
			if(world.time > next_pain_time)
				custom_pain("You feel a sharp pain in your [parent.name]", 50, affecting = parent)
			total_pain += 50
	
	total_pain = max(0, total_pain + getToxLoss() - LAZYACCESS0(chem_effects, CE_PAINKILLER))

	if(world.time < next_pain_time)
		return

	if(prob(3))
		switch(getToxLoss())
			if(10 to 25)
				custom_pain("Your body stings slightly.", getToxLoss())
			if(25 to 45)
				custom_pain("Your whole body hurts badly.", getToxLoss())
			if(61 to POSITIVE_INFINITY)
				custom_pain("Your body aches all over, it's driving you mad.", getToxLoss())
	
	if(damaged_organ)
		if(maxdam > 10 && paralysis)
			paralysis = max(0, paralysis - round(maxdam/10))
		//if(maxdam > 50 && prob(maxdam / 5))
		//	drop_item()
		var/burning = damaged_organ.burn_dam > damaged_organ.brute_dam
		var/msg
		switch(maxdam)
			if(1 to 10)
				msg = "Your [damaged_organ.name] [burning ? "burns" : "hurts"]."

			if(11 to 90)
				msg = "<font size=2>Your [damaged_organ.name] [burning ? "burns" : "hurts"] badly!</font>"

			if(91 to POSITIVE_INFINITY)
				msg = "<font size=3>OH GOD! Your [damaged_organ.name] is [burning ? "on fire" : "hurting terribly"]!</font>"

		custom_pain(SPAN_DANGER(msg), 0, prob(10), affecting = damaged_organ, flash_pain = maxdam)
