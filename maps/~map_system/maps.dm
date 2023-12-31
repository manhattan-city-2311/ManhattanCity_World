
var/datum/map/using_map = new USING_MAP_DATUM
var/list/all_maps = list()

/hook/startup/proc/initialise_map_list()
	for(var/type in typesof(/datum/map) - /datum/map)
		var/datum/map/M
		if(type == using_map.type)
			M = using_map
			M.setup_map()
		else
			M = new type
		if(!M.path)
			log_debug("Map '[M]' does not have a defined path, not adding to map list!")
		else
			all_maps[M.path] = M
	return 1


/datum/map
	var/name = "Unnamed Map"
	var/full_name = "Unnamed Map"
	var/path

	var/list/zlevels = list()
	var/zlevel_datum_type			// If populated, all subtypes of this type will be instantiated and used to populate the *_levels lists.

	var/list/station_levels = list() // Z-levels the station exists on
	var/list/admin_levels = list()   // Z-levels for admin functionality (Centcom, shuttle transit, etc)
	var/list/contact_levels = list() // Z-levels that can be contacted from the station, for eg announcements
	var/list/player_levels = list()  // Z-levels a character can typically reach
	var/list/sealed_levels = list()  // Z-levels that don't allow random transit at edge
	var/list/empty_levels = null     // Empty Z-levels that may be used for various things (currently used by bluespace jump)

	var/list/map_levels              // Z-levels available to various consoles, such as the crew monitor (when that gets coded in). Defaults to station_levels if unset.
	var/list/base_turf_by_z = list() // Custom base turf by Z-level. Defaults to world.turf for unlisted Z-levels

	//This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
	var/list/accessible_z_levels = list()

	//List of additional z-levels to load above the existing .dmm file z-levels using the maploader. Must be map template >>> NAMES <<<.
	var/list/lateload_z_levels = list()

	//Similar to above, but only pick ONE to load, useful for random away missions and whatnot
	var/list/lateload_single_pick = list()

	var/list/allowed_jobs = list() //Job datums to use.
	                               //Works a lot better so if we get to a point where three-ish maps are used
	                               //We don't have to C&P ones that are only common between two of them
	                               //That doesn't mean we have to include them with the rest of the jobs though, especially for map specific ones.
	                               //Also including them lets us override already created jobs, letting us keep the datums to a minimum mostly.
	                               //This is probably a lot longer explanation than it needs to be.

	var/station_name  = "BAD Station"
	var/station_short = "Baddy"

	var/list/holomap_smoosh		// List of lists of zlevels to smoosh into single icons
	var/list/holomap_offset_x = list()
	var/list/holomap_offset_y = list()
	var/list/holomap_legend_x = list()
	var/list/holomap_legend_y = list()

	var/dock_name     = "THE PirateBay"
	var/boss_name     = "Captain Roger"
	var/boss_short    = "Cap'"
	var/company_name  = "BadMan"
	var/company_short = "BM"
	var/starsys_name  = "Dull Star"

	var/shuttle_docked_message
	var/shuttle_leaving_dock
	var/shuttle_called_message
	var/shuttle_recall_message
	var/emergency_shuttle_docked_message
	var/emergency_shuttle_leaving_dock
	var/emergency_shuttle_called_message
	var/emergency_shuttle_recall_message

	var/list/station_networks = list() 		// Camera networks that will show up on the console.
	var/list/secondary_networks = list()	// Camera networks that exist, but don't show on regular camera monitors.

	var/allowed_spawns = list("Arrivals Shuttle", "Cryogenic Storage", "Cyborg Storage")

	var/current_lobby_screen = 'icons/misc/title.dmi' // The icon which contains the lobby image(s)
	var/list/lobby_screens = list("mockingjay00")                 // The list of lobby screen to pick() from. If left unset the first icon state is always selected.

	var/default_law_type = /datum/ai_laws/pollux // The default lawset use by synth units, if not overriden by their laws var.

	var/id_hud_icons = 'icons/mob/hud.dmi' // Used by the ID HUD (primarily sechud) overlay.

	// Some maps include areas for that map only and don't exist when not compiled, so Travis needs this to learn of new areas that are specific to a map.
	var/list/unit_test_exempt_areas = list()
	var/list/unit_test_exempt_from_atmos = list()
	var/list/unit_test_exempt_from_apc = list()
	var/list/unit_test_z_levels //To test more than Z1, set your z-levels to test here.

	var/list/usable_email_tlds = list("freemail.net")

	var/president_email = "president@nanotrasen.gov.nt"
	var/vice_email = "vice-president@nanotrasen.gov.nt"
	var/boss_email = "headoffice@nanotrasen.gov.nt"
	var/rep_email = "centralgovernment@nanotrasen.gov.nt"
	var/director_email = "governor@nanotrasen.gov.nt"
	var/investigation_email = "pdsi@nanotrasen.gov.nt"

	var/minister_defense_email = "defense@nanotrasen.gov.nt"
	var/minister_health_email = "health@nanotrasen.gov.nt"
	var/minister_innovation_email = "innovation@nanotrasen.gov.nt"
	var/minister_justice_email = "justice@nanotrasen.gov.nt"
	var/minister_information_email = "information@nanotrasen.gov.nt"
	var/court_email = "courts@nanotrasen.gov.nt"

	var/council_email = "city-council@nanotrasen.gov.nt"
	var/police_email = "police@nanotrasen.gov.nt"

	var/currency_name = CREDIT
	var/currency_name_plural = CREDITS
	var/currency_symbol = SYMBOL_CREDIT
	var/currency_suffix = SHORT_CREDIT

	var/head_department = DEPT_NANOTRASEN	// NOTE: Has to exist in-game as a department account. See: code\modules\economy\departments.dm and input id here.
	var/main_department = DEPT_COLONY

	var/forced_holomap_zlevel = null


