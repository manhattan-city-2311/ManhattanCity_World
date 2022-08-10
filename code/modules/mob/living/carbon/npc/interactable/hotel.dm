/mob/living/carbon/human/npc/interactable/hotel
	name = "unremarkable receptionist"
	var/list/products = list(
		list(
			"selled" = FALSE,
			"type" = /obj/item/weapon/door/key,
			"number" = "0",
			"price" = 0,
			"key_data" = "",
		)
	)

	var/transaction_owner // For transcations log

	var/datum/department/department

/mob/living/carbon/human/npc/interactable/hotel/initialize()
	. = ..()

	if(department)
		department = dept_by_name(department)

/mob/living/carbon/human/npc/interactable/hotel/testing
	products = list(
		list(
			"selled" = FALSE,
			"type" = /obj/item/weapon/door/key,
			"number" = "11",
			"price" = 400,
			"key_data" = "testing",
		)
	)

/mob/living/carbon/human/npc/interactable/hotel/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
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
		ui = new(user, src, ui_key, "hotel.tmpl", "Hotel renting", 450, 320)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE) // BECAUSE

/mob/living/carbon/human/npc/interactable/hotel/Topic(href, href_list)
	. = ..()
	var/mob/living/carbon/human/H = usr
	if(!istype(H))
		return

	if(href_list["rent"])
		var/number = href_list["rent"]
		for(var/list/L in products)
			if(L["number"] != number)
				continue
			to_world("before selled")
			if(L["selled"])
				return 
			to_world("after selled")
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

			var/from_card = min(price, C?.get_account().money)
			var/from_cash = price - from_card

			if(from_card > 0)
				if(C.get_account().suspended)
					to_chat(usr, "Your account was suspended")
					return

				C.get_account().add_transaction_log(transaction_owner, number, -price, "Hotel terminal")
				C.get_account().money -= from_card

			var/nL = get_step(loc, dir)

			if(from_cash > 0)
				H.take_cash(from_cash, nL)

			var/ptype = L["type"]
			var/key_item = new ptype(nL)
			key_item:key_data = L["key_data"]
			L["selled"] = TRUE

			H.put_in_hands(key_item)

			if(department)
				var/datum/money_account/department/D = department.bank_account
				D.add_transaction_log(D.owner_name, number, "([price])", "Receptionist in [get_area(src)]")
