// The lighting system
// consists of light fixtures (/obj/machinery/light) and light tube/bulb items (/obj/item/weapon/light)

// status values shared between lighting fixtures and items
#define LIGHT_OK 0
#define LIGHT_EMPTY 1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3
#define LIGHT_BULB_TEMPERATURE 400 //K - used value for a 60W bulb
#define LIGHTING_POWER_FACTOR 5		//5W per luminosity * range

// the standard tube light fixture
/obj/machinery/light
	name = "light fixture"
	icon = 'icons/obj/lighting.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube1"
	desc = "A lighting fixture."
	anchored = 1
	layer = OBJ_LAYER
	plane = LIGHTING_OBJS_PLANE
	use_power = 2
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT //Lights are calc'd via area so they dont need to be in the machine list
	var/on = TRUE					// 1 if on, 0 if off
	var/brightness_range
	var/brightness_power
	var/brightness_color
	var/status = LIGHT_OK		// LIGHT_OK, _EMPTY, _BURNED or _BROKEN
	var/flickering = 0
	var/light_type = /obj/item/weapon/light/tube		// the type of light item
	var/construct_type = /obj/machinery/light_construct
	var/switchcount = 0			// count of number of times switched on/off
								// this is used to calc the probability the light burns out

	var/rigged = 0				// true if rigged to explode
	var/on_wall = 1
	var/auto_flicker = FALSE // If true, will constantly flicker, so long as someone is around to see it (otherwise its a waste of CPU).

	unique_save_vars = list("status", "switchcount", "on", "rigged")
	var/emissive_state = "tube-emissive"

// create a new lighting fixture
/obj/machinery/light/New(atom/newloc, obj/machinery/light_construct/construct = null)
	. = ..(newloc)

	if(construct)
		status = LIGHT_EMPTY
		construct_type = construct.type
		construct.transfer_fingerprints_to(src)
		set_dir(construct.dir)
	else
		var/obj/item/weapon/light/L = get_light_type_instance(light_type)
		update_from_bulb(L)
		if(prob(L.broken_chance))
			broken(1)

	update(0)

/obj/machinery/light/built/New()
	status = LIGHT_EMPTY
	update(0)
	. = ..()

/obj/machinery/light/small/built/New()
	status = LIGHT_EMPTY
	update(0)
	. = ..()

/obj/machinery/light/Destroy()
	var/area/A = get_area(src)
	if(A)
		on = 0
//		A.update_lights()
	return ..()

/obj/machinery/light/attack_hand(mob/user)

	add_fingerprint(user)

	if(status == LIGHT_EMPTY)
		to_chat(user, "There is no [get_fitting_name()] in this light.")
		return

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			user.setClickCooldown(user.get_attack_speed())
			if(trigger_lot_security_system(null, /datum/lot_security_option/vandalism, "Attempted to smash [src]."))
				return
			for(var/mob/M in viewers(src))
				M.show_message("<font color='red'>[user.name] smashed the light!</font>", 3, "You hear a tinkle of breaking glass", 2)
			broken()
			return

	// make it burn hands if not wearing fire-insulated gloves
	if(on)
		var/prot = 0
		var/mob/living/carbon/human/H = user

		if(istype(H))
			if(H.species.heat_level_1 > LIGHT_BULB_TEMPERATURE)
				prot = 1
			else if(H.gloves)
				var/obj/item/clothing/gloves/G = H.gloves
				if(G.max_heat_protection_temperature)
					if(G.max_heat_protection_temperature > LIGHT_BULB_TEMPERATURE)
						prot = 1
		else
			prot = 1

		if(!prot && trigger_lot_security_system(null, /datum/lot_security_option/vandalism, "Tried to remove [src] from the fitting."))
			return

		if(prot > 0 || (COLD_RESISTANCE in user.mutations))
			to_chat(user, "You remove the light [get_fitting_name()]")
		else if(TK in user.mutations)
			to_chat(user, "You telekinetically remove the light [get_fitting_name()].")
		else
			to_chat(user, "You try to remove the light [get_fitting_name()], but it's too hot and you don't want to burn your hand.")
			return	// if burned, don't remove the light
	else
		to_chat(user, "You remove the light [get_fitting_name()].")

	// create a light tube/bulb item and put it in the user's hand
	update()
	user.put_in_active_hand(remove_bulb())	//puts it in our active hand

