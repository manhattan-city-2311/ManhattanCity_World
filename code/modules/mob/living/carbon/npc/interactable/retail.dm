/mob/living/carbon/human/npc/interactable/retail
	name = "unremarkable retailer"
	var/list/products = list(
		list(
			"key" 	= "_",
			"name"  = "FIXME",
			"price" = 0,
			"type" 	= null
		)
	)

	var/transaction_owner // For transcations log

	var/datum/department/department

/mob/living/carbon/human/npc/interactable/retail/initialize()
	. = ..()

	if(department)
		department = dept_by_name(department)

/mob/living/carbon/human/npc/interactable/retail/testing
	products = list(
		list(
			"key" = "gauze",
			"price" = 5,
			"name" = "бинт",
			"type" = /obj/item/stack/medical/gauze
		)
	)

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

/mob/living/carbon/human/npc/interactable/retail/proc/give_item(mob/living/carbon/human/H, item)
	return H.put_in_hands(item)

/mob/living/carbon/human/npc/interactable/retail/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/list/data = list()

	var/mob/living/carbon/human/H = user

	data["products"] = products

	var/avail = H.get_available_money()

	var/obj/item/weapon/card/debit/C = H.get_active_hand()
	if(istype(C))
		avail += C.get_account().money

	data["avail"] = avail

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "retail.tmpl", "Retail", 450, 320)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE) // BECAUSE

/mob/living/carbon/human/npc/interactable/retail/Topic(href, href_list)
	. = ..()
	var/mob/living/carbon/human/H = usr
	if(!istype(H))
		return

	if(href_list["buy"])
		var/key = href_list["buy"]
		for(var/list/L in products)
			if(L["key"] != key)
				continue
			var/price = L["price"]

			var/avail = H.get_available_money()
			var/obj/item/weapon/card/debit/C = H.get_active_hand()
			if(istype(C))
				avail += C.get_account().money
			else
				C = null

			if(avail < price)
				to_chat(usr, "Not enough cash!")
				return

			var/nL = get_step(loc, dir)

			var/from_card = min(price, C?.get_account().money)
			var/from_cash = price - from_card

			if(from_card > 0)
				if(C.get_account().suspended)
					to_chat(usr, "Your account was suspended")
					return

				C.get_account().add_transaction_log(transaction_owner, L["name"], -price, "Retail terminal")
				C.get_account().money -= from_card
			if(from_cash > 0)
				H.take_cash(from_cash, nL)

			var/ptype = L["type"]
			give_item(H, new ptype(nL))

			if(department)
				var/datum/money_account/department/D = department.bank_account
				D.add_transaction_log(D.owner_name, L["name"], "([price])", "Retailer in [get_area(src)]")
