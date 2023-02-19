/obj/screen/vehicle_ui_overlay
	var/global/screen_x
	var/global/screen_y
	var/global/screen_x_offset
	var/global/screen_y_offset
	layer = LAYER_HUD_BASE + 0.1

/obj/screen/vehicle_ui_overlay/New()
	. = ..()
	if(screen_x)
		return

	var/list/splitted_screen_loc = splittext(ui_vehicle_ui, ",")
	var/list/screen_locs = splittext(splitted_screen_loc[1], ":") + splittext(splitted_screen_loc[2], ":")

	screen_x = screen_locs[1]
	screen_x_offset = text2num(screen_locs[2])
	screen_y = screen_locs[3]
	screen_y_offset = text2num(screen_locs[4])

// @params: offsets NOTE: only bruteforce
/obj/screen/vehicle_ui_overlay/proc/set_screen_loc(x, y)
	screen_loc = "[screen_x]:[screen_x_offset + x - 2],[screen_y]:[44 + screen_y_offset - y]"

/obj/screen/vehicle_ui_overlay/speed
	name = "speed"
	icon = 'icons/vehicles/ui/speed.dmi'

/obj/screen/vehicle_ui_overlay/speed/New(number, index, is_blinking)
	. = ..()
	icon_state = "[round(number)][is_blinking ? "b" : null]"
	set_screen_loc(26 * (3 - index), 12)

/obj/screen/vehicle_ui_overlay/taho
	name = "tahometer"
	icon = 'icons/vehicles/ui/taho.dmi'

/obj/screen/vehicle_ui_overlay/taho/New(percentage)
	. = ..()
	icon_state = "[min(round(percentage, 7), 98)]"
	set_screen_loc(70, 38)

/obj/screen/vehicle_ui_overlay/select
	name = "selected gear"
	icon = 'icons/vehicles/ui/gear.dmi'
	
/obj/screen/vehicle_ui_overlay/select/New(gear)
	. = ..()
	icon_state = "gear_[gear]"
	set_screen_loc(152, 17)

/obj/screen/vehicle_ui_overlay/fuel
	name = "fuel"
	icon = 'icons/vehicles/ui/fuel.dmi'

/obj/screen/vehicle_ui_overlay/fuel/New(percentage)
	. = ..()
	icon_state = "[round(percentage, 3)]"
	set_screen_loc(163, 33)
	
/mob/var/obj/screen/vehicle_ui/vehicle_ui
/obj/screen/vehicle_ui
	name = "Vehicle dashboard"
	icon = 'icons/vehicles/ui/ui.dmi'
	screen_loc = ui_vehicle_ui
	var/obj/manhattan/vehicle/vehicle
	var/list/owned_overlays = list()
	var/mob/my_mob

/obj/screen/vehicle_ui/New(owner)
	. = ..()
	my_mob = owner

/obj/screen/vehicle_ui/proc/remove_overlays()
	my_mob.client?.screen -= owned_overlays
	QDEL_LIST(owned_overlays)
	owned_overlays.Cut()

/obj/screen/vehicle_ui/proc/append_overlay(noverlay)
	owned_overlays += noverlay
	my_mob.client?.screen += noverlay

/obj/screen/vehicle_ui/Destroy()
	remove_overlays()
	. = ..()

/obj/screen/vehicle_ui/update_icon()
	remove_overlays()

	if(!vehicle)
		return

	var/speed = TO_KPH(vehicle.speed.modulus())

	var/is_blinking = speed > 199
	if(is_blinking)
		speed = 199

	if(speed > 1)
		var/zeroes_cutted = null
		for(var/i = 3, i >= 1, --i)
			var/x = speed % (10 ** i) / 10 ** (i - 1)
			if(!zeroes_cutted)
				if(x >= 1)
					zeroes_cutted = TRUE
				else
					continue
			append_overlay(new /obj/screen/vehicle_ui_overlay/speed(x, i, is_blinking))
	else
		append_overlay(new /obj/screen/vehicle_ui_overlay/speed(0, 1, FALSE))
	
	var/obj/item/vehicle_part/engine/engine = vehicle.components[VC_ENGINE]
	if(engine)
		append_overlay(new /obj/screen/vehicle_ui_overlay/taho((engine.rpm / engine.max_rpm) * 100))
	
	var/obj/item/vehicle_part/gearbox/gearbox = vehicle.components[VC_GEARBOX]
	if(gearbox)
		append_overlay(new /obj/screen/vehicle_ui_overlay/select(gearbox.selected_gear))
		
	append_overlay(new /obj/screen/vehicle_ui_overlay/fuel((vehicle.get_fuel_amount() / vehicle.get_fuel_capacity()) * 100))

/obj/manhattan/vehicle/proc/update_ui()
	for(var/mob/M in get_occupants_in_position(VP_DRIVER))
		if(M.vehicle_ui && M.client)
			M.vehicle_ui.update_icon()
			M.client.screen |= M.vehicle_ui
