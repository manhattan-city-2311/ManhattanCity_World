#define VC_FRONT_WHEEL "frontwheel"
#define VC_BACK_WHEEL "backwheel"

/obj/manhattan/vehicle/motorcycle
	name = "Motorcycle"
	icon = 'icons/obj/bike.dmi'
	icon_state = "bike_off"
	var/overlay_icon_state = "bike_off_overlay"

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

	var/list/rider_xs

	var/list/rider_ys

	weight = 150
	aerodynamics_coefficent = 0.2
	traction_coefficent = 12

	var/image/img

/obj/manhattan/vehicle/motorcycle/get_braking_force()
	return 100

/obj/manhattan/vehicle/motorcycle/update_object_sprites()
	vis_contents.Cut()
	overlays.Cut()

	if(img)
		del(img)
	img = image(icon, icon_state = overlay_icon_state, dir = dir, layer = ABOVE_MOB_LAYER + 1)
	img.plane = MOB_PLANE

	if(!occupants)
		return

	var/mob/living/carbon/human/driver = LAZYFIRST(get_occupants_in_position("driver"))
	//var/mob/living/carbon/human/gunner = LAZYFIRST(get_occupants_in_position("gunner"))

	var/x = rider_xs[dir2text(dir & ALL_CARDINALS)]
	var/y = rider_ys[dir2text(dir & ALL_CARDINALS)]
	if(driver)
		driver.pixel_x = x
		driver.pixel_y = y
		vis_contents += driver
	overlays += img

/obj/manhattan/vehicle/motorcycle/exit_vehicle(mob/user)
	. = ..()
	user.pixel_x = 0
	user.pixel_y = 0