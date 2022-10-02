/obj/structure/plasma
	name = "plasma"
	icon = 'icons/obj/manhattan/ambience_generator.dmi'
	icon_state = "off"

	var/static/list/states = list(
		"city_day" = "#86A9CC",
		"city_night" = "#1F456D",
		"beach" = "#53C6FC",
		"aquarium" = "#019ACF",
		"fireplace" = "#B73002",
		"winter" = "#F8F8F8",
		"rain" = "#B6AF9E",
		"planets" = "#453224",
		"forest" = "#9C9A7E",
		"mountains" = "#6D9395",
	)

	var/n_light_range = 5
	var/n_light_power = 5

/obj/structure/plasma/attack_hand(mob/user)
	switch(alert("Select action",, "Cancel", "Change mode", "Switch off"))
		if("Change mode")
			icon_state = input("Choose a new state", "New state") in states
			set_light(n_light_range, n_light_power, l_color = states[icon_state])
			add_overlay(emissive_appearance(icon, icon_state))
		if("Switch off")
			icon_state = "off"
			set_light(0, 0)
			cut_overlays()
		else
			. = ..()
