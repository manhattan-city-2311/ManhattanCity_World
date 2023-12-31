// BLAST DOORS
//
// Refactored 27.12.2014 by Atlantis
//
// Blast doors are suposed to be reinforced versions of regular doors. Instead of being manually
// controlled they use buttons or other means of remote control. This is why they cannot be emagged
// as they lack any ID scanning system, they just handle remote control signals. Subtypes have
// different icons, which are defined by set of variables. Subtypes are on bottom of this file.

/obj/machinery/door/blast
	name = "Blast Door"
	desc = "That looks like it doesn't open easily."
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = null
	min_force = 20 //minimum amount of force needed to damage the door with a melee weapon
	var/material/implicit_material
	// Icon states for different shutter types. Simply change this instead of rewriting the update_icon proc.
	var/icon_state_open = null
	var/icon_state_opening = null
	var/icon_state_closed = null
	var/icon_state_closing = null

	var/open_sound = 'sound/machines/airlock_heavy.ogg'
	var/close_sound = 'sound/machines/AirlockClose_heavy.ogg'

	closed_layer = ON_WINDOW_LAYER // Above airlocks when closed
	var/id = 1.0
	dir = 1
	explosion_resistance = 25

	//Most blast doors are infrequently toggled and sometimes used with regular doors anyways,
	//turning this off prevents awkward zone geometry in places like medbay lobby, for example.
	block_air_zones = 0

	var/begins_closed = TRUE


	unique_save_vars = list("id", "density")

/obj/machinery/door/blast/on_persistence_load()
	update_icon()

/obj/machinery/door/blast/initialize()
	..()

	if(!begins_closed)
		icon_state = icon_state_open
		set_density(0)
		set_opacity(0)
		layer = open_layer

	implicit_material = get_material_by_name("plasteel")

/obj/machinery/door/blast/get_material()
	return implicit_material

// Proc: Bumped()
// Parameters: 1 (AM - Atom that tried to walk through this object)
// Description: If we are open returns zero, otherwise returns result of parent function.
/obj/machinery/door/blast/Bumped(atom/AM)
	if(!density)
		return ..()
	else
		return 0

// Proc: update_icon()
// Parameters: None
// Description: Updates icon of this object. Uses icon state variables.
/obj/machinery/door/blast/update_icon()
	if(density)
		icon_state = icon_state_closed
	else
		icon_state = icon_state_open
	return

// Proc: force_open()
// Parameters: None
// Description: Opens the door. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_open()
	src.operating = 1
	playsound(src.loc, open_sound, 100, 1)
	flick(icon_state_opening, src)
	src.density = 0

	src.update_icon()
	src.set_opacity(0)
	sleep(15)
	src.layer = open_layer
	src.operating = 0

// Proc: force_close()
// Parameters: None
// Description: Closes the door. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_close()
	src.operating = 1
	playsound(src.loc, close_sound, 100, 1)
	src.layer = closed_layer
	flick(icon_state_closing, src)
	src.density = 1

	src.update_icon()
	src.set_opacity(initial(opacity))
	sleep(15)
	src.operating = 0

// Proc: force_toggle()
// Parameters: None
// Description: Opens or closes the door, depending on current state. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_toggle(var/forced = 0, mob/user as mob)
	if (forced)
		playsound(src.loc, 'sound/machines/airlock_creaking.ogg', 100, 1)

	if(src.density)
		src.force_open()
	else
		src.force_close()

//Proc: attack_hand
//Description: Attacked with empty hand. Only to allow special attack_bys.
/obj/machinery/door/blast/attack_hand(mob/user as mob)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/X = user
		if(istype(X.species, /datum/species/xenos))
			src.attack_alien(user)
			return
	..()


