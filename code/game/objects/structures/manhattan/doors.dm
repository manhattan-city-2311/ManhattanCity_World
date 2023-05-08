/obj/machinery/door/unpowered/manhattan
	name = "door"
	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"

	var/material/material
	var/icon_base
	hitsound = 'sound/effects/doors/metal_door_impact.wav'
	var/datum/lock/lock
	var/initial_lock_value //for mapping purposes. Basically if this value is set, it sets the lock to this value.

/obj/machinery/door/unpowered/manhattan/bumpopen(mob/user as mob)
	return

/obj/machinery/door/unpowered/manhattan/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	TemperatureAct(exposed_temperature)

/obj/machinery/door/unpowered/manhattan/proc/TemperatureAct(temperature)
	take_damage(100*material.combustion_effect(get_turf(src),temperature, 0.3))

/obj/machinery/door/unpowered/manhattan/New(var/newloc, var/material_name, var/locked)
	..()
	if(!material_name)
		material_name = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(material_name)
	if(!material)
		qdel(src)
		return
	maxhealth = max(100, material.integrity*10)
	health = maxhealth
	if(!icon_base)
		icon_base = material.door_icon_base
	hitsound = 'sound/effects/doors/metal_door_impact.wav'
	name = "[material.display_name] door"
	color = material.icon_colour
	if(initial_lock_value)
		locked = initial_lock_value
	if(locked)
		lock = new(src,locked)

	if(material.opacity < 0.5)
		glass = 1
		set_opacity(0)
	else
		set_opacity(1)
	update_icon()

/obj/machinery/door/unpowered/manhattan/requiresID()
	return 0

/obj/machinery/door/unpowered/manhattan/get_material()
	return material

/obj/machinery/door/unpowered/manhattan/get_material_name()
	return material.name

/obj/machinery/door/unpowered/manhattan/bullet_act(var/obj/item/projectile/Proj)
	var/damage = Proj.get_structure_damage()
	if(damage)
		//cap projectile damage so that there's still a minimum number of hits required to break the door
		take_damage(min(damage, 100))

/obj/machinery/door/unpowered/manhattan/update_icon()
	if(density)
		icon_state = "[icon_base]"
	else
		icon_state = "[icon_base]open"
	return

/obj/machinery/door/unpowered/manhattan/do_animate(animation)
	switch(animation)
		if("opening")
			flick("[icon_base]opening", src)
		if("closing")
			flick("[icon_base]closing", src)
	return

/obj/machinery/door/unpowered/manhattan/inoperable(var/additional_flags = 0)
	return (stat & (BROKEN|additional_flags))

/obj/machinery/door/unpowered/manhattan/open(var/forced = 0)
	if(!can_open(forced))
		return
	playsound(src.loc, material.dooropen_noise, 150, 1)

	operating = 1
	do_animate("opening")

	icon_state = "door0"
	set_opacity(0)
	density = 0

	layer = open_layer
	explosion_resistance = 0
	update_icon()
	set_opacity(0)
	operating = 0

	if(autoclose)
		close_door_at = next_close_time()

/obj/machinery/door/unpowered/manhattan/close(var/forced = 0)
	if(!can_close(forced))
		return
	playsound(src.loc, material.dooropen_noise, 100, 1)

	operating = TRUE

	close_door_at = 0
	do_animate("closing")

	density = TRUE
	explosion_resistance = initial(explosion_resistance)
	layer = closed_layer

	update_icon()
	if(visible && !glass)
		set_opacity(TRUE)	//caaaaarn!
	operating = FALSE

/obj/machinery/door/unpowered/manhattan/set_broken()
	..()
	Dismantle(null)

/obj/machinery/door/unpowered/manhattan/proc/Dismantle(mob/user, moved = FALSE)
	material.place_dismantled_product(get_turf(src))
	qdel(src)

/obj/machinery/door/unpowered/manhattan/attack_ai(mob/user as mob) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(Adjacent(user)) //not remotely though
			return attack_hand(user)

/obj/machinery/door/unpowered/manhattan/ex_act(severity)
	switch(severity)
		if(1.0)
			set_broken()
		if(2.0)
			if(prob(25))
				set_broken()
			else
				take_damage(300)
		if(3.0)
			if(prob(20))
				take_damage(150)


