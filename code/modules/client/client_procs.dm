	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT		10485760	//Restricts client uploads to the server to 10MB //Boosted this thing. What's the worst that can happen?

//#define TOPIC_DEBUGGING 1

	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/
/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	#if defined(TOPIC_DEBUGGING)
	to_world("[src]'s Topic: [href] destined for [hsrc].")

	if(href_list["nano_err"]) //nano throwing errors
		to_world("## NanoUI, Subject [src]: " + html_decode(href_list["nano_err")]) //NANO DEBUG HOOK

	#endif

	//search the href for script injection
	if( findtext(href,"<script",1,0) )
		world.log << "Attempted use of scripts within a topic call, by [src]"
		message_admins("Attempted use of scripts within a topic call, by [src]")
		//del(usr)
		return

	//Admin PM
	if(href_list["priv_msg"])
		var/client/C = locate(href_list["priv_msg"])
		var/datum/ticket/ticket = locate(href_list["ticket"])
		if(ismob(C)) 		//Old stuff can feed-in mobs instead of clients
			var/mob/M = C
			C = M.client
		cmd_admin_pm(C, null, ticket)
		return

	if(href_list["irc_msg"])
		if(!holder && received_irc_pm < world.time - 6000) //Worse they can do is spam IRC for 10 minutes
			to_chat(usr, "<span class='warning'>You are no longer able to use this, it's been more then 10 minutes since an admin on IRC has responded to you</span>")
			return
		if(mute_irc)
			to_chat(usr, "<span class='warning'You cannot use this as your client has been muted from sending messages to the admins on IRC</span>")
			return
		cmd_admin_irc_pm(href_list["irc_msg"])
		return

	if(href_list["close_ticket"])
		var/datum/ticket/ticket = locate(href_list["close_ticket"])

		if(isnull(ticket))
			return

		ticket.close(client_repository.get_lite_client(usr.client))

	//Logs all hrefs
	if(config && config.log_hrefs && href_logfile)
		href_logfile << "<small>[time2text(world.timeofday,"hh:mm")] [src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]<br>"

	switch(href_list["_src_"])
		if("holder")	hsrc = holder
		if("usr")		hsrc = mob
		if("prefs")		return prefs.process_link(usr,href_list)
		if("vars")		return view_var_Topic(href,href_list,hsrc)
		if("chat")		return chatOutput.Topic(href, href_list)

	switch(href_list["action"])
		if("openLink")
			send_link(src, href_list["link"])
	..()	//redirect to hsrc.Topic()

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		to_chat(src, "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>")
		return 0
/*	//Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>")
		return 0
	fileaccess_timer = world.time + FTPDELAY	*/
	return 1


// here because it's similar to below

// Returns null if no DB connection can be established, or -1 if the requested key was not found in the database

/proc/get_player_age(key)
	establish_db_connection()
	if(!dbcon.IsConnected())
		if(config.hard_saving)
			var/player_mob = get_mob_by_key(key)
			return hard_save_player_age(player_mob)
		else
			return null

	var/sql_ckey = sql_sanitize_text(ckey(key))

	var/DBQuery/query = dbcon.NewQuery("SELECT datediff(Now(),firstseen) as age FROM erro_player WHERE ckey = '[sql_ckey]'")
	query.Execute()

	if(query.NextRow())
		return text2num(query.item[1])
	else
		return -1


/proc/hard_save_player_age(mob/M)
	if(!M || !M.client || !M.client.prefs)
		return 0

	var/age = 0

	age = text2num(Days_Difference(M.client.prefs.first_seen, M.client.prefs.last_seen))

	return age

/client/proc/get_byond_age()
	return text2num(Days_Difference(byond_join_date, full_real_time() ))


