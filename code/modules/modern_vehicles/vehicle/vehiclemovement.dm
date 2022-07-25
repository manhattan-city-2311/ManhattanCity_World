/obj/manhattan/vehicle/proc/update_angle_vector()
	angle_vector = vector2_from_angle(angle + 180)

// direction is -1 or 1
/obj/manhattan/vehicle/proc/handle_turning(direction)
	var/destDegree = round(angle - 90 * direction, 90)
	if(destDegree > 360)
		destDegree -= 360
	else if(destDegree < -360)
		destDegree += 360

	speed.rotate(closer_angle_difference(speed.angle(), destDegree))
	angle = destDegree
	update_angle_vector()

/obj/manhattan/vehicle/var/next_steering_input = 0
/obj/manhattan/vehicle/relaymove(mob/user, direction)
	if(world.time < next_steering_input)
		return 0
	var/list/driver_list = get_occupants_in_position("driver")
	var/is_driver = FALSE

	for(var/mob/driver in driver_list)
		if(user == driver)
			is_driver = TRUE
			break
	if(!is_driver)
		return -1 //doesn't return 0 so we can differentiate this from the other problems for simple mobs.

	if(movement_destroyed)
		to_chat(user, SPAN_NOTICE("[src] is in no state to move!"))
		return 0

	var/obj/item/vehicle_part/engine/engine = components[VC_ENGINE]

	if(!engine.rpm)
		to_chat(user, SPAN_NOTICE("The engine is shut down!"))
		return 0

	switch(direction)
		if(EAST, NORTHEAST, SOUTHEAST)
			handle_turning(1)
		if(WEST, NORTHWEST, SOUTHWEST)
			handle_turning(-1)
	next_steering_input = world.time + 10
	return 1

/obj/manhattan/vehicle/proc/handle_input()
	var/mob/user = listHead(get_occupants_in_position("driver"))
	is_clutch_pressed = FALSE
	is_acceleration_pressed = FALSE
	is_brake_pressed = FALSE
	if(!user || !user.client)
		return

	var/move_keys_held = user.client.move_keys_held
	if(move_keys_held & NORTH)
		is_acceleration_pressed = TRUE
	else if(move_keys_held & SOUTH)
		is_brake_pressed = TRUE

	is_clutch_pressed = user.client.mod_keys_held & ALT_KEY

// processes not only movement, but its will be in this file.
/obj/manhattan/vehicle/proc/process_vehicle(delta = 2)
	handle_input()

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
		if((engine.rpm / gearbox.get_ratio()) >= wheels_rpm)
			F += torque * gearbox.get_efficiency() * gearbox.get_ratio()

		var/desired_engine_rpm = wheels_rpm * gearbox.get_ratio()

		engine.rpm += (desired_engine_rpm - engine.rpm) * delta

	acceleration += angle_vector * F

	acceleration -= speed * (speed.modulus() * aerodynamics_coefficent + traction_coefficent)

	if(is_brake_pressed)
		acceleration.x -= min(speed.x * weight, get_braking_force())
		acceleration.y -= min(speed.y * weight, get_braking_force())

	//VECTOR_DEBUG(acceleration)
	//VECTOR_DEBUG(angle_vector)

	speed += acceleration / weight * delta

	if(abs(speed.angle() - angle) > 1)
		speed.rotate(closer_angle_difference(speed.angle(), angle))

	acceleration.x = 0
	acceleration.y = 0

/obj/manhattan/vehicle/Move(var/newloc,var/newdir)
	if(anchored)
		anchored = 0
		. = ..()
		anchored = 1
	else
		. = ..()
	update_object_sprites()

/obj/manhattan/vehicle/var/last_movement = 0
/obj/manhattan/vehicle/proc/move_helper(x_step, y_step)
	if(!(x_step || y_step))
		return

	if(last_movement)
		update_glide(world.time - last_movement)
	last_movement = world.time

	var/newLoc = locate(x + x_step, y + y_step, z)
	if(Move(newLoc, get_dir(loc, newLoc)))
		return
	speed.x = 0
	speed.y = 0
	if(is_clutch_transfering())
		var/obj/item/vehicle_part/engine/engine = components[VC_ENGINE]
		engine?.stop()

/obj/manhattan/vehicle/proc/process_movement(delta)
	if(speed.modulus() < (delta / 32))
		return

	var/x_step = 0
	var/y_step = 0
	if(speed.x < 1 && speed.y < 1)
		// delta-relative low speed pixel movement
		var/dx = speed.x * 32 * delta
		var/dy = speed.y * 32 * delta

		if(abs(pixel_x + dx) >= 32)
			var/temp = pixel_x + dx
			x_step  += SIGN(temp)
			pixel_x -= SIGN(temp) * 32
		else
			pixel_x += dx

		if(abs(pixel_y + dy) >= 32)
			var/temp = pixel_y + dy
			y_step  += SIGN(temp)
			pixel_y -= SIGN(temp) * 32
		else
			pixel_y += dy
	else
		// high speed
		if(pixel_x || pixel_y)
			pixel_x = 0
			pixel_y = 0

		x_step += speed.x * delta
		y_step += speed.y * delta

	move_helper(x_step, y_step)