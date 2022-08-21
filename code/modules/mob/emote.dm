/atom/movable/proc/see_emote(mob/source, text, emote_type)
	return

// All mobs should have custom emote, really..
//m_type == 1 --> visual.
//m_type == 2 --> audible
/mob/proc/custom_emote(var/m_type = VISIBLE_MESSAGE,var/message = null,var/range=world.view)
	if(stat || !use_me && usr == src)
		to_chat(src, "You are unable to emote.")
		return

	var/muzzled = is_muzzled()
	if(m_type == AUDIBLE_MESSAGE && muzzled) return

	var/input
	if(!message)
		input = sanitize(input(src,"Choose an emote to display.") as text|null)
	else
		input = message
	if(input)
		log_emote(input, src) //Log before we add junk
		message = input
	else
		return


	if(message)
		var/lastchar = copytext_char(message, -1)
		if(lastchar != "." && lastchar != "!" && lastchar != "?")
			message = message + "."
		message = encode_html_emphasis(message)
		if(findtext(message, "^") > 0) // not findtext_char because we don't need exact position, we just need fact that ^ exist
			message = replacetext_char(message, "^", "<b>[src]</b>")
		else
			message = "<b>[src]</b> [message]"

		if(m_type == VISIBLE_MESSAGE)
			visible_message(message)
			for(var/atom/movable/AM in viewers(range, src))
				AM.see_emote(src, message, m_type)
		else
			audible_message(message)
			for(var/atom/movable/AM in hearers(range, src))
				AM.see_emote(src, message, m_type)

// Shortcuts for above proc
/mob/proc/visible_emote(var/act_desc)
	custom_emote(1, act_desc)

/mob/proc/audible_emote(var/act_desc)
	custom_emote(2, act_desc)

/mob/proc/emote_dead(var/message)

	if(client.prefs.muted & MUTE_DEADCHAT)
		to_chat(src, "<span class='danger'>You cannot send deadchat emotes (muted).</span>")
		return

	if(!is_preference_enabled(/datum/client_preference/show_dsay))
		to_chat(src, "<span class='danger'>You have deadchat muted.</span>")
		return

	if(!src.client.holder)
		if(!config.dsay_allowed)
			to_chat(src, "<span class='danger'>Deadchat is globally muted.</span>")
			return


	var/input
	if(!message)
		input = sanitize(input(src, "Choose an emote to display.") as text|null)
	else
		input = message

	input = encode_html_emphasis(input)

	if(input)
		log_ghostemote(input, src)
		if(!invisibility) //If the ghost is made visible by admins or cult. And to see if the ghost has toggled its own visibility, as well. -Mech
			visible_message("<span class='deadsay'><B>[src]</B> [input]</span>")
		else
			say_dead_direct(input, src)
