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
	if(get_available_money() < amount)
		return

	for(var/obj/item/weapon/spacecash/S in contents)
		. += S.worth
		qdel(S)
		if(. >= amount)
			break

	spawn_money(amount, dloc, src)

/mob/living/carbon/human/npc/interactable/retail/proc/give_item(mob/living/carbon/human/H, item)
	return H.put_in_hands(item)

/mob/living/carbon/human/npc/interactable/retail/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/list/data = list()

	var/mob/living/carbon/human/H = user

	data["products"] = products
	data["avail"] = H.get_available_money()

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
			if(H.get_available_money() < price)
				to_chat(usr, "Not enough cash!")
				return

			var/nL = get_step(loc, dir)

			if(H.take_cash(price, nL))
				var/ptype = L["type"]
				give_item(H, new ptype(nL))
