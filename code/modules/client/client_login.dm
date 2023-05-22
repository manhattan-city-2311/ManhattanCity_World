#define MIN_CLIENT_VERSION	0		//Just an ambiguously low version for now, I don't want to suddenly stop people playing.
									//I would just like the code ready should it ever need to be used.

///////////
//CONNECT//
///////////
/client/New(TopicData)
	TopicData = null						//Prevent calls to client.Topic from connect

	// Load goonchat
	chatOutput = new(src)

	if(!(connection in list("seeker", "web")))					//Invalid connection type.
		return null
	if(byond_version < MIN_CLIENT_VERSION)		//Out of date client.
		return null

	if(!config.guests_allowed && IsGuestKey(key))
		alert(src,"This server doesn't allow guest accounts to play. Please go to http://www.byond.com/ and register for a key.","Guest","OK")
		del(src)
		return

	to_chat(src, "<font color='red'>If the title screen is black, resources are still downloading. Please be patient until the title screen appears.</font>")


	GLOB.clients += src
	GLOB.directory[ckey] = src

	//Admin Authorisation
	holder = admin_datums[ckey]
	if(holder)
		admins += src
		holder.owner = src

	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = preferences_datums[ckey]
	if(!prefs)
		prefs = new /datum/preferences(src)
		preferences_datums[ckey] = prefs

	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning

	add_ip_cid_list(address, computer_id)

	if(!byond_join_date)
		byond_join_date = findJoinDate()

	prefs.byond_join_date = byond_join_date

	. = ..()	//calls mob.Login()
	prefs.sanitize_preferences()

	prefs.last_seen = full_real_time()

	if(!prefs.first_seen)
		prefs.first_seen = full_real_time()
		prefs.last_seen = full_real_time()

	if(custom_event_msg && custom_event_msg != "")
		to_chat(src, "<h1 class='alert'>Custom Event</h1>")
		to_chat(src, "<h2 class='alert'>A custom event is taking place. OOC Info:</h2>")
		to_chat(src, "<span class='alert'>[custom_event_msg]</span>")
		to_chat(src, "<br>")

	if(holder)
		add_admin_verbs()
		admin_memo_show()

	// Forcibly enable hardware-accelerated graphics, as we need them for the lighting overlays.
	// (but turn them off first, since sometimes BYOND doesn't turn them on properly otherwise)
	spawn(5) // And wait a half-second, since it sounds like you can do this too fast.
		if(src)
			winset(src, null, "command=\".configure graphics-hwmode off\"")
			sleep(2) // wait a bit more, possibly fixes hardware mode not re-activating right
			winset(src, null, "command=\".configure graphics-hwmode on\"")
	log_client_to_db()

	var/player_byond_age = get_byond_age()

	//Panic bunker code
	if (isnum(player_age) && player_age == 0) //first connection
		if (config.panic_bunker && !holder && !deadmin_holder)
			log_adminwarn("Failed Login: [key] - New account attempting to connect during panic bunker")
			message_admins("<span class='adminnotice'>Failed Login: [key] - New account attempting to connect during panic bunker</span>")
			to_chat(src, "Sorry but the server is currently not accepting connections from never before seen players.")
			prefs.first_seen = null
			qdel(src)
			return 0


	// IP Reputation Check
	if(config.ip_reputation)
		if(config.ipr_allow_existing && player_age >= config.ipr_minimum_age)
			log_admin("Skipping IP reputation check on [key] with [address] because of player age")
		else if(update_ip_reputation()) //It is set now
			if(ip_reputation >= config.ipr_bad_score) //It's bad


				message_admins("[key] at [address] has bad IP reputation: [ip_reputation]. Will be kicked if enabled in config.")
				log_admin("[key] at [address] has bad IP reputation: [ip_reputation]. Will be kicked if enabled in config.")

				//Take action if required
				if(config.ipr_block_bad_ips && config.ipr_allow_existing) //We allow players of an age, but you don't meet it
					to_chat(src,"Sorry, we only allow VPN/Proxy/Tor usage for players who have spent at least [config.ipr_minimum_age] days on the server. If you are unable to use the internet without your VPN/Proxy/Tor, please contact an admin out-of-game to let them know so we can accomidate this.")
					qdel(src)
					return 0
				else if(config.ipr_block_bad_ips) //We don't allow players of any particular age
					to_chat(src,"Sorry, we do not accept connections from users via VPN/Proxy/Tor connections.")
					qdel(src)
					return 0
		else
			log_admin("Couldn't perform IP check on [key] with [address]")


	//VOREStation Code

	//var/alert = FALSE //VOREStation Edit start.
	if(isnum(player_age) && player_age == 0)
		message_admins("PARANOIA: [key_name(src)] has connected here for the first time.")
	//	alert = TRUE
	if(isnum(player_byond_age) && player_byond_age <= 2)
		message_admins("PARANOIA: [key_name(src)] has a very new BYOND account ([player_byond_age] days).")
	//	alert = TRUE
	// if(alert)
	// 	for(var/client/X in admins)
	// 		if(X.is_preference_enabled(/datum/client_preference/holder/play_adminhelp_ping))
	// 			X << 'sound/voice/bcriminal.ogg'


	send_resources()
	SSnanoui.send_resources(src)

	if(!void)
		void = new()
	screen += void

	if(prefs.lastchangelog != changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		to_chat(src, "<span class='info'>You have unread updates in the changelog.</span>")
		winset(src, "rpane.changelog", "background-color=#eaeaea;font-style=bold")
		if(config.aggressive_changelog)
			src.changes()

	chatOutput.start()

	var/client/client = src

	client.update_chat_position()
#undef MIN_CLIENT_VERSION

//////////////
//DISCONNECT//
//////////////
/client/Del()
	if(holder)
		holder.owner = null
		admins -= src
	GLOB.directory -= ckey
	GLOB.clients -= src
	return ..()

/client/Destroy()
	..()
	return QDEL_HINT_HARDDEL_NOW

/client/proc/add_ip_cid_list(ip, cid)
	// This is for hard saving.
	if(ip && !(ip in prefs.ips_associated))
		prefs.ips_associated += ip

	if(cid && !(cid in prefs.cids_associated))
		prefs.cids_associated += cid
