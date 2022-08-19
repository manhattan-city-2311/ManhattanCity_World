#define VECTOR_CHANGE_ANGLE 45

/obj/manhattan/vehicle
	name = "Vehicle"
	desc = "Vehicle"
	density = 1
	layer = ABOVE_MOB_LAYER

	w_class = ITEM_SIZE_VEHICLE

	var/headlights_overlay = "" //don't set this if vehicle has no headlights icon state
	var/headlights = FALSE //on-off

	appearance_flags = DEFAULT_APPEARANCE_UNBOUND
	step_size = 128

	var/active = 1
	var/guns_disabled = 0
	var/movement_destroyed = 0
	var/block_enter_exit = FALSE
	var/can_traverse_zs = 0

	var/obj/item/weapon/key/car/inserted_key

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

	light_power = 6
	light_range = 6

	var/list/components = list(
		VC_RIGHT_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_RIGHT_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_LEFT_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_LEFT_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_ENGINE = /obj/item/vehicle_part/engine,
		VC_GEARBOX = /obj/item/vehicle_part/gearbox,
		VC_CARDAN = /obj/item/vehicle_part/cardan
	)

	var/weight = 1000
	var/serial_number
	var/angle = 180

	var/vector2/angle_vector = new(0, -1)
	var/vector2/speed 		 = new(0, 0)
	var/vector2/acceleration = new(0, 0)

	var/is_acceleration_pressed = FALSE
	var/is_brake_pressed		= FALSE
	var/aerodynamics_coefficent = 0.32
	var/traction_coefficent 	= 9.6

	var/key_type = /obj/item/weapon/key/car
	var/serial_prefix = "CIV"

/obj/manhattan/vehicle/on_persistence_load()
	. = ..()
	for(var/ID in components)
		var/obj/item/vehicle_part/VP = components[ID]
		VP.vehicle = src

/obj/manhattan/vehicle/proc/doors_locked()
	return block_enter_exit

/obj/manhattan/vehicle/vars_to_save()
	return ..() + list("comp_prof", "serial_number", "inserted_key", "components", "block_enter_exit")

/obj/manhattan/vehicle/examine(mob/user)
	. = ..()
	to_chat(user, "There is a [serial_number] stamped on [src]'s license plate")

/obj/manhattan/vehicle/proc/generate_serial_number()
	var/part1 = "\[<b>[serial_prefix]</b>: "
	var/source = md5("[world.timeofday]")
	var/part2 = "[copytext(source, 1, 2)]-[copytext(source, 3, 6)]\]" // 12345 -> 12-345
	return part1 + uppertext(part2)

/mob/living/carbon/human/Stat()
	. = ..()
	if(isvehicle(loc))
		if(statpanel("Status"))
			var/obj/manhattan/vehicle/V = loc
			stat("Скорость:", "[round(TO_KPH(V.speed.modulus()))] км/ч")
			stat("Тахометр:", "[round(V.components[VC_ENGINE]?.rpm)] об/м")
			stat("Передача:", V.components[VC_GEARBOX]?.selected_gear)

/obj/manhattan/vehicle/proc/get_calculation_iterations()
	return round(max(1, speed.modulus() * 0.2))

/obj/manhattan/vehicle/proc/update_step_size()
	// TODO: Properly created system
	//step_size = speed.modulus() * WORLD_ICON_SIZE / world.tick_lag
	step_size = round(96 + round(speed.modulus()) * 1.5)

/obj/manhattan/vehicle/proc/get_wheel_diameter()
	return 0.34

/obj/manhattan/vehicle/proc/get_wheels_mass()
	return 25

/obj/manhattan/vehicle/proc/get_braking_force()
	return 2500

/obj/manhattan/vehicle/proc/is_transfering()
	var/obj/item/vehicle_part/gearbox/gearbox = components[VC_GEARBOX]
	return gearbox.get_ratio()

/obj/manhattan/vehicle/proc/get_components(type)
	. = list()
	for(var/i in components)
		var/component = components[i]
		if(istype(component, type))
			. += component

/obj/manhattan/vehicle/proc/get_wheels()
	return get_components(/obj/item/vehicle_part/wheel)

