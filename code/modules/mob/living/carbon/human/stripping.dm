/mob/living/carbon/human/proc/handle_strip(var/slot_to_strip,var/mob/living/user)

	if(!slot_to_strip || !istype(user))
		return

	if(user.incapacitated()  || !user.Adjacent(src))
		show_browser(user, null, "window=mob[src.name]")
		return TRUE

	if(isLivingSSD(src))
		if(user.client && !user.client.can_harm_ssds() && !isAntag(user))
			to_chat(user, "<span class='warning'>AdminHelp (F1) to get permission before stripping players who are suffering from Space Sleep Disorder / disconnected from the game. Read the server rules for more details.</span>")
			return

	switch(slot_to_strip)
		// Handle things that are part of this interface but not removing/replacing a given item.
		if("pockets")
			visible_message("<span class='danger'>\The [user] is trying to empty \the [src]'s pockets!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY,src))
				empty_pockets(user)
			return
		if("splints")
			visible_message("<span class='danger'>\The [user] is trying to remove \the [src]'s splints!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY,src))
				remove_splints(user)
			return
		if("intubation")
			visible_message("<span class='danger'>\The [user] is trying to remove \the [src]'s intubation tube!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY,src))
				remove_intubation(user)
			return
		if("sensors")
			visible_message("<span class='danger'>\The [user] is trying to set \the [src]'s sensors!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY,src))
				toggle_sensors(user)
			return
		if("tie")
			var/obj/item/clothing/under/suit = w_uniform
			if(!istype(suit) || !suit.accessories.len)
				return
			var/obj/item/clothing/accessory/A = suit.accessories[1]
			if(!istype(A))
				return


			visible_message("<span class='danger'>\The [usr] is trying to remove \the [src]'s [A.name]!</span>")

			if(!do_after(user,HUMAN_STRIP_DELAY,src))
				return

			if(!A || suit.loc != src || !(A in suit.accessories))
				return

			if(istype(A, /obj/item/clothing/accessory/badge) || istype(A, /obj/item/clothing/accessory/medal))
				user.visible_message("<span class='danger'>\The [user] tears off \the [A] from [src]'s [suit.name]!</span>")
			add_attack_logs(user,src,"Stripped [A.name] off [suit.name]")
			A.on_removed(user)
			suit.accessories -= A
			update_inv_w_uniform()
			return
		else
			var/obj/item/located_item = locate(slot_to_strip) in contents
			if(isunderwear(located_item))
				var/obj/item/underwear/UW = located_item
				if(UW.DelayedRemoveUnderwear(user, src))
					user.put_in_active_hand(UW)
				return

	var/obj/item/target_slot = get_equipped_item(text2num(slot_to_strip))

	// Are we placing or stripping?
	var/stripping = FALSE
	var/obj/item/held = user.get_active_hand()
	if(!istype(held) || is_robot_module(held))
		if(!istype(target_slot))  // They aren't holding anything valid and there's nothing to remove, why are we even here?
			return
		if(!target_slot.canremove)
			to_chat(user, "<span class='warning'>You cannot remove \the [src]'s [target_slot.name].</span>")
			return
		stripping = TRUE

	if(stripping)
		visible_message("<span class='danger'>\The [user] is trying to remove \the [src]'s [target_slot.name]!</span>")
	else
		if(slot_to_strip == slot_wear_mask && istype(held, /obj/item/weapon/grenade))
			visible_message("<span class='danger'>\The [user] is trying to put \a [held] in \the [src]'s mouth!</span>")
		else
			visible_message("<span class='danger'>\The [user] is trying to put \a [held] on \the [src]!</span>")

	if(!do_after(user,HUMAN_STRIP_DELAY,src))
		return

	if(!stripping && user.get_active_hand() != held)
		return

	if(stripping)
		add_attack_logs(user,src,"Removed equipment from slot [target_slot]")
		unEquip(target_slot)
	else if(user.unEquip(held))
		equip_to_slot_if_possible(held, text2num(slot_to_strip), 0, 1, 1)
		if(held.loc != src)
			user.put_in_hands(held)

// Empty out everything in the target's pockets.
/mob/living/carbon/human/proc/empty_pockets(var/mob/living/user)
	if(!r_store && !l_store)
		to_chat(user, "<span class='warning'>\The [src] has nothing in their pockets.</span>")
		return
	if(r_store)
		unEquip(r_store)
	if(l_store)
		unEquip(l_store)
	visible_message("<span class='danger'>\The [user] empties \the [src]'s pockets!</span>")

// Modify the current target sensor level.
/mob/living/carbon/human/proc/toggle_sensors(var/mob/living/user)
	var/obj/item/clothing/under/suit = w_uniform
	if(!suit)
		to_chat(user, "<span class='warning'>\The [src] is not wearing a suit with sensors.</span>")
		return
	if (suit.has_sensor >= 2)
		to_chat(user, "<span class='warning'>\The [src]'s suit sensor controls are locked.</span>")
		return
	add_attack_logs(user,src,"Adjusted suit sensor level")
	suit.set_sensors(user)

// Remove all splints.
/mob/living/carbon/human/proc/remove_splints(var/mob/living/user)

	var/can_reach_splints = 1
	if(istype(wear_suit,/obj/item/clothing/suit/space))
		var/obj/item/clothing/suit/space/suit = wear_suit
		if(suit.supporting_limbs && suit.supporting_limbs.len)
			to_chat(user, "<span class='warning'>You cannot remove the splints - [src]'s [suit] is supporting some of the breaks.</span>")
			can_reach_splints = 0

	if(can_reach_splints)
		var/removed_splint
		for(var/obj/item/organ/external/o in organs_by_name)
			if (o && o.splinted)
				var/obj/item/S = o.splinted
				if(istype(S) && S.loc == o) //can only remove splints that are actually worn on the organ (deals with hardsuit splints)
					S.add_fingerprint(user)
					if(o.remove_splint())
						user.put_in_active_hand(S)
						removed_splint = 1
		if(removed_splint)
			visible_message("<span class='danger'>\The [user] removes \the [src]'s splints!</span>")
		else
			to_chat(user, "<span class='warning'>\The [src] has no splints to remove.</span>")

/mob/living/carbon/human/proc/remove_intubation(var/mob/living/user)
	if(!intubated)
		to_chat(user, "<span class='warning'>\The [src] is not intubated.</span>")
		return
	visible_message("<span class='danger'>\The [user] pulls an intubation tube out of [src]'s throat!</span>")
	intubated = FALSE
