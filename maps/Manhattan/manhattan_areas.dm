#define HOLOMAP_AREACOLOR_SFP "#44aaaa99"
#define HOLOMAP_AREACOLOR_COMERCIAL "#749ea8aa"
#define HOLOMAP_AREACOLOR_BUILDING_FLATS "#00cc33aa"
#define HOLOMAP_AREACOLOR_BUILDING_FLATS_ELITE "#ffaa00aa"
#define HOLOMAP_AREACOLOR_BUILDING_OFFICE "#aaccffaa"
#define HOLOMAP_AREACOLOR_BUILDING_SOUTH "#882200aa"
#define HOLOMAP_AREACOLOR_BUILDING_SOCIAL "#749ea8aa"
#define HOLOMAP_AREACOLOR_TEOTR "#0e810099"
#define HOLOMAP_AREACOLOR_CIVILIAN "#00aa1199"
#define HOLOMAP_AREACOLOR_RUINS "#5b5b5baa"


//shuttle areas
/area/shuttle
	dynamic_lighting = 1 //OH BOY

/area/shuttle/trade/station
	dynamic_lighting = 1 //OH BOY

/area/shuttle/arrival/pre_game
	icon_state = "shuttle2"
	base_turf = /turf/simulated/sky

/area/syndicate_station/
	dynamic_lighting = 1

//city areas

/area
	name = "\improper Planet"
	icon_state = "planet"
	has_gravity = 1
	power_equip = 1
	power_light = 1
	power_environ = 1
	flags = RAD_SHIELDED
	base_turf = /turf/simulated/floor/outdoors/dirt

/area/planets
	name = "\improper Planet"
	icon_state = "planet"

/area/planets/Manhattan
	name = "\improper New-Manhattan"
	icon_state = "Holodeck"

/area/planets/Manhattan/outdoor
	name = "\improper New-Manhattan area(North)"
	dynamic_lighting = 1
	sound_env = CITY
	flags = null
	outdoors = TRUE
	forced_ambience = list(
		'sound/manhattan/north/north1.ogg',
		'sound/manhattan/north/north3.ogg',
		'sound/manhattan/north/north5.ogg',
		'sound/manhattan/north/north6.ogg',
		'sound/manhattan/north/north7.ogg',
		'sound/manhattan/north/north8.ogg'
	)
	should_objects_be_saved = FALSE

/area/planets/Manhattan/indoor
	name = "\improper New-Manhattan Interior(North)"
	icon_state = "yellow"
	dynamic_lighting = 1
	flags = RAD_SHIELDED
	base_turf = /turf/simulated/floor/plating
	luminosity = 0

/area/planets/Manhattan/indoor/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/outdoor/upper1
	name = "\improper New-Manhattan second level outdoors(North)"
	base_turf = /turf/simulated/open

/area/planets/Manhattan/outdoor/upper2
	name = "\improper New-Manhattan third level outdoors(North)"
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/substation
	name = "\improper GAS station power substation(North)"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/planets/Manhattan/indoor/north/underground_global
	name = "\improper New-Manhattan underground(North)"

/area/planets/Manhattan/indoor/north/underground_global/sewer
	name = "\improper New-Manhattan north sewers"
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/underground_global/sewer/hideout
	name = "\improper Hideout in sewers(North)"

/area/planets/Manhattan/indoor/north/bar
	holomap_color = HOLOMAP_AREACOLOR_COMERCIAL
	forced_ambience = list(
	'sound/manhattan/salvatore.ogg'
	)

/area/planets/Manhattan/indoor/north/bar/entrance
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/bar/underground_storage
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/bar/entrance/upper
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/bar/other1
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/bar/other1/upper
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/bar/other2
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/bar/other3
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/bar/other2/upper
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/bar/other3/upper
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/bar/bathroom
	icon_state = "north_m3"

/area/planets/Manhattan/indoor/north/bar/pub1
	name = "\improper Bar Clients Zone(North)"
	icon_state = "north_m2"

/area/planets/Manhattan/indoor/north/bar/pub2
	name = "\improper Bar Clients Zone(North-Upper)"
	base_turf = /turf/simulated/open
	icon_state = "north_m2"

/area/planets/Manhattan/indoor/north/bar/vip_zone
	name = "\improper Bar VIP Zone(North-Upper)"
	base_turf = /turf/simulated/open
	icon_state = "north_m4"
	outdoors = TRUE

/area/planets/Manhattan/indoor/north/gas
	holomap_color = HOLOMAP_AREACOLOR_COMERCIAL

/area/planets/Manhattan/indoor/north/gas/store
	name = "\improper GAS Station Store(North)"
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/gas/other
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/gas/storage
	icon_state = "north_m4"

/area/planets/Manhattan/indoor/north/gas/cabinet
	icon_state = "north_m2"

/area/planets/Manhattan/indoor/north/gas/rest_room
	icon_state = "north_m3"

/area/planets/Manhattan/indoor/north/gas/bathroom
	icon_state = "north_m3"

/area/planets/Manhattan/indoor/north/cityhall
	name = "\improper City Hall(North)"
	base_turf = /turf/simulated/floor/plating
	icon_state = "north_m4"
	holomap_color = "#ffff00aa"
	forced_ambience = list(
	'sound/manhattan/office1.ogg'
	) //add variations and other room ambients i.e. courtroom & offices

/area/planets/Manhattan/indoor/north/cityhall/office1
/area/planets/Manhattan/indoor/north/cityhall/office2
/area/planets/Manhattan/indoor/north/cityhall/archive
/area/planets/Manhattan/indoor/north/cityhall/courtroom
/area/planets/Manhattan/indoor/north/cityhall/courtroomwaiting

/area/planets/Manhattan/indoor/north/cityhall/upper
	name = "\improper City Hall(North-Upper)"
	base_turf = /turf/simulated/open
	icon_state = "north_m4"

/area/planets/Manhattan/indoor/north/cityhall/upper/headslounge
/area/planets/Manhattan/indoor/north/cityhall/upper/restroom
/area/planets/Manhattan/indoor/north/cityhall/upper/briefing
/area/planets/Manhattan/indoor/north/cityhall/upper/mayoroffice
/area/planets/Manhattan/indoor/north/cityhall/upper/solgov
/area/planets/Manhattan/indoor/north/cityhall/upper/gcc
/area/planets/Manhattan/indoor/north/cityhall/upper/stairs1
/area/planets/Manhattan/indoor/north/cityhall/upper/stairs2
/area/planets/Manhattan/indoor/north/cityhall/upper/stairs3
/area/planets/Manhattan/indoor/north/cityhall/upper/lawyeroffice
/area/planets/Manhattan/indoor/north/cityhall/upper/judgeassistantoffice
/area/planets/Manhattan/indoor/north/cityhall/upper/scene
/area/planets/Manhattan/indoor/north/cityhall/upper/sceneback
/area/planets/Manhattan/indoor/north/cityhall/upper/hall
/area/planets/Manhattan/indoor/north/cityhall/upper/license1
/area/planets/Manhattan/indoor/north/cityhall/upper/license2
/area/planets/Manhattan/indoor/north/cityhall/upper/hallway
/area/planets/Manhattan/indoor/north/cityhall/upper/janitor
/area/planets/Manhattan/indoor/north/cityhall/upper/garage
/area/planets/Manhattan/indoor/north/cityhall/upper/secoffice

/area/planets/Manhattan/indoor/north/cray
	name = "\improper CRAY Ind. Headquarters(North)"
	base_turf = /turf/simulated/floor/plating
	icon_state = "north_m2"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/planets/Manhattan/indoor/north/cray/toilet
/area/planets/Manhattan/indoor/north/cray/breakroom
/area/planets/Manhattan/indoor/north/cray/cafeteria
/area/planets/Manhattan/indoor/north/cray/garage

/area/planets/Manhattan/indoor/north/cray/chiefsecurity
/area/planets/Manhattan/indoor/north/cray/armory
/area/planets/Manhattan/indoor/north/cray/powerplant
/area/planets/Manhattan/indoor/north/cray/interrogationroom
/area/planets/Manhattan/indoor/north/cray/gym
/area/planets/Manhattan/indoor/north/cray/lockerroom

/area/planets/Manhattan/indoor/north/cray/upper1
	name = "\improper CRAY Ind. Headquarters(North-Upper)"
	base_turf = /turf/simulated/open
	icon_state = "north_m2"

/area/planets/Manhattan/indoor/north/cray/upper1/checkpoint

/area/planets/Manhattan/indoor/north/cray/upper1/hydromain
/area/planets/Manhattan/indoor/north/cray/upper1/hydroillegal
/area/planets/Manhattan/indoor/north/cray/upper1/cabinet1
/area/planets/Manhattan/indoor/north/cray/upper1/cabinet2
/area/planets/Manhattan/indoor/north/cray/upper1/cabinet3
/area/planets/Manhattan/indoor/north/cray/upper1/seniorscicabinet
/area/planets/Manhattan/indoor/north/cray/upper1/rnd
/area/planets/Manhattan/indoor/north/cray/upper1/chemistry

/area/planets/Manhattan/indoor/north/cray/upper1/toilet
/area/planets/Manhattan/indoor/north/cray/upper1/office1
/area/planets/Manhattan/indoor/north/cray/upper1/office2
/area/planets/Manhattan/indoor/north/cray/upper1/seniorbearucabinet
/area/planets/Manhattan/indoor/north/cray/upper1/officecab1
/area/planets/Manhattan/indoor/north/cray/upper1/officecab2
/area/planets/Manhattan/indoor/north/cray/upper1/officecab3
/area/planets/Manhattan/indoor/north/cray/upper1/officecab4
/area/planets/Manhattan/indoor/north/cray/upper1/officecab5
/area/planets/Manhattan/indoor/north/cray/upper1/officecab6

/area/planets/Manhattan/indoor/north/cray/upper2
	name = "\improper CRAY Ind. Headquarters(North-Upper-Second)"
	base_turf = /turf/simulated/open
	icon_state = "north_m2"

/area/planets/Manhattan/indoor/north/cray/upper2/chiefbearucabinet
/area/planets/Manhattan/indoor/north/cray/upper2/chiefscicabinet
/area/planets/Manhattan/indoor/north/cray/upper2/briefingroom
/area/planets/Manhattan/indoor/north/cray/upper2/toilet
/area/planets/Manhattan/indoor/north/cray/upper2/chiefcraycabinet
/area/planets/Manhattan/indoor/north/cray/upper2/chiefcraycabinet/balcony
	forced_ambience = list(
		'sound/manhattan/north/north1.ogg',
		'sound/manhattan/north/north3.ogg',
		'sound/manhattan/north/north5.ogg',
		'sound/manhattan/north/north6.ogg',
		'sound/manhattan/north/north7.ogg',
		'sound/manhattan/north/north8.ogg'
	)
