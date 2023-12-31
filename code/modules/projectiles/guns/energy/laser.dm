/obj/item/weapon/gun/energy/laser
	name = "laser rifle"
	desc = "A Hephaestus Industries G40E rifle, designed to kill with concentrated energy blasts.  This variant has the ability to \
	switch between standard fire and a more efficent but weaker 'suppressive' fire."
	icon_state = "laser"
	item_state = "laser"
	wielded_item_state = "laser-wielded"
	fire_delay = 8
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEMSIZE_LARGE
	force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000, "copper" = 1000, "silver" = 150)
	projectile_type = /obj/item/projectile/beam/midlaser
//	one_handed_penalty = 30

	firemodes = list(
		list(mode_name="normal", fire_delay=8, projectile_type=/obj/item/projectile/beam/midlaser, charge_cost = 240),
		list(mode_name="suppressive", fire_delay=5, projectile_type=/obj/item/projectile/beam/weaklaser, charge_cost = 60),
		)

/obj/item/weapon/gun/energy/laser/mounted
	self_recharge = 1
	use_external_power = 1
	one_handed_penalty = 0 // Not sure if two-handing gets checked for mounted weapons, but better safe than sorry.

/obj/item/weapon/gun/energy/laser/practice
	name = "practice laser carbine"
	desc = "A modified version of the HI G40E, this one fires less concentrated energy bolts designed for target practice."
	projectile_type = /obj/item/projectile/beam/practice
	charge_cost = 48

	cell_type = /obj/item/weapon/cell/device

	firemodes = list(
		list(mode_name="normal", projectile_type=/obj/item/projectile/beam/practice, charge_cost = 48),
		list(mode_name="suppressive", projectile_type=/obj/item/projectile/beam/practice, charge_cost = 12),
		)

/obj/item/weapon/gun/energy/retro
	name = "retro laser"
	icon_state = "retro"
	item_state = "retro"
	desc = "An older model of the basic lasergun. Nevertheless, it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws."
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	projectile_type = /obj/item/projectile/beam
	fire_delay = 10 //old technology

/obj/item/weapon/gun/energy/retro/mounted
	self_recharge = 1
	use_external_power = 1

/obj/item/weapon/gun/energy/retro/empty
	icon_state = "retro"
	cell_type = null


/obj/item/weapon/gun/energy/alien
	name = "alien pistol"
	desc = "A weapon that works very similarly to a traditional energy weapon. How this came to be will likely be a mystery for the ages."
	icon_state = "alienpistol"
	item_state = "alienpistol"
	fire_sound = 'sound/weapons/eLuger.ogg'
	fire_delay = 10 // Handguns should be inferior to two-handed weapons. Even alien ones I suppose.
	charge_cost = 480 // Five shots.

	projectile_type = /obj/item/projectile/beam/cyan
	cell_type = /obj/item/weapon/cell/device/weapon/recharge/alien // Self charges.
	origin_tech = list(TECH_COMBAT = 8, TECH_MAGNET = 7)
	modifystate = "alienpistol"


/obj/item/weapon/gun/energy/captain
	name = "antique laser gun"
	icon_state = "caplaser"
	item_state = "caplaser"
	desc = "A rare weapon, handcrafted by a now defunct specialty manufacturer on Luna for a small fortune. It's certainly aged well."
	force = 5
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	projectile_type = /obj/item/projectile/beam
	origin_tech = null
	fire_delay = 10		//Old pistol
	charge_cost = 480	//to compensate a bit for self-recharging
	cell_type = /obj/item/weapon/cell/device/weapon/recharge/captain
	battery_lock = 1
	dont_save = TRUE

/obj/item/weapon/gun/energy/lasercannon
	name = "laser cannon"
	desc = "With the laser cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron \
	flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	item_state = null
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	slot_flags = SLOT_BELT|SLOT_BACK
	projectile_type = /obj/item/projectile/beam/heavylaser/cannon
	battery_lock = 1
	fire_delay = 20
	w_class = ITEMSIZE_LARGE
//	one_handed_penalty = 90 // The thing's heavy and huge.
	accuracy = 45
	charge_cost = 600

