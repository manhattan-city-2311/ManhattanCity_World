/mob/living/simple_mob/animal/borer/say(var/message, whispering)

	message = sanitize(message)
	message = capitalize(message)

	if(!message)
		return

	if (stat == 2)
		return say_dead(message)

	if (stat)
		return

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<font color='red'>You cannot speak in IC (muted).</font>")
			return

	if (copytext(message, 1, 2) == "*")
		return emote(copytext(message, 2))

	var/datum/language/L = parse_language(message)
	if(L && L.flags & HIVEMIND)
		L.broadcast(src,trim(copytext(message,3)),src.truename)
		return

	if(!host)
		//TODO: have this pick a random mob within 3 tiles to speak for the borer.
		to_chat(src, "You have no host to speak to.")
		return //No host, no audible speech.

	to_chat(src, "You drop words into [host]'s mind: \"[message]\"")
	to_chat(host, "Your own thoughts speak: \"[message]\"")

	for (var/mob/M in player_list)
		if (istype(M, /mob/new_player))
			continue
		else if(M.stat == DEAD && M.is_preference_enabled(/datum/client_preference/ghost_ears))
			to_chat(M, "[src.truename] whispers to [host], \"[message]\"")