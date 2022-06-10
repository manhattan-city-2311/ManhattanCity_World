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