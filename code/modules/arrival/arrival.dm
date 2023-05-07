/obj/effect/arrival_stop
	icon = 'icons/effects/effects.dmi'
	icon_state = "rift"
	var/order = 0

/obj/effect/arrival_stop/initialize()
	. = ..()
	ADD_SORTED(SSarrival.stops, src, GLOBAL_PROC_REF(cmp_arrival_stop))
	icon_state = null

/obj/effect/arrival_stop/Destroy()
	SSarrival.stops -= src
	. = ..()

#define ASD_FONT_SIZE "6pt"
#define ASD_FONT_COLOR "#fff"
#define ASD_ARRIVED_FONT_COLOR LIGHT_COLOR_NEONLIGHTBLUE
#define ASD_FONT "Small Fonts"

/obj/machinery/arrival_status_display
	name = "hyperloop status display"
	icon = 'icons/obj/status_display_wide.dmi'
	icon_state = "frame"
	maptext_height = 26
	maptext_width = 64
	var/display_length = 12
	var/text_shift = 1

/obj/machinery/arrival_status_display/initialize()
	. = ..()
	add_overlay(emissive_appearance(icon, "emissive"))
	STOP_MACHINE_PROCESSING(src)
	START_PROCESSING(SSfastprocess, src)

/obj/machinery/arrival_status_display/proc/set_text(line1, line2, font_color = ASD_FONT_COLOR)
	var/new_text = {"<div style="font-size:[ASD_FONT_SIZE];color:[font_color];font:'[ASD_FONT]';text-align:center;" valign="top">[line1]<br>[line2]</div>"}
	if(maptext != new_text)
		maptext = new_text

/obj/machinery/arrival_status_display/proc/get_eta_text(timeleft)
	timeleft /= 1 SECOND
	return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"

/obj/machinery/arrival_status_display/proc/shift_text(text)
	text += " "
	var/len = length_char(text)

	if(len <= display_length)
		return text

	. = copytext_char(text, text_shift, text_shift + display_length)
	if(text_shift + display_length - 1 > len)
		. += copytext_char(text, 1, text_shift + display_length - len)

	if(++text_shift == len)
		text_shift = 1


/obj/machinery/arrival_status_display/process()
	var/time_left = max(0, SSarrival.next - world.time)
	var/station_name
	if(SSarrival.current_stop)
		station_name = shift_text(uppertext(get_area(SSarrival.stops[SSarrival.current_stop]).name))

	switch(SSarrival.arrival_state)
		if(ARRIVAL_HOLD)
			if(SSarrival.next)
				set_text(station_name, get_eta_text(time_left))
			else
				set_text("", "")
		if(ARRIVAL_INCOMING)
			set_text(station_name, get_eta_text(time_left))
		if(ARRIVAL_WAITING)
			set_text(station_name, "Depart in [get_eta_text(time_left)]", font_color = ASD_ARRIVED_FONT_COLOR)
				


/obj/hyperloop_renderer
	name = "hyperloop tunnell"
	icon = 'icons/effects/arrival.dmi'
	icon_state = "static"
	density = TRUE
	opacity = TRUE
	appearance_flags = DEFAULT_APPEARANCE_UNBOUND

/obj/hyperloop_renderer/initialize()
	. = ..()
	tag = "@hyperloop_renderer"

/obj/hyperloop_display
	name = ""
	icon = 'icons/effects/arrival.dmi'
	icon_state = "static"
	density = TRUE
	opacity = TRUE
	appearance_flags = DEFAULT_APPEARANCE_UNBOUND
	
	var/obj/hyperloop_renderer/renderer

/obj/hyperloop_display/update_icon()
	icon = null
	icon_state = null

	vis_contents += renderer

	if(x > renderer.x) // right
		transform = matrix(-1, 0, 0, 0, 1, 0)

	set_light(6, 6, "#952CF4")

/obj/hyperloop_display/initialize()
	. = ..()

	spawn()
		do
			renderer = locate("@hyperloop_renderer")
			sleep(1)
		while(!renderer)
		update_icon()