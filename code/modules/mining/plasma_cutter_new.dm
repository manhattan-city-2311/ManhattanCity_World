//From DS13

/obj/item/weapon/gun/energy/cutter
	name = "Standart Mining Cutter(SMC)"
	desc = "A medium-power mining tool capable of splitting dense material with only a few directed blasts. Unsurprisingly, it is also an extremely deadly tool and should be handled with the utmost care. "
	charge_meter = 0
	icon = 'icons/obj/items.dmi'
	icon_state = "plasmacutter"
	item_state = "plasmacutter"
	fire_sound = 'sound/items/Welder.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEMSIZE_NORMAL
	force = 8
	origin_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 4, TECH_ENGINEERING = 6, TECH_COMBAT = 3)
	matter = list(MATERIAL_STEEL = 4000)
	projectile_type = /obj/item/projectile/beam/cutter
	charge_cost = 100

	cell_type = /obj/item/weapon/cell/plasmacutter
	slot_flags = SLOT_BELT|SLOT_BACK

/obj/item/weapon/gun/energy/cutter/empty
	cell_type = null

/obj/item/weapon/gun/energy/cutter/plasma
	name = "Plasma Cutter"
	desc = "A high power plasma cutter designed to cut through tungsten reinforced bulkheads during engineering works. Also a rather hazardous improvised weapon, capable of severing limbs in a few shots."
	projectile_type = /obj/item/projectile/beam/cutter/plasma

/obj/item/projectile/beam/cutter
	name = "plasma arc"
	damage = 20
	accuracy = 130	//Its a broad arc, easy to land hits on limbs with
	edge = 1
	damage_type = BURN //plasma is a physical object with mass, rather than purely burning. this also means you can decapitate/sever limbs, not just ash them.
	check_armour = "laser"
	kill_count = 5 //mining tools are not exactly known for their ability to replace firearms, they're good against necros, not so much against anything else.
	pass_flags = PASSTABLE

	muzzle_type = /obj/effect/projectile/plasmacutter/muzzle
	tracer_type = null
	impact_type = /obj/effect/projectile/plasmacutter/impact
	fire_sound = 'sound/items/Welder.ogg'

/obj/item/projectile/beam/cutter/Bump(var/turf/simulated/mineral/A)
	if(istype(A))
		A.GetDrilled(1)
	. = ..()

/obj/item/projectile/beam/cutter/plasma
	damage = 30
	kill_count = 7 //an upgrade over the mining cutter, used for engineering work, but still not a proper firearm

//----------------------------
// Plasmacutter Effects
//----------------------------
/obj/effect/projectile/plasmacutter/
	light_color = COLOR_ORANGE

/obj/effect/projectile/plasmacutter/muzzle
	icon_state = "muzzle_plasmacutter"

/obj/effect/projectile/plasmacutter/impact
	icon_state = "impact_plasmacutter"


/*--------------------------
	Ammo
---------------------------*/

/obj/item/weapon/cell/plasmacutter
	name = "plasma energy"
	desc = "A light power pack designed for use with high energy cutting tools."
	origin_tech = list(TECH_POWER = 4)
	icon = 'icons/obj/ammo.dmi'
	icon_state = "darts"
	w_class = ITEMSIZE_SMALL
	maxcharge = 2500
	matter = list(MATERIAL_STEEL = 700, MATERIAL_SILVER = 80)

/obj/item/weapon/cell/plasmacutter/update_icon()
	return