/area/planets/Manhattan/indoor/north/cray/upper2/breakroom

//UNDER CONSTRUCTION

/area/planets/Manhattan/indoor/north/cray/under
	name = "\improper CRAY Ind. Headquarters(North-Under)"
	base_turf = /turf/simulated/floor/plating
	icon_state = "north_m2"

/area/planets/Manhattan/indoor/north/cray/under/archives
/area/planets/Manhattan/indoor/north/cray/under/backrooms
	name = "\improper CRAY Ind. Portal Room(North-Under)"
/area/planets/Manhattan/indoor/north/cray/under/hallway
	name = "\improper CRAY Ind. main hallway"
/area/planets/Manhattan/indoor/north/cray/under/medicaloffice
	name = "\improper CRAY Ind. medical office"
/area/planets/Manhattan/indoor/north/cray/under/personalroom
	name = "\improper CRAY Ind. smoking"
/area/planets/Manhattan/indoor/north/cray/under/toiletblyat
	name = "\improper CRAY Ind. toilrt undermom"
/area/planets/Manhattan/indoor/north/cray/under/checkpointa
	name = "\improper CRAY Ind. checkpoint"
/area/planets/Manhattan/indoor/north/cray/under/checkpointb
	name = "\improper CRAY Ind. checkpoint b"
/area/planets/Manhattan/indoor/north/cray/under/checkpointc
	name = "\improper CRAY Ind. checkpoint c"
/area/planets/Manhattan/indoor/north/cray/under/checkpointd
	name = "\improper CRAY Ind. checkpoint d"
/area/planets/Manhattan/indoor/north/cray/under/checkpointe
	name = "\improper CRAY Ind. checkpoint e"
/area/planets/Manhattan/indoor/north/cray/under/gate
	name = "\improper CRAY Ind. gate"
/area/planets/Manhattan/indoor/north/cray/under/jail
	name = "\improper CRAY Ind. jail"
/area/planets/Manhattan/indoor/north/cray/under/armoryu
	name = "\improper CRAY Ind. armory underground"
/area/planets/Manhattan/indoor/north/cray/under/backrooms/sec
	name = "\improper CRAY Ind. Portal Checkpoint(North-Under)"
/area/planets/Manhattan/indoor/north/cray/under/backrooms/watching
	name = "\improper CRAY Ind. Portal Observation Room(North-Under)"

/area/planets/Manhattan/indoor/north/cray/under/hydro
/area/planets/Manhattan/indoor/north/cray/under/firingrange
/area/planets/Manhattan/indoor/north/cray/under/workshop
/area/planets/Manhattan/indoor/north/cray/under/xenobio
/area/planets/Manhattan/indoor/north/cray/under/bombingrange
/area/planets/Manhattan/indoor/north/cray/under/lockerroom

/area/planets/Manhattan/indoor/north/cray/under/rndmain
/area/planets/Manhattan/indoor/north/cray/under/cyberspace

//UNDER CONSTRUCTION



/area/planets/Manhattan/indoor/north/casino
	base_turf = /turf/simulated/floor/plating
	icon_state = "north_m1"
	holomap_color = HOLOMAP_AREACOLOR_COMERCIAL
	forced_ambience = list(
	'sound/manhattan/casino.ogg'
	)

/area/planets/Manhattan/indoor/north/casino/director
/area/planets/Manhattan/indoor/north/casino/recroom
/area/planets/Manhattan/indoor/north/casino/hall1
/area/planets/Manhattan/indoor/north/casino/hall2
	name = "\improper Casino Playing Hall(North)"
/area/planets/Manhattan/indoor/north/casino/restroom
/area/planets/Manhattan/indoor/north/casino/securitypost
/area/planets/Manhattan/indoor/north/casino/hallway1
/area/planets/Manhattan/indoor/north/casino/stairs1
/area/planets/Manhattan/indoor/north/casino/registration
/area/planets/Manhattan/indoor/north/casino/gamezal1
/area/planets/Manhattan/indoor/north/casino/boss
/area/planets/Manhattan/indoor/north/casino/stairs2
/area/planets/Manhattan/indoor/north/casino/miniboss
/area/planets/Manhattan/indoor/north/casino/vip1
/area/planets/Manhattan/indoor/north/casino/vip2
/area/planets/Manhattan/indoor/north/casino/viphall
/area/planets/Manhattan/indoor/north/casino/vipmini
/area/planets/Manhattan/indoor/north/casino/toilet
/area/planets/Manhattan/indoor/north/casino/hallway2
/area/planets/Manhattan/indoor/north/casino/roof1
/area/planets/Manhattan/indoor/north/casino/heli
/area/planets/Manhattan/indoor/north/casino/penthall1
/area/planets/Manhattan/indoor/north/casino/penthall2
/area/planets/Manhattan/indoor/north/casino/penthall3
/area/planets/Manhattan/indoor/north/casino/penthall4
/area/planets/Manhattan/indoor/north/casino/pentkitchen
/area/planets/Manhattan/indoor/north/casino/pentbedroom
/area/planets/Manhattan/indoor/north/casino/penttoilet1
/area/planets/Manhattan/indoor/north/casino/penttoilet2
/area/planets/Manhattan/indoor/north/casino/pentcinema
/area/planets/Manhattan/indoor/north/casino/pentmeet

/area/planets/Manhattan/indoor/north/casino/under
	base_turf = /turf/simulated/floor/plating
	icon_state = "north_m2"

/area/planets/Manhattan/indoor/north/casino/under/moneystorage
	name = "\improper Casino Money Storage(North-Under)"
/area/planets/Manhattan/indoor/north/casino/under/vault
	name = "\improper Casino Money Storage(North-Under)"

/area/planets/Manhattan/indoor/north/casino/upper
	name = "\improper Casino Playing Hall(North-Upper)"
	base_turf = /turf/simulated/open
	icon_state = "north_m2"

/area/planets/Manhattan/indoor/north/church
	name = "\improper Church(North)"
	base_turf = /turf/simulated/floor/plating
	icon_state = "north_m3"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/planets/Manhattan/indoor/north/church/hall
	name = "\improper Church Hall(North)"
/area/planets/Manhattan/indoor/north/church/restroom
	name = "\improper Church Bathroom(North)"

/area/planets/Manhattan/indoor/north/church/upper
	name = "\improper Church(North-Upper)"
	base_turf = /turf/simulated/open
	icon_state = "north_m3"

/area/planets/Manhattan/indoor/north/church/upper/hall
/area/planets/Manhattan/indoor/north/church/upper/cabinet
	name = "\improper Church Priest Office(North-Upper)"

/area/planets/Manhattan/indoor/north/auto
	base_turf = /turf/simulated/floor/plating
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/auto/store1
	name = "\improper Car Dealership Carshop(North)"
/area/planets/Manhattan/indoor/north/auto/store2
/area/planets/Manhattan/indoor/north/auto/hall
/area/planets/Manhattan/indoor/north/auto/director
/area/planets/Manhattan/indoor/north/auto/recroom

/area/planets/Manhattan/indoor/north/auto/upper
	name = "\improper Car Dealership(North-Upper)"
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/auto/upper/office
/area/planets/Manhattan/indoor/north/auto/upper/restroom
/area/planets/Manhattan/indoor/north/auto/upper/storage
/area/planets/Manhattan/indoor/north/auto/upper/powerplant
	name = "\improper Car Dealership Power Substation(North-Upper)"

/area/planets/Manhattan/indoor/north/cinema
	base_turf = /turf/simulated/floor/plating
	icon_state = "north_m4"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/planets/Manhattan/indoor/north/cinema/room1
/area/planets/Manhattan/indoor/north/cinema/room2
/area/planets/Manhattan/indoor/north/cinema/hall1
	name = "\improper Cinema(North)"
/area/planets/Manhattan/indoor/north/cinema/room3
/area/planets/Manhattan/indoor/north/cinema/room4

/area/planets/Manhattan/indoor/north/cinema/upper
	base_turf = /turf/simulated/open
	icon_state = "north_m4"

/area/planets/Manhattan/indoor/north/cinema/upper/director
/area/planets/Manhattan/indoor/north/cinema/upper/recroom
/area/planets/Manhattan/indoor/north/cinema/upper/lounge
/area/planets/Manhattan/indoor/north/cinema/upper/hall1
	name = "\improper Cinema(North-Upper)"

/area/planets/Manhattan/indoor/north/house_standart1
	name = "\improper Living House #1(North)"
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_BUILDING_FLATS

/area/planets/Manhattan/indoor/north/house_standart1/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/house_standart1/room1
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room1/bathroom
/area/planets/Manhattan/indoor/north/house_standart1/room1/hall
/area/planets/Manhattan/indoor/north/house_standart1/room1/bedroom


/area/planets/Manhattan/indoor/north/house_standart1/room2
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room2/bathroom
/area/planets/Manhattan/indoor/north/house_standart1/room2/hall
/area/planets/Manhattan/indoor/north/house_standart1/room2/bedroom

/area/planets/Manhattan/indoor/north/house_standart1/room3
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room3/bathroom
/area/planets/Manhattan/indoor/north/house_standart1/room3/hall
/area/planets/Manhattan/indoor/north/house_standart1/room3/bedroom

/area/planets/Manhattan/indoor/north/house_standart1/room4
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room4/bathroom
/area/planets/Manhattan/indoor/north/house_standart1/room4/hall
/area/planets/Manhattan/indoor/north/house_standart1/room4/bedroom

/area/planets/Manhattan/indoor/north/house_standart1/room5
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room5/bathroom
/area/planets/Manhattan/indoor/north/house_standart1/room5/hall
/area/planets/Manhattan/indoor/north/house_standart1/room5/bedroom

/area/planets/Manhattan/indoor/north/house_standart1/room6
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room6/bathroom
/area/planets/Manhattan/indoor/north/house_standart1/room6/hall
/area/planets/Manhattan/indoor/north/house_standart1/room6/bedroom

/area/planets/Manhattan/indoor/north/house_standart1/room7
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room7/bathroom
/area/planets/Manhattan/indoor/north/house_standart1/room7/hall
/area/planets/Manhattan/indoor/north/house_standart1/room7/bedroom

/area/planets/Manhattan/indoor/north/house_standart1/room8
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room8/bathroom
/area/planets/Manhattan/indoor/north/house_standart1/room8/hall
/area/planets/Manhattan/indoor/north/house_standart1/room8/bedroom

/area/planets/Manhattan/indoor/north/house_standart1/room9
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room9/bathroom
/area/planets/Manhattan/indoor/north/house_standart1/room9/hall
/area/planets/Manhattan/indoor/north/house_standart1/room9/bedroom

