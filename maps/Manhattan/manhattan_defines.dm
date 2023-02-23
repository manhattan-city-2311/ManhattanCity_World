#define Z_LEVEL_FIRST_MANHATTAN						1
#define Z_LEVEL_SECOND_MANHATTAN					2
#define Z_LEVEL_THIRD_MANHATTAN						3
#define Z_LEVEL_FOURTH_MANHATTAN					4

/datum/map/new_manhattan
	name = "Manhattan"
	full_name = "New-Manhattan City"
	path = "manhattan"

	lobby_screens = list('icons/lobby.gif')

	zlevel_datum_type = /datum/map_z_level/new_manhattan

//�������� ��� �� �� ������ ����������:

	station_name  = "New-Manhattan City"
	station_short = "Manhattan"
	dock_name     = "Manhattan Airbus"
	boss_name     = "Central Polluxian Government"
	boss_short    = "Pollux Gov"
	company_name  = "Nanotrasen"
	company_short = "NT"
	starsys_name  = "Vetra"

	shuttle_docked_message = "The scheduled air shuttle to the %dock_name% has arrived far east of the city. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Civilian Transfer shuttle has left. Estimate %ETA% until the airbus docks at %dock_name%."
	shuttle_called_message = "A civilian transfer to %Dock_name% has been scheduled. The airbus has been called. Those leaving should procede to the far east side of the city by %ETA%"
	shuttle_recall_message = "The scheduled civilian transfer has been cancelled."
	emergency_shuttle_docked_message = "The Emergency Evacuation Shuttle has arrived at the far east side of the city. You have approximately %ETD% to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The Emergency Shuttle has left the city. Estimate %ETA% until the shuttle docks at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive at the east side of the city in approximately %ETA%"
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."

	allowed_spawns = list(DEFAULT_SPAWNPOINT_NAME, "Cryogenic Storage", "Prison")

//	planet_datums_to_make = list(/datum/planet/pollux)

	usable_email_tlds = list("freemail.net", "solnet.org")
	default_law_type = /datum/ai_laws/pollux

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_DEFAULT,
							NETWORK_MEDICAL,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_SECURITY,
							)

	council_email = "city-council@geminus.nt"

	forced_holomap_zlevel = Z_LEVEL_SECOND_MANHATTAN
	// holomap_offset_x

//� ����� �� ��� ������ ��� �����?:

/*/datum/map/new_manhattan/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_FIRST_GEMINUS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_FIRST_GEMINUS, world.maxx, world.maxy)         // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system(null, 1, 1, Z_LEVEL_FIRST_GEMINUS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_FIRST_GEMINUS, world.maxx, world.maxy)         // Create the mining ore distribution map.

	return 1*/
/datum/map_z_level/new_manhattan
	holomap_offset_y = 96
	holomap_offset_x = -5

	holomap_legend_y = 150
	holomap_legend_x = 0


/datum/map_z_level/new_manhattan/first
	z = Z_LEVEL_FIRST_MANHATTAN
	name = "Underground Sewers"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	transit_chance = 50
	base_turf = /turf/simulated/floor/plating
//	holomap_legend_x = 220
//	holomap_legend_y = 200

/datum/map_z_level/new_manhattan/second
	z = Z_LEVEL_SECOND_MANHATTAN
	name = "Manhattan City first floor"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	transit_chance = 50
	base_turf = /turf/simulated/floor/outdoors/dirt
//	holomap_offset_x = 220
//	holomap_offset_y = GEMINUS_HOLOMAP_MARGIN_Y + GEMINUS_MAP_SIZE*1


/datum/map_z_level/new_manhattan/third
	z = Z_LEVEL_THIRD_MANHATTAN
	name = "Manhattan City second floor"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	transit_chance = 50
	base_turf = /turf/simulated/floor/outdoors/dirt
//	holomap_offset_x = GEMINUS_HOLOMAP_MARGIN_X - 40
//	holomap_offset_y = GEMINUS_HOLOMAP_MARGIN_Y + GEMINUS_MAP_SIZE*0

/datum/map_z_level/new_manhattan/fourth
	z = Z_LEVEL_FOURTH_MANHATTAN
	name = "Sky"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	transit_chance = 50
	base_turf = /turf/simulated/floor/outdoors/dirt

/datum/planet/pollux
	expected_z_levels = list(
		Z_LEVEL_SECOND_MANHATTAN,
		Z_LEVEL_THIRD_MANHATTAN,
		Z_LEVEL_FOURTH_MANHATTAN,
	)

//�������� �� ���� �������� ������:

/datum/map/manhattan/get_map_info()
	. = list()
	. +=  "[full_name] is a very well-known metropolitan city in Blue Colony located on the planet Pollux.<br>"
	. +=  "Pollux exists in the Vetra star system which is entirely monopolized by NanoTrasen acting as a quasi-corporate government."
	. +=  "Being one of the first cities and initially a mining colony, Geminus has a rich history and is home to many descendants of the first prospectors.<br> "
	. +=  "There's a definite class struggle, as working class Geminians feel pushed out by the richer colonists who wish to further gentrify the city and make it... <i>more profitable, more corporate, more <b>chic</b></i>."
	return jointext(., "<br>")