// Proc: attackby()
// Parameters: 2 (C - Item this object was clicked with, user - Mob which clicked this object)
// Description: If we are clicked with crowbar, wielded fire axe, or armblade, try to manually open the door.
// This only works on broken doors or doors without power. Also allows repair with Plasteel.
/obj/machinery/door/blast/attackby(obj/item/weapon/C as obj, mob/user as mob)
	src.add_fingerprint(user)
	if(istype(C, /obj/item/weapon)) // For reasons unknown, sometimes C is actually not what it is advertised as, like a mob.
		if(C.pry == 1 && (user.a_intent != I_HURT || (stat & BROKEN))) // Can we pry it open with something, like a crowbar/fireaxe/lingblade?
			if(istype(C,/obj/item/weapon/material/twohanded/fireaxe)) // Fireaxes need to be in both hands to pry.
				var/obj/item/weapon/material/twohanded/fireaxe/F = C
				if(!F.wielded)
					to_chat(user, "<span class='warning'>You need to be wielding \the [F] to do that.</span>")
					return

			// If we're at this point, it's a fireaxe in both hands or something else that doesn't care for twohanding.
			if(((stat & NOPOWER) || (stat & BROKEN)) && !( src.operating ))
				force_toggle(1, user)

			else
				to_chat(usr, "<span class='notice'>[src]'s motors resist your effort.</span>")
			return


		else if(src.density && (user.a_intent == I_HURT)) //If we can't pry it open and it's a weapon, let's hit it.
			var/obj/item/weapon/W = C
			user.setClickCooldown(user.get_attack_speed(W))
			if(W.damtype == BRUTE || W.damtype == BURN)
				user.do_attack_animation(src)
				if(W.force < min_force)
					user.visible_message("<span class='danger'>\The [user] hits \the [src] with \the [W] with no visible effect.</span>")
				else
					user.visible_message("<span class='danger'>\The [user] forcefully strikes \the [src] with \the [W]!</span>")
					playsound(src.loc, hitsound, 100, 1)
					take_damage(W.force*0.35) //it's a blast door, it should take a while. -Luke
				return

	else if(istype(C, /obj/item/stack/material) && C.get_material_name() == "plasteel") // Repairing.
		var/amt = ceil((maxhealth - health)/150)
		if(!amt)
			to_chat(usr, "<span class='notice'>\The [src] is already fully repaired.</span>")
			return
		var/obj/item/stack/P = C
		if(P.amount < amt)
			to_chat(usr, "<span class='warning'>You don't have enough sheets to repair this! You need at least [amt] sheets.</span>")
			return
		to_chat(usr, "<span class='notice'>You begin repairing [src]...</span>")
		if(do_after(usr, 30))
			if(P.use(amt))
				to_chat(usr, "<span class='notice'>You have repaired \The [src]</span>")
				src.repair()
			else
				to_chat(usr, "<span class='warning'>You don't have enough sheets to repair this! You need at least [amt] sheets.</span>")

	else if(src.density && (user.a_intent == I_HURT)) //If we can't pry it open and it's not a weapon.... Eh, let's attack it anyway.
		var/obj/item/weapon/W = C
		user.setClickCooldown(user.get_attack_speed(W))
		if(W.damtype == BRUTE || W.damtype == BURN)
			user.do_attack_animation(src)
			if(W.force < min_force) //No actual non-weapon item shouls have a force greater than the min_force, but let's include this just in case.
				user.visible_message("<span class='danger'>\The [user] hits \the [src] with \the [W] with no visible effect.</span>")
			else
				user.visible_message("<span class='danger'>\The [user] forcefully strikes \the [src] with \the [W]!</span>")
				playsound(src.loc, hitsound, 100, 1)
				take_damage(W.force*0.15) //If the item isn't a weapon, let's make this take longer than usual to break it down.
			return

// Proc: attack_alien()
// Parameters: Attacking Xeno mob.
// Description: Forces open the door after a delay.
/obj/machinery/door/blast/attack_alien(var/mob/user) //Familiar, right? Doors.
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/X = user
		if(istype(X.species, /datum/species/xenos))
			if(src.density)
				visible_message("<span class='alium'>\The [user] begins forcing \the [src] open!</span>")
				if(do_after(user, 15 SECONDS,src))
					playsound(src.loc, 'sound/machines/airlock_creaking.ogg', 100, 1)
					visible_message("<span class='danger'>\The [user] forces \the [src] open!</span>")
					force_open(1)
			else
				visible_message("<span class='alium'>\The [user] begins forcing \the [src] closed!</span>")
				if(do_after(user, 5 SECONDS,src))
					playsound(src.loc, 'sound/machines/airlock_creaking.ogg', 100, 1)
					visible_message("<span class='danger'>\The [user] forces \the [src] closed!</span>")
					force_close(1)
		else
			visible_message("<span class='notice'>\The [user] strains fruitlessly to force \the [src] [density ? "open" : "closed"].</span>")
			return
	..()

// Proc: open()
// Parameters: None
// Description: Opens the door. Does necessary checks. Automatically closes if autoclose is true
/obj/machinery/door/blast/open(var/forced = 0)
	if(forced)
		force_open()
		return 1
	else
		if (src.operating || (stat & BROKEN || stat & NOPOWER))
			return 1
		force_open()

	if(autoclose && src.operating && !(stat & BROKEN || stat & NOPOWER))
		spawn(150)
			close()
	return 1

// Proc: close()
// Parameters: None
// Description: Closes the door. Does necessary checks.
/obj/machinery/door/blast/close()
	if (src.operating || (stat & BROKEN || stat & NOPOWER))
		return
	force_close()


// Proc: repair()
// Parameters: None
// Description: Fully repairs the blast door.
/obj/machinery/door/blast/proc/repair()
	health = maxhealth
	if(stat & BROKEN)
		stat &= ~BROKEN


/obj/machinery/door/blast/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 1
	return ..()



// SUBTYPE: Regular
// Your classical blast door, found almost everywhere.
obj/machinery/door/blast/regular
	icon_state_open = "pdoor0"
	icon_state_opening = "pdoorc0"
	icon_state_closed = "pdoor1"
	icon_state_closing = "pdoorc1"
	icon_state = "pdoor1"
	maxhealth = 600

obj/machinery/door/blast/regular/open
	icon_state = "pdoor0"
	density = 0
	opacity = 0

// SUBTYPE: Shutters
// Nicer looking, and also weaker, shutters. Found in kitchen and similar areas.
/obj/machinery/door/blast/shutters
	icon_state_open = "shutter0"
	icon_state_opening = "shutterc0"
	icon_state_closed = "shutter1"
	icon_state_closing = "shutterc1"
	icon_state = "shutter1"
