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

	addDescriptionAboutReagents()

/obj/item/weapon/reagent_containers/ivpack/empty
	name = "Empty IV Pack"



/obj/item/weapon/reagent_containers/ivpack/insulin_glucagone
	name = "Insulin-Glucagone Pack"
	prefill = list("insulin" = 150, "glucagone" = 150, "salinesolution" = 1200)

/obj/item/weapon/reagent_containers/ivpack/nutrition
	name = "Nutrition Pack"
	prefill = list("glucagone" = 150, "salinesolution" = 1350)

/obj/item/weapon/reagent_containers/ivpack/antibiotics
	name = "Agressive Antibiotics Pack"
	prefill = list("amicile" = 175, "cetrifiaxone" = 175, "penicillin" = 175, "corophizine" = 175, "salinesolution" = 800)

/obj/item/weapon/reagent_containers/ivpack/sodium_bicarbonate
	name = "Sodium Bicarbonate Pack"
	prefill = list("sodiumbicarbonate" = 150, "salinesolution" = 1350)