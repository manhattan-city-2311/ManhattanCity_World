/obj/item/weapon/storage/box/ivpacks
	name = "IV packs box"
	desc = "This box contains infusion packs."
	icon_state = "sterile"
	drop_sound = 'sound/items/drop/food.ogg'

/obj/item/weapon/reagent_containers/ivpack
	name = "IV pack"
	desc = "Holds liquids used for infusion."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "empty"
	item_state = "bloodpack_empty"
	volume = 1500
	var/list/prefill = null

/obj/item/weapon/reagent_containers/ivpack/New()
	..()
	if(LAZYLEN(prefill))
		for(var/R in prefill)
			reagents.add_reagent(R,prefill[R])
		prefill = null
		update_icon()
	desc += " It contains:"
	if(reagents.reagent_list.len > 1)
		for(var/datum/reagent/reagent in reagents.reagent_list)
			desc += " [reagent.name]"
		desc += "."
	else
		var/datum/reagent/reagent = pick(reagents.reagent_list)
		desc += " [reagent.volume]ml of [reagent.name]. [reagent.description]"

	var/cost
	for(var/datum/reagent/reagent in reagents.reagent_list)
		cost += reagent.volume * reagent.price_tag
	desc += " It's cost label reads: [cost]."

/obj/item/weapon/reagent_containers/ivpack/empty
	name = "Empty IV Pack"



/obj/item/weapon/reagent_containers/ivpack/insulin_glucagone
	name = "Insulin-Glucagone Pack"
	prefill = list("insulin" = 750, "glucagone" = 750)

/obj/item/weapon/reagent_containers/ivpack/nutrition
	name = "Nutrition Pack"
	prefill = list("glucagone" = 150, "saline" = 1350)

/obj/item/weapon/reagent_containers/ivpack/antibiotics
	name = "Agressive Antibiotics Pack"
	prefill = list("amicile" = 175, "cetrifiaxone" = 175, "penicillin" = 175, "corophizine" = 175, "saline" = 800)