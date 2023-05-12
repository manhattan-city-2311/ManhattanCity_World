//Geiger counter
//Rewritten version of TG's geiger counter
//I opted to show exact radiation levels

/obj/item/device/geiger
	name = "geiger counter"
	desc = "A handheld device used for detecting and measuring radiation in an area."
	icon_state = "geiger_off"
	item_state = "multitool"
	w_class = ITEMSIZE_SMALL
	var/scanning = 0
	var/radiation_count = 0
	tax_type = ELECTRONICS_TAX

/obj/item/device/geiger/New()
	processing_objects |= src

/obj/item/device/geiger/Destroy()
	processing_objects -= src
	return ..()

/obj/item/device/geiger/process()
	get_radiation()

/obj/item/device/geiger/proc/get_radiation()
	if(!scanning)
		return
	update_icon()

/obj/item/device/geiger/examine(mob/user)
	..(user)
	get_radiation()
	to_chat(user, "<span class='warning'>[scanning ? "Ambient" : "Stored"] radiation level: [radiation_count ? radiation_count : "0"]Bq.</span>")

/obj/item/device/geiger/attack_self(var/mob/user)
	scanning = !scanning
	update_icon()
	to_chat(user, "<span class='notice'>\icon[src] You switch [scanning ? "on" : "off"] \the [src].</span>")

/obj/item/device/geiger/update_icon()
	if(!scanning)
		icon_state = "geiger_off"
		return 1

	switch(radiation_count)
		if(null)
			icon_state = "geiger_on_1"
		if(NEGATIVE_INFINITY to RAD_LEVEL_LOW)
			icon_state = "geiger_on_1"
		if(RAD_LEVEL_LOW to RAD_LEVEL_MODERATE)
			icon_state = "geiger_on_2"
		if(RAD_LEVEL_MODERATE to RAD_LEVEL_HIGH)
			icon_state = "geiger_on_3"
		if(RAD_LEVEL_HIGH to RAD_LEVEL_VERY_HIGH)
			icon_state = "geiger_on_4"
		if(RAD_LEVEL_VERY_HIGH to POSITIVE_INFINITY)
			icon_state = "geiger_on_5"

#undef RAD_LEVEL_LOW
#undef RAD_LEVEL_MODERATE
#undef RAD_LEVEL_HIGH
#undef RAD_LEVEL_VERY_HIGH