/obj/manhattan/vehicle/initialize(loadsource)
	. = ..()

	if(loadsource != LOADSOURCE_PERSISTENCE)
		comp_prof = new comp_prof(src)
		if(light_range != 0)
			verbs += /obj/manhattan/vehicle/verb/toggle_headlights
			set_light(0) //Switch off at spawn.
		for(var/id in components)
			var/type = components[id]
			components[id] = new type
			components[id].vehicle = src
		if(!serial_number)
			serial_number = generate_serial_number()
		if(!inserted_key)
			inserted_key = new key_type(src)
			inserted_key.key_data = serial_number

	cargo_capacity = base_storage_capacity(capacity_flag)
	SSvehicles.vehicles += src
	START_PROCESSING(SSobj, src)
	update_object_sprites()

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
	kick_occupants()
	SSvehicles.vehicles -= src
	. = ..()

/obj/manhattan/vehicle/proc/on_death()
	explosion(loc, -1, -1, 2, 5)
	movement_destroyed = 1
	guns_disabled = 1
	icon_state = "[initial(icon_state)]_destroyed"
/*	if(spawn_datum)
		spawn_datum.is_spawn_active = 0*/

/obj/manhattan/vehicle/proc/inactive_pilot_effects() //Overriden on a vehicle-by-vehicle basis.

/obj/manhattan/vehicle/process()
	if(world.time % 3)
		comp_prof.give_gunner_weapons(src)
		update_object_sprites()
		if(active)
			var/list/drivers = get_occupants_in_position("driver")
			if(!drivers.len || isnull(drivers) || movement_destroyed)
				inactive_pilot_effects()

	var/obj/item/vehicle_part/engine/engine = components[VC_ENGINE]
	engine?.handle_sound()

	for(var/obj/item/vehicle_part/vp in components)
		if(vp.can_process())
			vp.part_process()

/obj/manhattan/vehicle/proc/update_object_sprites() //This is modified on a vehicle-by-vehicle basis to render mobsprites etc, a basic render of playerheads in the top right is used if no overidden.
	underlays.Cut()
	overlays.Cut()
	if(headlights)
		overlays += image(icon, headlights_overlay)

/obj/manhattan/vehicle/fall()
	if(can_traverse_zs && active)
		return
	. = ..()

/obj/manhattan/vehicle/bullet_act(obj/item/projectile/P, def_zone)
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
	if(doors_locked())
		to_chat(user, "\The [src] is locked.")
		return ..()

	if(user.a_intent != "harm")
		if(!enter_as_position(user, VP_DRIVER))
			if(!enter_as_position(user, VP_GUNNER))
				enter_as_position(user, VP_PASSENGER)
	else
		. = ..()

/obj/manhattan/vehicle/attackby(obj/item/weapon/I, mob/user)
	if(elevation > user.elevation || elevation > I.elevation)
		to_chat(user,"<span class = 'notice'>[name] is too far away to interact with!</span>")
		return
	if(!istype(I))
		return
	if(istype(I, /obj/item/weapon/grab))
		handle_grab_attack(I, user)
		return
	if(user.a_intent == I_HURT)
		if(comp_prof.is_repair_tool(I))
			comp_prof.repair_inspected_with_tool(I, user)
			return
		if(istype(I,/obj/item/stack))
			comp_prof.repair_inspected_with_sheet(I, user)
			return
		. = ..()
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		var/pos_to_dam = should_damage_occ()
		if(!isnull(pos_to_dam))
			damage_occupant(pos_to_dam, I, user)
			return
		comp_prof.take_component_damage(I.force, I.damtype)
		return
	if(istype(I, /obj/item/weapon/key/car))
		if(attack_key(I, user))
			return

	put_cargo_item(user, I)

/obj/manhattan/vehicle/proc/attack_key(obj/item/weapon/key/car/key, user)
	if(key.key_data != serial_number)
		to_chat(user, SPAN_WARNING("The key doesn't fit!"))
		return TRUE
	playsound(src, 'sound/vehicles/modern/vehicle_key.ogg', 150, 1, 5)

	block_enter_exit = !block_enter_exit
	visible_message(SPAN_NOTICE("[user] [block_enter_exit ? "" : "un"]locks \the [src]."))
