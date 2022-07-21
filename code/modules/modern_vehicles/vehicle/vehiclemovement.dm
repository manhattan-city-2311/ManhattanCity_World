/obj/manhattan/vehicle/proc/update_angle_vector()
	angle_vector = vector2_from_angle(angle)

/obj/manhattan/vehicle/Move(var/newloc,var/newdir)
	if(abs(speed[1]) > abs(speed[2]))
		if(speed[1] > 0)
			newdir = EAST
		else
			newdir = WEST
	else
		if(speed[2] > 0)
			newdir = NORTH
		else
			newdir = SOUTH
	if(anchored)
		anchored = 0
		. = ..()
		anchored = 1
	else
		. = ..()
	update_object_sprites()

/obj/manhattan/vehicle/proc/drag_slowdown(var/index,var/slowdown_amount = drag)
	if(speed[index] > 0)
		speed[index] = max(speed[index] - drag,0)
	else
		speed[index] = min(speed[index] + drag,0)

/obj/manhattan/vehicle/proc/movement_loop(var/speed_index_target = 1)
	var/noprocstart = 0
	if(moving_x || moving_y)
		noprocstart = 1
	switch(speed_index_target)
		if(1)
			moving_x = 1
		if(2)
			moving_y = 1
	if(noprocstart)
		return
	spawn()
		while (moving_x || moving_y)
			var/delay = max(min_speed - vector_modulus(speed), max_speed)
			sleep(delay)

			glide_size = 0

			for(var/mob/occupant in occupants)
				if(!ismob(occupant))
					continue

				occupant.update_glide(delay)

				if(!glide_size)
					glide_size = occupant.glide_size

			if(speed[1] == 0)
				moving_x = 0
			else
				if(speed[1] > 0)
					last_move = EAST
					. = Move(get_step(loc,EAST),EAST)
				else
					last_move = WEST
					. = Move(get_step(loc,WEST),WEST)

			if(speed[2] == 0)
				moving_y = 0
			else
				if(speed[2] > 0)
					last_move = NORTH
					. = Move(get_step(loc,NORTH),NORTH)
				else
					last_move = SOUTH
					. = Move(get_step(loc,SOUTH),SOUTH)
			var/list/index_list = list(1,2)
			for(var/index in index_list)
				if(last_moved_axis == index)
					continue
				drag_slowdown(index)
			if(world.time >= next_move_input_at)
				last_moved_axis = 0
			if(move_sound && world.time % 2 == 0)
				playsound(loc,move_sound,75,0,4)

/obj/manhattan/vehicle/relaymove(var/mob/user, var/direction)
	if(world.time < next_move_input_at)
		return 0
	if(movement_destroyed)
		to_chat(user,"<span class = 'notice'>[src] is in no state to move!</span>")
		return 0
	for(var/obj/item/vehicle_part/engine/engine in components)
		if(engine.needs_processing == 0)
			to_chat(user,"<span class = 'notice'>The engine is shut down!</span>")
			return 0
		engine.rpm += 100
	var/list/driver_list = get_occupants_in_position("driver")
	var/is_driver = FALSE

	for(var/mob/driver in driver_list)
		if(user == driver)
			is_driver = TRUE
			break
	if(!is_driver)
		return -1 //doesn't return 0 so we can differentiate this from the other problems for simple mobs.

	is_clutch_pressed = user.client?.mod_keys_held & ALT_KEY

	switch(direction)
		if(NORTH)
			is_acceleration_pressed = TRUE
			is_brake_pressed = FALSE
		if(SOUTH)
			is_acceleration_pressed = FALSE
			is_brake_pressed = TRUE 
		if(EAST)
			angle += VECTOR_CHANGE_ANGLE
			update_angle_vector()
		if(WEST)
			angle -= VECTOR_CHANGE_ANGLE
			update_angle_vector()

	next_move_input_at = world.time + 2

	return 1

/obj/manhattan/vehicle/proc/get_force()

/obj/manhattan/vehicle/proc/handle_movement(delta = 2)
	var/friction = 0
	for(var/obj/item/vehicle_part/wheel/W in get_wheels())
		friction += W.get_traction()

	friction /= weight

	// Drag
	acceleration -= speed * (speed.modulus() * aerodynamics_coefficent + friction)

	speed += acceleration * delta

	acceleration = vector2(0, 0)

	step_x += speed.x / 32 * delta
	step_y += speed.y / 32 * delta

	if(step_x >= 32 || step_y >= 32)
		var/x_step = step_x / 32
		var/y_step = step_y / 32

		step_x /= 32
		step_y /= 32

		var/turf/newLoc = locate(x + x_step, y + y_step, z)
		Move(newloc, angle2dir(angle))