/area/planets/Manhattan/indoor/north/house_standart1/room10
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room10/bathroom
/area/planets/Manhattan/indoor/north/house_standart1/room10/hall
/area/planets/Manhattan/indoor/north/house_standart1/room10/bedroom

/area/planets/Manhattan/indoor/north/house_standart1/room11
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room11/bathroom
/area/planets/Manhattan/indoor/north/house_standart1/room11/hall
/area/planets/Manhattan/indoor/north/house_standart1/room11/bedroom

/area/planets/Manhattan/indoor/north/house_standart1/room12
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room12/bathroom
/area/planets/Manhattan/indoor/north/house_standart1/room12/hall
/area/planets/Manhattan/indoor/north/house_standart1/room12/bedroom

/area/planets/Manhattan/indoor/north/house_standart1/balcony
	icon_state = "north_m3"
	sound_env = CITY
	forced_ambience = list(
	'sound/manhattan/north/north1.ogg',
	'sound/manhattan/north/north3.ogg',
	'sound/manhattan/north/north5.ogg',
	'sound/manhattan/north/north6.ogg',
	'sound/manhattan/north/north7.ogg',
	'sound/manhattan/north/north8.ogg'
	)
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/house_standart1/balcony/one

/area/planets/Manhattan/indoor/north/house_standart1/balcony/two

/area/planets/Manhattan/indoor/north/house_standart1/balcony/three

/area/planets/Manhattan/indoor/north/house_standart1/balcony/four

/area/planets/Manhattan/indoor/north/house_standart2
	name = "\improper Living House #2(North)"
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_BUILDING_FLATS

/area/planets/Manhattan/indoor/north/house_standart2/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/house_standart2/room1
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart2/room1/bathroom
/area/planets/Manhattan/indoor/north/house_standart2/room1/hall
/area/planets/Manhattan/indoor/north/house_standart2/room1/bedroom


/area/planets/Manhattan/indoor/north/house_standart2/room2
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart2/room2/bathroom
/area/planets/Manhattan/indoor/north/house_standart2/room2/hall
/area/planets/Manhattan/indoor/north/house_standart2/room2/bedroom

/area/planets/Manhattan/indoor/north/house_standart2/room3
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart2/room3/bathroom
/area/planets/Manhattan/indoor/north/house_standart2/room3/hall
/area/planets/Manhattan/indoor/north/house_standart2/room3/bedroom

/area/planets/Manhattan/indoor/north/house_standart2/room4
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart2/room4/bathroom
/area/planets/Manhattan/indoor/north/house_standart2/room4/hall
/area/planets/Manhattan/indoor/north/house_standart2/room4/bedroom

/area/planets/Manhattan/indoor/north/house_standart2/room5
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart2/room5/bathroom
/area/planets/Manhattan/indoor/north/house_standart2/room5/hall
/area/planets/Manhattan/indoor/north/house_standart2/room5/bedroom

/area/planets/Manhattan/indoor/north/house_standart2/room6
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart2/room6/bathroom
/area/planets/Manhattan/indoor/north/house_standart2/room6/hall
/area/planets/Manhattan/indoor/north/house_standart2/room6/bedroom

/area/planets/Manhattan/indoor/north/house_standart2/room7
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart2/room7/bathroom
/area/planets/Manhattan/indoor/north/house_standart2/room7/hall
/area/planets/Manhattan/indoor/north/house_standart2/room7/bedroom

/area/planets/Manhattan/indoor/north/house_standart2/room8
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart2/room8/bathroom
/area/planets/Manhattan/indoor/north/house_standart2/room8/hall
/area/planets/Manhattan/indoor/north/house_standart2/room8/bedroom

/area/planets/Manhattan/indoor/north/house_standart2/room9
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart2/room9/bathroom
/area/planets/Manhattan/indoor/north/house_standart2/room9/hall
/area/planets/Manhattan/indoor/north/house_standart2/room9/bedroom

/area/planets/Manhattan/indoor/north/house_standart2/room10
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart2/room10/bathroom
/area/planets/Manhattan/indoor/north/house_standart2/room10/hall
/area/planets/Manhattan/indoor/north/house_standart2/room10/bedroom

/area/planets/Manhattan/indoor/north/house_standart2/room11
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart2/room11/bathroom
/area/planets/Manhattan/indoor/north/house_standart2/room11/hall
/area/planets/Manhattan/indoor/north/house_standart2/room11/bedroom

/area/planets/Manhattan/indoor/north/house_standart2/room12
	base_turf = /turf/simulated/open
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart2/room12/bathroom
/area/planets/Manhattan/indoor/north/house_standart2/room12/hall
/area/planets/Manhattan/indoor/north/house_standart2/room12/bedroom

/area/planets/Manhattan/indoor/north/house_standart2/balcony
	icon_state = "north_m3"
	sound_env = CITY
	forced_ambience = list(
	'sound/manhattan/north/north1.ogg',
	'sound/manhattan/north/north3.ogg',
	'sound/manhattan/north/north5.ogg',
	'sound/manhattan/north/north6.ogg',
	'sound/manhattan/north/north7.ogg',
	'sound/manhattan/north/north8.ogg'
	)
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/house_standart2/balcony/one

/area/planets/Manhattan/indoor/north/house_standart2/balcony/two

/area/planets/Manhattan/indoor/north/house_standart2/balcony/three

/area/planets/Manhattan/indoor/north/house_standart2/balcony/four

/area/planets/Manhattan/indoor/north/house_standart2/balcony/five

/area/planets/Manhattan/indoor/north/house_standart2/balcony/six

/area/planets/Manhattan/indoor/north/house_standart2/balcony/seven

/area/planets/Manhattan/indoor/north/house_standart2/balcony/eight

/area/planets/Manhattan/indoor/north/house_standart3
	name = "\improper Living House #3(North)"
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_BUILDING_FLATS

/area/planets/Manhattan/indoor/north/house_standart3/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/house_standart3/room1
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart3/room1/bathroom
/area/planets/Manhattan/indoor/north/house_standart3/room1/hall
/area/planets/Manhattan/indoor/north/house_standart3/room1/bedroom
/area/planets/Manhattan/indoor/north/house_standart3/room1/kitchen
/area/planets/Manhattan/indoor/north/house_standart3/room1/bedroomkid
/area/planets/Manhattan/indoor/north/house_standart3/room1/storage

/area/planets/Manhattan/indoor/north/house_standart3/room2
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart3/room2/bathroom
/area/planets/Manhattan/indoor/north/house_standart3/room2/hall
/area/planets/Manhattan/indoor/north/house_standart3/room2/bedroom
/area/planets/Manhattan/indoor/north/house_standart3/room2/kitchen
/area/planets/Manhattan/indoor/north/house_standart3/room2/bedroomkid
/area/planets/Manhattan/indoor/north/house_standart3/room2/storage

/area/planets/Manhattan/indoor/north/house_standart3/room3
	icon_state = "north_m1"
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/house_standart3/room3/bathroom
/area/planets/Manhattan/indoor/north/house_standart3/room3/hall
/area/planets/Manhattan/indoor/north/house_standart3/room3/bedroom
/area/planets/Manhattan/indoor/north/house_standart3/room3/kitchen
/area/planets/Manhattan/indoor/north/house_standart3/room3/bedroomkid
/area/planets/Manhattan/indoor/north/house_standart3/room3/storage

/area/planets/Manhattan/indoor/north/house_standart3/room3/balcony
	icon_state = "north_m3"
	sound_env = CITY
	forced_ambience = list(
	'sound/manhattan/north/north1.ogg',
	'sound/manhattan/north/north3.ogg',
	'sound/manhattan/north/north5.ogg',
	'sound/manhattan/north/north6.ogg',
	'sound/manhattan/north/north7.ogg',
	'sound/manhattan/north/north8.ogg'
	)
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/house_standart3/room4
	icon_state = "north_m1"
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/house_standart3/room4/bathroom
/area/planets/Manhattan/indoor/north/house_standart3/room4/hall
/area/planets/Manhattan/indoor/north/house_standart3/room4/bedroom
/area/planets/Manhattan/indoor/north/house_standart3/room4/kitchen
/area/planets/Manhattan/indoor/north/house_standart3/room4/bedroomkid
/area/planets/Manhattan/indoor/north/house_standart3/room4/storage

/area/planets/Manhattan/indoor/north/house_standart3/room5
	icon_state = "north_m1"
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/house_standart3/room5/bathroom
/area/planets/Manhattan/indoor/north/house_standart3/room5/hall
/area/planets/Manhattan/indoor/north/house_standart3/room5/bedroom
/area/planets/Manhattan/indoor/north/house_standart3/room5/kitchen
/area/planets/Manhattan/indoor/north/house_standart3/room5/bedroomkid
/area/planets/Manhattan/indoor/north/house_standart3/room5/storage

/area/planets/Manhattan/indoor/north/house_standart3/room6
	icon_state = "north_m1"
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/house_standart3/room6/bathroom
/area/planets/Manhattan/indoor/north/house_standart3/room6/hall
/area/planets/Manhattan/indoor/north/house_standart3/room6/bedroom
/area/planets/Manhattan/indoor/north/house_standart3/room6/kitchen
/area/planets/Manhattan/indoor/north/house_standart3/room6/bedroomkid
/area/planets/Manhattan/indoor/north/house_standart3/room6/storage

/area/planets/Manhattan/indoor/north/elite1
	icon_state = "north_m3"
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_BUILDING_FLATS_ELITE

/area/planets/Manhattan/indoor/north/elite1/hall
	name = "\improper Mayor House (North)"
/area/planets/Manhattan/indoor/north/elite1/hallway1
/area/planets/Manhattan/indoor/north/elite1/hallway2
/area/planets/Manhattan/indoor/north/elite1/bath
/area/planets/Manhattan/indoor/north/elite1/kitchen
/area/planets/Manhattan/indoor/north/elite1/carpark
/area/planets/Manhattan/indoor/north/elite1/storage
/area/planets/Manhattan/indoor/north/elite1/maidroom
/area/planets/Manhattan/indoor/north/elite1/hall2

/area/planets/Manhattan/indoor/north/elite1/upper
	base_turf = /turf/simulated/open
/area/planets/Manhattan/indoor/north/elite1/upper/hall3
/area/planets/Manhattan/indoor/north/elite1/upper/workroom
/area/planets/Manhattan/indoor/north/elite1/upper/bedroom

/area/planets/Manhattan/indoor/north/elite2
	icon_state = "north_m3"
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_BUILDING_FLATS_ELITE

/area/planets/Manhattan/indoor/north/elite2/hallkitchen
	name = "\improper Elite House #1(North)"
/area/planets/Manhattan/indoor/north/elite2/hallway
/area/planets/Manhattan/indoor/north/elite2/bath
/area/planets/Manhattan/indoor/north/elite2/carpark
/area/planets/Manhattan/indoor/north/elite2/storage
/area/planets/Manhattan/indoor/north/elite2/touchgrass

