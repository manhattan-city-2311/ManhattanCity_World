/obj/item/clothing/under/manhattan
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/manhattan
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/manhattan/armor
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/device/flashlight/maglight,/obj/item/clothing/head/helmet)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	item_flags = THICKMATERIAL

	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.6

// MANHATTAN CITY POLICE DEPARTMENT

/obj/item/clothing/under/manhattan/police/turtleneck
	name = "turtleneck"
	desc = "Standart MCPD uniform"
	icon_state = "turtleneckpd"
	worn_state = "turtleneckpd"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/manhattan/police/turtleneck/black
	icon_state = "turtleneckpd2"
	worn_state = "turtleneckpd2"

/obj/item/clothing/under/manhattan/police/formal
	name = "office uniform"
	desc = "Standart MCPD uniform"
	icon_state = "whiteshirt"
	worn_state = "whiteshirt"

/obj/item/clothing/suit/manhattan/police/detective
	name = "armored leather coat"
	desc = "A long, thick brown leather coat."
	icon_state = "mcpddetective"
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight, /obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	item_state_slots = list(slot_r_hand_str = "leather_jacket", slot_l_hand_str = "leather_jacket")
	flags_inv = HIDEHOLSTER
	armor = list(melee = 10, bullet = 45, laser = 0,energy = 0, bomb = 5, bio = 5, rad = 0)
	var/open = 0	//0 is closed, 1 is open, -1 means it won't be able to toggle
	verb/toggle()
		set name = "Toggle Coat Buttons"
		set category = "Object"
		set src in usr
		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		if(open == 1) //Will check whether icon state is currently set to the "open" or "closed" state and switch it around with a message to the user
			open = 0
			icon_state = initial(icon_state)
			flags_inv = HIDETIE|HIDEHOLSTER
			to_chat(usr, "You button up the coat.")
		else if(open == 0)
			open = 1
			icon_state = "[icon_state]_open"
			flags_inv = HIDEHOLSTER
			to_chat(usr, "You unbutton the coat.")
		else //in case some goofy admin switches icon states around without switching the icon_open or icon_closed
			to_chat(usr, "You attempt to button-up the velcro on your [src], before promptly realising how silly you are.")
			return
		update_clothing_icon()	//so our overlays update

/obj/item/clothing/suit/manhattan/armor/police/l_armor
	name = "MCPD Light armored vest"
	desc = "A thick, black MCPD vest."
	icon_state = "lightvest"
	armor = list(melee = 20, bullet = 40, laser = 0,energy = 0, bomb = 10, bio = 5, rad = 0)

/obj/item/clothing/suit/manhattan/armor/police/m_armor
	name = "MCPD Medium armored vest"
	desc = "A thick, black MCPD vest."
	icon_state = "armorvest"
	armor = list(melee = 30, bullet = 60, laser = 0,energy = 0, bomb = 20, bio = 10, rad = 0)

/obj/item/clothing/suit/manhattan/armor/police/h_armor
	name = "MCPD Heavy armored vest"
	desc = "A thick, black MCPD vest."
	icon_state = "heavyvest"
	armor = list(melee = 45, bullet = 85, laser = 0,energy = 0, bomb = 35, bio = 10, rad = 0)

/obj/item/clothing/suit/manhattan/police/puffer
	name = "MCPD Cadet puffer vest"
	desc = "A thick, blue MCPD jacket."
	icon_state = "mcpdcadet"
	item_state_slots = list(slot_r_hand_str = "armor", slot_l_hand_str = "armor")
	flags_inv = HIDEHOLSTER
	armor = list(melee = 10, bullet = 10, laser = 0,energy = 0, bomb = 0, bio = 20, rad = 0)

/obj/item/clothing/head/manhattan/police
	name = "MCPD cap"
	desc = "Standart police cap"
	icon_state = "mcpdcadet"

/obj/item/clothing/head/manhattan/police/detective
	name = "MCPD beret"
	desc = "Standart detective beret"
	icon_state = "mcpddetective"

/obj/item/clothing/head/manhattan/police/chief
	name = "MCPD Chief cap"
	desc = "Standart PD Chief cap"
	icon_state = "mcpdboss"

/obj/item/clothing/suit/manhattan/police/puffer/officer
	name = "MCPD Officer puffer vest"
	desc = "A thick, black MCPD jacket."
	icon_state = "mcpdofficer"

/obj/item/clothing/suit/manhattan/police/puffer/chief
	name = "MCPD Chief puffer vest"
	desc = "A thick, black MCPD jacket with extra armor."
	icon_state = "mcpdboss"
	armor = list(melee = 15, bullet = 20, laser = 0,energy = 0, bomb = 5, bio = 20, rad = 0)

/obj/item/clothing/gloves/manhattan/police
	desc = "These tactical gloves are somewhat fire and impact-resistant."
	name = "\improper SWAT Gloves"
	icon_state = "blackgloves"
	armor = list(melee = 75, bullet = 60, laser = 0,energy = 0, bomb = 60, bio = 0, rad = 0)
	siemens_coefficient = 0

// SOL FEDERAL POLICE

/obj/item/clothing/under/manhattan/sfp/leader_formal
	name = "formal SFP leader uniform"
	desc = "Standart SFP leader uniform"
	icon_state = "fbileader"
	worn_state = "fbileader"

/obj/item/clothing/under/manhattan/sfp/formal
	name = "formal SFP uniform"
	desc = "Standart SFP uniform"
	icon_state = "fbi"
	worn_state = "fbi"

/obj/item/clothing/suit/manhattan/sfp/leader_coat
	name = "armored SFP coat"
	desc = "A long, thick blue SFP leader coat."
	icon_state = "fbileader"
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight, /obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	item_state_slots = list(slot_r_hand_str = "leather_jacket", slot_l_hand_str = "leather_jacket")
	flags_inv = HIDEHOLSTER
	armor = list(melee = 10, bullet = 60, laser = 0,energy = 0, bomb = 5, bio = 15, rad = 0)

/obj/item/clothing/suit/manhattan/sfp/coat
	name = "armored SFP coat"
	desc = "A long, thick blue SFP coat."
	icon_state = "fbi"
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight, /obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	item_state_slots = list(slot_r_hand_str = "johnny_coat", slot_l_hand_str = "johnny_coat")
	flags_inv = HIDEHOLSTER
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 15, rad = 0)

// OTHERS

/obj/item/clothing/shoes/manhattan/standart
	name = "black formal shoes"
	desc = "Sharp looking low quarters, perfect for a formal uniform."
	icon_state = "shoes"
	armor = list(melee = 0, bullet = 5, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/manhattan/jackboots
	name = "black jackboots shoes"
	desc = "Standard-issue Security combat boots for combat scenarios or combat situations. All combat, all the time."
	icon_state = "jackbootspd"
	armor = list(melee = 80, bullet = 60, laser = 0,energy = 0, bomb = 50, bio = 10, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6

/obj/item/clothing/glasses/sunglasses/manhattan/aviator
	name = "yellow aviators"
	desc = "A pair of designer sunglasses."
	icon_state = "yellowaviators"

// CUSTOM ITEMS

/obj/item/clothing/suit/manhattan/sfp/leader_coat/zakat
	name = "black leather coat"
	desc = "A long, thick black coat."
	icon_state = "zakatneba"