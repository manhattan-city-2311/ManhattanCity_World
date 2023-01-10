/mob/living/carbon/human/npc/interactable
	nanoui_interactive_dist = 2
	nanoui_update_dist = 2
	nanoui_disabled_dist = 2
	dont_save = FALSE

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

/mob/living/carbon/human/proc/take_money(price, turf/nL = loc, datum/department/department, transaction_owner, log_purpose, log_terminal_id = "Retailer in [get_area(nL)]")
	var/avail = get_available_money()
	var/obj/item/weapon/card/debit/C = get_active_hand()
	if(istype(C))
		avail += C.get_account().money
	else
		C = null

	if(avail < price)
		to_chat(src, "Not enough cash!")
		return FALSE

	var/from_card = min(price, C?.get_account().money)
	var/from_cash = price - from_card

	if(from_card > 0)
		if(C.get_account().suspended)
			to_chat(usr, "Your account was suspended")
			return FALSE

		C.get_account().add_transaction_log(transaction_owner, log_purpose, -price, log_terminal_id)
		C.get_account().money -= from_card
	if(from_cash > 0)
		take_cash(from_cash, nL)
	if(department)
		var/datum/money_account/department/D = department.bank_account
		D.add_transaction_log(D.owner_name, log_purpose, "([price])", log_terminal_id)

	return TRUE
