/obj/manhattan/vehicle/proc/update_angle_vector()
	angle = SIMPLIFY_DEGREES(angle)
	angle_vector = vector2_from_angle(angle)

/obj/manhattan/vehicle/Move(var/newloc,var/newdir)
	if(anchored)
		anchored = 0
		. = ..()
		anchored = 1
	else
		. = ..()
	update_object_sprites()

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

	next_move_input_at = world.time + 10

	return 1

// processes not only movement, but its will be in this file.
/obj/manhattan/vehicle/proc/process_vehicle(delta = 2)
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
		F += torque * gearbox.get_efficiency() / gearbox.get_ratio()

		var/wheels_rpm = speed.modulus() / get_wheel_diameter() * 60
		var/desired_rpm = wheels_rpm * gearbox.get_ratio()

		var/wheels_inertia = get_wheels_mass() * MASS_TO_INERTIA_COEFFICENT
		var/engine_inertia = engine.mass * MASS_TO_INERTIA_COEFFICENT
		var/base_torque = (desired_rpm - engine.rpm) / (wheels_inertia + engine_inertia)

		engine.rpm += base_torque * wheels_inertia * delta

		F += base_torque * engine_inertia

	acceleration += angle_vector * F

	// Drag
	acceleration -= speed * (speed.modulus() * aerodynamics_coefficent)
	acceleration -= speed * traction_coefficent
	//calc_force()

	if(is_brake_pressed)
		acceleration.x -= min(speed.x, 10)
		acceleration.y -= min(speed.y, 10)

	speed += acceleration * (1 / weight) * delta

	acceleration.x = 0
	acceleration.y = 0

	pixel_x += round(speed.x * 32 * delta)
	pixel_y += round(speed.y * 32 * delta)

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
		Move(newLoc, get_dir(loc, newLoc))