/area/planets/Manhattan/indoor/north/elite2/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/elite2/upper/hallway2
/area/planets/Manhattan/indoor/north/elite2/upper/workroom
/area/planets/Manhattan/indoor/north/elite2/upper/bedroom


/area/planets/Manhattan/indoor/north/elite3
	icon_state = "north_m3"
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_BUILDING_FLATS_ELITE

/area/planets/Manhattan/indoor/north/elite3/hallkitchen
	name = "\improper Elite House #2(North)"
/area/planets/Manhattan/indoor/north/elite3/hallway
/area/planets/Manhattan/indoor/north/elite3/bath
/area/planets/Manhattan/indoor/north/elite3/carpark
/area/planets/Manhattan/indoor/north/elite3/storage
/area/planets/Manhattan/indoor/north/elite3/touchgrass

/area/planets/Manhattan/indoor/north/elite3/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/elite3/upper/hallway2
/area/planets/Manhattan/indoor/north/elite3/upper/workroom
/area/planets/Manhattan/indoor/north/elite3/upper/bedroom

/area/planets/Manhattan/indoor/north/hotel
	icon_state = "north_m1"
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_BUILDING_FLATS

/area/planets/Manhattan/indoor/north/hotel/hall
	name = "\improper Grand Hotel(North)"
/area/planets/Manhattan/indoor/north/hotel/receprion
/area/planets/Manhattan/indoor/north/hotel/room1
/area/planets/Manhattan/indoor/north/hotel/room1/bath
/area/planets/Manhattan/indoor/north/hotel/room2
/area/planets/Manhattan/indoor/north/hotel/room2/bath
/area/planets/Manhattan/indoor/north/hotel/room3
/area/planets/Manhattan/indoor/north/hotel/room3/bath
/area/planets/Manhattan/indoor/north/hotel/room4
/area/planets/Manhattan/indoor/north/hotel/room4/bath
/area/planets/Manhattan/indoor/north/hotel/kitchen
/area/planets/Manhattan/indoor/north/hotel/cafe

/area/planets/Manhattan/indoor/north/hotel/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/hotel/upper/hall
/area/planets/Manhattan/indoor/north/hotel/upper/washing
/area/planets/Manhattan/indoor/north/hotel/upper/room5
/area/planets/Manhattan/indoor/north/hotel/upper/room5/bath
/area/planets/Manhattan/indoor/north/hotel/upper/room6
/area/planets/Manhattan/indoor/north/hotel/upper/room6/bath
/area/planets/Manhattan/indoor/north/hotel/upper/room7
/area/planets/Manhattan/indoor/north/hotel/upper/room7/bath
/area/planets/Manhattan/indoor/north/hotel/upper/room8
/area/planets/Manhattan/indoor/north/hotel/upper/room8/bath
/area/planets/Manhattan/indoor/north/hotel/upper/room9
/area/planets/Manhattan/indoor/north/hotel/upper/room9/bath
/area/planets/Manhattan/indoor/north/hotel/upper/room9/bedroom
/area/planets/Manhattan/indoor/north/hotel/upper/room11
/area/planets/Manhattan/indoor/north/hotel/upper/room11/bath
/area/planets/Manhattan/indoor/north/hotel/upper/room11/bedroom
/area/planets/Manhattan/indoor/north/hotel/upper/room12
/area/planets/Manhattan/indoor/north/hotel/upper/room12/bath
/area/planets/Manhattan/indoor/north/hotel/upper/room12/bedroom
/area/planets/Manhattan/indoor/north/hotel/upper/room13
/area/planets/Manhattan/indoor/north/hotel/upper/room13/bath
/area/planets/Manhattan/indoor/north/hotel/upper/room13/bedroom

/area/planets/Manhattan/indoor/north/office1
	icon_state = "north_m2"
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_BUILDING_OFFICE

/area/planets/Manhattan/indoor/north/office1/hall
	name = "\improper Empty Office #1(North)"
/area/planets/Manhattan/indoor/north/office1/restroom
/area/planets/Manhattan/indoor/north/office1/cabinet

/area/planets/Manhattan/indoor/north/office1/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/office1/upper/hall
/area/planets/Manhattan/indoor/north/office1/upper/restroom
/area/planets/Manhattan/indoor/north/office1/upper/cabinet
/area/planets/Manhattan/indoor/north/office1/upper/briefing

/area/planets/Manhattan/indoor/north/office2
	icon_state = "north_m2"
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_BUILDING_OFFICE

/area/planets/Manhattan/indoor/north/office2/hall
	name = "\improper Empty Office #2(North)"
/area/planets/Manhattan/indoor/north/office2/restroom
/area/planets/Manhattan/indoor/north/office2/recroom

/area/planets/Manhattan/indoor/north/office2/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/office2/upper/hall1
/area/planets/Manhattan/indoor/north/office2/upper/restroom1
/area/planets/Manhattan/indoor/north/office2/upper/hall2
/area/planets/Manhattan/indoor/north/office2/upper/restroom2
/area/planets/Manhattan/indoor/north/office2/upper/workplace1
/area/planets/Manhattan/indoor/north/office2/upper/workplace2
/area/planets/Manhattan/indoor/north/office2/upper/director1
/area/planets/Manhattan/indoor/north/office2/upper/director2
/area/planets/Manhattan/indoor/north/office2/upper/storage
/area/planets/Manhattan/indoor/north/office2/upper/briefing1
/area/planets/Manhattan/indoor/north/office2/upper/briefing2
/area/planets/Manhattan/indoor/north/office2/upper/cab1
/area/planets/Manhattan/indoor/north/office2/upper/cab2
/area/planets/Manhattan/indoor/north/office2/upper/cab3

/area/planets/Manhattan/indoor/north/police_dept
	forced_ambience = list(
	'sound/ambience/MAIN0C.SAP.ogg',
	'sound/ambience/MAIN05.SAP.ogg'
	)
	icon_state = "north_m3"
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/planets/Manhattan/indoor/north/police_dept/mainhall
	name = "\improper MCPD Department(North)"
/area/planets/Manhattan/indoor/north/police_dept/bullpen
/area/planets/Manhattan/indoor/north/police_dept/westreception
/area/planets/Manhattan/indoor/north/police_dept/westgarage
/area/planets/Manhattan/indoor/north/police_dept/briefing
/area/planets/Manhattan/indoor/north/police_dept/armoryouter
/area/planets/Manhattan/indoor/north/police_dept/armoryinside
/area/planets/Manhattan/indoor/north/police_dept/lockerroom
/area/planets/Manhattan/indoor/north/police_dept/lockershower
/area/planets/Manhattan/indoor/north/police_dept/powerplant
/area/planets/Manhattan/indoor/north/police_dept/eastoffice
/area/planets/Manhattan/indoor/north/police_dept/eastofficechief
/area/planets/Manhattan/indoor/north/police_dept/press
/area/planets/Manhattan/indoor/north/police_dept/restroom
/area/planets/Manhattan/indoor/north/police_dept/eastgarage
/area/planets/Manhattan/indoor/north/police_dept/interrogation
/area/planets/Manhattan/indoor/north/police_dept/interrogationobservation

/area/planets/Manhattan/indoor/north/police_dept/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/police_dept/upper/mainhall
	name = "\improper MCPD Department(North-Upper)"
/area/planets/Manhattan/indoor/north/police_dept/upper/archives
/area/planets/Manhattan/indoor/north/police_dept/upper/restroom
/area/planets/Manhattan/indoor/north/police_dept/upper/detectives
/area/planets/Manhattan/indoor/north/police_dept/upper/recroom
/area/planets/Manhattan/indoor/north/police_dept/upper/pdchiefcabinet
/area/planets/Manhattan/indoor/north/police_dept/upper/eastoffice
/area/planets/Manhattan/indoor/north/police_dept/upper/eastofficechief

/area/planets/Manhattan/indoor/north/police_dept/underground

/area/planets/Manhattan/indoor/north/police_dept/underground/maincells
	name = "\improper MCPD Department(North-Under)"
/area/planets/Manhattan/indoor/north/police_dept/underground/seccheckpoint
/area/planets/Manhattan/indoor/north/police_dept/underground/perma
/area/planets/Manhattan/indoor/north/police_dept/underground/perma/room1
/area/planets/Manhattan/indoor/north/police_dept/underground/perma/room2
/area/planets/Manhattan/indoor/north/police_dept/underground/perma/room3
/area/planets/Manhattan/indoor/north/police_dept/underground/perma/library
/area/planets/Manhattan/indoor/north/police_dept/underground/perma/restroom
/area/planets/Manhattan/indoor/north/police_dept/underground/perma/boxring
/area/planets/Manhattan/indoor/north/police_dept/underground/confiscation
/area/planets/Manhattan/indoor/north/police_dept/underground/firingrange
/area/planets/Manhattan/indoor/north/police_dept/underground/eastgarageunder

/area/planets/Manhattan/indoor/north/hospital
	icon_state = "north_m4"
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/planets/Manhattan/indoor/north/hospital/hall
	name = "\improper W.E.H.S. City Hospital(North)"
/area/planets/Manhattan/indoor/north/hospital/cab1
/area/planets/Manhattan/indoor/north/hospital/cab2
/area/planets/Manhattan/indoor/north/hospital/recroom
/area/planets/Manhattan/indoor/north/hospital/archive
/area/planets/Manhattan/indoor/north/hospital/poweplant
/area/planets/Manhattan/indoor/north/hospital/chamber1
/area/planets/Manhattan/indoor/north/hospital/chamber2
/area/planets/Manhattan/indoor/north/hospital/pharmacy
/area/planets/Manhattan/indoor/north/hospital/lockerroom


/area/planets/Manhattan/indoor/north/hospital/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/hospital/upper/vipchamber1
/area/planets/Manhattan/indoor/north/hospital/upper/vipchamber2
/area/planets/Manhattan/indoor/north/hospital/upper/cab3
/area/planets/Manhattan/indoor/north/hospital/upper/cmocab
/area/planets/Manhattan/indoor/north/hospital/upper/mri
/area/planets/Manhattan/indoor/north/hospital/upper/emergency
/area/planets/Manhattan/indoor/north/hospital/upper/emergency/recroom
/area/planets/Manhattan/indoor/north/hospital/upper/restroom
/area/planets/Manhattan/indoor/north/hospital/upper/shower
/area/planets/Manhattan/indoor/north/hospital/upper/surgical
/area/planets/Manhattan/indoor/north/hospital/upper/surgicalobservation
/area/planets/Manhattan/indoor/north/hospital/upper/storagepills
/area/planets/Manhattan/indoor/north/hospital/upper/hall
	name = "\improper W.E.H.S. City Hospital(North-Upper)"

