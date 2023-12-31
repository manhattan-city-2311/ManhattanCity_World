/obj/structure/grille
	name = "grille"
	desc = "A flimsy lattice of metal rods, with screws to secure it to the floor."
	icon = 'icons/obj/grille.dmi'
	icon_state = "grille"
	density = 1
	anchored = 1
	flags = CONDUCT
	layer = 2.9
	explosion_resistance = 1
	var/health = 10
	var/destroyed = 0
	var/on_frame = FALSE
	blend_objects = list(/obj/machinery/door) // Objects which to blend with
	noblend_objects = list(/obj/machinery/door/window)
	var/electric = 0 //required if we have no engine.
	var/no_states = 0

	unique_save_vars = list("health", "destroyed")

/obj/structure/grille/New()
	. = ..()
	update_connections(1)
	update_icon()

/obj/structure/grille/electric
	name = "electrified grille"
	desc = "An electrified grille, quite dangerous."
	electric = 1

/obj/structure/grille/ex_act(severity)
	qdel(src)

/obj/structure/grille/update_icon()
	update_onframe()

	overlays.Cut()
	if(!no_states)
		if(destroyed)
			if(on_frame)
				icon_state = "broke_onframe"
			else
				icon_state = "broken"
		else
			var/image/I
			icon_state = ""
			if(on_frame)
				for(var/i = 1 to 4)
					if(other_connections[i] != "0")
						I = image(icon, "grille_other_onframe[connections[i]]", dir = 1<<(i-1))
					else
						I = image(icon, "grille_onframe[connections[i]]", dir = 1<<(i-1))
					overlays += I
			else
				for(var/i = 1 to 4)
					if(other_connections[i] != "0")
						I = image(icon, "grille_other[connections[i]]", dir = 1<<(i-1))
					else
						I = image(icon, "grille[connections[i]]", dir = 1<<(i-1))
					overlays += I

/obj/structure/grille/Bumped(atom/user)
	if(ishuman(user)) shock(user, 70)

/obj/structure/grille/attack_hand(mob/user as mob)

	user.setClickCooldown(user.get_attack_speed())
	playsound(loc, 'sound/effects/grillehit.ogg', 80, 1)
	user.do_attack_animation(src)

	var/damage_dealt = 1
	var/attack_message = "kicks"
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			attack_message = "mangles"
			damage_dealt = 5
	if(shock(user, 50))
		return

	if(HULK in user.mutations)
		damage_dealt += 5
	else
		damage_dealt += 1

	attack_generic(user,damage_dealt,attack_message)

/obj/structure/grille/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover) && (mover.checkpass(PASSGRILLE) || mover.elevation != elevation))
		return 1
	else
		if(istype(mover, /obj/item/projectile))
			return prob(30)
		else
			return (!density || (mover && mover.elevation != elevation))

/obj/structure/grille/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return

	//Flimsy grilles aren't so great at stopping projectiles. However they can absorb some of the impact
	var/damage = Proj.get_structure_damage()
	var/passthrough = 0

	if(!damage) return

	//20% chance that the grille provides a bit more cover than usual. Support structure for example might take up 20% of the grille's area.
	//If they click on the grille itself then we assume they are aiming at the grille itself and the extra cover behaviour is always used.
	switch(Proj.damage_type)
		if(BRUTE)
			//bullets
			if(Proj.original == src || prob(20))
				Proj.damage *= between(0, Proj.damage/60, 0.5)
				if(prob(max((damage-10)/25, 0))*100)
					passthrough = 1
			else
				Proj.damage *= between(0, Proj.damage/60, 1)
				passthrough = 1
		if(BURN)
			//beams and other projectiles are either blocked completely by grilles or stop half the damage.
			if(!(Proj.original == src || prob(20)))
				Proj.damage *= 0.5
				passthrough = 1

	if(passthrough)
		. = PROJECTILE_CONTINUE
		damage = between(0, (damage - Proj.damage)*(Proj.damage_type == BRUTE? 0.4 : 1), 10) //if the bullet passes through then the grille avoids most of the damage

	src.health -= damage*0.2
	spawn(0) healthcheck() //spawn to make sure we return properly if the grille is deleted

/obj/structure/grille/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(iswirecutter(W))
		if(!shock(user, 100))
			playsound(src, W.usesound, 100, 1)
			new /obj/item/stack/rods(get_turf(src), destroyed ? 1 : 2)
			qdel(src)
	else if((isscrewdriver(W)) && (istype(loc, /turf/simulated) || anchored))
		if(!shock(user, 90))
			playsound(src, W.usesound, 100, 1)
			anchored = !anchored
			user.visible_message("<span class='notice'>[user] [anchored ? "fastens" : "unfastens"] the grille.</span>", \
								 "<span class='notice'>You have [anchored ? "fastened the grille to" : "unfastened the grill from"] the floor.</span>")
			return

