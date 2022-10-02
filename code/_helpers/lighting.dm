/// Produces a mutable appearance glued to the [EMISSIVE_PLANE] dyed to be the [EMISSIVE_COLOR].
/proc/emissive_appearance(icon, icon_state = "", layer = FLOAT_LAYER, alpha = 255, appearance_flags = EMISSIVE_APPEARANCE)
	var/mutable_appearance/appearance = mutable_appearance(icon, icon_state, layer, EMISSIVE_PLANE, alpha, appearance_flags)
	appearance.color = EMISSIVE_COLOR
	return appearance