/area/planets/Manhattan/indoor/north/hospital/underground

/area/planets/Manhattan/indoor/north/hospital/underground/hall
	name = "\improper W.E.H.S. City Hospital(North-Under)"
/area/planets/Manhattan/indoor/north/hospital/underground/morgue
/area/planets/Manhattan/indoor/north/hospital/underground/storagemain
/area/planets/Manhattan/indoor/north/hospital/underground/washroom
/area/planets/Manhattan/indoor/north/hospital/underground/lab
/area/planets/Manhattan/indoor/north/hospital/underground/storagevirus
/area/planets/Manhattan/indoor/north/hospital/underground/blood
/area/planets/Manhattan/indoor/north/hospital/underground/chamber

/area/planets/Manhattan/indoor/north/transit
	name = "\improper Transit Station(North)"
	icon_state = "north_m2"
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS
	forced_ambience = list(
	'sound/manhattan/metro.ogg'
	)

/area/planets/Manhattan/indoor/north/transit/secpost1
/area/planets/Manhattan/indoor/north/transit/secpost2

/area/planets/Manhattan/indoor/north/transit/under
	name = "North Transit Station"
	icon_state = "north_m2"
	base_turf = /turf/simulated/floor/plating

/area/planets/Manhattan/indoor/north/transit/under/engiepost
/area/planets/Manhattan/indoor/north/transit/under/restroom
/area/planets/Manhattan/indoor/north/transit/under/storage
/area/planets/Manhattan/indoor/north/transit/under/cabinet
/area/planets/Manhattan/indoor/north/transit/under/hall

/area/planets/Manhattan/indoor/north/sfp
	icon_state = "north_m1"
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_SFP

/area/planets/Manhattan/indoor/north/sfp/hall
	name = "\improper SFP Office(North)"
/area/planets/Manhattan/indoor/north/sfp/office
	forced_ambience = list(
	'sound/manhattan/office1.ogg'
	) //todo: add variations
/area/planets/Manhattan/indoor/north/sfp/supervisorcab
/area/planets/Manhattan/indoor/north/sfp/garage
/area/planets/Manhattan/indoor/north/sfp/storage
/area/planets/Manhattan/indoor/north/sfp/powerplant
/area/planets/Manhattan/indoor/north/sfp/upper
	icon_state = "north_m2"
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/sfp/upper/archive
/area/planets/Manhattan/indoor/north/sfp/upper/restroom
/area/planets/Manhattan/indoor/north/sfp/upper/investigator
/area/planets/Manhattan/indoor/north/sfp/upper/hall
/area/planets/Manhattan/indoor/north/sfp/upper/interrogationobservation
/area/planets/Manhattan/indoor/north/sfp/upper/interrogation
/area/planets/Manhattan/indoor/north/sfp/upper/hall2
/area/planets/Manhattan/indoor/north/sfp/upper/lockerroom
/area/planets/Manhattan/indoor/north/sfp/upper/evidencelocker

/area/planets/Manhattan/indoor/north/shopping
	name = "\improper City Mall(North)"
	icon_state = "north_m1"
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_COMERCIAL
	forced_ambience = list(
	'sound/manhattan/trading_center/trading_center1.ogg',
	'sound/manhattan/trading_center/trading_center2.ogg',
	'sound/manhattan/trading_center/trading_center3.ogg',
	'sound/manhattan/trading_center/trading_center4.ogg'
	)

/area/planets/Manhattan/indoor/north/shopping/Ashan
/area/planets/Manhattan/indoor/north/shopping/Hall1
/area/planets/Manhattan/indoor/north/shopping/Barber
/area/planets/Manhattan/indoor/north/shopping/Asia
/area/planets/Manhattan/indoor/north/shopping/gym
/area/planets/Manhattan/indoor/north/shopping/toiler
/area/planets/Manhattan/indoor/north/shopping/hall2
/area/planets/Manhattan/indoor/north/shopping/security
/area/planets/Manhattan/indoor/north/shopping/chillroompersonal
/area/planets/Manhattan/indoor/north/shopping/balcony
/area/planets/Manhattan/indoor/north/shopping/shopodezhda
/area/planets/Manhattan/indoor/north/shopping/tools

/area/planets/Manhattan/indoor/north/shopping/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/indoor/north/shopping/upper/gamecenterhallway
/area/planets/Manhattan/indoor/north/shopping/upper/gamecenter/bar
/area/planets/Manhattan/indoor/north/shopping/upper/gamecenter/arena
/area/planets/Manhattan/indoor/north/shopping/upper/gamecenter/computers
/area/planets/Manhattan/indoor/north/shopping/upper/gamecenter/games
/area/planets/Manhattan/indoor/north/shopping/upper/seccam
/area/planets/Manhattan/indoor/north/shopping/upper/restroom
/area/planets/Manhattan/indoor/north/shopping/upper/storage
/area/planets/Manhattan/indoor/north/shopping/upper/bookstore
/area/planets/Manhattan/indoor/north/shopping/upper/bookstore/upper
/area/planets/Manhattan/indoor/north/shopping/upper/techstore
/area/planets/Manhattan/indoor/north/shopping/upper/bank
/area/planets/Manhattan/indoor/north/shopping/upper/bank/sec
/area/planets/Manhattan/indoor/north/shopping/upper/bank/vault
/area/planets/Manhattan/indoor/north/shopping/upper/bank/archive
/area/planets/Manhattan/indoor/north/shopping/upper/bank/roof

/area/planets/Manhattan/indoor/north/shopping/underground

/area/planets/Manhattan/indoor/north/shopping/underground/gym
/area/planets/Manhattan/indoor/north/shopping/underground/gym/pool
/area/planets/Manhattan/indoor/north/shopping/underground/gym/boxring
/area/planets/Manhattan/indoor/north/shopping/underground/gym/trainer

/*
 		--------S O U T H---------
*/

/area/planets/Manhattan/south
	name = "\improper New-Manhattan South District"
	icon_state = "south_m1"
	dynamic_lighting = 1
	sound_env = CITY
	flags = null
	outdoors = 1
	forced_ambience = list(
		'sound/manhattan/south/Ghetto.ogg',
		'sound/manhattan/south/south_indoors1.ogg',
		'sound/manhattan/south/south_indoors2.ogg',
		'sound/manhattan/south/south_indoors3.ogg',
		'sound/manhattan/south/south_indoors4.ogg',
		'sound/manhattan/south/south_indoors5.ogg',
		'sound/manhattan/south/south_indoors6.ogg',
		'sound/manhattan/south/south_indoors7.ogg',
		'sound/manhattan/south/south_indoors8.ogg'
	)

/area/planets/Manhattan/south/indoor
	name = "\improper New-Manhattan South District Interior"
	icon_state = "south_m1_indoor"
	dynamic_lighting = 1
	flags = RAD_SHIELDED
	outdoors = 0
	base_turf = /turf/simulated/floor/plating

/area/planets/Manhattan/south/indoor/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/south/outdoor/upper1
	name = "\improper New-Manhattan South District second level outdoors"
	base_turf = /turf/simulated/open

/area/planets/Manhattan/south/outdoor/upper2
	name = "\improper New-Manhattan South District third level outdoors"
	base_turf = /turf/simulated/open

/area/planets/Manhattan/south/str
	should_objects_be_saved = FALSE
/area/planets/Manhattan/south/str/chpock
	name = "\improper  South District Chpock Street"
	icon_state = "south_m_chpock"
/area/planets/Manhattan/south/str/helio
	name = "\improper  South District Helio Street"
	icon_state = "south_m_helio"
/area/planets/Manhattan/south/str/chem
	name = "\improper  South District Chem Street"
/area/planets/Manhattan/south/str/dane
	name = "\improper  South District Oui Street"
	icon_state = "south_m_dane"
/area/planets/Manhattan/south/str/sereo
	name = "\improper  South District Sereo Street"
	icon_state = "south_m_stereo"

//BUILDINGS - FLATS

/area/planets/Manhattan/south/building
	name = "\improper Building"
	icon_state = "south_m_build"
	dynamic_lighting = 1
	flags = RAD_SHIELDED
	outdoors = 0
	base_turf = /turf/simulated/floor/plating
	forced_ambience = list(
		'sound/manhattan/south/south_indoors1.ogg',
		'sound/manhattan/south/south_indoors2.ogg',
		'sound/manhattan/south/south_indoors3.ogg',
		'sound/manhattan/south/south_indoors4.ogg',
		'sound/manhattan/south/south_indoors5.ogg',
		'sound/manhattan/south/south_indoors6.ogg',
		'sound/manhattan/south/south_indoors7.ogg',
		'sound/manhattan/south/south_indoors8.ogg'
	)

	holomap_color = HOLOMAP_AREACOLOR_BUILDING_SOUTH

/area/planets/Manhattan/south/building/f1
	icon_state = "south_m_build_flat"
/area/planets/Manhattan/south/building/f1/n1
	name = "\improper Flat 1 N101"
/area/planets/Manhattan/south/building/f1/n2
	name = "\improper Flat 2 N102"
/area/planets/Manhattan/south/building/f1/n3
	name = "\improper Flat 3 N103"
/area/planets/Manhattan/south/building/f1/n4
	name = "\improper Flat 4 N104"
/area/planets/Manhattan/south/building/f1/n5
	name = "\improper Flat 5 N105"
/area/planets/Manhattan/south/building/f1/n6
	name = "\improper Flat 6 N106"

/area/planets/Manhattan/south/building/f2
	icon_state = "south_m_build_flat"
/area/planets/Manhattan/south/building/f2/n1
	name = "\improper Flat 1 N107"
/area/planets/Manhattan/south/building/f2/n2
	name = "\improper Flat 2 N108"
/area/planets/Manhattan/south/building/f2/n3
	name = "\improper Flat 3 N109"
/area/planets/Manhattan/south/building/f2/n4
	name = "\improper Flat 4 N110"
/area/planets/Manhattan/south/building/f2/n5
	name = "\improper Flat 5 N111"
/area/planets/Manhattan/south/building/f2/n6
	name = "\improper Flat 6 N112"

/area/planets/Manhattan/south/building/f3
	icon_state = "south_m_build_flat"
/area/planets/Manhattan/south/building/f3/n1
	name = "\improper Flat 1 N113"
/area/planets/Manhattan/south/building/f3/n2
	name = "\improper Flat 2 N114"
/area/planets/Manhattan/south/building/f3/n3
	name = "\improper Flat 3 N115"
/area/planets/Manhattan/south/building/f3/n4
	name = "\improper Flat 4 N116"
/area/planets/Manhattan/south/building/f3/n5
	name = "\improper Flat 5 N117"