/obj/machinery/door/unpowered/manhattan/attackby(obj/item/I as obj, mob/user as mob)
	src.add_fingerprint(user, 0, I)
	if(istype(I, /obj/item/weapon/door/key) && lock)
		var/obj/item/weapon/door/key/K = I
		playsound(src.loc, "sound/effects/doors/door_key.wav", 100, 1)
		if(!lock.toggle(I))
			to_chat(user, "<span class='warning'>\The [K] does not fit in the lock!</span>")
		else
			to_chat(user, "<span class='warning'>You unlock the door.</span>")
		return
	if(lock && lock.pick_lock(I,user))
		return

	if(istype(I,/obj/item/weapon/material/lock_construct))
		if(lock)
			to_chat(user, "<span class='warning'>\The [src] already has a lock.</span>")
		else
			var/obj/item/weapon/material/lock_construct/L = I
			lock = L.create_lock(src,user)
		return

	if(istype(I, /obj/item/weapon/door/masterkey) && lock)
		var/obj/item/weapon/door/masterkey/MK = I
		playsound(src.loc, 'sound/effects/doors/door_key.wav', 100, 1)
		for(var/obj/item/weapon/door/key/K in MK.contents)
			if(!lock.toggle(K))
				continue
			else
				to_chat(user, "<span class='warning'>You use [MK] on the door.</span>")

	if(istype(I, /obj/item/stack/material) && I.get_material_name() == src.get_material_name())
		if(stat & BROKEN)
			to_chat(user, "<span class='notice'>It looks like \the [src] is pretty busted. It's going to need more than just patching up now.</span>")
			return
		if(health >= maxhealth)
			to_chat(user, "<span class='notice'>Nothing to fix!</span>")
			return
		if(!density)
			to_chat(user, "<span class='warning'>\The [src] must be closed before you can repair it.</span>")
			return

		//figure out how much metal we need
		var/obj/item/stack/stack = I
		var/amount_needed = ceil((maxhealth - health)/DOOR_REPAIR_AMOUNT)
		var/used = min(amount_needed,stack.amount)
		if (used)
			to_chat(user, "<span class='notice'>You fit [used] [stack.singular_name]\s to damaged and broken parts on \the [src].</span>")
			stack.use(used)
			health = between(health, health + used*DOOR_REPAIR_AMOUNT, maxhealth)
		return

	//psa to whoever coded this, there are plenty of objects that need to call attack() on doors without bludgeoning them.
	if(src.density && istype(I, /obj/item/weapon) && user.a_intent == I_HURT && !istype(I, /obj/item/weapon/card))
		var/obj/item/weapon/W = I
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(W.damtype == BRUTE || W.damtype == BURN)
			user.do_attack_animation(src)
			if(W.force < min_force)
				user.visible_message("<span class='danger'>\The [user] hits \the [src] with \the [W] with no visible effect.</span>")
			else
				user.visible_message("<span class='danger'>\The [user] forcefully strikes \the [src] with \the [W]!</span>")
				playsound(src.loc, hitsound, 100, 1)
				take_damage(W.force)
		return

	if(src.operating) return

	if(lock && lock.isLocked())
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		to_chat(user, "\The [src] is locked!")
		playsound(src.loc, "sound/effects/doors/door_locked.wav", 50, 1)

//	if(operable())
//		if(src.density)
//			open()
//		else
//			close()
//		return

	return

/obj/machinery/door/unpowered/manhattan/attack_hand(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(lock && lock.isLocked())
		to_chat(user, "\The [src] is locked!")
		if(user.a_intent == I_GRAB)
			if(material == "steel")
				playsound(src.loc, 'sound/effects/doors/door_locked.wav', 70, 1)
			else
				playsound(src.loc, 'sound/effects/doors/doorknock.wav', 70, 1)
			user.visible_message("<span class='danger'>\The [user] knocks at \the [src].</span>")
	if(user.a_intent == I_HURT && user.skill_check(SKILL_CLOSE_COMBAT, SKILL_TRAINED))
		playsound(src.loc, 'sound/effects/doors/smod_freeman.ogg', 70, 1)
		open()
	if(operable())
		if(src.density)
			open()
		else
			close()
		return

/obj/machinery/door/unpowered/manhattan/examine(mob/user)
	if(..(user,1) && lock)
		to_chat(user, "<span class='notice'>It appears to have a lock.</span>")

/obj/machinery/door/unpowered/manhattan/can_open()
	if(!..() || (lock && lock.isLocked()))
		return 0
	return 1

/obj/machinery/door/unpowered/manhattan/Destroy()
	qdel(lock)
	lock = null
	..()

/obj/machinery/door/unpowered/manhattan/wood
	icon_base = "door"
	icon = 'icons/obj/manhattan/wood_door.dmi'
	icon_state = "wood"
	icon_base = "wood"
	opacity = 1
	density = 1
	color = null

/obj/machinery/door/unpowered/manhattan/wood/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "wood", complexity)
	color = null

/obj/machinery/door/unpowered/manhattan/wood/north
	dir = NORTH
	pixel_x = -16
	pixel_y = -8

/obj/machinery/door/unpowered/manhattan/wood/south
	dir = SOUTH
	pixel_x = -16
	pixel_y = -8

/obj/machinery/door/unpowered/manhattan/wood/east
	dir = EAST
	pixel_x = -26
	pixel_y = -5

/obj/machinery/door/unpowered/manhattan/wood/west
	dir = WEST
	pixel_x = -6
	pixel_y = -5

/obj/machinery/door/unpowered/manhattan/steel
	icon = 'icons/obj/manhattan/metal_door.dmi'
	icon_state = "metal"
	icon_base = "metal"
	opacity = 1
	density = 1
	color = null

/obj/machinery/door/unpowered/manhattan/steel/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "steel", complexity)
	color = null

/obj/machinery/door/unpowered/manhattan/steel/north
	dir = NORTH
	pixel_x = -16
	pixel_y = -8

/obj/machinery/door/unpowered/manhattan/steel/south
	dir = SOUTH
	pixel_x = -16
	pixel_y = -8

/obj/machinery/door/unpowered/manhattan/steel/east
	dir = EAST
	pixel_x = -26
	pixel_y = -5

/obj/machinery/door/unpowered/manhattan/steel/west
	dir = WEST
	pixel_x = -6
	pixel_y = -5