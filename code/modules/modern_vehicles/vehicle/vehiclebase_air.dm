#define VEHICLE_CONNECT_DELAY 7.5 SECONDS
#define VEHICLE_ITEM_LOAD 3.0 SECONDS
#define TAKEOFF_LAND_DELAY 4 SECONDS
#define WAYPOINT_FLIGHT_DELAY 7.5 SECONDS

/obj/manhattan/vehicle/air
	name = "Dropship"
	desc = "A dropship."

	icon = 'code/modules/modern_vehicles/vehicle/pelican.dmi'
	icon_state = "base"

	density = 1
	anchored = 1

	layer = ABOVE_MOB_LAYER
	plane = -16

	active = 0

	can_traverse_zs = 1

	var/takeoff_overlay_icon_state
	var/takeoff_sound
	var/crash_sound

	vehicle_size = 128//Way too big

/obj/manhattan/vehicle/air/proc/takeoff_vehicle(var/message_n_sound_override = 0)
	active = 1
	change_elevation(2)
	if(!message_n_sound_override)
		visible_message("<span class = 'warning'>[name]'s engines activate, propelling them into the air.</span>")
		if(takeoff_sound)
			playsound(src,takeoff_sound,100,0)
	var/takeoff_overlay = image(icon,takeoff_overlay_icon_state)
	overlays += takeoff_overlay
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	block_enter_exit = 1

/obj/manhattan/vehicle/air/proc/land_vehicle(var/message_n_sound_override = 0)
	active = 0
	change_elevation(-2)
	if(!message_n_sound_override)
		visible_message("<span class = 'warning'>[name]'s engines power down, slowly bringing them to the ground.</span>")
		if(takeoff_sound)
			playsound(src,takeoff_sound,100,0)
	pass_flags = 0
	block_enter_exit = 0
	overlays.Cut()

/obj/manhattan/vehicle/air/verb/takeoff_land()
	set name = "Takeoff/Land"
	set desc = "Takeoff or land."
	set category = "Vehicle"
	set src in range(1)

	if(movement_destroyed)
		to_chat(usr,"<span class = 'notice'>[src]'s engines have been damaged beyond use!</span>")
		return
	if(!(usr in get_occupants_in_position("driver")))
		to_chat(usr,"<span class = 'notice'>You need to be the driver of [name] to do that!</span>")
		return
	to_chat(usr,"<span class = 'notice'>You start prepping [src] for [active ? "landing" : "takeoff"].</span>")
	visible_message("<span class = 'notice'>[src] starts prepping for [active?"landing":"takeoff"].</span>")
	if(!do_after(usr,TAKEOFF_LAND_DELAY,src))
		return
	if(active)
		land_vehicle()
	else
		takeoff_vehicle()

/obj/manhattan/vehicle/air/proc/perform_move_sequence(var/obj/move_to_obj)
	if(isnull(move_to_obj))
		return
	var/move_to_loc = move_to_obj.loc
	loc = move_to_loc

/obj/manhattan/vehicle/air/inactive_pilot_effects()
	//Crashing this vehicle with potential casualties.
	active = 0
	if(elevation <= 0)//Nocrash if we're not flying
		return
	visible_message("<span class = 'danger'>[name] spirals towards the ground, engines uncontrolled!!</span>")
	for(var/mob/living/carbon/human/h in occupants)
		h.adjustBruteLoss(rand(20,50))
	kick_occupants()
	land_vehicle(1)
	if(crash_sound)
		playsound(src,crash_sound,100,0)
	explosion(src.loc,-1,3,4,7)

#undef VEHICLE_CONNECT_DELAY