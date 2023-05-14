/obj/manhattan/vehicle/proc/update_angle_vector()
	angle = round(angle, 90)
	angle_vector.set_angle(90 - angle)

// direction is -1 or 1
/obj/manhattan/vehicle/proc/handle_turning(direction)
	var/destDegree = angle + 90 * direction
	dir = turn(dir, -90 * direction)
	angle = destDegree

	update_angle_vector()
	speed = angle_vector * speed.modulus()
	update_icon()

/obj/manhattan/vehicle/var/next_steering_input = 0
/obj/manhattan/vehicle/var/next_strafe_input = 0
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

	if(!(user.client.mod_keys_held & ALT_KEY))
		if(user.client.move_keys_held & EAST_KEY)
			handle_turning(1)
		else if(user.client.move_keys_held & WEST_KEY)
			handle_turning(-1)
		else
			return 1
		next_steering_input = world.time + 3
	else
		if(world.time < next_strafe_input)
			return 0

		if(user.client.move_keys_held & EAST_KEY)
			direction = 1
		else if(user.client.move_keys_held & WEST_KEY)
			direction = -1
		else
			return 1
		var/vector2/temp = vector2_from_angle(round(90 - (angle + 90 * direction), 90)) * WORLD_ICON_SIZE
		temp.round_components(1)

		move_helper(temp.x, temp.y, update_dir = FALSE)

		next_strafe_input = world.time + 2
	return 1

/obj/manhattan/vehicle/proc/handle_input()
	var/mob/user = listHead(get_occupants_in_position("driver"))
	is_acceleration_pressed = FALSE
	is_brake_pressed = FALSE
	if(!user || !user.client)
		return

	var/move_keys_held = user.client.move_keys_held
	if(move_keys_held & NORTH)
		is_acceleration_pressed = TRUE
	else if(move_keys_held & SOUTH)
		is_brake_pressed = TRUE

// processes not only movement, but its will be in this file.
/obj/manhattan/vehicle/proc/process_vehicle(delta = 2)
	if(!components?.len)
		return

	handle_input()

	var/obj/item/vehicle_part/engine/engine   = components[VC_ENGINE]
	var/obj/item/vehicle_part/gearbox/gearbox = components[VC_GEARBOX]
	var/obj/item/vehicle_part/cardan/cardan   = components[VC_CARDAN]

	if(!(engine && gearbox && cardan))
		return

	var/F = 0
	var/torque = engine.handle_torque(delta)
	if(is_transfering())
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

	var/max_F = weight / delta
	if(get_transfer_case() != TRANSFER_CASE_AWD)
		max_F /= 1.88

	skid = !ISINRANGE(F, -max_F, max_F)
	if(skid)
		var/nF = clamp(F, -max_F * 0.9, max_F * 0.9)
		skid = (F - nF) * delta
		F = nF

	acceleration = angle_vector * F

	acceleration -= speed * (speed.modulus() * aerodynamics_coefficent + traction_coefficent)

	speed += acceleration / weight * delta

	if(is_brake_pressed)
		var/force = get_braking_force() / weight * delta * 10
		speed.x = SIGN(speed.x) * max(abs(speed.x) - force, 0)
		speed.y = SIGN(speed.y) * max(abs(speed.y) - force, 0)
		update_occupants_eye_offsets()

	// unlikely due to simplified turning mechanic, but still can serve some bugs.
	if(abs(speed.angle() - angle_vector.angle()) > 1)
		speed.rotate(closer_angle_difference(speed.angle(), angle_vector.angle()))

/obj/manhattan/vehicle/Move(newloc, newdir)
	if(anchored)
		anchored = FALSE
		. = ..()
		anchored = TRUE
	else
		. = ..()

/obj/manhattan/vehicle/var/last_collision = 0
/obj/manhattan/vehicle/proc/collide_with_obstacle(atom/obstacle)
	if(world.time < last_collision + 5)
		return
	last_collision = world.time

	if(!obstacle.handle_vehicle_collision(src))
		visible_message(SPAN_DANGER("[icon2html(src, viewers(get_turf(src)) + contents)]\The [src] collides with [obstacle]!"))
	comp_prof.take_component_damage(speed.modulus() * 0.5, BRUTE)

	for(var/mob/living/carbon/human/H in occupants)
		for(var/i in 1 to 5)
			H.adjustBruteLoss(speed.modulus() * 0.083)
	if(components[VC_GEARBOX]?.get_ratio())
		components[VC_ENGINE]?.stop()
	speed.x = 0
	speed.y = 0
	step_x = 0
	step_y = 0

	update_occupants_eye_offsets()

/obj/manhattan/vehicle/var/bypass_bump = 0

/obj/manhattan/vehicle/Bump(atom/obstacle)
	if(obstacle == src)
		return

	log_debug("Bump([obstacle]), bounds_dist = [bounds_dist(src, obstacle)]")

	if(bounds_dist(src, obstacle) > 0 )
		++bypass_bump
		return

	. = ..()
	collide_with_obstacle(obstacle)

/obj/manhattan/vehicle/proc/move_helper3(x_step, y_step, nstep_x = step_x, nstep_y = step_y, update_dir = TRUE)
	var/turf/newLoc = locate(x + x_step, y + y_step, z)
	 // FIXME:
	if(isopenspace(newLoc) && newLoc.below)
		for(var/obj/structure/stairs/S in newLoc.below)
			newLoc = newLoc.below
			break
	else
		for(var/obj/structure/stairs/S in newLoc)
			newLoc = newLoc.above
			break

	Move(newLoc, update_dir ? get_dir(loc, newLoc) : dir, nstep_x, nstep_y)
	
	if(bypass_bump > 3)
		bypass_bump = 0

	if(bypass_bump)
		density = FALSE
		Move(newLoc, update_dir ? get_dir(loc, newLoc) : dir, nstep_x, nstep_y)
		density = TRUE
		bypass_bump = 0

// Tile step
/obj/manhattan/vehicle/proc/move_helper2(x_step, y_step, nstep_x, nstep_y, update_dir = TRUE)
	var/nstep_x1 = x_step ? (SIGN(nstep_x) * max(abs(nstep_x) - WORLD_ICON_SIZE, 0)) : nstep_x
	var/nstep_y1 = y_step ? (SIGN(nstep_y) * max(abs(nstep_y) - WORLD_ICON_SIZE, 0)) : nstep_y

	move_helper3(x_step, y_step, nstep_x1, nstep_y1, update_dir = update_dir)

// Pixel step
/obj/manhattan/vehicle/proc/move_helper(dx, dy, update_dir = TRUE)
	var/nstep_x = step_x + dx
	var/nstep_y = step_y + dy

	var/x_step
	var/y_step

	if(abs(nstep_x) > WORLD_ICON_SIZE)
		x_step += REMOVE_FRAC(nstep_x / WORLD_ICON_SIZE)
	if(abs(nstep_y) > WORLD_ICON_SIZE)
		y_step += REMOVE_FRAC(nstep_y / WORLD_ICON_SIZE)

	update_occupants_eye_offsets()

	move_helper2(x_step, y_step, nstep_x, nstep_y, update_dir = update_dir)

/obj/manhattan/vehicle/update_glide()
	. = ..()
	for(var/mob/M in contents)
		M.client?.glide_size = glide_size

/obj/manhattan/vehicle/proc/process_movement(delta)
	if(speed.modulus() == 0)
		return

	update_glide(max(world.tick_lag, 10 / speed.modulus()))
	update_step_size()
	move_helper(speed.x * WORLD_ICON_SIZE * delta, speed.y * WORLD_ICON_SIZE * delta)