/client/proc/log_client_to_db()
	if ( IsGuestKey(src.key) )
		return

	if(config.hard_saving)
		player_age = hard_save_player_age(mob)

	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/sql_ckey = sql_sanitize_text(src.ckey)

	var/DBQuery/query = dbcon.NewQuery("SELECT id, datediff(Now(),firstseen) as age FROM erro_player WHERE ckey = '[sql_ckey]'")
	query.Execute()
	var/sql_id = 0
	player_age = 0	// New players won't have an entry so knowing we have a connection we set this to zero to be updated if their is a record.
	while(query.NextRow())
		sql_id = query.item[1]
		player_age = text2num(query.item[2])
		break

	var/DBQuery/query_ip = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE ip = '[address]'")
	query_ip.Execute()
	related_accounts_ip = ""
	while(query_ip.NextRow())
		related_accounts_ip += "[query_ip.item[1]], "
		break

	var/DBQuery/query_cid = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE computerid = '[computer_id]'")
	query_cid.Execute()
	related_accounts_cid = ""
	while(query_cid.NextRow())
		related_accounts_cid += "[query_cid.item[1]], "
		break

	//Just the standard check to see if it's actually a number
	if(sql_id)
		if(istext(sql_id))
			sql_id = text2num(sql_id)
		if(!isnum(sql_id))
			return

	var/admin_rank = "Player"
	if(src.holder)
		admin_rank = src.holder.rank

	var/sql_ip = sql_sanitize_text(src.address)
	var/sql_computerid = sql_sanitize_text(src.computer_id)
	var/sql_admin_rank = sql_sanitize_text(admin_rank)

	if(sql_id)
		//Player already identified previously, we need to just update the 'lastseen', 'ip' and 'computer_id' variables
		var/DBQuery/query_update = dbcon.NewQuery("UPDATE erro_player SET lastseen = Now(), ip = '[sql_ip]', computerid = '[sql_computerid]', lastadminrank = '[sql_admin_rank]' WHERE id = [sql_id]")
		query_update.Execute()
	else
		//New player!! Need to insert all the stuff
		var/DBQuery/query_insert = dbcon.NewQuery("INSERT INTO erro_player (id, ckey, firstseen, lastseen, ip, computerid, lastadminrank) VALUES (null, '[sql_ckey]', Now(), Now(), '[sql_ip]', '[sql_computerid]', '[sql_admin_rank]')")
		query_insert.Execute()

	//Logging player access
	var/serverip = "[world.internet_address]:[world.port]"
	var/DBQuery/query_accesslog = dbcon.NewQuery("INSERT INTO `erro_connection_log`(`id`,`datetime`,`serverip`,`ckey`,`ip`,`computerid`) VALUES(null,Now(),'[serverip]','[sql_ckey]','[sql_ip]','[sql_computerid]');")
	query_accesslog.Execute()

#undef UPLOAD_LIMIT

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration=3000)
	if(inactivity > duration)	return inactivity
	return 0

//gets byond age
/client/proc/findJoinDate()
	var/list/http = world.Export("http://byond.com/members/[ckey]?format=text")
	if(!http)
		log_world("Failed to connect to byond member page to age check [ckey]")
		return
	var/F = file2text(http["CONTENT"])
	if(F)
		var/regex/R = regex("joined = \"(\\d{4}-\\d{2}-\\d{2})\"")
		if(R.Find(F))
			var/new_date = R.group[1]

			//get year
			var/year = "[copytext(new_date, 1,5)]"
			var/month = "[copytext(new_date, 6,8)]"
			var/day = "[copytext(new_date, 9)]"

			return "[day]/[month]/[year]"
		else
			CRASH("Age check regex failed for [src.ckey]")

// Byond seemingly calls stat, each tick.
// Calling things each tick can get expensive real quick.
// So we slow this down a little.
// See: http://www.byond.com/docs/ref/info.html#/client/proc/Stat
/client/Stat()
	. = ..()
	if (holder)
		sleep(1)
	else
		sleep(5)
		stoplag()

/client/proc/last_activity_seconds()
	return inactivity / 10

