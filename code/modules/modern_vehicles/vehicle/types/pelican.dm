/obj/manhattan/vehicles/air/halo/pelican
	name = "D77-TC Pelican"
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. It can also be used as a support gunship. An M370 Autocannon is mounted on the nose."

	icon = 'code/modules/modern_vehicle/vehicle/pelican.dmi'
	icon_state = "base"

	density = 1

	bound_height = 128
	bound_width = 128

	pixel_x = -32
	pixel_y = -32

	takeoff_overlay_icon_state = "thrust"
	takeoff_sound = 'code/modules/modern_vehicle/vehicle/pelican_takeoff.ogg'

	comp_prof = /datum/component_profile/pelican

	ammo_containers = newlist(/obj/item/ammo_magazine/pelican_hmg)

	occupants = list(6,1)

	vehicle_size = ITEM_SIZE_VEHICLE_LARGE
	vehicle_carry_size = ITEM_SIZE_VEHICLE
	capacity_flag = ITEM_SIZE_VEHICLE_LARGE

	light_color = "#E1FDFF"

	min_speed = 17.25
	max_speed = 2.25
	acceleration = 6
	drag = 3.5

/obj/manhattan/vehicles/air/halo/pelican/update_object_sprites()

//Pelican component profile define//
/obj/item/vehicle_component/health_manager/pelican
	integrity = 900
	resistances = list("brute"=45,"burn"=45,"emp"=50,"bomb" = 50)

/datum/component_profile/pelican
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/pelican_autocannon)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/pelican)

/obj/item/weapon/gun/vehicle_turret/pelican_autocannon
	name = "M370 Autocannon"

	icon_state = "chaingun_obj"
	item_state = "chaingun_obj"

	fire_delay = 1.5 SECONDS

	burst = 5

	magazine_type = /obj/item/ammo_magazine/pelican_hmg

/obj/item/ammo_magazine/pelican_hmg
	name = "Internal Ammunition Storage"
	max_ammo = 100
	caliber = "12.7mm"
	ammo_type = /obj/item/ammo_casing/pelican_hmg

/obj/item/ammo_casing/pelican_hmg
	projectile_type = /obj/item/projectile/bullet/rifle/a145

/obj/item/ammo_magazine/pelican_chaingun
	max_ammo = 150
	caliber = "a762"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/manhattan/vehicles/air/halo/pelican/civ
	desc = "A civilian pelican lacking in both weapons and armor."
	occupants = list(6,0)

	comp_prof = /datum/component_profile/pelican/civ

/obj/item/vehicle_component/health_manager/pelican/civ
	resistances = list("brute"=15,"burn"=10,"emp"=20)

/datum/component_profile/pelican/civ
	vital_components = newlist(/obj/item/vehicle_component/health_manager/pelican/civ)
