#define VC_FRONT_WHEEL "frontwheel"
#define VC_BACK_WHEEL "backwheel"

/obj/manhattan/vehicle/motorcycle
	name = "Motorcycle"
	icon = 'icons/obj/bike.dmi'
	icon_state = "bike_off"
	var/list/components = list(
		VC_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_ENGINE = /obj/item/vehicle_part/engine,
		VC_CLUTCH = /obj/item/vehicle_part/clutch,
		VC_GEARBOX = /obj/item/vehicle_part/gearbox,
		VC_CARDAN = /obj/item/vehicle_part/cardan
	)

/obj/manhattan/vehicle/motorcycle/update_object_sprites()
    ..()
    var/list/drivers = get_occupants_in_position("driver")
    var/mob/living/carbon/human/driver = drivers[1]
    overlays += driver.overlays.Copy()