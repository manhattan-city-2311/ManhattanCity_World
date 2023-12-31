var/list/outfits_decls_ = list()
var/decl/hierarchy/outfit/outfits_decls_root_ = list()
var/list/outfits_decls_by_type_ = list()

/proc/outfit_by_type(var/outfit_type)
	if(!outfits_decls_root_)
		init_outfit_decls()
	return outfits_decls_by_type_["[outfit_type]"]

/proc/outfits()
	if(!outfits_decls_root_)
		init_outfit_decls()
	return outfits_decls_

/proc/init_outfit_decls()
	if(outfits_decls_root_)
		return
	outfits_decls_ = list()
	outfits_decls_by_type_ = list()
	outfits_decls_root_ = new/decl/hierarchy/outfit()

/decl/hierarchy/outfit
	name = "Naked"

	var/uniform = null
	var/suit = null
	var/back = null
	var/belt = null
	var/gloves = null
	var/shoes = null
	var/head = null
	var/mask = null
	var/l_ear = null
	var/r_ear = null
	var/glasses = null
	var/id = null
	var/l_pocket = null
	var/r_pocket = null
	var/suit_store = null
	var/r_hand = null
	var/l_hand = null
	var/list/backpack_contents = list() // In the list(path=count,otherpath=count) format

	var/id_type
	var/id_desc
	var/id_slot

	var/pda_type
	var/pda_slot

	var/id_pda_assignment

	var/backpack = /obj/item/weapon/storage/backpack
	var/satchel_one  = /obj/item/weapon/storage/backpack/satchel/norm
	var/satchel_two  = /obj/item/weapon/storage/backpack/satchel
	var/messenger_bag = /obj/item/weapon/storage/backpack/messenger

	var/flags // Specific flags

	var/undress = 1	//Does the outfit undress the mob upon equp?

/decl/hierarchy/outfit/New()
	..()

	if(is_hidden_category())
		return
	outfits_decls_by_type_["[type]"] = src
	dd_insertObjectList(outfits_decls_, src)

/decl/hierarchy/outfit/proc/pre_equip(mob/living/carbon/human/H)
	if(flags & OUTFIT_HAS_BACKPACK)
		switch(H.backbag)
			if(2) back = backpack
			if(3) back = satchel_one
			if(4) back = satchel_two
			if(5) back = messenger_bag
			else back = null

/decl/hierarchy/outfit/proc/post_equip(mob/living/carbon/human/H)
	for(var/obj/item/O in H.GetAllContents())

		if(istype(O, /obj/item/weapon/card/department))
			var/obj/item/weapon/card/department/D = O
			D.owner_name = H.real_name
			D.update_name()

	if(flags & OUTFIT_HAS_JETPACK)
		var/obj/item/weapon/tank/jetpack/J = locate(/obj/item/weapon/tank/jetpack) in H
		if(!J)
			return
		J.toggle()
		J.toggle_valve()

/decl/hierarchy/outfit/proc/equip(mob/living/carbon/human/H, var/rank, var/assignment)
	equip_base(H)

	rank = rank || id_pda_assignment
	assignment = id_pda_assignment || assignment || rank
	equip_communicator(H,rank)

	for(var/path in backpack_contents)
		var/number = backpack_contents[path]
		for(var/i=0,i<number,i++)
			H.equip_to_slot_or_del(new path(H), slot_in_backpack)

	post_equip(H)
	return 1

/decl/hierarchy/outfit/proc/equip_base(mob/living/carbon/human/H)
	pre_equip(H)

	//Start with uniform,suit,backpack for additional slots
	if(uniform)
		H.equip_to_slot_or_del(new uniform(H),slot_w_uniform)
	if(suit)
		H.equip_to_slot_or_del(new suit(H),slot_wear_suit)
	if(back)
		H.equip_to_slot_or_del(new back(H),slot_back)
	if(belt)
		H.equip_to_slot_or_del(new belt(H),slot_belt)
	if(gloves)
		H.equip_to_slot_or_del(new gloves(H),slot_gloves)
	if(shoes)
		H.equip_to_slot_or_del(new shoes(H),slot_shoes)
	if(mask)
		H.equip_to_slot_or_del(new mask(H),slot_wear_mask)
	if(head)
		H.equip_to_slot_or_del(new head(H),slot_head)
	if(l_ear)
		H.equip_to_slot_or_del(new l_ear(H),slot_l_ear)
	if(r_ear)
		H.equip_to_slot_or_del(new r_ear(H),slot_r_ear)
	if(glasses)
		H.equip_to_slot_or_del(new glasses(H),slot_glasses)
	if(l_pocket)
		H.equip_to_slot_or_del(new l_pocket(H),slot_l_store)
	if(r_pocket)
		H.equip_to_slot_or_del(new r_pocket(H),slot_r_store)
	if(suit_store)
		H.equip_to_slot_or_del(new suit_store(H),slot_s_store)

	if(l_hand)
		H.put_in_l_hand(new l_hand(H))
	if(r_hand)
		H.put_in_r_hand(new r_hand(H))
	if (!H)
		if(H.species)
			H.species.equip_survival_gear(H, flags&OUTFIT_EXTENDED_SURVIVAL, flags&OUTFIT_COMPREHENSIVE_SURVIVAL)

/decl/hierarchy/outfit/proc/equip_communicator(mob/living/carbon/human/H, rank)
//	if(!pda_slot || !pda_type)
//		return
	if(!pda_slot)
		return
	var/obj/item/device/communicator/phone = new
	if(H.equip_to_slot_or_del(phone, pda_slot))
		// phone.owner = H.real_name
		// phone.occupation = rank
		// phone.name = "[H.real_name]'s communicator"
		phone.register_device(H.real_name)
		return phone

/decl/hierarchy/outfit/dd_SortValue()
	return name
