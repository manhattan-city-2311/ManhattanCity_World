
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
	volume = 8
	var/broken = 0

/obj/item/weapon/reagent_containers/glass/bottle/ampoule/examine(mob/user)
	. = ..()
	if(broken)
		. += "<span class='warning'>[src]'s lid is intact.</span>"
	else
		. += "<span class='warning'>[src]'s lid is broken.</span>"

/obj/item/weapon/reagent_containers/glass/bottle/ampoule/attack_self(mob/user)
	if(!broken)
		broken = 1
		src.visible_message("<span class='warning'>[user] breaks off the [src] lid.</span>")

/obj/item/weapon/reagent_containers/glass/bottle/trioxin
	name = "Trioxin bottle"
	desc = "A small bottle of trioxin. Don't fuck with this shit.."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"
	prefill = list("trioxin" = 60)

/obj/item/weapon/reagent_containers/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"
	prefill = list("cyanide" = 30) //volume changed to match chloral


/obj/item/weapon/reagent_containers/glass/bottle/stoxin
	name = "soporific bottle"
	desc = "A small bottle of soporific. Just the fumes make you sleepy."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"
	prefill = list("stoxin" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/mutagen
	name = "unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-1"
	prefill = list("mutagen" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-1"
	prefill = list("ammonia" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/eznutrient
	name = "EZ NUtrient bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list("eznutrient" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/left4zed
	name = "Left-4-Zed bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list("left4zed" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/robustharvest
	name = "Robust Harvest"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list("robustharvest" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list("diethylamine" = 60)

/obj/item/weapon/reagent_containers/glass/bottle/pacid
	name = "Polytrinic Acid Bottle"
	desc = "A small bottle. Contains a small amount of Polytrinic Acid"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list("pacid" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/adminordrazine
	name = "Adminordrazine Bottle"
	desc = "A small bottle. Contains the liquid essence of the gods."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"
	prefill = list("adminordrazine" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/capsaicin
	name = "Capsaicin Bottle"
	desc = "A small bottle. Contains hot sauce."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list("capsaicin" = 60)


/obj/item/weapon/reagent_containers/glass/bottle/frostoil
	name = "Frost Oil Bottle"
	desc = "A small bottle. Contains cold sauce."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list("frostoil" = 60)

/obj/item/weapon/reagent_containers/glass/bottle/biomass
	name = "biomass bottle"
	desc = "A bottle of raw biomass! Gross!"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"
	prefill = list("biomass" = 60)


//AMPOULES
/obj/item/weapon/reagent_containers/glass/bottle/ampoule/morphine
	name = "morphine ampoule"
	desc = "A tiny ampoule. Contains morphine. 8u."

/obj/item/weapon/reagent_containers/glass/bottle/ampoule/morphine/New()
	..()
	reagents.add_reagent("morphine", volume)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/ampoule/ceftriaxone
	name = "cetriaxone ampoule"
	desc = "A tiny ampoule. Contains cetriaxone. 8u."

/obj/item/weapon/reagent_containers/glass/bottle/ampoule/ceftriaxone/New()
	..()
	reagents.add_reagent("ceftriaxone", volume)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/ampoule/glucose
	name = "glucose ampoule"
	desc = "A tiny ampoule. Contains glucose. 8u."

/obj/item/weapon/reagent_containers/glass/bottle/ampoule/glucose/New()
	..()
	reagents.add_reagent("glucose", volume)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/ampoule/insulin
	name = "insulin ampoule"
	desc = "A tiny ampoule. Contains insulin. 2u."
	volume = 2

/obj/item/weapon/reagent_containers/glass/bottle/ampoule/insulin/New()
	..()
	reagents.add_reagent("insulin", volume)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/lidocaine
	name = "lidocaine ampoule"
	desc = "A small ampoule. Contains lidocaine. 5u"
	volume = 5

/obj/item/weapon/reagent_containers/glass/bottle/lidocaine/New()
	..()
	reagents.add_reagent("lidocaine", volume)
	update_icon()

//BOTTLES
/obj/item/weapon/reagent_containers/glass/bottle/glucagone
	name = "glucagone bottle"
	desc = "A small bottle. Contains glucagone."

/obj/item/weapon/reagent_containers/glass/bottle/glucagone/New()
	..()
	reagents.add_reagent("glucagone", volume)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/adenosine
	name = "adenosine bottle"
	desc = "A small bottle. Contains adenosine."

/obj/item/weapon/reagent_containers/glass/bottle/adenosine/New()
	..()
	reagents.add_reagent("adenosine", volume)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/amiodarone
	name = "amiodarone bottle"
	desc = "A small bottle. Contains amiodarone."

/obj/item/weapon/reagent_containers/glass/bottle/amiodarone/New()
	..()
	reagents.add_reagent("amiodarone", volume)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/dopamine
	name = "dopamine bottle"
	desc = "A small bottle. Contains dopamine."

/obj/item/weapon/reagent_containers/glass/bottle/dopamine/New()
	..()
	reagents.add_reagent("dopamine", volume)
	update_icon()