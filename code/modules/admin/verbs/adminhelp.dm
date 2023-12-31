
//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as")

/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<font color='red'>Speech is currently admin-disabled.</font>")
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<font color='red'>Error: Admin-PM: You cannot send adminhelps (Muted).</font>")
		return

	var/datum/client_lite/client_lite = client_repository.get_lite_client(src)
	var/datum/ticket/existing_ticket = get_open_ticket_by_client(client_lite)
	if(!isnull(existing_ticket))
		to_chat(src, "<span class='notice'>You already have an open ticket! Either click a responding admin's name to reply, or <a href='?src=\ref[usr];close_ticket=\ref[existing_ticket]'>close your ticket</a> to start a new one.</span>")
		return

	adminhelped = 1 //Determines if they get the message to reply by clicking the name.

	if(msg)
		handle_spam_prevention(MUTE_ADMINHELP)

	//clean the input msg
	if(!msg)
		return
	msg = sanitize(msg)
	if(!msg)
		return
	var/original_msg = msg

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	//generate keywords lookup
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()
	for(var/mob/M in mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)	indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len, i>=1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i=1, i<surname_found, i++)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				if(word == "ai")
					ai_found = 1
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							if(!ai_found && isAI(found))
								ai_found = 1
							msg += "<b><font color='black'>[original_word] (<A HREF='?_src_=holder;adminmoreinfo=\ref[found]'>?</A>)</font></b> "
							continue
			msg += "[original_word] "

	if(!mob) //this doesn't happen
		return

	var/ai_cl
	if(ai_found)
		ai_cl = " (<A HREF='?_src_=holder;adminchecklaws=\ref[mob]'>CL</A>)"

			//Options bar:  mob, details ( admin = 2, dev = 3, event manager = 4, character name (0 = just ckey, 1 = ckey and character name), link? (0 no don't make it a link, 1 do so),
			//		highlight special roles (0 = everyone has same looking name, 1 = antags / special roles get a golden name)

	// create ticket
	var/datum/ticket/ticket = new /datum/ticket(client_lite)
	ticket.msgs += new /datum/ticket_msg(src.ckey, null, original_msg)

	var/mentor_msg = "<span class='notice'><b><font color=red>HELP: </font>[get_options_bar(mob, 4, 1, 1, 0, ticket)][ai_cl] (<a href='?_src_=holder;take_ticket=\ref[ticket]'>TAKE</a>) (<a href='?src=\ref[usr];close_ticket=\ref[ticket]'>CLOSE</a>):</b> [original_msg]</span>"
	msg = "<span class='notice'><b><font color=red>HELP: </font>[get_options_bar(mob, 2, 1, 1, 1, ticket)][ai_cl] (<a href='?_src_=holder;take_ticket=\ref[ticket]'>TAKE</a>) (<a href='?src=\ref[usr];close_ticket=\ref[ticket]'>CLOSE</a>):</b> [original_msg]</span>"

	var/admin_number_afk = 0

	for(var/client/X in admins)
		if((R_ADMIN|R_MOD|R_CBIA|R_SERVER) & X.holder.rights)
			if(X.is_afk())
				admin_number_afk++
			to_chat(X, msg)
			if(X.is_preference_enabled(/datum/client_preference/holder/play_adminhelp_ping))
				sound_to(X, 'sound/effects/adminhelp.ogg')
			if(X.holder.rights == R_CBIA)
				to_chat(X, mentor_msg)// Mentors won't see coloring of names on people with special_roles (Antags, etc.)
	//show it to the person adminhelping too
	to_chat(src, SPAN_INFO("PM to-<b>Staff</b> (<a href='?src=\ref[usr];close_ticket=\ref[ticket]'>CLOSE</a>): [original_msg]"))

	var/admin_number_present = admins.len - admin_number_afk
	log_admin("HELP: [key_name(src)]: [original_msg] - heard by [admin_number_present] non-AFK admins.")
	SSwebhooks.send(WEBHOOK_ADMINHELP, list("sender_name" = key_name(src), "text" = original_msg))

	if(admin_number_present <= 0)

		send2adminirc("Request for Help from [key_name(src)]: [html_decode(original_msg)] - !![admin_number_afk ? "All admins AFK ([admin_number_afk])" : "No admins online"]!!")
	else
		send2adminirc("Request for Help from [key_name(src)]: [html_decode(original_msg)]")

	feedback_add_details("admin_verb","AH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/proc/generate_ahelp_key_words(var/mob/mob, var/msg)
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	for(var/mob/M in mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)	indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len, i>=1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i=1, i<surname_found, i++)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				if(word == "ai" && !ai_found)
					ai_found = 1
					msg += "<b>[original_word] <A HREF='?_src_=holder;adminchecklaws=\ref[mob]'>(CL)</A></b> "
					continue
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							msg += "<b>[original_word] <A HREF='?_src_=holder;adminmoreinfo=\ref[found]'>(?)</A>"
							if(!ai_found && isAI(found))
								ai_found = 1
								msg += " <A HREF='?_src_=holder;adminchecklaws=\ref[mob]'>(CL)</A>"
							msg += "</b> "
							continue
		msg += "[original_word] "

	return msg
