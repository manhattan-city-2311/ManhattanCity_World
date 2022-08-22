/obj/turbolift_map_holder/normal_house1
	name = "House Elevator"
	depth = 2
	lift_size_x = 3
	lift_size_y = 3
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	wall_type =  /turf/simulated/wall/iron
	floor_type = /turf/simulated/floor/tiled/techfloor/grid

	areas_to_use = list(
		/area/turbolift/manhattan_house11,
		/area/turbolift/manhattan_house12
		)

/obj/turbolift_map_holder/hospital
	name = "Hospital Elevator"
	depth = 3
	lift_size_x = 3
	lift_size_y = 3
	areas_to_use = list(
		/area/turbolift/hospital1,
		/area/turbolift/hospital2,
		/area/turbolift/hospital3
		)

/obj/turbolift_map_holder/factory1
	name = "Factory Industrial Garage Elevator"
	depth = 3
	lift_size_x = 3
	lift_size_y = 4
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	wall_type =  /turf/simulated/wall/iron
	floor_type = /turf/simulated/floor/tiled/techfloor/grid

	areas_to_use = list(
		/area/turbolift/factory1,
		/area/turbolift/factory2,
		/area/turbolift/factory3
		)