/area/planets/Manhattan/south/building/f3/n6
	name = "\improper Flat 6 N118"

/area/planets/Manhattan/south/building/f4
	icon_state = "south_m_build_flat"
/area/planets/Manhattan/south/building/f4/n1
	name = "\improper Flat 1 N119"
/area/planets/Manhattan/south/building/f4/n2
	name = "\improper Flat 2 N120"
/area/planets/Manhattan/south/building/f4/n3
	name = "\improper Flat 3 N121"
/area/planets/Manhattan/south/building/f4/n4
	name = "\improper Flat 4 N122"
/area/planets/Manhattan/south/building/f4/n5
	name = "\improper Flat 5 N123"
/area/planets/Manhattan/south/building/f4/n6
	name = "\improper Flat 6 N124"

/area/planets/Manhattan/south/building/f5
	icon_state = "south_m_build_flat"
/area/planets/Manhattan/south/building/f5/n1
	name = "\improper Flat 1 N125"
/area/planets/Manhattan/south/building/f5/n2
	name = "\improper Flat 2 N126"
/area/planets/Manhattan/south/building/f5/n3
	name = "\improper Flat 3 N127"
/area/planets/Manhattan/south/building/f5/n4
	name = "\improper Flat 4 N128"
/area/planets/Manhattan/south/building/f5/n5
	name = "\improper Flat 5 N129"
/area/planets/Manhattan/south/building/f5/n6
	name = "\improper Flat 6 N130"
/area/planets/Manhattan/south/building/f5/n7
	name = "\improper Flat 7 N131"
/area/planets/Manhattan/south/building/f5/n8
	name = "\improper Flat 8 N132"
/area/planets/Manhattan/south/building/f5/n9
	name = "\improper Flat 9 N133"
/area/planets/Manhattan/south/building/f5/n10
	name = "\improper Flat 10 N134"
/area/planets/Manhattan/south/building/f5/n11
	name = "\improper Flat 11 N135"
/area/planets/Manhattan/south/building/f5/n12
	name = "\improper Flat 12 N136"
/area/planets/Manhattan/south/building/f6
	icon_state = "south_m_build_flat"
/area/planets/Manhattan/south/building/f6/n1
	name = "\improper Flat 1 N137"
/area/planets/Manhattan/south/building/f6/n2
	name = "\improper Flat 2 N138"
/area/planets/Manhattan/south/building/f6/n3
	name = "\improper Flat 3 N139"
/area/planets/Manhattan/south/building/f6/n4
	name = "\improper Flat 4 N140"
/area/planets/Manhattan/south/building/f6/n5
	name = "\improper Flat 5 N141"
/area/planets/Manhattan/south/building/f6/n6
	name = "\improper Flat 6 N142"
/area/planets/Manhattan/south/building/f7
	icon_state = "south_m_build_flat"
/area/planets/Manhattan/south/building/f7/n1
	name = "\improper Flat 1 N143"
/area/planets/Manhattan/south/building/f7/n2
	name = "\improper Flat 2 N144"
/area/planets/Manhattan/south/building/f7/n3
	name = "\improper Flat 3 N145"
/area/planets/Manhattan/south/building/f7/n4
	name = "\improper Flat 4 N146"
/area/planets/Manhattan/south/building/f7/n5
	name = "\improper Flat 5 N147"
/area/planets/Manhattan/south/building/f7/n6
	name = "\improper Flat 6 N148"
/area/planets/Manhattan/south/building/f8
	icon_state = "south_m_build_flat"
/area/planets/Manhattan/south/building/f8/n1
	name = "\improper Flat 1 N149"
/area/planets/Manhattan/south/building/f8/n2
	name = "\improper Flat 2 N150"
/area/planets/Manhattan/south/building/f8/n3
	name = "\improper Flat 3 N151"
/area/planets/Manhattan/south/building/f8/n4
	name = "\improper Flat 4 N152"
/area/planets/Manhattan/south/building/f8/n5
	name = "\improper Flat 5 N153"
/area/planets/Manhattan/south/building/f8/n6
	name = "\improper Flat 6 N154"
/area/planets/Manhattan/south/building/f8/n7
	name = "\improper Flat 7 N155"

/area/planets/Manhattan/south/building/ruin
	name = "\improper Building Ruins"
	icon_state = "south_m_ruin"
	holomap_color = HOLOMAP_AREACOLOR_RUINS

/area/planets/Manhattan/south/building/ruin/upper
	name = "\improper Building Ruins"
	base_turf = /turf/simulated/open
/area/planets/Manhattan/south/building/ruin/r1
	name = "\improper Building Ruin"
/area/planets/Manhattan/south/building/ruin/r2
	name = "\improper Building Room Two"
/area/planets/Manhattan/south/building/ruin/r3
	name = "\improper Building Room Three"
/area/planets/Manhattan/south/building/ruin/r4
	name = "\improper Building Room Four"
/area/planets/Manhattan/south/building/ruin/r5
/area/planets/Manhattan/south/building/ruin/r6
/area/planets/Manhattan/south/building/ruin/r7
/area/planets/Manhattan/south/building/ruin/r8
/area/planets/Manhattan/south/building/ruin/r9
/area/planets/Manhattan/south/building/ruin/r10
/area/planets/Manhattan/south/building/ruin/r11
/area/planets/Manhattan/south/building/ruin/r12
/area/planets/Manhattan/south/building/ruin/r13
/area/planets/Manhattan/south/building/ruin/r14
/area/planets/Manhattan/south/building/ruin/r15
/area/planets/Manhattan/south/building/ruin/r16
/area/planets/Manhattan/south/building/ruin/r17
/area/planets/Manhattan/south/building/ruin/r18
/area/planets/Manhattan/south/building/ruin/r19
/area/planets/Manhattan/south/building/ruin/r20
/area/planets/Manhattan/south/building/ruin/r21
/area/planets/Manhattan/south/building/ruin/r22
/area/planets/Manhattan/south/building/ruin/r23


/area/planets/Manhattan/south/building/shophome
	name = "\improper Shop Flats"
/area/planets/Manhattan/south/building/shophome/h1
	name = "\improper Flat 1 N201"
/area/planets/Manhattan/south/building/shophome/h2
	name = "\improper Flat 2 N202"

/area/planets/Manhattan/south/building/chem_str
	name = "\improper Chem Street"
/area/planets/Manhattan/south/building/chem_str/tower
	name = "\improper Chem Street Tower"
/area/planets/Manhattan/south/building/chem_str/garage
	name = "\improper Chem Street Garage N101"
/area/planets/Manhattan/south/building/chem_str/garage/two
	name = "\improper Chem Street Garage N102"
/area/planets/Manhattan/south/building/chem_str/garage/three
	name = "\improper Chem Street Garage N103"
/area/planets/Manhattan/south/building/chem_str/office
	name = "\improper Chem Street Office"
	icon_state = "south_m_chem_office"
	forced_ambience = list(
	'sound/manhattan/office1.ogg'
	)
/area/planets/Manhattan/south/building/chem_str/hallway
	name = "\improper Chem Street Hallway"
	icon_state = "south_m_chem_hall"
/area/planets/Manhattan/south/building/chem_str/mess
	name = "\improper Chem Street Mess Hall"
	icon_state = "south_m_chem_mess"
/area/planets/Manhattan/south/building/chem_str/parking
	name = "\improper Chem Street Parking"
/area/planets/Manhattan/south/building/chem_str/lab
	name = "\improper Chem Street Laboratory"
/area/planets/Manhattan/south/building/chem_str/dorms
	name = "\improper Chem Street Dorms"
	icon_state = "south_m_chem_dorm"
/area/planets/Manhattan/south/building/chem_str/dorms/flats
	name = "\improper Chem Street Flats"
	icon_state = "south_m_chem_flats"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f1
	name = "\improper Chem Street Flat 1"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f2
	name = "\improper Chem Street Flat 2"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f3
	name = "\improper Chem Street Flat 3"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f4
	name = "\improper Chem Street Flat 4"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f5
	name = "\improper Chem Street Flat 5"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f6
	name = "\improper Chem Street Flat 6"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f7
	name = "\improper Chem Street Flat 7"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f8
	name = "\improper Chem Street Flat 8"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f9
	name = "\improper Chem Street Flat 9"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f10
	name = "\improper Chem Street Flat 10"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f11
	name = "\improper Chem Street Flat 11"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f12
	name = "\improper Chem Street Flat 12"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f13
	name = "\improper Chem Street Flat 13"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f14
	name = "\improper Chem Street Flat 14"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f15
	name = "\improper Chem Street Flat 15"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f16
	name = "\improper Chem Street Flat 16"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f17
	name = "\improper Chem Street Flat 17"
/area/planets/Manhattan/south/building/chem_str/dorms/flats/f18
	name = "\improper Chem Street Flat 18"

/area/planets/Manhattan/south/building/chem_str/dorms/upper
	name = "\improper Chem Street Dorms 2nd Floor"
	base_turf = /turf/simulated/open
/area/planets/Manhattan/south/building/chem_str/bridge
	name = "\improper Chem Street Bridges"
	icon_state = "south_m_chem_bridge"
	outdoors = 1
/area/planets/Manhattan/south/building/chem_str/office/upper
	name = "\improper Chem Street 2nd Floor Office"
	forced_ambience = list(
	'sound/manhattan/office1.ogg'
	)
/area/planets/Manhattan/south/building/chem_str/under
	name = "\improper Chem Street Underground"
/area/planets/Manhattan/south/building/chem_str/storage
	name = "\improper Chem Street Storage"
/area/planets/Manhattan/south/building/chem_str/inter
	name = "\improper Chem Street Interrogation"
/area/planets/Manhattan/south/building/chem_str/upper
	name = "\improper Chem Street 2nd Floor"
	base_turf = /turf/simulated/open

/area/planets/Manhattan/south/building/garage
	name = "\improper GARAGE FUCK YEAH"
	icon_state = "south_m_garage"
/area/planets/Manhattan/south/building/garage/g1
	name = "\improper Garage 1"
/area/planets/Manhattan/south/building/garage/g2
	name = "\improper Garage 2"
/area/planets/Manhattan/south/building/garage/g3
	name = "\improper Garage 3"
/area/planets/Manhattan/south/building/garage/g4
	name = "\improper Garage 4"
/area/planets/Manhattan/south/building/garage/g5
	name = "\improper Garage 5"
/area/planets/Manhattan/south/building/garage/g6
	name = "\improper Garage 6"
/area/planets/Manhattan/south/building/garage/g7
	name = "\improper Garage 7"
/area/planets/Manhattan/south/building/garage/g8
	name = "\improper Garage 8"
/area/planets/Manhattan/south/building/garage/g8/upper
	name = "\improper Garage 8 Upper"
	base_turf = /turf/simulated/open