//window placing begin //TODO CONVERT PROPERLY TO MATERIAL DATUM
	else if(istype(W,/obj/item/stack/material))
		var/obj/item/stack/material/ST = W
		if(!ST.material.created_window)
			return 0

		for(var/obj/structure/window/WINDOW in loc)
			to_chat(user, "<span class='notice'>There is already a window there.</span>")
			return

		to_chat(user, "<span class='notice'>You start placing the window.</span>")
		if(do_after(user,20,src))
			for(var/obj/structure/window/WINDOW in loc)
				to_chat(user, "<span class='notice'>There is already a window there.</span>")
				return

			var/wtype = ST.material.created_window
			if (ST.use(1))
				var/obj/structure/window/WD = new wtype(loc)
				to_chat(user, "<span class='notice'>You place the [WD] on [src].</span>")
				WD.anchored = TRUE
				WD.update_icon()
		return
//window placing end

	else if(!(W.flags & CONDUCT) || !shock(user, 70))
		user.setClickCooldown(user.get_attack_speed(W))
		user.do_attack_animation(src)
		playsound(loc, 'sound/effects/grillehit.ogg', 80, 1)
		switch(W.damtype)
			if("fire")
				health -= W.force
			if("brute")
				health -= W.force * 0.1
	healthcheck()
	..()
	return


/obj/structure/grille/proc/healthcheck()
	if(health <= 0)
		if(!destroyed)
			density = 0
			destroyed = 1
			update_icon()
			new /obj/item/stack/rods(get_turf(src))

		else
			if(health <= -6)
				new /obj/item/stack/rods(get_turf(src))
				qdel(src)
				return
	return


// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(var/mob/living/carbon/human/user as mob)
	if(!anchored || destroyed) // anchored/destroyed grilles are never connected
		return 0
	if(!in_range(src, user)) //To prevent TK and mech users from getting shocked
		return 0

	if(electric)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		if(istype(user, /mob/living/carbon/human))
			user.electrify(user, 120)
		if(user.stunned)
			return 1
		else
			return 0

//Lack of engine makes the following redundant. Commenting out.
/*	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(electrocute_mob(user, C, src))
			if(C.powernet)
				C.powernet.trigger_warning()
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if(user.stunned)
				return 1
		else
			return 0
	return 0
*/

/obj/structure/grille/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!destroyed)
		if(exposed_temperature > T0C + 1500)
			health -= 1
			healthcheck()
	..()

/obj/structure/grille/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	user.do_attack_animation(src)
	health -= damage
	spawn(1) healthcheck()
	return 1

// Used in mapping
/obj/structure/grille/broken
	destroyed = 1
	icon_state = "broken"
	density = 0
	New()
		..()
		health = rand(-5, -1) //In the destroyed but not utterly threshold.
		healthcheck() //Send this to healthcheck just in case we want to do something else with it.

/obj/structure/grille/cult
	name = "cult grille"
	desc = "A matrice built out of an unknown material, with some sort of force field blocking air around it"
	icon = 'icons/obj/grille_cult.dmi'
	health = 40 //Make it strong enough to avoid people breaking in too easily

/obj/structure/grille/cult/CanPass(atom/movable/mover, turf/target, height = 1.5, air_group = 0)
	if(air_group)
		return 0 //Make sure air doesn't drain
	..()

/obj/structure/grille/broken/cult
	icon_state = "grillecult-b"

/obj/structure/grille/crescent

/obj/structure/grille/crescent/attack_hand()
	return

/obj/structure/grille/crescent/attackby()
	return

/obj/structure/grille/crescent/ex_act()
	return

/obj/structure/grille/crescent/hitby()
	return

/*
/obj/structure/grille/rustic
	name = "rustic grille"
	desc = "A lattice of metal, arranged in an old, rustic fashion."
	icon_state = "grillerustic"

/obj/structure/grille/broken/rustic
	icon_state = "grillerustic-b"
*/

/obj/structure/grille/fence/
	blend_objects = 0
	var/width = 3
	health = 50

/obj/structure/grille/fence/New()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size


/obj/structure/grille/fence/east_west
//	bound_width=80
//	bound_height=42
	icon='icons/obj/fences.dmi'

/obj/structure/grille/fence/north_south
//	bound_width=80
//	bound_height=42
	icon='icons/obj/fences2.dmi'

/obj/structure/grille/proc/update_onframe()
	on_frame = FALSE
	var/turf/T = get_turf(src)
	for(var/obj/O in T)
		if(istype(O, /obj/structure/wall_frame))
			on_frame = TRUE
			break