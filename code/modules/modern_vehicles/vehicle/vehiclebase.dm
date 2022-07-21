#define VECTOR_CHANGE_ANGLE 25

/obj/manhattan/vehicle
	name = "Vehicle"
	desc = "Vehicle"
	density = 1
	layer = ABOVE_MOB_LAYER

	var/active = 1
	var/guns_disabled = 0
	var/movement_destroyed = 0
	var/block_enter_exit //Set this to block entering/exiting.
	var/can_traverse_zs = 0

	var/keys_in_ignition = FALSE

	var/next_move_input_at = 0//When can we send our next movement input?
	var/moving_x = 0
	var/moving_y = 0
	var/acceleration = 1 //By how much does our speed change per input?
	var/braking_mode = 0 //1 = brakes active, -1 = purposefully reducing drag to slide.
	var/can_space_move = 0

	//Advanced Damage Handling
	var/datum/component_profile/comp_prof = /datum/component_profile

	var/list/sprite_offsets = list("1" = list(0,0),"2" = list(0,0),"4" = list(0,0),"8" = list(0,0)) //Handled Directionally. Numbers correspond to directions

	//Passenger Management
	var/list/occupants = list(1,1) //Contains all occupants of the vehicle including the driver. First 2 values defines max passengers /gunners. Format: [MobRef] = [PositionName]
	var/list/passengers = list()
	var/list/exposed_positions = list("driver" = 0.0,"gunner" = 0.0,"passenger" = 0.0) //Assoc. Value is the chance of hitting this position

	//Cargo
	var/used_cargo_space = 0
	var/cargo_capacity = 0
	var/capacity_flag = ITEMSIZE_SMALL
	var/list/cargo_contents = list()
	var/list/ammo_containers = list() //Ammunition containers in the form of ammo magazines.

	//Vehicle ferrying//
	var/vehicle_size = ITEM_SIZE_VEHICLE//The size of the vehicle, used by vehicle cargo ferrying to determine allowed amount and allowed size.
	var/vehicle_carry_size = 0		//the max size of a carried vehicle
	var/obj/manhattan/vehicle/carried_vehicle

	var/vehicle_view_modifier = 1 //The view-size modifier to apply to the occupants of the vehicle.
	var/move_sound = null

	var/datum/mobile_spawn/spawn_datum //Setting this makes this a mobile spawn point.

	var/datum/gas_mixture/internal_air = null//If this is new()'d, the vehicle provides air to the occupants.
	//I would make it require refilling, but that's likely to just be boring tedium for players.

	light_power = 6
	light_range = 6

	var/list/components = list(
		VC_RIGHT_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_RIGHT_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_LEFT_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_LEFT_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_ENGINE = /obj/item/vehicle_part/engine
	)

	var/weight = 1500
	var/skid = FALSE
	var/serial_number
	var/angle = 0

	var/vector2/angle_vector = new
	var/vector2/speed 		 = new
	var/vector2/acceleration = new

	var/is_acceleration_pressed = FALSE
	var/is_clutch_pressed		= FALSE
	var/is_brake_pressed		= FALSE
	var/aerodynamics_coefficent = 0.32


/obj/manhattan/vehicle/proc/update_angle_vector()
	angle_vector = vector2_from_angle(angle)

/mob/living/carbon/human/Stat()
	. = ..()
	if(istype(loc, /obj/manhattan/vehicle))
		if(statpanel("Status"))
			stat("Speed:", speed.modulus())
			stat("RPM:", components[VC_ENGINE]?.rpm)

/obj/manhattan/vehicle/proc/get_components(type)
	. = list()
	for(var/i in components)
		var/component = components[i]
		if(istype(component, type))
			. += component
		
/obj/manhattan/vehicle/proc/get_wheels()
	return get_components(/obj/item/vehicle_part/wheel)

/obj/manhattan/vehicle/initialize()
	. = ..()
	comp_prof = new comp_prof(src)
	
	START_PROCESSING(SSobj, src)

	update_object_sprites()
	if(light_range != 0)
		verbs += /obj/manhattan/vehicle/verb/toggle_headlights
		set_light(0) //Switch off at spawn.
	cargo_capacity = base_storage_capacity(capacity_flag)

	for(var/id in components)
		var/type = components[id]
		components[id] = new type
		components[id].vehicle = src
	serial_number = rand(1, 9999)

/obj/manhattan/vehicle/attack_generic(mob/living/simple_animal/attacker, damage, text)
	visible_message("<span class = 'danger'>[attacker] [text] [src]</span>")
	var/pos_to_dam = should_damage_occ()
	if(!isnull(pos_to_dam))
		var/list/occ_list = get_occupants_in_position(pos_to_dam)
		if(isnull(occ_list) || !occ_list.len)
			return 1
		var/mob/mob_to_hit = pick(occ_list)
		if(isnull(mob_to_hit))
			return 1
		attacker.UnarmedAttack(mob_to_hit)
	comp_prof.take_component_damage(damage,"brute")

