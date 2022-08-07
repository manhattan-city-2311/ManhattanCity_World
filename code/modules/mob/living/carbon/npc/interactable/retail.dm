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

	nanoui_interactive_dist = 3
	nanoui_update_dist = 3
	nanoui_disabled_dist = 3

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
			var/received = 0
			for(var/obj/item/weapon/spacecash/S in H.contents)
				received += S.worth
				qdel(S)
				if(received >= price)
					break

			spawn(3)
				var/ptype = L["type"]
				H.put_in_hands(new ptype(get_step(loc, dir)))

				var/change = received - price
				if(change)
					spawn(5)
						spawn_money(change, get_step(loc, dir), H)
