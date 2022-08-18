#define RPM_IDLE 700
#define RPM_SLOW 2000
#define RPM_MED  3500
#define RPM_FAST 6500

#define VC_ENGINE "engine"

/obj/item/vehicle_part/engine
	name = "car engine"
	icon_state = "engine"
	armor = 50
	id = VC_ENGINE
	break_sound = 'sound/vehicles/modern/vehicle_running_out_of_gas.ogg'
	var/stop_sound = 'sound/vehicles/modern/vehicle_turned_off.ogg'
	var/start_sound = 'sound/vehicles/modern/vehicle_start.ogg'
	var/failstart_sound = 'sound/vehicles/modern/vehicle_failing_to_start.ogg'
	break_message = "<span class = 'danger'>The car's engine whines like an injured animal and shuts down!</span>"

	// Note:
	var/list/xs = list(0, 400, 1000, 2000, 3000, 4000, 5000, 5500, 6000)
	var/list/ys = list(0, 60, 140,   150,  160,  175,  155,  144,  122)
	var/max_rpm = 6200

	mass = 70
	var/tmp/rpm = 0

/obj/item/vehicle_part/engine/fail()
	..()
	vehicle.active = FALSE
	needs_processing = FALSE

/obj/item/vehicle_part/engine/proc/start()
	if(prob(integrity))
		needs_processing = TRUE
		playsound(vehicle, start_sound, 150, 1, 5)
		spawn(15)
			playsound(vehicle, 'sound/vehicles/modern/zb_fb_med.ogg', 7)
			rpm = RPM_IDLE
	else
		playsound(vehicle, failstart_sound, 150, 1, 5)

/obj/item/vehicle_part/engine/proc/stop()
	needs_processing = FALSE
	vehicle.active = FALSE
	playsound(vehicle, stop_sound, 150, 1, 5)
	rpm = 0

/obj/item/vehicle_part/engine/proc/handle_torque(delta = 2)
	if(rpm < (RPM_IDLE - 200))
		rpm = 0
		return 0

	if(rpm > max_rpm)
		rpm = max_rpm
		return 0

	. = interpolate_list(rpm, xs, ys) * delta

	if(!vehicle.is_acceleration_pressed && rpm > RPM_IDLE)
		. *= -0.1

	if(!vehicle.is_transfering())
		receive_torque(.)
		return 0

/obj/item/vehicle_part/engine/proc/receive_torque(amount)
	rpm += amount / (mass * MASS_TO_INERTIA_COEFFICENT)

/obj/item/vehicle_part/engine/part_process(delta)
	handle_sound()

/obj/item/vehicle_part/engine/proc/handle_sound()
	if(!needs_processing)
		return
	switch(rpm)
		if(1 to RPM_IDLE + 500)
			playsound(vehicle, 'sound/vehicles/modern/zb_fb_idle.ogg', 100)
			spawn(5)
			handle_sound()
		if(RPM_IDLE + 500 to RPM_SLOW)
			playsound(vehicle, 'sound/vehicles/modern/zb_fb_slow.ogg', 100)
		if(RPM_SLOW to RPM_FAST)
			playsound(vehicle, 'sound/vehicles/modern/zb_fb_med.ogg', 100)
		if(RPM_FAST to INFINITY)
			playsound(vehicle, 'sound/vehicles/modern/zb_fb_fast.ogg', 100)
