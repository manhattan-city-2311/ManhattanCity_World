/obj/item/clothing/shoes/leg_guard
	name = "leg guards"
	desc = "These will protect your legs and feet."
	body_parts_covered = LEGS|FEET
	slowdown = SHOES_SLOWDOWN+0.5
	species_restricted = null	//Unathi and Taj can wear leg armor now
	w_class = ITEMSIZE_NORMAL
	step_volume_mod = 1.3

/obj/item/clothing/shoes/leg_guard/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..()) //This will only run if no other problems occured when equiping.
		if(H.wear_suit)
			if(H.wear_suit.body_parts_covered & LEGS)
				to_chat(H, "<span class='warning'>You can't wear \the [src] with \the [H.wear_suit], it's in the way.</span>")
				return 0
		return 1

/obj/item/clothing/shoes/leg_guard/laserproof
	name = "ablative leg guards"
	desc = "These will protect your legs and feet from energy weapons."
	icon_state = "leg_guards_laser"
	item_state_slots = list(slot_r_hand_str = "jackboots", slot_l_hand_str = "jackboots")
	siemens_coefficient = 0.1
	armor = list(melee = 10, bullet = 10, laser = 80, energy = 50, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/shoes/leg_guard/bulletproof
	name = "bullet resistant leg guards"
	desc = "These will protect your legs and feet from ballistic weapons."
	icon_state = "leg_guards_bullet"
	item_state_slots = list(slot_r_hand_str = "jackboots", slot_l_hand_str = "jackboots")
	siemens_coefficient = 0.7
	armor = list(melee = 10, bullet = 80, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/shoes/leg_guard/riot
	name = "riot leg guards"
	desc = "These will protect your legs and feet from close combat weapons."
	icon_state = "leg_guards_riot"
	item_state_slots = list(slot_r_hand_str = "jackboots", slot_l_hand_str = "jackboots")
	siemens_coefficient = 0.5
	armor = list(melee = 80, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/shoes/leg_guard/combat
	name = "combat leg guards"
	desc = "These will protect your legs and feet from a variety of weapons."
	icon_state = "leg_guards_combat"
	item_state_slots = list(slot_r_hand_str = "jackboots", slot_l_hand_str = "jackboots")
	siemens_coefficient = 0.6
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 30, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/shoes/leg_guard/poxball
	name = "poxball leg guards"
	desc = "A pair of modified ablative leg guards designed to protect from poxball surges."
	icon_state = "poxball_feet"
	item_state_slots = list(slot_r_hand_str = "jackboots", slot_l_hand_str = "jackboots")
	siemens_coefficient = 0.1
	armor = list(melee = 10, bullet = 5, laser = 20, energy = 30, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/shoes/leg_guard/poxball/verb/Set_Team_Color()
	set name = "Set Team Color"
	if(!usr.canmove || usr.stat || usr.restrained()) return

	switch(alert("Select a color.", "Which team are you on?", "Red", "Blue", "Disable Team Color"))
		if("Red")
			icon_state = "poxball_feet_r"
			update_clothing_icon()
		if("Blue")
			icon_state = "poxball_feet_b"
			update_clothing_icon()
		if("Disable Team Color")
			icon_state = initial(icon_state)
			update_clothing_icon()