/area/planets/Manhattan/south/building/garage/g9
	name = "\improper Garage 9"
/area/planets/Manhattan/south/building/garage/g9/upper
	name = "\improper Garage 9 Upper"
	base_turf = /turf/simulated/open
/area/planets/Manhattan/south/building/garage/g10
	name = "\improper Garage 10"

/area/planets/Manhattan/south/building/tcomms_tower
	name = "\improper telecomms Tower"
	icon_state = "server"

/area/planets/Manhattan/south/building/motel
	name = "\improper Motel"
	icon_state = "south_m_motel"
/area/planets/Manhattan/south/building/motel/office
	name = "\improper Motel Office"
/area/planets/Manhattan/south/building/motel/rooms
	name = "\improper Motel Rooms"
/area/planets/Manhattan/south/building/motel/shop
	name = "\improper Motel Shop"

//FACTORY

/area/planets/Manhattan/south/factory
	name = "\improper South District Factory"
	icon_state = "south_m_factory"
	dynamic_lighting = 1
	flags = RAD_SHIELDED
	outdoors = 1
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/planets/Manhattan/south/factory/upper
	outdoors = 0
	base_turf = /turf/simulated/open

/area/planets/Manhattan/south/factory/roof
	name = "\improper Factory Roof"
	base_turf = /turf/simulated/open

/area/planets/Manhattan/south/factory/maintenance
	name = "\improper Factory Maintenance"
	icon_state = "south_m_factory_m"
	outdoors = 0

/area/planets/Manhattan/south/factory/maintenance/janitor
	name = "\improper Janitorial Closet"

/area/planets/Manhattan/south/factory/office
	name = "\improper Factory Office Hallway"
	icon_state = "south_m_factory_o"
	outdoors = 0

/area/planets/Manhattan/south/factory/office/a
	name = "\improper Factory Office A"

/area/planets/Manhattan/south/factory/office/b
	name = "\improper Factory Office B"

/area/planets/Manhattan/south/factory/office/c
	name = "\improper Factory Office C"

/area/planets/Manhattan/south/factory/office/d
	name = "\improper Factory Office D"

/area/planets/Manhattan/south/factory/office/storage
	name = "\improper Factory Office Storage"

/area/planets/Manhattan/south/factory/office/director
	name = "\improper General Director Office"

/area/planets/Manhattan/south/factory/office/director/room
	name = "\improper General Director Backroom"

/area/planets/Manhattan/south/factory/office/ce
	base_turf = /turf/simulated/open
	name = "\improper Chief Engineer Office"

/area/planets/Manhattan/south/factory/office/ce/room
	name = "\improper Chief Engineer Backroom"

/area/planets/Manhattan/south/factory/office/qm
	base_turf = /turf/simulated/open
	name = "\improper Quartermaster Office"

/area/planets/Manhattan/south/factory/office/qm/room
	name = "\improper Quartermaster Backroom"

/area/planets/Manhattan/south/factory/office/pmchead
	name = "\improper PMC Head Office"

/area/planets/Manhattan/south/factory/pmc
	name = "\improper PMC Wing"
	icon_state = "south_m_factory_s"
	outdoors = 0

/area/planets/Manhattan/south/factory/pmc/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/south/factory/pmc/armory
	base_turf = /turf/simulated/open
	name = "\improper PMC Armory"

/area/planets/Manhattan/south/factory/pmc/brig
	base_turf = /turf/simulated/open
	name = "\improper PMC Brig"

/area/planets/Manhattan/south/factory/pmc/forensics
	name = "\improper PMC Forensics"

/area/planets/Manhattan/south/factory/pmc/gate
	name = "\improper Factory Main Gate"

/area/planets/Manhattan/south/factory/pmc/gate/control
	name = "\improper Factory Gate Control"

/area/planets/Manhattan/south/factory/pmc/interrogation
	name = "\improper PMC Interrogation"

/area/planets/Manhattan/south/factory/pmc/checkpoint
	name = "\improper PMC Checkpoint A"

/area/planets/Manhattan/south/factory/pmc/checkpoint/b
	base_turf = /turf/simulated/open
	name = "\improper PMC Checkpoint B"

/area/planets/Manhattan/south/factory/pmc/checkpoint/c
	name = "\improper PMC Checkpoint C"

/area/planets/Manhattan/south/factory/hallway
	name = "\improper Factory Hallway"
	outdoors = 0

/area/planets/Manhattan/south/factory/hallway/second_floor
	name = "\improper Factory 2th Floor Hallway"
	base_turf = /turf/simulated/open

/area/planets/Manhattan/south/factory/hallway/mess
	name = "\improper Factory Mess Hall"

/area/planets/Manhattan/south/factory/cargo
	name = "\improper Factory Cargo Wing"
	icon_state = "south_m_factory_c"
	outdoors = 0
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/planets/Manhattan/south/factory/cargo/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/south/factory/cargo/storage
	name = "\improper Cargo Storage"

/area/planets/Manhattan/south/factory/cargo/storage/second
	name = "\improper Cargo Second Storage"

/area/planets/Manhattan/south/factory/cargo/storage/thirt
	name = "\improper Cargo Thirt Storage"

/area/planets/Manhattan/south/factory/cargo/breakroom
	base_turf = /turf/simulated/open
	name = "\improper Cargo Break Room"

/area/planets/Manhattan/south/factory/cargo/meeting
	base_turf = /turf/simulated/open
	name = "\improper Cargo Meeting Room"

/area/planets/Manhattan/south/factory/cargo/equipment
	base_turf = /turf/simulated/open
	name = "\improper Cargo Equipment"

/area/planets/Manhattan/south/factory/cargo/mining
	name = "\improper Mining"

/area/planets/Manhattan/south/factory/cargo/mining/equip
	name = "\improper Mining equipment"

/area/planets/Manhattan/south/factory/engineering
	name = "\improper Engineering"
	icon_state = "south_m_factory_e"
	outdoors = 0

/area/planets/Manhattan/south/factory/engineering/lobby
	name = "\improper Engineering Lobby"

/area/planets/Manhattan/south/factory/engineering/construction
	base_turf = /turf/simulated/open
	name = "\improper Engineering Construction Site"

/area/planets/Manhattan/south/factory/engineering/exosuit
	name = "\improper Engineering Exosuit Fabrication"

/area/planets/Manhattan/south/factory/engineering/breakroom
	base_turf = /turf/simulated/open
	name = "\improper Engineering Break Room"

/area/planets/Manhattan/south/factory/engineering/breakroom/b
	name = "\improper Engineering Observatory"

/area/planets/Manhattan/south/factory/engineering/equipment
	name = "\improper Engineering Equipment"

/area/planets/Manhattan/south/factory/engineering/hangar
	name = "\improper Delivery Hangar"
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/planets/Manhattan/south/factory/engineering/hangar/upper
	base_turf = /turf/simulated/open

/area/planets/Manhattan/south/factory/engineering/meeting
	name = "\improper Engineering Meeting Room"

/area/planets/Manhattan/south/factory/engineering/storage
	name = "\improper Engineering Storage"

/area/planets/Manhattan/south/factory/engineering/storage/b
	name = "\improper Engineering Second Storage"

/area/planets/Manhattan/south/factory/engineering/reactor
	name = "\improper Engineering Reactor"

// BUIDINGS - SOCIAL

/area/planets/Manhattan/south/building/social
	name = "\improper Unoccupied building"
	icon_state = "south_m_build"
	holomap_color = HOLOMAP_AREACOLOR_COMERCIAL

/area/planets/Manhattan/south/building/social/teotr
	name = "\improper Bar 'TEoTR'"
	icon_state = "south_m_teotr"
	holomap_color = HOLOMAP_AREACOLOR_TEOTR
/area/planets/Manhattan/south/building/social/teotr/office
	name = "\improper 'TEoTR' Office"
	base_turf = /turf/simulated/open
/area/planets/Manhattan/south/building/social/teotr/kitchen
	name = "\improper 'TEoTR' Kitchen"
/area/planets/Manhattan/south/building/social/teotr/breakroom
	name = "\improper 'TEoTR' Breakroom"
	base_turf = /turf/simulated/open
/area/planets/Manhattan/south/building/social/teotr/netsurfer
	name = "\improper 'TEoTR' Computer Office"
	base_turf = /turf/simulated/open
/area/planets/Manhattan/south/building/social/teotr/upper
	name = "\improper 'TEoTR' Upper Floor"
	base_turf = /turf/simulated/open
/area/planets/Manhattan/south/building/social/teotr/scene
	name = "\improper 'TEoTR' Scene"

/area/planets/Manhattan/south/building/social/restaurant
	name = "\improper Restaurant '3xi'"
	icon_state = "south_m_resta"
/area/planets/Manhattan/south/building/social/restaurant/kitchen
	name = "\improper Restaurant '3xi' Kitchen"
/area/planets/Manhattan/south/building/social/restaurant/office
	name = "\improper Restaurant '3xi' Office"
/area/planets/Manhattan/south/building/social/restaurant/upper
	name = "\improper Restaurant '3xi' Upper"
	base_turf = /turf/simulated/open

/area/planets/Manhattan/south/building/social/retail
	name = "\improper Store 'Echpochmak'"
/area/planets/Manhattan/south/building/social/retail/back

/area/planets/Manhattan/south/building/social/cafe_oui
	name = "\improper Cafe 'Oui'"
/area/planets/Manhattan/south/building/social/cafe_oui/back
	name = "\improper Cafe 'Oui' Backroom"

/area/planets/Manhattan/south/building/social/atelier
	name = "\improper Atelier"
	icon_state = "south_m_atelier"
/area/planets/Manhattan/south/building/social/atelier/back
	name = "\improper Atelier Backroom"
/area/planets/Manhattan/south/building/social/atelier/bath
	name = "\improper Atelier Toilet"
/area/planets/Manhattan/south/building/social/atelier/storage
	name = "\improper Atelier Storage"
/area/planets/Manhattan/south/building/social/atelier/hall
/area/planets/Manhattan/south/building/social/atelier/room1
/area/planets/Manhattan/south/building/social/atelier/room2
/area/planets/Manhattan/south/building/social/atelier/room3
/area/planets/Manhattan/south/building/social/atelier/fabric

/area/planets/Manhattan/south/building/social/gas
	name = "\improper South GAS Station"
	icon_state = "south_m_gas"

/area/planets/Manhattan/south/building/social/brothel
	name = "\improper Brothel Lobby"
	icon_state = "south_m_brothel"

/area/planets/Manhattan/south/building/social/brothel/hallway
	name = "\improper Brothel Hallway"
/area/planets/Manhattan/south/building/social/brothel/office
	name = "\improper Brothel Office"
/area/planets/Manhattan/south/building/social/brothel/pub
	name = "\improper Brothel Pub"
