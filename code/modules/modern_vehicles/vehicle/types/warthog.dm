
/obj/manhattan/vehicles/halo/warthog
	name = "M12 Warthog LRV"
	desc = "A nimble vehicle capable of providing anti-infantry support and small-scale troop transport."

	icon = 'code/modules/halo/vehicle/types/finalwarthog-chaingun.dmi'
	icon_state = "warthog-chaingun"

	bound_height = 64
	bound_width = 64

	comp_prof = /datum/component_profile/warthog

	ammo_containers = newlist(/obj/item/ammo_magazine/warthog_mag)

	occupants = list(1,1)
	exposed_positions = list("driver" = 10,"passenger" = 10)

	vehicle_size = ITEM_SIZE_VEHICLE
	capacity_flag = ITEMSIZE_NORMAL

//	move_sound = 'code/modules/halo/sounds/warthog_move.ogg'

	light_color = "#E1FDFF"

	min_speed = 8.5
	max_speed = 2.5

/obj/manhattan/vehicles/halo/warthog/on_death()
	. = ..()

/obj/item/vehicle_component/health_manager/warthog
	integrity = 500
	resistances = list("brute"=80,"burn"=80,"emp"=25,"bomb"=50)

/datum/component_profile/warthog
	pos_to_check = "gunner"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/warthog_turret)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/warthog)

/obj/item/ammo_magazine/warthog_mag
	name = "Internal Ammunition Storage"
	caliber = "a762"
	max_ammo = 200
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/weapon/gun/vehicle_turret/warthog_turret
	name = "Warthog Turret"
	desc = "A rapid-fire mounted machine gun."

	fire_delay = 20

	dispersion = list(0,0,0,0,0,1)
	burst_accuracy = list(0,0,0,0,0.-1)

	magazine_type = /obj/item/ammo_magazine/warthog_mag

/obj/manhattan/vehicles/halo/warthog/turretless
	name = "M12 Warthog LRV Recon Modified"
	desc = "A nimble vehicle capable of performing small scale recon operations."

	icon = 'code/modules/halo/vehicle/types/finalwarthog-turretless.dmi'
	icon_state = "warthog-turretless"

	max_speed = 2.3
	capacity_flag = ITEMSIZE_LARGE

	occupants = list(2,0)
	exposed_positions = list("driver" = 10,"passenger" = 10)

/obj/manhattan/vehicles/halo/warthog/troop
	name = "M12 Warthog LRV Troop Transport Modified"
	desc = "A nimble vehicle capable of providing small to medium scale troop transport."

	icon = 'code/modules/halo/vehicle/types/finalwarthog.dmi'
	icon_state = "Warthog"

	max_speed = 2.4

	occupants = list(3,0)
	exposed_positions = list("driver" = 10,"passenger" = 15)

/obj/manhattan/vehicles/halo/warthog/troop/police
	name = "M12 Warthog LRV Police Modified"
	desc = "A nimble vehicle capable of providing small to medium scale troop transport."

	icon = 'code/modules/halo/vehicle/types/GCPD_Warthog.dmi'
	icon_state = "Warthog"

	min_speed = 8.5
	max_speed = 2.4