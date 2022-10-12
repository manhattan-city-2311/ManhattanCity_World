/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
/obj/item/weapon/storage/firstaid
	name = "first aid kit"
	desc = "A cheap first-aid kit for general injuries."
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	max_storage_space = ITEMSIZE_COST_SMALL * 7 // 14
	var/list/icon_variety
	price_tag = 5


/obj/item/weapon/storage/firstaid/initialize()
	. = ..()
	if(icon_variety)
		icon_state = pick(icon_variety)
		icon_variety = null

/obj/item/weapon/storage/firstaid/fire
	name = "fire first aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>accidentally</i> burns down."
	icon_state = "ointment"
	item_state_slots = list(slot_r_hand_str = "firstaid-ointment", slot_l_hand_str = "firstaid-ointment")
	icon_variety = list("ointment","firefirstaid")
	starts_with = list(
		/obj/item/device/healthanalyzer,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/ointment
	)

/obj/item/weapon/storage/firstaid/regular
	icon_state = "firstaid"
	starts_with = list(
		/obj/item/stack/medical/gauze,
		/obj/item/stack/medical/harness,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/ointment,
		/obj/item/device/healthanalyzer
	)

/obj/item/weapon/storage/firstaid/toxin
	name = "poison first aid kit" //IRL the term used would be poison first aid kit.
	desc = "Used to treat when one has a high amount of toxins in their body."
	icon_state = "antitoxin"
	item_state_slots = list(slot_r_hand_str = "firstaid-toxin", slot_l_hand_str = "firstaid-toxin")
	icon_variety = list("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

/obj/item/weapon/storage/firstaid/o2
	name = "oxygen deprivation first aid kit"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state_slots = list(slot_r_hand_str = "firstaid-o2", slot_l_hand_str = "firstaid-o2")

/obj/item/weapon/storage/firstaid/adv
	name = "advanced first aid kit"
	desc = "Contains advanced medical treatments, for <b>serious</b> boo-boos."
	icon_state = "advfirstaid"
	item_state_slots = list(slot_r_hand_str = "firstaid-advanced", slot_l_hand_str = "firstaid-advanced")
	starts_with = list(
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/gauze,
		/obj/item/stack/medical/harness,
		/obj/item/stack/medical/splint,
		/obj/item/stack/medical/ointment
	)

/obj/item/weapon/storage/firstaid/combat
	name = "martial medical kit"
	desc = "Contains treatments used to martial use."
	icon_state = "bezerk"
	item_state_slots = list(slot_r_hand_str = "firstaid-advanced", slot_l_hand_str = "firstaid-advanced")
	starts_with = list(
		/obj/item/weapon/reagent_containers/syringe/morphine = 3,
		/obj/item/weapon/reagent_containers/syringe/adrenaline,
		/obj/item/weapon/reagent_containers/syringe/noradrenaline,
		/obj/item/weapon/reagent_containers/pill/amicile = 3,
		/obj/item/stack/medical/gauze = 2,
		/obj/item/stack/medical/harness,
		/obj/item/stack/medical/splint,
		/obj/item/stack/medical/ointment,
		/obj/item/weapon/surgical/suture
	)

/obj/item/weapon/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport and automatically sterilizes the content between uses."
	icon_state = "surgerykit"
	item_state = "firstaid-surgery"
	max_w_class = ITEMSIZE_NORMAL

	can_hold = list(
		/obj/item/weapon/surgical/bonesetter,
		/obj/item/weapon/surgical/cautery,
		/obj/item/weapon/surgical/suture,
		/obj/item/weapon/surgical/circular_saw,
		/obj/item/weapon/surgical/hemostat,
		/obj/item/weapon/surgical/retractor,
		/obj/item/weapon/surgical/scalpel,
		/obj/item/weapon/surgical/surgicaldrill,
		/obj/item/weapon/surgical/bonegel,
		/obj/item/weapon/surgical/suture,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/nanopaste,
		/obj/item/device/healthanalyzer/advanced
		)

	starts_with = list(
		/obj/item/weapon/surgical/bonesetter,
		/obj/item/weapon/surgical/cautery,
		/obj/item/weapon/surgical/suture,
		/obj/item/weapon/surgical/circular_saw,
		/obj/item/weapon/surgical/hemostat,
		/obj/item/weapon/surgical/retractor,
		/obj/item/weapon/surgical/scalpel,
		/obj/item/weapon/surgical/surgicaldrill,
		/obj/item/weapon/surgical/bonegel,
		/obj/item/weapon/surgical/suture,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/device/healthanalyzer/advanced
		)

/obj/item/weapon/storage/firstaid/clotting
	name = "clotting kit"
	desc = "Contains chemicals to stop bleeding."
	max_storage_space = ITEMSIZE_COST_SMALL * 7
	starts_with = list(/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/clotting = 8)

/*
 * Pill Bottles
 */
/obj/item/weapon/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state_slots = list(slot_r_hand_str = "contsolid", slot_l_hand_str = "contsolid")
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/dice,/obj/item/weapon/paper)
	allow_quick_gather = 1
	allow_quick_empty = 1
	use_to_pickup = 1
	use_sound = null
	max_storage_space = ITEMSIZE_COST_TINY * 14
	max_w_class = ITEMSIZE_TINY

	var/label_text = ""
	var/base_name = " "
	var/base_desc = " "

	matter = list("plastic" = 400)