/obj/manhattan/vehicle/proc/pick_valid_exit_loc()
	var/list/valid_exit_locs = list()
	for(var/turf/t in locs)
		for(var/turf/t_2 in range(1,t))
			if(!(t_2 in locs) && t_2.density == 0)
				valid_exit_locs |= t
				break
	if(valid_exit_locs.len == 0)
		return null
	return pick(valid_exit_locs)

/obj/manhattan/vehicle/Destroy()
	processing_objects -= src
	kick_occupants()
	. = ..()

/obj/manhattan/vehicle/proc/on_death()
	explosion(loc,-1,-1,2,5)
	movement_destroyed = 1
	guns_disabled = 1
	icon_state = "[initial(icon_state)]_destroyed"
/*	if(spawn_datum)
		spawn_datum.is_spawn_active = 0*/

/obj/manhattan/vehicle/proc/inactive_pilot_effects() //Overriden on a vehicle-by-vehicle basis.

/obj/manhattan/vehicle/process()
	for(var/obj/item/vehicle_part/vp in components)
		vp.process()

	if(world.time % 3)
		comp_prof.give_gunner_weapons(src)
		update_object_sprites()
		if(active)
			var/list/drivers = get_occupants_in_position("driver")
			if(!drivers.len || isnull(drivers) || movement_destroyed)
				inactive_pilot_effects()
	
	handle_movement()

/obj/manhattan/vehicle/proc/update_object_sprites() //This is modified on a vehicle-by-vehicle basis to render mobsprites etc, a basic render of playerheads in the top right is used if no overidden.
	underlays.Cut()
	overlays.Cut()

/obj/manhattan/vehicle/fall()
	if(can_traverse_zs && active)
		return
	. = ..()

/obj/manhattan/vehicle/proc/collide_with_obstacle(var/atom/obstacle)
	moving_x = 0
	moving_y = 0
	last_moved_axis = 0
	speed[1] = 0
	speed[2] = 0
	if(!obstacle.handle_vehicle_collision(obstacle))
		visible_message("<span class = 'danger'>[src] collides with [obstacle]!</span>")
	comp_prof.take_component_damage(5,"brute") //very minor, in case we hit something small

/obj/manhattan/vehicle/Bump(var/atom/obstacle)
	..()
	. = collide_with_obstacle(obstacle)

/obj/manhattan/vehicle/bullet_act(var/obj/item/projectile/P, var/def_zone)
	var/pos_to_dam = should_damage_occ()
	var/mob/mob_to_dam
	if(movement_destroyed)
		var/list/mobs = list()
		for(var/mob/m in occupants)
			mobs += m
		if(mobs.len == 0)
			return
		mob_to_dam = pick(mobs)
		if(!isnull(mob_to_dam))
			mob_to_dam.bullet_act(P)
			return
	if(!isnull(pos_to_dam))
		var/should_continue = damage_occupant(pos_to_dam,P)
		if(!should_continue)
			return
	comp_prof.take_component_damage(P.get_structure_damage(),P.damtype)
	visible_message("<span class = 'danger'>[P] hits [src]!</span>")

/obj/manhattan/vehicle/ex_act(var/severity)
	comp_prof.take_comp_explosion_dam(severity)
	for(var/position in exposed_positions)
		for(var/mob/living/m in get_occupants_in_position(position))
			m.apply_damage((250/severity)*(exposed_positions[position]/100),BRUTE,,m.run_armor_check(null,"bomb"))

/obj/manhattan/vehicle/attack_hand(var/mob/user)
	if(user.a_intent != "harm")
		if(!enter_as_position(user,"driver"))
			if(!enter_as_position(user,"gunner"))
				enter_as_position(user,"passenger")
	else
		. = ..()

/obj/manhattan/vehicle/attackby(var/obj/item/I,var/mob/user)
	if(elevation > user.elevation || elevation > I.elevation)
		to_chat(user,"<span class = 'notice'>[name] is too far away to interact with!</span>")
		return
	if(!istype(I))
		return
	if(istype(I,/obj/item/weapon/grab))
		handle_grab_attack(I,user)
		return
	if(istype(I, /obj/item/car_key))
		var/obj/item/car_key/key = I
		if(key.serial_number == serial_number)
			playsound(src, 'sound/vehicles/modern/vehicle_key.ogg', 150, 1, 5)
			if(block_enter_exit)
				visible_message("<span class = 'notice'>[user] unlocks the [src].</span>")
				block_enter_exit = 0
			else
				visible_message("<span class = 'notice'>[user] locks the [src].</span>")
				block_enter_exit = 1
		else
			to_chat(user,"<span class = 'notice'>The key doesn't fit!</span>")
	if(user.a_intent == I_HURT)
		if(comp_prof.is_repair_tool(I))
			comp_prof.repair_inspected_with_tool(I,user)
			return
		if(istype(I,/obj/item/stack))
			comp_prof.repair_inspected_with_sheet(I,user)
			return
		. = ..()
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		var/pos_to_dam = should_damage_occ()
		if(!isnull(pos_to_dam))
			damage_occupant(pos_to_dam,I,user)
			return
		comp_prof.take_component_damage(I.force,I.damtype)
		return
	put_cargo_item(user,I)
