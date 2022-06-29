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
	requires_power = 0
	flags = RAD_SHIELDED
	base_turf = /turf/simulated/floor/outdoors/dirt

/area/planets
	name = "\improper Planet"
	icon_state = "planet"
//	has_gravity = 1
//	power_equip = 1
//	power_light = 1
//	power_environ = 1
//	requires_power = 0

/area/planets/Manhattan
	name = "\improper New-Manhattan"
	icon_state = "Holodeck"

/area/planets/Manhattan/outdoor
	name = "\improper New-Manhattan area"
	dynamic_lighting = 1
	sound_env = CITY
	flags = null
	ambience = list('sound/manhattan/north1.ogg', 'sound/manhattan/north3.ogg', 'sound/manhattan/north4.ogg', 'sound/manhattan/north5.ogg', 'sound/manhattan/north6.ogg', 'sound/manhattan/north7.ogg', 'sound/manhattan/north8.ogg')

/area/planets/Manhattan/indoor
	name = "\improper New-Manhattan Interior"
	icon_state = "yellow"
	dynamic_lighting = 1
	flags = RAD_SHIELDED

/area/planets/Manhattan/indoor/north/bar

/area/planets/Manhattan/indoor/north/bar/entrance
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/bar/other1
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/bar/other2
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/bar/other3
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/bar/bathroom
	icon_state = "north_m3"

/area/planets/Manhattan/indoor/north/bar/pub1
	icon_state = "north_m2"

/area/planets/Manhattan/indoor/north/bar/pub2
	icon_state = "north_m2"

/area/planets/Manhattan/indoor/north/bar/vip_zone
	icon_state = "north_m4"

/area/planets/Manhattan/indoor/north/gas

/area/planets/Manhattan/indoor/north/gas/store
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

/area/planets/Manhattan/indoor/north/house_standart1/room1
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room2
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room3
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room4
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room5
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room6
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room7
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/room8
	icon_state = "north_m1"

/area/planets/Manhattan/indoor/north/house_standart1/balcony
	icon_state = "north_m3"
	sound_env = CITY
	ambience = list('sound/manhattan/north1.ogg', 'sound/manhattan/north3.ogg', 'sound/manhattan/north4.ogg', 'sound/manhattan/north5.ogg', 'sound/manhattan/north6.ogg', 'sound/manhattan/north7.ogg', 'sound/manhattan/north8.ogg')

/area/planets/Manhattan/indoor/north/house_standart1/balcony/one

/area/planets/Manhattan/indoor/north/house_standart1/balcony/two

/area/planets/Manhattan/indoor/north/house_standart1/balcony/three

/area/planets/Manhattan/indoor/north/house_standart1/balcony/four

/*
 		--------S O U T H---------
*/

/area/planets/Manhattan/south
	name = "\improper New-Manhattan South District"
	icon_state = "south_m1"
	dynamic_lighting = 1
	sound_env = CITY
	flags = null
	ambience = list('sound/manhattan/south1.mp3')

/area/planets/Manhattan/south/indoor
	name = "\improper New-Manhattan South District Interior"
	icon_state = "south_m1_indoor"
	dynamic_lighting = 1
	flags = RAD_SHIELDED

//BUILDINGS - FLATS

/area/planets/Manhattan/south/building
	name = "\improper Building"
	icon_state = "south_m_build"
	dynamic_lighting = 1
	flags = RAD_SHIELDED

/area/planets/Manhattan/south/building/f1
	icon_state = "south_m_build_flat"
/area/planets/Manhattan/south/building/f1/n1
	name = "\improper Flat 1"
/area/planets/Manhattan/south/building/f1/n2
	name = "\improper Flat 2"
/area/planets/Manhattan/south/building/f1/n3
	name = "\improper Flat 3"
/area/planets/Manhattan/south/building/f1/n4
	name = "\improper Flat 4"
/area/planets/Manhattan/south/building/f1/n5
	name = "\improper Flat 5"
/area/planets/Manhattan/south/building/f1/n6
	name = "\improper Flat 6"

/area/planets/Manhattan/south/building/f2
	icon_state = "south_m_build_flat"
/area/planets/Manhattan/south/building/f2/n1
	name = "\improper Flat 1"
/area/planets/Manhattan/south/building/f2/n2
	name = "\improper Flat 2"
/area/planets/Manhattan/south/building/f2/n3
	name = "\improper Flat 3"
/area/planets/Manhattan/south/building/f2/n4
	name = "\improper Flat 4"
/area/planets/Manhattan/south/building/f2/n5
	name = "\improper Flat 5"
/area/planets/Manhattan/south/building/f2/n6
	name = "\improper Flat 6"

/area/planets/Manhattan/south/building/f3
	icon_state = "south_m_build_flat"
/area/planets/Manhattan/south/building/f3/n1
	name = "\improper Flat 1"
/area/planets/Manhattan/south/building/f3/n2
	name = "\improper Flat 2"
/area/planets/Manhattan/south/building/f3/n3
	name = "\improper Flat 3"
/area/planets/Manhattan/south/building/f3/n4
	name = "\improper Flat 4"
/area/planets/Manhattan/south/building/f3/n5
	name = "\improper Flat 5"
/area/planets/Manhattan/south/building/f3/n6
	name = "\improper Flat 6"

