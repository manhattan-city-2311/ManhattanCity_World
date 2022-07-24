/obj/manhattan/vehicle/proc/update_angle_vector()
	angle = SIMPLIFY_DEGREES(angle)
	angle_vector = vector2_from_angle(angle)
	angle_vector.round_components(0.01)

/obj/manhattan/vehicle/Move(var/newloc,var/newdir)
	if(anchored)
		anchored = 0
		. = ..()
		anchored = 1
	else
		. = ..()
	update_object_sprites()

/obj/manhattan/vehicle/relaymove(var/mob/user, var/direction)
/*
	if(world.time < next_move_input_at)
		return 0
	if(movement_destroyed)
		to_chat(user,"<span class = 'notice'>[src] is in no state to move!</span>")
		return 0
	for(var/obj/item/vehicle_part/engine/engine in components)
		if(engine.needs_processing == 0)
			to_chat(user,"<span class = 'notice'>The engine is shut down!</span>")
			return 0
	var/list/driver_list = get_occupants_in_position("driver")
	var/is_driver = FALSE

	for(var/mob/driver in driver_list)
		if(user == driver)
			is_driver = TRUE
			break
	if(!is_driver)
		return -1 //doesn't return 0 so we can differentiate this from the other problems for simple mobs.

	is_clutch_pressed = user.client?.mod_keys_held & ALT_KEY
	turning = 0

	switch(direction)
		if(NORTH)
			is_acceleration_pressed = TRUE
			is_brake_pressed = FALSE
		if(SOUTH)
			is_acceleration_pressed = FALSE
			is_brake_pressed = TRUE
		if(EAST)
			turning = 1
		if(WEST)
			turning = -1
	next_move_input_at = world.time + 5
*/
	return 1

/obj/manhattan/vehicle/proc/handle_input()
	var/mob/user = listHead(get_occupants_in_position("driver"))
	is_clutch_pressed = FALSE
	is_acceleration_pressed = FALSE
	is_brake_pressed = FALSE
	turning = 0
	if(!user || !user.client)
		return

	var/move_keys_held = user.client.move_keys_held
	if(move_keys_held & NORTH)
		is_acceleration_pressed = TRUE
	else if(move_keys_held & SOUTH)
		is_brake_pressed = TRUE

	if(move_keys_held & EAST)
		turning = 1
	else if(move_keys_held & WEST)
		turning = -1

	is_clutch_pressed = user.client.mod_keys_held & ALT_KEY

// processes not only movement, but its will be in this file.
/obj/manhattan/vehicle/proc/process_vehicle(delta = 2)
	handle_input()

	for(var/obj/item/vehicle_part/vp in components)
		if(vp.can_process())
			vp.part_process(delta)

	var/obj/item/vehicle_part/engine/engine = components[VC_ENGINE]
	var/obj/item/vehicle_part/clutch/clutch = components[VC_CLUTCH]
	var/obj/item/vehicle_part/gearbox/gearbox = components[VC_GEARBOX]
	var/obj/item/vehicle_part/cardan/cardan = components[VC_CARDAN]

	if(!(engine && clutch && gearbox && cardan))
		return

	var/F = 0
	var/torque = engine.handle_torque(delta)
	if(is_clutch_transfering())
		var/wheels_rpm = speed.modulus() / get_wheel_diameter() * 60 / M_2PI
		if(engine.rpm >= wheels_rpm * gearbox.get_ratio())
			F += torque * gearbox.get_efficiency() / gearbox.get_ratio()

		var/desired_engine_rpm = wheels_rpm * gearbox.get_ratio()

		var/engineInertia = engine.mass * MASS_TO_INERTIA_COEFFICENT
		var/wheelsInertia = get_wheels_mass() * MASS_TO_INERTIA_COEFFICENT

		var/baseTorque = (desired_engine_rpm - engine.rpm) / (engineInertia + wheelsInertia)

		engine.rpm += baseTorque * wheelsInertia * delta
		F          += baseTorque * engineInertia

	acceleration += angle_vector * F

	// Drag

	var/vector2/aerodrag = speed * (speed.modulus() * aerodynamics_coefficent)
	var/vector2/traction_drag = speed * traction_coefficent

	//VECTOR_DEBUG(aerodrag)
	//VECTOR_DEBUG(traction_drag)

	acceleration -= aerodrag + traction_drag

	if(is_brake_pressed)
		acceleration.x -= min(speed.x * weight, get_braking_force())
		acceleration.y -= min(speed.y * weight, get_braking_force())

	//VECTOR_DEBUG(acceleration)
	//VECTOR_DEBUG(angle_vector)

	speed += acceleration / weight * delta
	acceleration.x = 0
	acceleration.y = 0

/obj/manhattan/vehicle/proc/process_movement(delta)
	pixel_x += round(speed.x * 32 * delta)
	pixel_y += round(speed.y * 32 * delta)

	if(turning)
		var/rotate_speed = 22.5 * turning * delta
		speed.rotate(SIMPLIFY_DEGREES(rotate_speed))
		angle += rotate_speed
		update_angle_vector()
	else
		angle = Atan2(speed.x, speed.y)
		update_angle_vector()

	if(abs(pixel_x) >= 32 || abs(pixel_y) >= 32)
		var/x_step = 0
		var/y_step = 0

		if(abs(pixel_x) >= 32)
			x_step  += SIGN(pixel_x)
			pixel_x -= SIGN(pixel_x) * 32
		if(abs(pixel_y) >= 32)
			y_step  += SIGN(pixel_y)
			pixel_y -= SIGN(pixel_y) * 32

		var/turf/newLoc = locate(x + x_step, y + y_step, z)
		if(!Move(newLoc, get_dir(loc, newLoc)))
			speed.x = 0
			speed.y = 0
			if(is_clutch_transfering())
				var/obj/item/vehicle_part/engine/engine = components[VC_ENGINE]
				engine?.stop()
