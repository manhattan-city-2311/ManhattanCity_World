/mob/living/carbon/human/npc/interactable
	nanoui_interactive_dist = 2
	nanoui_update_dist = 2
	nanoui_disabled_dist = 2

/mob/living/carbon/human/npc/interactable/switch_mode()
	return

/mob/living/carbon/human/npc/interactable/examine(mob/user)
	ui_interact(user)

/mob/living/carbon/human/proc/get_available_money()
	for(var/obj/item/weapon/spacecash/C in contents)
		. += C.worth

/mob/living/carbon/human/proc/take_cash(amount, dloc = loc)
	var/avail = get_available_money()
	if(avail < amount)
		return

	for(var/obj/item/weapon/spacecash/S in contents)
		. += S.worth
		qdel(S)
		if(. >= amount)
			break

	if((. - amount) > 0)
		spawn_money(. - amount, dloc, src)