/obj/machinery/light/var/icondebugenabled = FALSE
/obj/machinery/light/update_icon()
	if(on_wall)
		pixel_y = 0
		pixel_x = 0
		var/turf/T = get_step(get_turf(src), dir)
		if(istype(T, /turf/simulated/wall))
			if(dir == NORTH) // 1
				pixel_y = 18
			else if(dir == EAST) // 4
				pixel_x = 10
			else if(dir == WEST) // 8
				pixel_x = -10
			//
			var/directionToCheck = dir
			if(directionToCheck % 4 == 0)
				var/turf/Tbottom
				var/turf/Tupper
				if(directionToCheck == EAST)
					Tbottom = get_step(get_turf(src), SOUTHEAST)
					Tupper = get_step(get_turf(src), NORTHEAST)
				else if(directionToCheck == WEST)
					Tbottom = get_step(get_turf(src), SOUTHWEST)
					Tupper = get_step(get_turf(src), NORTHWEST)
				if(icondebugenabled)
					to_world("B[!Tbottom.contains_dense_objects()] U[Tupper.contains_dense_objects()]")
				if(!istype(Tbottom, /turf/simulated/wall) && istype(Tupper, /turf/simulated/wall)) // if(!Tbottom.contains_dense_objects() && Tupper.contains_dense_objects())
					pixel_y = 18
					//  |  |
					// >\__/<
					// pixel_y = 18
					//
			else
				var/turf/Tleft
				var/turf/Tright
				if(directionToCheck == NORTH)
					Tleft = get_step(get_turf(src), NORTHWEST)
					Tright = get_step(get_turf(src), NORTHEAST)
				else if(directionToCheck == SOUTH)
					Tleft = get_step(get_turf(src), SOUTHWEST)
					Tright = get_step(get_turf(src), SOUTHEAST)
				if(icondebugenabled)
					to_world("L[!Tleft.contains_dense_objects()] R[Tright.contains_dense_objects()]")
					to_world("L[Tleft.contains_dense_objects()] R[!Tright.contains_dense_objects()]")
				if(!istype(Tleft, /turf/simulated/wall) && istype(Tright, /turf/simulated/wall)) // if(!Tleft.contains_dense_objects() && Tright.contains_dense_objects())
					pixel_x = 10
				else if(istype(Tleft, /turf/simulated/wall) && !istype(Tright, /turf/simulated/wall)) // if(Tleft.contains_dense_objects() && !Tright.contains_dense_objects())
					pixel_x = -10
					//  |  |
					//  \__/
					//   ^^
					// pixel_x = +/- 10
					//

	cut_overlays()
	switch(status)		// set icon_states
		if(LIGHT_OK)
			icon_state = "[base_state][on]"
			if(on && emissive_state)
				add_overlay(emissive_appearance(icon, emissive_state))
		if(LIGHT_EMPTY)
			icon_state = "[base_state]-empty"
			on = 0
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			on = 0
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			on = 0

// update the icon_state and luminosity of the light depending on its state
/obj/machinery/light/proc/update(var/trigger = 1)
	update_icon()
	if(QDELETED(LocationOfLightSource))
		LocationOfLightSource = null
	if(on)
		if(light_range != brightness_range || light_power != brightness_power || light_color != brightness_color)
			switchcount++
			if(rigged)
				if(status == LIGHT_OK && trigger)

					log_admin("LOG: Rigged light explosion, last touched by [fingerprintslast]")
					message_admins("LOG: Rigged light explosion, last touched by [fingerprintslast]")

					explode()
			else if( prob( min(60, switchcount*switchcount*0.01) ) )
				if(status == LIGHT_OK && trigger)
					status = LIGHT_BURNED
					update_icon()
					on = 0
					set_light(0)
					if(LocationOfLightSource)
						LocationOfLightSource.set_light(0)
			else
				use_power = 2
				if(LocationOfLightSource)
					LocationOfLightSource.set_light(brightness_range, brightness_power, brightness_color)
					set_light(0)
				else
					set_light(brightness_range, brightness_power, brightness_color)
	else
		use_power = 1
		set_light(0)
		LocationOfLightSource?.set_light(0)

	active_power_usage = ((light_range * light_power) * LIGHTING_POWER_FACTOR)