//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_resources()

	getFiles(
		'html/search.js',
		'html/panels.css',
		'html/images/loading.gif',
		'html/images/ntlogo.png',
		'html/images/sglogo.png',
		'html/images/talisman.png',
		'html/images/paper_bg.png',
		// 'icons/pda_icons/pda_atmos.png',
		// 'icons/pda_icons/pda_back.png',
		// 'icons/pda_icons/pda_bell.png',
		// 'icons/pda_icons/pda_blank.png',
		// 'icons/pda_icons/pda_boom.png',
		// 'icons/pda_icons/pda_bucket.png',
		'html/images/no_image32.png',
		// 'icons/pda_icons/pda_crate.png',
		// 'icons/pda_icons/pda_cuffs.png',
		// 'icons/pda_icons/pda_eject.png',
		// 'icons/pda_icons/pda_exit.png',
		// 'icons/pda_icons/pda_flashlight.png',
		// 'icons/pda_icons/pda_honk.png',
		// 'icons/pda_icons/pda_mail.png',
		// 'icons/pda_icons/pda_medical.png',
		// 'icons/pda_icons/pda_menu.png',
		// 'icons/pda_icons/pda_mule.png',
		// 'icons/pda_icons/pda_notes.png',
		// 'icons/pda_icons/pda_power.png',
		// 'icons/pda_icons/pda_rdoor.png',
		// 'icons/pda_icons/pda_reagent.png',
		// 'icons/pda_icons/pda_refresh.png',
		// 'icons/pda_icons/pda_scanner.png',
		// 'icons/pda_icons/pda_signaler.png',
		// 'icons/pda_icons/pda_status.png',
		// 'icons/spideros_icons/sos_1.png',
		// 'icons/spideros_icons/sos_2.png',
		// 'icons/spideros_icons/sos_3.png',
		// 'icons/spideros_icons/sos_4.png',
		// 'icons/spideros_icons/sos_5.png',
		// 'icons/spideros_icons/sos_6.png',
		// 'icons/spideros_icons/sos_7.png',
		// 'icons/spideros_icons/sos_8.png',
		// 'icons/spideros_icons/sos_9.png',
		// 'icons/spideros_icons/sos_10.png',
		// 'icons/spideros_icons/sos_11.png',
		// 'icons/spideros_icons/sos_12.png',
		// 'icons/spideros_icons/sos_13.png',
		// 'icons/spideros_icons/sos_14.png',
		'websites/website_images/ntoogle_logo.png',
		'websites/website_images/ntoogle_search.png',
		'websites/website_images/seized.png',
		'sound/manhattan/metro.ogg',
		'sound/manhattan/office1.ogg',
		'sound/manhattan/salvatore.ogg',
		'sound/manhattan/north/north1.ogg',
		'sound/manhattan/north/north3.ogg',
		'sound/manhattan/north/north5.ogg',
		'sound/manhattan/north/north6.ogg',
		'sound/manhattan/north/north7.ogg',
		'sound/manhattan/north/north8.ogg',
		'sound/manhattan/trading_center/trading_center1.ogg',
		'sound/manhattan/trading_center/trading_center2.ogg',
		'sound/manhattan/trading_center/trading_center3.ogg',
		'sound/manhattan/trading_center/trading_center4.ogg',
		)

	spawn (10) // removing this spawn causes all clients to not get verbs.
		if(!src) // client disconnected
			return

		var/list/priority_assets = list()
		var/list/other_assets = list()

		for(var/type in subtypesof(/datum/asset))
			get_asset_datum(type)

		for(var/asset_type in asset_datums)
			var/datum/asset/simple/D = asset_datums[asset_type]
			priority_assets += D

		for(var/datum/asset/D in (priority_assets + other_assets))
			if (!D.send_slow(src)) // Precache the client with all other assets slowly, so as to not block other browse() calls
				return

/mob/proc/MayRespawn()
	return 0


/client/proc/MayRespawn()
	if(mob)
		return mob.MayRespawn()

	// Something went wrong, client is usually kicked or transfered to a new mob at this point
	return 0


/*
client/verb/character_setup()
	set name = "Character Setup"
	set category = "Preferences"
	if(prefs)
		prefs.ShowChoices(usr)
*/

