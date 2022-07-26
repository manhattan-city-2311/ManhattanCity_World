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

	//var/obj/item/vehicle_part/engine/engine = components[VC_ENGINE]

	switch(direction)
		if(EAST, NORTHEAST, SOUTHEAST)
			handle_turning(1)
			next_steering_input = world.time + 10
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
	if(!components?.len)
		return

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
			F += torque * gearbox.get_efficiency() * gearbox.get_ratio() / get_wheel_diameter() / delta
		else
			engine.receive_torque(torque)

		var/desired_engine_rpm = wheels_rpm * gearbox.get_ratio()

		var/rpm_add = (desired_engine_rpm - engine.rpm) * delta
		if(engine.rpm + rpm_add > engine.max_rpm)
			F -= (engine.rpm + rpm_add - engine.max_rpm) * engine.mass * MASS_TO_INERTIA_COEFFICENT
		else
			engine.rpm += rpm_add


	acceleration += angle_vector * F

	acceleration -= speed * (speed.modulus() * aerodynamics_coefficent + traction_coefficent)

	speed += acceleration / weight * delta

	if(is_brake_pressed)
		var/x_sign = SIGN(speed.x)
		speed.x -= x_sign * (get_braking_force() / weight)
		if(SIGN(speed.x) != x_sign)
			speed.x = 0

		var/y_sign = SIGN(speed.y)
		speed.y -= y_sign * (get_braking_force() / weight)
		if(SIGN(speed.y) != y_sign)
			speed.y = 0
		
	if(abs(speed.angle() - angle_vector.angle()) > 1)
		speed.rotate(closer_angle_difference(speed.angle(), angle_vector.angle()))

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

/obj/manhattan/vehicle/proc/collide_with_obstacle(atom/obstacle)
	if(!obstacle.handle_vehicle_collision(obstacle))
		visible_message(SPAN_DANGER("[src] collides with [obstacle]!"))
	comp_prof.take_component_damage(speed.modulus() * 0.83, "brute")

	for(var/mob/living/carbon/human/H in occupants)
		for(var/i in 1 to 5)
			H.adjustBruteLoss(speed.modulus() * 0.83 / 5)
	speed.x = 0
	speed.y = 0
	step_x = 0
	step_y = 0

/obj/manhattan/vehicle/Bump(atom/obstacle)
	..()
	. = collide_with_obstacle(obstacle)

/obj/manhattan/vehicle/var/last_movement
/obj/manhattan/vehicle/proc/move_helper(x_step, y_step)
	if(!(x_step || y_step))
		return

	if(last_movement)
		update_glide(world.time - last_movement)
	last_movement = world.time

	var/newLoc = locate(x + x_step, y + y_step, z)
	if(Move(newLoc, get_dir(loc, newLoc), x_step ? 0 : step_x, y_step ? 0 : step_y))
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
	var/dx = speed.x * 32 * delta
	var/dy = speed.y * 32 * delta

	if(abs(step_x + dx) >= 32)
		var/temp = step_x + dx
		x_step += SIGN(temp)
		step_x -= SIGN(temp) * 32
	else
		step_x += dx

	if(abs(step_y + dy) >= 32)
		var/temp = step_y + dy
		y_step += SIGN(temp)
		step_y -= SIGN(temp) * 32
	else
		step_y += dy

	move_helper(x_step, y_step)