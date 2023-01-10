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
			if(L["selled"])
				return

			var/nL = get_step(loc, dir)
			if(!H.take_money(L["price"], nL, department, transaction_owner, number, "Receptionist in [get_area(src)]"))
				return

			var/ptype = L["type"]
			var/key_item = new ptype(nL)
			key_item:key_data = L["key_data"]
			L["selled"] = TRUE

			H.put_in_hands(key_item)
