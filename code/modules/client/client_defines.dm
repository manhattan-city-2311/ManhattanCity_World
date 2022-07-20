/client
		//////////////////////
		//BLACK MAGIC THINGS//
		//////////////////////
	parent_type = /datum
		////////////////
		//ADMIN THINGS//
		////////////////
	var/datum/admins/holder = null
	var/datum/admins/deadmin_holder = null
	var/buildmode		= 0

	var/last_message	= "" //Contains the last message sent by this client - used to protect against copy-paste spamming.
	var/last_message_count = 0 //contins a number of how many times a message identical to last_message was sent.

		/////////
		//OTHER//
		/////////
	var/datum/preferences/prefs = null
//	var/move_delay		= 1
	var/moving			= null
	var/adminobs		= null
	var/area			= null
	var/time_died_as_mouse = null //when the client last died as a mouse
	var/datum/tooltip/tooltips 	= null
	var/seen_news = 0

	var/adminhelped = 0

		///////////////
		//SOUND STUFF//
		///////////////
	var/ambience_playing= null
	var/played			= 0

		////////////
		//SECURITY//
		////////////
	// comment out the line below when debugging locally to enable the options & messages menu
	//control_freak = 1

	var/received_irc_pm = -99999
	var/irc_admin			//IRC admin that spoke with them last.
	var/mute_irc = 0


		////////////////////////////////////
		//things that require the database//
		////////////////////////////////////
	var/player_age = "Requires database"	//So admins know why it isn't working - Used to determine how old the account is - in days.
	var/byond_join_date = null
	var/related_accounts_ip = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this ip
	var/related_accounts_cid = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this computer id

	preload_rsc = PRELOAD_RSC

	var/fullscreen = FALSE

	var/global/obj/screen/click_catcher/void

	// Has the client been granted permission to mess with SSDs by an admin?
	var/bypass_ssd_guard = FALSE

	var/last_ooc_message = ""
	var/last_ping_time = 0 // Stores the last time this cilent pinged someone in OOC, to protect against spamming pings

	var/ip_reputation = 0 //Do we think they're using a proxy/vpn? Only if IP Reputation checking is enabled in config.

	var/lobby_joined = FALSE // Have they already joined as a lobby join antag?

		///////////
		// INPUT //
		///////////

	/// Bitfield of modifier keys (Shift, Ctrl, Alt) held currently.
	var/mod_keys_held = 0
	/// Bitfield of movement keys (WASD/Cursor Keys) held currently.
	var/move_keys_held = 0

	/// These next two vars are to apply movement for keypresses and releases made while move delayed.
	/// Because discarding that input makes the game less responsive.

	/// Bitfield of movement dirs that were pressed down *this* cycle (even if not currently held).
	/// Note that only dirs that actually are first pressed down during this cycle are included, if it was still held from last cycle it won't be in here.
	/// On next move, add this dir to the move that would otherwise be done
	var/next_move_dir_add

	/// Bitfield of movement dirs that were released *this* cycle (even if currently held).
	/// Note that only dirs that were already held at the start of this cycle are included, if it pressed then released it won't be in here.
 	/// On next move, subtract this dir from the move that would otherwise be done
	var/next_move_dir_sub
	#ifdef CARDINAL_INPUT_ONLY

	/// Movement dir of the most recently pressed movement key.  Used in cardinal-only movement mode.
	var/last_move_dir_pressed = NONE

	#endif 
