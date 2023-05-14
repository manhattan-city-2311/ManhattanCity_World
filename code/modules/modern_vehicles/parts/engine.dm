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
	break_message = "<span class = 'danger'>The car's engine lets out a sharp creak and shuts down!</span>"

	// Note:
	var/list/xs = list(0, 400, 1000, 2000, 3000, 4000, 5000, 5500, 6000)
	var/list/ys = list(0, 60,  140,  150,  160,  175,  155,  144,  122)
	var/max_rpm = 6200

	mass = 70
	var/tmp/rpm = 0
	var/tmp/cur_sound
	var/tmp/datum/sound_token/sound_token

	needs_processing = TRUE

/obj/item/vehicle_part/engine/fail()
	..()
	vehicle.active = FALSE

/obj/item/vehicle_part/engine/proc/start()
	if(prob(integrity))
		playsound(vehicle, start_sound, 150, 1, 5)
		spawn(15)
			playsound(vehicle, 'sound/vehicles/modern/zb_fb_med.ogg', 7)
			rpm = RPM_IDLE
	else
		playsound(vehicle, failstart_sound, 150, 1, 5)

/obj/item/vehicle_part/engine/proc/stop()
	vehicle.active = FALSE
	if(vehicle.active)
		playsound(vehicle, stop_sound, 150, 1, 5)
		vehicle.visible_message("\The [vehicle]'s engine stops.")
	rpm = 0

/obj/item/vehicle_part/engine/proc/handle_torque(delta = 2)
	if(rpm < (RPM_IDLE - 200))
		if(rpm)
			stop()
		return 0

	if(rpm > max_rpm)
		. = -(rpm - max_rpm) * mass * MASS_TO_INERTIA_COEFFICENT * delta
		rpm = max_rpm
		return

	. = interpolate_list(rpm, xs, ys) * delta

	if(!vehicle.is_acceleration_pressed && rpm > RPM_IDLE)
		. *= -0.25
	else if(!vehicle.consume_fuel(max(0, 0.0000192 * (rpm * 0.001 + .))))
		stop()

	if(!vehicle.is_transfering())
		receive_torque(.)
		return 0

/obj/item/vehicle_part/engine/proc/receive_torque(amount)
	rpm += amount / (mass * MASS_TO_INERTIA_COEFFICENT)

/obj/item/vehicle_part/engine/part_process(delta)
	handle_sound()

/obj/item/vehicle_part/engine/proc/handle_sound()
	. = null
	switch(rpm)
		if(200 to RPM_IDLE + 500)
			. = 'sound/vehicles/modern/zb_fb_idle.ogg'
		if(RPM_IDLE + 500 to RPM_SLOW)
			. = 'sound/vehicles/modern/zb_fb_slow.ogg'
		if(RPM_SLOW to RPM_FAST)
			. = 'sound/vehicles/modern/zb_fb_med.ogg'
		if(RPM_FAST to POSITIVE_INFINITY)
			. = 'sound/vehicles/modern/zb_fb_fast.ogg'

	if(. != cur_sound)
		sound_token?.Stop()
		sound_token = global.sound_player.PlayLoopingSound(vehicle, "[vehicle.serial_number][type]", ., 25, 7)
		cur_sound = .