/obj/machinery/light/attack_generic(var/mob/user, var/damage)
	if(!damage)
		return
	if(status == LIGHT_EMPTY||status == LIGHT_BROKEN)
		to_chat(user, "That object is useless to you.")
		return
	if(!(status == LIGHT_OK||status == LIGHT_BURNED))
		return
	if(trigger_lot_security_system(null, /datum/lot_security_option/vandalism, "Attempted to smash [src]."))
		return

	visible_message("<span class='danger'>[user] smashes the light!</span>")
	user.do_attack_animation(src)
	broken()
	return 1

/obj/machinery/light/blob_act()
	broken()

// attempt to set the light's on/off status
// will not switch on if broken/burned/empty
/obj/machinery/light/proc/seton(var/s)
	on = (s && status == LIGHT_OK)
	update()

// examine verb
/obj/machinery/light/examine(mob/user)
	var/fitting = get_fitting_name()
	switch(status)
		if(LIGHT_OK)
			to_chat(user, "[desc] It is turned [on? "on" : "off"].")
		if(LIGHT_EMPTY)
			to_chat(user, "[desc] The [fitting] has been removed.")
		if(LIGHT_BURNED)
			to_chat(user, "[desc] The [fitting] is burnt out.")
		if(LIGHT_BROKEN)
			to_chat(user, "[desc] The [fitting] has been smashed.")

/obj/machinery/light/proc/get_fitting_name()
	var/obj/item/weapon/light/L = light_type
	return initial(L.name)

/obj/machinery/light/proc/update_from_bulb(obj/item/weapon/light/L)
	status = L.status
	switchcount = L.switchcount
	rigged = L.rigged
	brightness_range = L.brightness_range
	brightness_power = L.brightness_power
	brightness_color = L.brightness_color

// attack with item - insert light (if right type), otherwise try to break the light

/obj/machinery/light/proc/insert_bulb(obj/item/weapon/light/L)
	update_from_bulb(L)
	qdel(L)

	update()

	if(on && rigged)

		log_admin("LOG: Rigged light explosion, last touched by [fingerprintslast]")
		message_admins("LOG: Rigged light explosion, last touched by [fingerprintslast]")

		explode()

/obj/machinery/light/proc/remove_bulb()
	. = new light_type(src.loc, src)

	switchcount = 0
	status = LIGHT_EMPTY
	update()

