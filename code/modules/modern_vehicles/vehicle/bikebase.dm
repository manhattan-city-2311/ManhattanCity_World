#define VC_FRONT_WHEEL "frontwheel"
#define VC_BACK_WHEEL "backwheel"

/obj/manhattan/vehicle/motorcycle
	name = "Motorcycle"
	icon = 'icons/obj/bike.dmi'
	icon_state = "bike_off"
	components = list(
		VC_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_ENGINE = /obj/item/vehicle_part/engine,
		VC_CLUTCH = /obj/item/vehicle_part/clutch,
		VC_GEARBOX = /obj/item/vehicle_part/gearbox,
		VC_CARDAN = /obj/item/vehicle_part/cardan
	)

	var/rider_x = 0
	var/rider_y = 0

	var/list/rider_xs = list(
		EAST = 0,
		WEST = 16,
		NORTH = 8,
		SOUTH = 8

	)
	var/list/rider_ys = list(
		EAST = 5,
		WEST = 5,
		NORTH = 12,
		SOUTH = 12
	)

	weight = 150
	aerodynamics_coefficent = 0.15
	traction_coefficent = 4.5

/obj/manhattan/vehicle/motorcycle/update_object_sprites()
	..()
	vis_contents.Cut()
	var/list/drivers = get_occupants_in_position("driver")
	var/mob/living/carbon/human/driver = drivers[1]
	driver.pixel_x = rider_xs[dir]
	driver.pixel_y = rider_ys[dir]
	vis_contents += driver