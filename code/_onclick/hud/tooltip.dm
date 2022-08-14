// Thank to Quardbreak (Bill-luxe) and _Elar_
/client
	var/obj/screen/tooltip/tooltip

/obj/screen/tooltip
	// icon = 'infinity/icons/tooltip.dmi'
	icon_state = "blank"
	screen_loc = "TOP, CENTER - 3"
	plane = PLANE_PLAYER_HUD
	layer = LAYER_HUD_ABOVE
	maptext_width = 256
	maptext_x = -16
	var/state = TRUE
	var/maptext_style = "font-family: 'Small Fonts';"

/obj/screen/tooltip/proc/SetMapText(newValue, forcedFontColor = "#ffffff", tooltip_text_shadow_color, atom/H)
	if(!tooltip_text_shadow_color && H.light_power && H.light_color)
		tooltip_text_shadow_color = "0 2px 3px [H.light_color]"
		forcedFontColor = H.light_color
	else
		tooltip_text_shadow_color = "0 2px 2px #000000"
	var/style = "color:[forcedFontColor]; text-shadow: [tooltip_text_shadow_color]; [maptext_style]"
	maptext = "<center><span style=\"[style]\">[newValue]</span></center>"

/obj/screen/tooltip/proc/set_state(new_state)
	if(new_state == state)
		return
	state = new_state
	set_invisibility(state ? initial(invisibility) : INVISIBILITY_MAXIMUM)

/client/New(TopicData)
	. = ..()
	tooltip = new()
	// var/value = is_preference_enabled(/datum/client_preference/tooltip)
	// if(value)
	// 	tooltip.set_state(TRUE) //value
	// else
	// 	tooltip.set_state(FALSE) //value
	tooltip.set_state(is_preference_enabled(/datum/client_preference/tooltip))

/client/MouseEntered(atom/hoverOn, location, control, params)
	. = ..()
	if(tooltip?.state && Master.current_runlevel > RUNLEVEL_SETUP)
		screen |= tooltip
		// hoverOn.update_tooltip_data()
		tooltip.SetMapText(hoverOn.name, hoverOn.tooltip_text_color, hoverOn.tooltip_text_shadow_color, hoverOn)/*, istext(hoverOn.color) ? hoverOn.color : null*/
/atom
	var/tooltip_text_color
	var/tooltip_text_shadow_color
/atom/proc/update_tooltip_data()

// /obj/structure/sign/neon
// 	tooltip_text_shadow_color = "0 0 6px #00ffff"
// /obj/structure/sign/neon/update_tooltip_data()
// 	. = ..()
// 	tooltip_text_color = light_color
// 	tooltip_text_shadow_color = "0 0 6px " + light_color

// /obj/machinery/light/colored
// 	tooltip_text_shadow_color = "0 0 6px #00ffff"
// /obj/machinery/light/colored/update_tooltip_data()
// 	. = ..()
// 	tooltip_text_color = light_color
// 	tooltip_text_shadow_color = "0 0 6px " + light_color

/datum/client_preference/tooltip
	description = "Show Tooltip"
	key = "SHOW_TOOLTIP"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/tooltip/toggled(mob/preference_mob, enabled)
	var/client/C = preference_mob.client
	C.tooltip.set_state(enabled)

