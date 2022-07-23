
//Not to be confused with /obj/item/weapon/reagent_containers/food/drinks/bottle

/obj/item/weapon/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30)
	flags = 0
	volume = 30
	matter = list("glass" = 50)

/obj/item/weapon/reagent_containers/glass/bottle/open
	flags = OPENCONTAINER


/obj/item/weapon/reagent_containers/glass/bottle/can_empty()
	return TRUE

/obj/item/weapon/reagent_containers/glass/bottle/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/pickup(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/dropped(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/attack_hand()
	..()
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/New()
	..()
	if(!icon_state)
		icon_state = "bottle-[rand(1,4)]"

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
	

/obj/item/weapon/reagent_containers/glass/bottle/update_icon()
	overlays.Cut()

	if(reagents.total_volume && (icon_state == "bottle-1" || icon_state == "bottle-2" || icon_state == "bottle-3" || icon_state == "bottle-4"))
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)		filling.icon_state = "[icon_state]--10"
			if(10 to 24) 	filling.icon_state = "[icon_state]-10"
			if(25 to 49)	filling.icon_state = "[icon_state]-25"
			if(50 to 74)	filling.icon_state = "[icon_state]-50"
			if(75 to 79)	filling.icon_state = "[icon_state]-75"
			if(80 to 90)	filling.icon_state = "[icon_state]-80"
			if(91 to INFINITY)	filling.icon_state = "[icon_state]-100"

		filling.color = reagents.get_color()
		overlays += filling

	if (!is_open_container())
		var/image/lid = image(icon, src, "lid_bottle")
		overlays += lid

/obj/item/weapon/reagent_containers/glass/bottle/ampoule
	name = "glass ampoule"
	desc = "A tiny ampoule."
	icon_state = "ampoule"
	volume = 10
	w_class = ITEMSIZE_TINY

/obj/item/weapon/reagent_containers/glass/bottle/trioxin
	name = "Trioxin bottle"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"
	prefill = list("trioxin" = 60)

/obj/item/weapon/reagent_containers/glass/bottle/cyanide
	name = "cyanide bottle"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"
	prefill = list("cyanide" = 30) //volume changed to match chloral


/obj/item/weapon/reagent_containers/glass/bottle/stoxin
	name = "soporific bottle"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"
	prefill = list("stoxin" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/mutagen
	name = "unstable mutagen bottle"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-1"
	prefill = list("mutagen" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-1"
	prefill = list("ammonia" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/eznutrient
	name = "EZ NUtrient bottle"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list("eznutrient" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/left4zed
	name = "Left-4-Zed bottle"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list("left4zed" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/robustharvest
	name = "Robust Harvest"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list("robustharvest" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list("diethylamine" = 60)

/obj/item/weapon/reagent_containers/glass/bottle/pacid
	name = "Polytrinic Acid Bottle"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list("pacid" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/adminordrazine
	name = "Adminordrazine Bottle"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"
	prefill = list("adminordrazine" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/capsaicin
	name = "Capsaicin Bottle"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list("capsaicin" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/frostoil
	name = "Frost Oil Bottle"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list("frostoil" = 60)

/obj/item/weapon/reagent_containers/glass/bottle/biomass
	name = "biomass bottle"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"
	prefill = list("biomass" = 60)


//AMPOULES
/obj/item/weapon/reagent_containers/glass/bottle/ampoule/morphine
	name = "morphine ampoule"
	prefill = list("morphine" = 8)

/obj/item/weapon/reagent_containers/glass/bottle/ampoule/ceftriaxone
	name = "cetriaxone ampoule"
	prefill = list("cetriaxone" = 8)

/obj/item/weapon/reagent_containers/glass/bottle/ampoule/glucose
	name = "glucose ampoule"
	prefill = list("glucose" = 8)

/obj/item/weapon/reagent_containers/glass/bottle/ampoule/insulin
	name = "insulin ampoule"
	prefill = list("insulin" = 2)

/obj/item/weapon/reagent_containers/glass/bottle/ampoule/lidocaine
	name = "lidocaine ampoule"
	prefill = list("lidocaine" = 5)

/obj/item/weapon/reagent_containers/glass/bottle/ampoule/esmolol
	name = "esmolol ampoule"
	prefill = list("esmolol" = 5)

/obj/item/weapon/reagent_containers/glass/bottle/ampoule/amicile
	name = "amicile ampoule"
	prefill = list("amicile" = 8)

//BOTTLES
/obj/item/weapon/reagent_containers/glass/bottle/glucagone
	name = "glucagone bottle"
	prefill = list("glucagone" = 30)

/obj/item/weapon/reagent_containers/glass/bottle/adenosine
	name = "adenosine bottle"
	prefill = list("adenosine" = 30)

/obj/item/weapon/reagent_containers/glass/bottle/amiodarone
	name = "amiodarone bottle"
	prefill = list("amiodarone" = 30)

/obj/item/weapon/reagent_containers/glass/bottle/dopamine
	name = "dopamine bottle"
	prefill = list("dopamine" = 30)