/datum/map/New()
	..()
	if(zlevel_datum_type)
		for(var/type in subtypesof(zlevel_datum_type))
			var/datum/map_z_level/Z = new type(src)
			if(!forced_holomap_zlevel && Z.z == forced_holomap_zlevel)
				forced_holomap_zlevel = Z.z
	if(!map_levels)
		map_levels = station_levels.Copy()
	if(!allowed_jobs || !allowed_jobs.len)
		allowed_jobs = subtypesof(/datum/job)

	spawn()
		change_lobbyscreen()

/datum/map/proc/setup_map()
	return

/datum/map/proc/perform_map_generation()
	return

// Getting the department that "owns" the map.
/datum/map/proc/get_head_department()
	return dept_by_id(head_department)

// Getting the department that "runs" the map.
/datum/map/proc/get_main_department()
	return dept_by_id(main_department)


// Used to apply various post-compile procedural effects to the map.
/datum/map/proc/refresh_mining_turfs()

	set background = 1
	set waitfor = 0

	// Update all turfs to ensure everything looks good post-generation. Yes,
	// it's brute-forcey, but frankly the alternative is a mine turf rewrite.
	for(var/turf/simulated/mineral/M in world) // Ugh.
		M.update_icon()

/datum/map/proc/get_network_access(var/network)
	return 0

// By default transition randomly to another zlevel
/datum/map/proc/get_transit_zlevel(var/current_z_level)
	var/list/candidates = using_map.accessible_z_levels.Copy()
	candidates.Remove(num2text(current_z_level))

	if(!candidates.len)
		return current_z_level
	return text2num(pickweight(candidates))

/datum/map/proc/get_empty_zlevel()
	if(empty_levels == null)
		world.maxz++
		empty_levels = list(world.maxz)
	return pick(empty_levels)

// Get the list of zlevels that a computer on srcz can see maps of (for power/crew monitor, cameras, etc)
// The long_range parameter expands the coverage.  Default is to return map_levels for long range otherwise just srcz.
// zLevels outside station_levels will return an empty list.
/datum/map/proc/get_map_levels(var/srcz, var/long_range = TRUE)
	if (long_range && (srcz in map_levels))
		return map_levels
	else if (srcz in station_levels)
		return list(srcz)
	else
		return list()

/datum/map/proc/get_zlevel_name(var/index)
	var/datum/map_z_level/Z = zlevels["[index]"]
	return Z.name

// Another way to setup the map datum that can be convenient.  Just declare all your zlevels as subtypes of a common
// subtype of /datum/map_z_level and set zlevel_datum_type on /datum/map to have the lists auto-initialized.

// Structure to hold zlevel info together in one nice convenient package.
/datum/map_z_level
	var/z = 0				// Actual z-index of the zlevel. This had better be right!
	var/name				// Friendly name of the zlevel
	var/flags = 0			// Bitflag of which *_levels lists this z should be put into.
	var/turf/base_turf		// Type path of the base turf for this z
	var/transit_chance = 0	// Percentile chance this z will be chosen for map-edge space transit.