/obj/item/weapon/storage/pill_bottle/New()
	..()
	base_name = name
	base_desc = desc

/obj/item/weapon/storage/pill_bottle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/pen) || istype(W, /obj/item/device/flashlight/pen))
		var/tmp_label = sanitizeSafe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(length(tmp_label) > 50)
			to_chat(user, "<span class='notice'>The label can be at most 50 characters long.</span>")
		else if(length(tmp_label) > 10)
			to_chat(user, "<span class='notice'>You set the label.</span>")
			label_text = tmp_label
			update_name_label()
		else
			to_chat(user, "<span class='notice'>You set the label to \"[tmp_label]\".</span>")
			label_text = tmp_label
			update_name_label()
	else
		..()

/obj/item/weapon/storage/pill_bottle/proc/update_name_label()
	if(!label_text)
		name = base_name
		desc = base_desc
		return
	else if(length(label_text) > 10)
		var/short_label_text = copytext(label_text, 1, 11)
		name = "[base_name] ([short_label_text]...)"
	else
		name = "[base_name] ([label_text])"
	desc = "[base_desc] It is labeled \"[label_text]\"."

/obj/item/weapon/storage/pill_bottle/antitox
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to counter toxins."

/obj/item/weapon/storage/pill_bottle/penicillin
	name = "bottle of Penicillin pills"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in Pollux."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/penicillin = 14)

/obj/item/weapon/storage/pill_bottle/tramadol
	name = "bottle of Tramadol pills"
	desc = "Contains pills used to relieve pain."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/tramadol = 14)

/obj/item/weapon/storage/pill_bottle/carbon
	name = "bottle of Carbon pills"
	desc = "Contains pills used to neutralise chemicals in the stomach."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/carbon = 14)

/obj/item/weapon/storage/pill_bottle/iron
	name = "bottle of Iron pills"
	desc = "Contains pills used to aid in blood regeneration."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/iron = 14)

/obj/item/weapon/storage/pill_bottle/paracetamol
	name = "bottle of Paracetamol pills"
	desc = "Contains pills used to relieve pain."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/paracetamol = 14)

/obj/item/weapon/storage/pill_bottle/oxycodone
	name = "bottle of Oxycodone pills"
	desc = "Contains pills used to relieve pain."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/oxycodone = 14)

/obj/item/weapon/storage/pill_bottle/amiodarone
	name = "bottle of Amiodarone pills"
	desc = "Contains pills."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/amiodarone = 14)

/obj/item/weapon/storage/pill_bottle/haloperidol
	name = "bottle of Haloperidol pills"
	desc = "Contains pills."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/haloperidol = 14)

/obj/item/weapon/storage/pill_bottle/amicile
	name = "bottle of Amicile pills"
	desc = "Contains pills."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/amicile = 14)

/obj/item/weapon/storage/backpack/dufflebag/med/emt
	name = "emergency medical operations kit"
	desc = "A dufflebag full of supplies for emergency medical operations."
	icon_state = "duffle_emt"
	starts_with = list(
		/obj/item/intubation_tube,
		/obj/item/intubation_baloon,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/defibrillator/loaded,
		/obj/item/weapon/surgical/scalpel,
		/obj/item/stack/medical/gauze,
		/obj/item/stack/medical/harness,
		/obj/item/stack/medical/splint,
		/obj/item/stack/medical/ointment,
		/obj/item/weapon/reagent_containers/glass/bottle/adenosine,
		/obj/item/weapon/reagent_containers/glass/bottle/ampoule/lidocaine,
		/obj/item/weapon/reagent_containers/glass/bottle/ampoule/morphine
	)