/client/proc/can_harm_ssds()
	if(!config.ssd_protect)
		return 1
	if(bypass_ssd_guard)
		return 1
	if(mob && (mob.job in security_positions))
		return 1
	if(mob && (mob.job in medical_positions))
		return 1
	if(check_rights(R_ADMIN, 0, mob))
		return 1
	return 0

//This is for getipintel.net.
//You're welcome to replace this proc with your own that does your own cool stuff.
//Just set the client's ip_reputation var and make sure it makes sense with your config settings (higher numbers are worse results)
/client/proc/update_ip_reputation()
	var/request = "http://check.getipintel.net/check.php?ip=[address]&contact=[config.ipr_email]"
	var/http[] = world.Export(request)

	/* Debug
	world.log << "Requested this: [request]"
	for(var/entry in http)
		world.log << "[entry] : [http[entry]]"
	*/

	if(!http || !islist(http)) //If we couldn't check, the service might be down, fail-safe.
		log_admin("Couldn't connect to getipintel.net to check [address] for [key]")
		return FALSE

	//429 is rate limit exceeded
	if(text2num(http["STATUS"]) == 429)
		log_adminwarn("getipintel.net reports HTTP status 429. IP reputation checking is now disabled. If you see this, let a developer know.")
		config.ip_reputation = FALSE
		return FALSE

	var/content = file2text(http["CONTENT"]) //world.Export actually returns a file object in CONTENT
	var/score = text2num(content)
	if(isnull(score))
		return FALSE

	//Error handling
	if(score < 0)
		var/fatal = TRUE
		var/ipr_error = "getipintel.net IP reputation check error while checking [address] for [key]: "
		switch(score)
			if(-1)
				ipr_error += "No input provided"
			if(-2)
				fatal = FALSE
				ipr_error += "Invalid IP provided"
			if(-3)
				fatal = FALSE
				ipr_error += "Unroutable/private IP (spoofing?)"
			if(-4)
				fatal = FALSE
				ipr_error += "Unable to reach database"
			if(-5)
				ipr_error += "Our IP is banned or otherwise forbidden"
			if(-6)
				ipr_error += "Missing contact info"

		log_adminwarn(ipr_error)
		if(fatal)
			config.ip_reputation = FALSE
			log_adminwarn("With this error, IP reputation checking is disabled for this shift. Let a developer know.")
		return FALSE

	//Went fine
	else
		ip_reputation = score
		return TRUE

/client/proc/update_chat_position(use_alternative)
	var/input_height = 0
	var/mode = GLOB.PREF_NO // TODO: Make alternative command input field.
	var/currently_alternative = (winget(src, "input", "is-default") == "false") ? TRUE : FALSE

	// Hell
	if(mode == GLOB.PREF_YES && !currently_alternative)
		input_height = winget(src, "input", "size")
		input_height = text2num(splittext(input_height, "x")[2])

		winset(src, "input_alt", "is-visible=true;is-disabled=false;is-default=true")
		winset(src, "hotkey_toggle_alt", "is-visible=true;is-disabled=false;is-default=true")
		winset(src, "saybutton_alt", "is-visible=true;is-disabled=false;is-default=true")

		winset(src, "input", "is-visible=false;is-disabled=true;is-default=false")
		winset(src, "hotkey_toggle", "is-visible=false;is-disabled=true;is-default=false")
		winset(src, "saybutton", "is-visible=false;is-disabled=true;is-default=false")

		var/current_size = splittext(winget(src, "outputwindow.output", "size"), "x")
		var/new_size = "[current_size[1]]x[text2num(current_size[2]) - input_height]"
		winset(src, "outputwindow.output", "size=[new_size]")
		winset(src, "outputwindow.browseroutput", "size=[new_size]")

		current_size = splittext(winget(src, "mainwindow.mainvsplit", "size"), "x")
		new_size = "[current_size[1]]x[text2num(current_size[2]) + input_height]"
		winset(src, "mainwindow.mainvsplit", "size=[new_size]")
	else if(mode == GLOB.PREF_NO && currently_alternative)
		input_height = winget(src, "input_alt", "size")
		input_height = text2num(splittext(input_height, "x")[2])

		winset(src, "input_alt", "is-visible=false;is-disabled=true;is-default=false")
		winset(src, "hotkey_toggle_alt", "is-visible=false;is-disabled=true;is-default=false")
		winset(src, "saybutton_alt", "is-visible=false;is-disabled=true;is-default=false")

		winset(src, "input", "is-visible=true;is-disabled=false;is-default=true")
		winset(src, "hotkey_toggle", "is-visible=true;is-disabled=false;is-default=true")
		winset(src, "saybutton", "is-visible=true;is-disabled=false;is-default=true")

		var/current_size = splittext(winget(src, "outputwindow.output", "size"), "x")
		var/new_size = "[current_size[1]]x[text2num(current_size[2]) + input_height]"
		winset(src, "outputwindow.output", "size=[new_size]")
		winset(src, "outputwindow.browseroutput", "size=[new_size]")

		current_size = splittext(winget(src, "mainwindow.mainvsplit", "size"), "x")
		new_size = "[current_size[1]]x[text2num(current_size[2]) - input_height]"
		winset(src, "mainwindow.mainvsplit", "size=[new_size]")