/area/planets/Manhattan/south/building/f4
	icon_state = "south_m_build_flat"
/area/planets/Manhattan/south/building/f4/n1
	name = "\improper Flat 1"
/area/planets/Manhattan/south/building/f4/n2
	name = "\improper Flat 2"
/area/planets/Manhattan/south/building/f4/n3
	name = "\improper Flat 3"
/area/planets/Manhattan/south/building/f4/n4
	name = "\improper Flat 4"
/area/planets/Manhattan/south/building/f4/n5
	name = "\improper Flat 5"
/area/planets/Manhattan/south/building/f4/n6
	name = "\improper Flat 6"

/area/planets/Manhattan/south/building/f5
	icon_state = "south_m_build_flat"
/area/planets/Manhattan/south/building/f5/n1
	name = "\improper Flat 1"
/area/planets/Manhattan/south/building/f5/n2
	name = "\improper Flat 2"
/area/planets/Manhattan/south/building/f5/n3
	name = "\improper Flat 3"
/area/planets/Manhattan/south/building/f5/n4
	name = "\improper Flat 4"
/area/planets/Manhattan/south/building/f5/n5
	name = "\improper Flat 5"
/area/planets/Manhattan/south/building/f5/n6
	name = "\improper Flat 6"

//FACTORY

/area/planets/Manhattan/south/factory
	name = "\improper South District Factory"
	icon_state = "south_m_factory"
	dynamic_lighting = 1
	flags = RAD_SHIELDED

/area/planets/Manhattan/south/factory/roof
	name = "\improper Factory Roof"

/area/planets/Manhattan/south/factory/maintenance
	name = "\improper Factory Maintenance"
	icon_state = "south_m_factory_m"

/area/planets/Manhattan/south/factory/maintenance/janitor
	name = "\improper Janitorial Closet"

/area/planets/Manhattan/south/factory/office
	name = "\improper Factory Office Hallway"
	icon_state = "south_m_factory_o"

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
	name = "\improper Chief Engineer Office"

/area/planets/Manhattan/south/factory/office/ce/room
	name = "\improper Chief Engineer Backroom"

/area/planets/Manhattan/south/factory/office/qm
	name = "\improper Quartermaster Office"

/area/planets/Manhattan/south/factory/office/qm/room
	name = "\improper Quartermaster Backroom"

/area/planets/Manhattan/south/factory/office/pmchead
	name = "\improper PMC Head Office"

/area/planets/Manhattan/south/factory/pmc
	name = "\improper PMC Wing"
	icon_state = "south_m_factory_s"

/area/planets/Manhattan/south/factory/pmc/armory
	name = "\improper PMC Armory"

/area/planets/Manhattan/south/factory/pmc/brig
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
	name = "\improper PMC Checkpoint B"

/area/planets/Manhattan/south/factory/pmc/checkpoint/c
	name = "\improper PMC Checkpoint C"

/area/planets/Manhattan/south/factory/hallway
	name = "\improper Factory Hallway"

/area/planets/Manhattan/south/factory/hallway/second_floor
	name = "\improper Factory 2th Floor Hallway"

/area/planets/Manhattan/south/factory/hallway/mess
	name = "\improper Factory Mess Hall"

/area/planets/Manhattan/south/factory/cargo
	name = "\improper Factory Cargo Wing"
	icon_state = "south_m_factory_c"

/area/planets/Manhattan/south/factory/cargo/storage
	name = "\improper Cargo Storage"

/area/planets/Manhattan/south/factory/cargo/storage/second
	name = "\improper Cargo Second Storage"

/area/planets/Manhattan/south/factory/cargo/storage/thirt
	name = "\improper Cargo Thirt Storage"

/area/planets/Manhattan/south/factory/cargo/breakroom
	name = "\improper Cargo Break Room"

/area/planets/Manhattan/south/factory/cargo/meeting
	name = "\improper Cargo Meeting Room"

/area/planets/Manhattan/south/factory/cargo/equipment
	name = "\improper Cargo Equipment"

/area/planets/Manhattan/south/factory/cargo/mining
	name = "\improper Mining"

/area/planets/Manhattan/south/factory/engineering
	name = "\improper Engineering"
	icon_state = "south_m_factory_e"

/area/planets/Manhattan/south/factory/engineering/lobby
	name = "\improper Engineering Lobby"

/area/planets/Manhattan/south/factory/engineering/construction
	name = "\improper Engineering Construction Site"

/area/planets/Manhattan/south/factory/engineering/exosuit
	name = "\improper Engineering Exosuit Fabrication"

/area/planets/Manhattan/south/factory/engineering/breakroom
	name = "\improper Engineering Break Room"

/area/planets/Manhattan/south/factory/engineering/breakroom/b
	name = "\improper Engineering Observatory"

/area/planets/Manhattan/south/factory/engineering/equipment
	name = "\improper Engineering Equipment"

/area/planets/Manhattan/south/factory/engineering/hangar
	name = "\improper Delivery Hangar"

/area/planets/Manhattan/south/factory/engineering/meeting
	name = "\improper Engineering Meeting Room"

/area/planets/Manhattan/south/factory/engineering/storage
	name = "\improper Engineering Storage"

/area/planets/Manhattan/south/factory/engineering/storage/b
	name = "\improper Engineering Second Storage"

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
	base_turf = /turf/simulated/floor/plating