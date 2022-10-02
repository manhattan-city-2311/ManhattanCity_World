// Anyone that fixed this my code on Infinity - thank you. ~~~ _Elar_

/proc/clamphex(hex, bmin, bmax=255)
	. = hex
	var/list/bgr = ReadRGB(hex)
	if(length(bgr) == 3)
		for(var/i in bgr)
			i = clamp(i, bmin, bmax)
		. = rgb(bgr[1], bgr[2], bgr[3])


#define HOLOPLANT_REC_COLORS COLOR_LIGHTING_RED_BRIGHT, COLOR_LIGHTING_BLUE_BRIGHT, COLOR_LIGHTING_GREEN_BRIGHT, COLOR_LIGHTING_ORANGE_BRIGHT, COLOR_LIGHTING_PURPLE_BRIGHT, COLOR_LIGHTING_CYAN_BRIGHT, LIGHT_COLOR_HOTPINK, LIGHT_COLOR_NEONGREEN, LIGHT_COLOR_NEONRED, LIGHT_COLOR_NEONYELLOW, LIGHT_COLOR_NEONLIGHTBLUE, LIGHT_COLOR_NEONBLUE, LIGHT_COLOR_NEONDARKBLUE, LIGHT_COLOR_NEONORANGE
GLOBAL_LIST_INIT(recomended_holoplants_colors,list(HOLOPLANT_REC_COLORS))
/obj/machinery/holoplant
	name = "holograph"
	desc = "An strange flower pot. It have something like holograph projector."
	icon = 'icons/infinity/holoplants.dmi'
	icon_state = "holopot"
	w_class = ITEMSIZE_TINY

	emagged = FALSE
	var/interference = FALSE

	var/brightness_on = 2
	var/enabled = TRUE

	var/icon/plant = null
	var/plant_color
	var/list/colors_clamp = 60
	var/hologram_opacity = 0.85

	var/tmp/list/possible_states
	var/tmp/list/emagged_states


/obj/machinery/holoplant/initialize()
	. = ..()
	update_icon()

/obj/machinery/holoplant/proc/parse_icon()
	possible_states = list()
	emagged_states = list()
	var/list/states = icon_states(icon)
	for(var/i in states)
		var/list/state_splittext = splittext(i, "-")
		if(length(state_splittext) > 1)
			if(istext(state_splittext[1]))
				var/t = state_splittext[1]
				var/list/add2
				if(t == "P")
					add2 = possible_states
				else if(t == "E")
					add2 = emagged_states
				add2[state_splittext[2]] = i

/obj/machinery/holoplant/power_change()
	. = ..()
	set_enabled(!(stat & (BROKEN|NOPOWER)))

/obj/machinery/holoplant/update_icon()
	if(!islist(possible_states))
		parse_icon()
	cut_overlays(force_compile = TRUE)
	hologram_opacity = (emagged ? 0.95 : initial(hologram_opacity))
	change_plant(plant)
	change_color(plant_color)

	if(enabled)
		add_overlay(plant)
		add_overlay(emissive_appearance(plant))
		use_power = 2
	else
		use_power = 0
	set_light(enabled ? brightness_on : 0, 10, plant_color)
/obj/machinery/holoplant/proc/get_states_list()
	return (emagged ? emagged_states : possible_states)

/obj/machinery/holoplant/proc/change_plant(var/state, list/states)
	if(length(states))
		state = states[state]
	plant = prepare_icon(state)

/obj/machinery/holoplant/proc/prepare_icon(var/state)
	if(!istext(state))
		var/L = get_states_list()
		state = L[pick(L)]

	var/plant_icon = icon(icon, state)
	return getHologramIcon(plant_icon, TRUE, nopacity = hologram_opacity)

/obj/machinery/holoplant/proc/change_color(var/ncolor)
	if (!plant)
		return
	if(!ncolor)
		ncolor = pick(GLOB.recomended_holoplants_colors)
//	ncolor = clamphex(ncolor, (islist(colors_clamp) && length(colors_clamp)) ? (colors_clamp[1], colors_clamp[2]) : (colors_clamp, 255))
	if(islist(colors_clamp) && length(colors_clamp))
		ncolor = clamphex(ncolor, colors_clamp[1], colors_clamp[2])
	else
		ncolor = clamphex(ncolor, colors_clamp)
	plant_color = ncolor
	plant.ColorTone(ncolor)

	set_light(l_color = ncolor)

/obj/machinery/holoplant/attack_hand(mob/user)
	if(!interference)
		switch(alert("What do you want?",,"Color", "Cancel", "Hologram"))
			if("Color")
				change_color(input("Select New color", "Color", plant_color) as color)
			if("Hologram")
				var/list/SL = get_states_list()
				change_plant(input("Select Hologram", "Hologram") in SL, SL)
		update_icon()

/obj/machinery/holoplant/attackby(obj/item/I, mob/user, click_params)
	if(istype(I, /obj/item/weapon/card/id))
		if(!emagged)
			emag_act()
			to_chat(user, SPAN_NOTICE("\icon[src] [src] beeps."))
		else
			rollback()
			to_chat(user, SPAN_NOTICE("\icon[src] [src] boops."))
		playsound(src, 'sound/machines/button1.ogg', 70)
		return TRUE
	if(ismultitool(I))
		set_enabled(!enabled)
		to_chat(usr, SPAN_NOTICE("You switch [enabled ? "on" : "off"] the [src]"))
		return TRUE
	return ..()

/obj/machinery/holoplant/proc/set_enabled(value)
	if(enabled != value)
		enabled = value
		update_icon()

/obj/machinery/holoplant/proc/rollback()
	emagged = FALSE
	change_plant()
	update_icon()

/obj/machinery/holoplant/emag_act()
	emagged = TRUE
	change_plant()
	update_icon()

/obj/machinery/holoplant/proc/Interference() //should not have any returns, cuz of waitfor = 0
	set waitfor = 0
	interference = TRUE
	overlays -= plant
	set_light(0, 0, plant_color)
	sleep(3)
	if(QDELETED(src))
		return

	overlays += plant
	set_light(brightness_on, 1, plant_color)
	sleep(3)
	if(QDELETED(src))
		return

	overlays -= plant
	set_light(0, 0, plant_color)
	sleep(3)
	if(QDELETED(src))
		return
	update_icon()

	interference = FALSE

/obj/machinery/holoplant/proc/doInterference()
	if(!interference && enabled)
		// addtimer(CALLBACK(src, .proc/Interference), 0, TIMER_STOPPABLE)
		Interference()
/obj/machinery/holoplant/Crossed(var/mob/living/L)
	if(istype(L))
		doInterference()

/obj/machinery/holoplant/shipped
	anchored = FALSE