/obj/machinery/light/attackby(obj/item/W, mob/user)

	//Light replacer code
	if(istype(W, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/LR = W
		if(isliving(user))
			var/mob/living/U = user
			LR.ReplaceLight(src, U)
			return

	// attempt to insert light
	if(istype(W, /obj/item/weapon/light))
		if(status != LIGHT_EMPTY)
			to_chat(user, "There is a [get_fitting_name()] already inserted.")
			return
		if(!istype(W, light_type))
			to_chat(user, "This type of light requires a [get_fitting_name()].")
			return
		to_chat(user, "You insert [W].")
		insert_bulb(W)
		src.add_fingerprint(user)

		// attempt to break the light
		//If xenos decide they want to smash a light bulb with a toolbox, who am I to stop them? /N

	else if(status != LIGHT_BROKEN && status != LIGHT_EMPTY)
		if(trigger_lot_security_system(null, /datum/lot_security_option/vandalism, "Attempted to smash [src] with [W]."))
			return

		if(prob(1+W.force * 5))
			to_chat(user, "You hit the light, and it smashes!")
			for(var/mob/M in viewers(src))
				if(M == user)
					continue
				M.show_message("[user.name] smashed the light!", 3, "You hear a tinkle of breaking glass", 2)
			if(on && (W.flags & CONDUCT))
				//if(!user.mutations & COLD_RESISTANCE)
				if (prob(12))
					electrocute_mob(user, get_area(src), src, 0.3)
			broken()

		else
			to_chat(user, "You hit the light!")

	// attempt to stick weapon into light socket
	else if(status == LIGHT_EMPTY)
		if(istype(W, /obj/item/weapon/screwdriver)) //If it's a screwdriver open it.
			playsound(src, W.usesound, 75, 1)
			user.visible_message("[user.name] opens [src]'s casing.", \
				"You open [src]'s casing.", "You hear a noise.")
			new construct_type(src.loc, src)
			qdel(src)
			return

		to_chat(user, "You stick \the [W] into the light socket!")
		if(has_power() && (W.flags & CONDUCT))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			//if(!user.mutations & COLD_RESISTANCE)
			if (prob(75))
				electrocute_mob(user, get_area(src), src, rand(0.7,1.0))

// returns whether this light has power
// true if area has power and lightswitch is on
/obj/machinery/light/proc/has_power()
	var/area/A = get_area(src)
	return A?.lightswitch


/obj/machinery/light/proc/flicker(var/amount = rand(10, 20))
	if(flickering) return
	flickering = 1
	spawn(0)
		if(on && status == LIGHT_OK)
			for(var/i = 0; i < amount; i++)
				if(status != LIGHT_OK) break
				on = !on
				update(0)
				sleep(rand(5, 15))
			on = (status == LIGHT_OK)
			update(0)
		flickering = 0

// ai attack - make lights flicker, because why not

/obj/machinery/light/attack_ai(mob/user)
	src.flicker(1)


// attack with hand - remove tube/bulb
// if hands aren't protected and the light is on, burn the player

/obj/machinery/light/attack_tk(mob/user)
	if(status == LIGHT_EMPTY)
		to_chat(user, "There is no [get_fitting_name()] in this light.")
		return

	to_chat(user, "You telekinetically remove the light [get_fitting_name()].")
	remove_bulb()

// break the light and make sparks if was on

/obj/machinery/light/proc/broken(var/skip_sound_and_sparks = 0)
	if(status == LIGHT_EMPTY)
		return

	if(!skip_sound_and_sparks)
		if(status == LIGHT_OK || status == LIGHT_BURNED)
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		if(on)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
	status = LIGHT_BROKEN
	update()

/obj/machinery/light/proc/fix()
	if(status == LIGHT_OK)
		return
	status = LIGHT_OK
	on = 1
	update()

// explosion effect
// destroy the whole light fixture or just shatter it

/obj/machinery/light/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(75))
				broken()
		if(3.0)
			if (prob(50))
				broken()

//blob effect
// timed process
// use power

/obj/machinery/light/process()
	if(auto_flicker && !flickering)
		if(check_for_player_proximity(src, radius = 12, ignore_ghosts = FALSE, ignore_afk = TRUE))
			seton(TRUE) // Lights must be on to flicker.
			flicker(5)
		else
			seton(FALSE) // Otherwise keep it dark and spooky for when someone shows up.
	else
		return PROCESS_KILL


// called when area power state changes
/obj/machinery/light/power_change()
	spawn(10)
		seton(has_power())

// called when on fire

/obj/machinery/light/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 673)))   //0% at <400C, 100% at >500C
		broken()

// explode the light

/obj/machinery/light/proc/explode()
	var/turf/T = get_turf(src.loc)
	spawn(0)
		broken()	// break it first to give a warning
		sleep(2)
		explosion(T, 0, 0, 2, 2)
		sleep(1)
		qdel(src)


/obj/machinery/light/on_persistence_load()
	update(0)