/area/planets/Manhattan/south/building/social/brothel/dress
	name = "\improper Brothel Dressing Room"
	base_turf = /turf/simulated/open
/area/planets/Manhattan/south/building/social/brothel/hallway/upper
	name = "\improper Brothel Lobby"
	base_turf = /turf/simulated/open
/area/planets/Manhattan/south/building/social/brothel/roof
	name = "\improper Brothel Roof"
	base_turf = /turf/simulated/open
/area/planets/Manhattan/south/building/social/brothel/room
	name = "\improper Brothel Room 1"
	base_turf = /turf/simulated/open
/area/planets/Manhattan/south/building/social/brothel/room/r2
	name = "\improper Brothel Room 2"
/area/planets/Manhattan/south/building/social/brothel/room/r3
	name = "\improper Brothel Room 3"
/area/planets/Manhattan/south/building/social/brothel/room/r4
	name = "\improper Brothel Room 4"
/area/planets/Manhattan/south/building/social/brothel/room/r5
	name = "\improper Brothel Room 5"
/area/planets/Manhattan/south/building/social/brothel/room/r6
	name = "\improper Brothel Room 6"

/area/planets/Manhattan/south/building/social/laundry
	name = "\improper South Laundry"
	icon_state = "south_m_laundry"

/area/planets/Manhattan/south/building/social/alleys
	name = "\improper South Alleys"
	icon_state = "south_m_alley"
/area/planets/Manhattan/south/building/social/alleys/uppe2
	name = "\improper South Alleys 2nd Floor"
	base_turf = /turf/simulated/open
/area/planets/Manhattan/south/building/social/alleys/upper3
	name = "\improper South Alleys 3nd Floor"
	base_turf = /turf/simulated/open
/area/planets/Manhattan/south/building/social/alleys/uppe2/room
	name = "\improper South Alleys Ancient Room"
/area/planets/Manhattan/south/building/social/alleys/uppe2/room2
	name = "\improper South Alleys Second Ancient Room"

/area/planets/Manhattan/south/building/social/metro
	name = "\improper South Transit Station"
	icon_state = "south_m_metro"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS
	forced_ambience = list(
	'sound/manhattan/metro.ogg'
	)

/area/planets/Manhattan/south/building/social/motodealer
	name = "\improper South Motorcycle dealership dealer"
	icon_state = "south_m_dealer"
/area/planets/Manhattan/south/building/social/motodealer/upper
	name = "\improper South Motorcycle dealership dealer 2nd Floor"
/area/planets/Manhattan/south/building/social/church
	name = "\improper South Ancient Church"
	icon_state = "south_m_church"
/area/planets/Manhattan/south/building/social/church/upper
	name = "\improper South Ancient Church 2nd Floor"
/area/planets/Manhattan/south/building/social/library
	name = "\improper South Library"
	icon_state = "south_m_library"
/area/planets/Manhattan/south/building/social/library/secondfloor
	name = "\improper South Library 2nd Floor"

/area/planets/Manhattan/south/building/social/gym
	name = "\improper South Gym"
	icon_state = "south_m_gym"
/area/planets/Manhattan/south/building/social/gym/upper
	name = "\improper South Gym 2nd Floor"
/area/planets/Manhattan/south/building/social/gym/ring
	name = "\improper South Gym Box Ring"

// Elevator areas.
/area/turbolift/manhattan_house11
	name = "lift (first floor)"
	lift_floor_label = "Floor 1"
	lift_floor_name = "First floor"
	lift_announce_str = "Lift arriving at first floor, please stand clear of the doors."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/manhattan_house12
	name = "lift (second floor)"
	lift_floor_label = "Floor 2"
	lift_floor_name = "Second floor"
	lift_announce_str = "Lift arriving at second floor, please stand clear of the doors."
	base_turf = /turf/simulated/open

/area/turbolift/manhattan_house13
	name = "lift (third floor)"
	lift_floor_label = "Floor 3"
	lift_floor_name = "Third floor"
	lift_announce_str = "Lift arriving at third floor, please stand clear of the doors."
	base_turf = /turf/simulated/open

/area/turbolift/manhattan_house21
	name = "lift (first floor)"
	lift_floor_label = "Floor 1"
	lift_floor_name = "First floor"
	lift_announce_str = "Lift arriving at first floor, please stand clear of the doors."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/manhattan_house22
	name = "lift (second floor)"
	lift_floor_label = "Floor 2"
	lift_floor_name = "Second floor"
	lift_announce_str = "Lift arriving at second floor, please stand clear of the doors."
	base_turf = /turf/simulated/open

/area/turbolift/manhattan_house23
	name = "lift (third floor)"
	lift_floor_label = "Floor 3"
	lift_floor_name = "Third floor"
	lift_announce_str = "Lift arriving at third floor, please stand clear of the doors."
	base_turf = /turf/simulated/open

/area/turbolift/hospital1
	name = "lift (first floor)"
	lift_floor_label = "Floor 1"
	lift_floor_name = "First floor"
	lift_announce_str = "Lift arriving at first floor, please stand clear of the doors."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/hospital2
	name = "lift (second floor)"
	lift_floor_label = "Floor 2"
	lift_floor_name = "Second floor"
	lift_announce_str = "Lift arriving at second floor, please stand clear of the doors."
	base_turf = /turf/simulated/open

/area/turbolift/crey1
	name = "lift (level zero)"
	lift_floor_label = "Floor 0"
	lift_floor_name = "Level 0"
	lift_announce_str = "Lift arriving at level zero, please stand clear of the doors."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/crey2
	name = "lift (first level)"
	lift_floor_label = "Floor 1"
	lift_floor_name = "Level 1"
	lift_announce_str = "Lift arriving at level one, please stand clear of the doors."
	base_turf = /turf/simulated/open

/area/turbolift/crey3
	name = "lift (second level)"
	lift_floor_label = "Floor 2"
	lift_floor_name = "Level 2"
	lift_announce_str = "Lift arriving at level two, please stand clear of the doors."
	base_turf = /turf/simulated/open

/area/turbolift/crey4
	name = "lift (third level)"
	lift_floor_label = "Floor 3"
	lift_floor_name = "Level 3"
	lift_announce_str = "Lift arriving at level three, please stand clear of the doors."
	base_turf = /turf/simulated/open

/area/turbolift/hospitalm1
	name = "lift (first floor)"
	lift_floor_label = "Floor 1"
	lift_floor_name = "First floor"
	lift_announce_str = "Lift arriving at first floor, please stand clear of the doors."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/hospitalm2
	name = "lift (second floor)"
	lift_floor_label = "Floor 2"
	lift_floor_name = "Second floor"
	lift_announce_str = "Lift arriving at second floor, please stand clear of the doors."
	base_turf = /turf/simulated/open

/area/turbolift/hospitalm3
	name = "lift (third floor)"
	lift_floor_label = "Floor 3"
	lift_floor_name = "Third floor"
	lift_announce_str = "Lift arriving at third floor, please stand clear of the doors."
	base_turf = /turf/simulated/open

/area/turbolift/hotel1
	name = "lift (first floor)"
	lift_floor_label = "Floor 1"
	lift_floor_name = "First floor"
	lift_announce_str = "Lift arriving at first floor, please stand clear of the doors."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/hotel2
	name = "lift (second floor)"
	lift_floor_label = "Floor 2"
	lift_floor_name = "Second floor"
	lift_announce_str = "Lift arriving at second floor, please stand clear of the doors."
	base_turf = /turf/simulated/open

/area/turbolift/hotel3
	name = "lift (third floor)"
	lift_floor_label = "Floor 3"
	lift_floor_name = "Third floor"
	lift_announce_str = "Lift arriving at third floor, please stand clear of the doors."
	base_turf = /turf/simulated/open

/area/turbolift/office11
	name = "lift (first floor)"
	lift_floor_label = "Floor 1"
	lift_floor_name = "First floor"
	lift_announce_str = "Lift arriving at first floor, please stand clear of the doors."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/office12
	name = "lift (second floor)"
	lift_floor_label = "Floor 2"
	lift_floor_name = "Second floor"
	lift_announce_str = "Lift arriving at second floor, please stand clear of the doors."
	base_turf = /turf/simulated/open

/area/turbolift/office13
	name = "lift (third floor)"
	lift_floor_label = "Floor 3"
	lift_floor_name = "Third floor"
	lift_announce_str = "Lift arriving at third floor, please stand clear of the doors."
	base_turf = /turf/simulated/open

/area/turbolift/office21
	name = "lift (first floor)"
	lift_floor_label = "Floor 1"
	lift_floor_name = "First floor"
	lift_announce_str = "Lift arriving at first floor, please stand clear of the doors."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/office22
	name = "lift (second floor)"
	lift_floor_label = "Floor 2"
	lift_floor_name = "Second floor"
	lift_announce_str = "Lift arriving at second floor, please stand clear of the doors."
	base_turf = /turf/simulated/open

/area/turbolift/office23
	name = "lift (third floor)"
	lift_floor_label = "Floor 3"
	lift_floor_name = "Third floor"
	lift_announce_str = "Lift arriving at third floor, please stand clear of the doors."
	base_turf = /turf/simulated/open

/*/area/turbolift/hospital1
	name = "Elevator-1"
	lift_floor_label = "1 этаж"
	lift_floor_name = "Первый этаж"
	lift_announce_str = "Первый этаж: Департамент реанимации, хранилище медикаментов и лобби."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/hospital2
	name = "Elevator-2"
	lift_floor_label = "2 этаж"
	lift_floor_name = "Второй этаж"
	lift_announce_str = "Второй этаж: Операционная, лаборатория, крыло долговременного лечения, приёмная и постоянное хранилище."

/area/turbolift/hospital3
	name = "Elevator-3"
	lift_floor_label = "3 этаж"
	lift_floor_name = "Третий этаж"
	lift_announce_str = "Третий этаж: Офисы, крыло персонала и смотровая операционной."*/

/area/turbolift/factory1
	name = "lift (1 floor)"
	lift_floor_label = "Floor 1"
	lift_floor_name = "First floor"
	lift_announce_str = "Lift arriving at first floor, truck garage."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/factory2
	name = "lift (2 floor)"
	lift_floor_label = "Floor 2"
	lift_floor_name = "Second floor"
	lift_announce_str = "Lift arriving at second floor, truck garage upper floor."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/factory3
	name = "lift (3 floor)"
	lift_floor_label = "Floor 3"
	lift_floor_name = "Third floor"
	lift_announce_str = "Lift arriving at third floor, offices."
	base_turf = /turf/simulated/floor/plating


/area/planets/Manhattan/indoor/mining_lift
	name = "mine shaft lift"

/area/mine
	name = "mine"
	should_objects_be_saved = FALSE