/obj/item/weapon/gun/energy/lasercannon/mounted
	name = "mounted laser cannon"
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
	accuracy = 0 // Mounted cannons are just fine the way they are.
	one_handed_penalty = 0 // Not sure if two-handing gets checked for mounted weapons, but better safe than sorry.
	projectile_type = /obj/item/projectile/beam/heavylaser
	charge_cost = 400
	fire_delay = 20

/obj/item/weapon/gun/energy/xray
	name = "xray laser gun"
	desc = "A high-power laser gun capable of expelling concentrated xray blasts, which are able to penetrate matter easier than \
	standard photonic beams, resulting in an effective 'anti-armor' energy weapon."
	icon_state = "xray"
	item_state = "xray"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	projectile_type = /obj/item/projectile/beam/xray
	charge_cost = 200

/obj/item/weapon/gun/energy/sniperrifle
	name = "marksman energy rifle"
	desc = "The HI DMR 9E is an older design of Hephaestus Industries. A designated marksman rifle capable of shooting powerful \
	ionized beams, this is a weapon to kill from a distance."
	icon_state = "sniper"
	item_state = "sniper"
	item_state_slots = list(slot_r_hand_str = "z8carbine", slot_l_hand_str = "z8carbine") //placeholder
	fire_sound = 'sound/weapons/gauss_shoot.ogg'
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 5, TECH_POWER = 4)
	projectile_type = /obj/item/projectile/beam/sniper
	slot_flags = SLOT_BACK
	battery_lock = 1
	charge_cost = 600
	fire_delay = 35
	force = 10
	w_class = ITEMSIZE_HUGE // So it can't fit in a backpack.
	accuracy = -45 //shooting at the hip
	scoped_accuracy = 0
//	requires_two_hands = 1
//	one_handed_penalty = 60 // The weapon itself is heavy, and the long barrel makes it hard to hold steady with just one hand.

/obj/item/weapon/gun/energy/sniperrifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)

////////Laser Tag////////////////////

/obj/item/weapon/gun/energy/lasertag
	name = "laser tag gun"
	item_state = "laser"
	desc = "Standard issue weapon of the Imperial Guard"
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/beam/lastertag/blue
	cell_type = /obj/item/weapon/cell/device/weapon/recharge
	battery_lock = 1
	var/required_vest

/obj/item/weapon/gun/energy/lasertag/special_check(mob/living/carbon/human/M)
	if(ishuman(M))
		if(!istype(M.wear_suit, required_vest))
			to_chat(M, "<span class='warning'>You need to be wearing your laser tag vest!</span>")
			return 0
	return ..()

/obj/item/weapon/gun/energy/lasertag/blue
	icon_state = "bluetag"
	item_state = "bluetag"
	projectile_type = /obj/item/projectile/beam/lastertag/blue
	required_vest = /obj/item/clothing/suit/bluetag

/obj/item/weapon/gun/energy/lasertag/red
	icon_state = "redtag"
	item_state = "redtag"
	projectile_type = /obj/item/projectile/beam/lastertag/red
	required_vest = /obj/item/clothing/suit/redtag

//Poxball//

/obj/item/weapon/gun/energy/poxball
	name = "poxball launcher"
	icon_state = "poxball"
	item_state = "poxball"
	desc = "A somewhat cumbersome arm cannon capable of firing charged poxball projectiles."
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	projectile_type = /obj/item/projectile/energy/poxball
	cell_type = /obj/item/weapon/cell/device/weapon/recharge/captain
	force = 5
	fire_delay = 15
	charge_cost = 180
	battery_lock = 1
	self_recharge = 1

/obj/item/weapon/gun/energy/poxball/street
	name = "makeshift poxball launcher"
	icon_state = "poxball_s"
	item_state = "poxball_s"
	desc = "A bulky arm cannon haphazardly assembled in some back-alley. It buzzes with uncontained energy."
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	projectile_type = /obj/item/projectile/energy/poxball/street
	cell_type = /obj/item/weapon/cell/device/weapon/recharge/captain
	force = 5
	fire_delay = 15
	charge_cost = 360 //double the cost of a real launcher
	battery_lock = 1
	self_recharge = 1