/client/verb/toggle_fullscreen()
	set name = "Toggle Fullscreen"
	set category = "OOC"

	return

	fullscreen = !fullscreen

	if (fullscreen)
		winset(src, "mainwindow", "titlebar=false")
		winset(src, "mainwindow", "can-resize=false")
		winset(src, "mainwindow", "is-maximized=false")
		winset(src, "mainwindow", "is-maximized=true")
		winset(src, "mainwindow", "statusbar=false")
		winset(src, "mainwindow", "menu=")
//		winset(usr, "mainwindow.mainvsplit", "size=0x0")
	else
		winset(src, "mainwindow", "is-maximized=false")
		winset(src, "mainwindow", "titlebar=true")
		winset(src, "mainwindow", "can-resize=true")
		winset(src, "mainwindow", "statusbar=true")
		winset(src, "mainwindow", "menu=menu")

	fit_viewport()

/client/verb/fit_viewport()
	set name = "Fit Viewport"
	set category = "OOC"
	set desc = "Fit the width of the map window to match the viewport"

	// Fetch aspect ratio
	var/view_size = getviewsize(view)
	var/aspect_ratio = view_size[1] / view_size[2]

	// Calculate desired pixel width using window size and aspect ratio
	var/sizes = params2list(winget(src, "mainwindow.mainvsplit;mapwindow", "size"))
	var/map_size = splittext(sizes["mapwindow.size"], "x")
	var/height = text2num(map_size[2])
	var/desired_width = round(height * aspect_ratio)
	if (text2num(map_size[1]) == desired_width)
		// Nothing to do
		return

	var/split_size = splittext(sizes["mainwindow.mainvsplit.size"], "x")
	var/split_width = text2num(split_size[1])

	// Avoid auto-resizing the statpanel and chat into nothing.
	desired_width = min(desired_width, split_width - 300)

	// Calculate and apply a best estimate
	// +4 pixels are for the width of the splitter's handle
	var/pct = 100 * (desired_width + 4) / split_width
	winset(src, "mainwindow.mainvsplit", "splitter=[pct]")

	// Apply an ever-lowering offset until we finish or fail
	var/delta
	for(var/safety in 1 to 10)
		var/after_size = winget(src, "mapwindow", "size")
		map_size = splittext(after_size, "x")
		var/got_width = text2num(map_size[1])

		if (got_width == desired_width)
			// success
			return
		else if (isnull(delta))
			// calculate a probable delta value based on the difference
			delta = 100 * (desired_width - got_width) / split_width
		else if ((delta > 0 && got_width > desired_width) || (delta < 0 && got_width < desired_width))
			// if we overshot, halve the delta and reverse direction
			delta = -delta/2

		pct += delta
		winset(src, "mainwindow.mainvsplit", "splitter=[pct]")