// Holomaps
	var/holomap_offset_x = -1	// Number of pixels to offset the map right (for centering) for this z
	var/holomap_offset_y = -1	// Number of pixels to offset the map up (for centering) for this z
	var/holomap_legend_x = 96	// x position of the holomap legend for this z
	var/holomap_legend_y = 96	// y position of the holomap legend for this z

// Default constructor applies itself to the parent map datum
/datum/map_z_level/New(var/datum/map/map)
	if(!z) return
	map.zlevels["[z]"] = src
	if(flags & MAP_LEVEL_STATION) map.station_levels += z
	if(flags & MAP_LEVEL_ADMIN) map.admin_levels += z
	if(flags & MAP_LEVEL_CONTACT) map.contact_levels += z
	if(flags & MAP_LEVEL_PLAYER) map.player_levels += z
	if(flags & MAP_LEVEL_SEALED) map.sealed_levels += z
	if(flags & MAP_LEVEL_EMPTY)
		if(!map.empty_levels) map.empty_levels = list()
		map.empty_levels += z
	if(flags & MAP_LEVEL_CONSOLES)
		if (!map.map_levels) map.map_levels = list()
		map.map_levels += z
	if(base_turf)
		map.base_turf_by_z["[z]"] = base_turf
	if(transit_chance)
		map.accessible_z_levels["[z]"] = transit_chance
	// Holomaps
	// Auto-center the map if needed (Guess based on maxx/maxy)
	if (holomap_offset_x < 0)
		holomap_offset_x = ((HOLOMAP_ICON_SIZE - world.maxx) / 2)
	if (holomap_offset_x < 0)
		holomap_offset_y = ((HOLOMAP_ICON_SIZE - world.maxy) / 2)
	// Assign them to the map lists
	LIST_NUMERIC_SET(map.holomap_offset_x, z, holomap_offset_x)
	LIST_NUMERIC_SET(map.holomap_offset_y, z, holomap_offset_y)
	LIST_NUMERIC_SET(map.holomap_legend_x, z, holomap_legend_x)
	LIST_NUMERIC_SET(map.holomap_legend_y, z, holomap_legend_y)

/datum/map_z_level/Destroy(var/force)
	crash_with("Attempt to delete a map_z_level instance [log_info_line(src)]")
	if(!force)
		return QDEL_HINT_LETMELIVE // No.
	if (using_map.zlevels["[z]"] == src)
		using_map.zlevels -= "[z]"
	return ..()

// Access check is of the type requires one. These have been carefully selected to avoid allowing the janitor to see channels he shouldn't
// This list needs to be purged but people insist on adding more cruft to the radio.
/datum/map/proc/default_internal_channels()
	return list(
		num2text(PUB_FREQ)   = list(),
		num2text(AI_FREQ)    = list(access_synth),
		num2text(ENT_FREQ)   = list(),
		num2text(ERT_FREQ)   = list(access_cent_specops),
		num2text(COMM_FREQ)  = list(access_heads),
		num2text(ENG_FREQ)   = list(access_engine_equip, access_atmospherics),
		num2text(MED_FREQ)   = list(access_medical_equip),
		num2text(MED_I_FREQ) = list(access_medical_equip),
		num2text(SEC_FREQ)   = list(access_security),
		num2text(SEC_I_FREQ) = list(access_security),
		num2text(SCI_FREQ)   = list(access_tox,access_robotics,access_xenobiology),
		num2text(SUP_FREQ)   = list(access_cargo),
		num2text(SRV_FREQ)   = list(access_janitor, access_hydroponics),
	)

/datum/map/proc/map_info(var/client/victim)
	to_chat(victim, "<h2>Current map information</h2>")
	to_chat(victim, get_map_info())

/datum/map/proc/get_map_info()
	return "No map information available"

/datum/map/proc/show_titlescreen(client/C)
	winset(C, "lobbybrowser", "is-disabled=false;is-visible=true")

	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/lobby)
	assets.send(C)

	show_browser(C, current_lobby_screen, "file=titlescreen.gif;display=0")

	if(isnewplayer(C.mob))
		var/mob/new_player/player = C.mob
		player.set_viewsize(7)
		show_browser(C, player.get_lobby_html(), "window=lobbybrowser")

/datum/map/proc/hide_titlescreen(client/C)
	if(C.mob) // Check if the client is still connected to something
		// Hide title screen, allowing player to see the map
		winset(C, "lobbybrowser", "is-disabled=true;is-visible=false")
