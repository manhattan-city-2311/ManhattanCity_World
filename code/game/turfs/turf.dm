/turf
	icon = 'icons/turf/floors.dmi'
	appearance_flags = TILE_MOVER | PIXEL_SCALE
	layer = TURF_LAYER
	plane = TURF_PLANE
	level = 1
	var/holy = 0

	var/natural_elevation_mod = 0 //People stepping on this turf just get their elevation modified by this amount.
	var/list/elevation_impacters = list() //A list of items that impact elevation, present on this tile.

	//Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	// General properties.
	var/icon_old = null
	var/pathweight = 10          // How much does it cost to pathfind over this turf?
	var/blessed = 0             // Has the turf been blessed?

	var/list/decals

	var/movement_cost = 0       // How much the turf slows down movement, if any.

	var/list/footstep_sounds = null

	var/block_tele = FALSE      // If true, most forms of teleporting to or from this turf tile will fail.
	var/list/dangerous_objects // List of 'dangerous' objs that the turf holds that can cause something bad to happen when stepped on, used for AI mobs.

/turf/CanPass(atom/movable/mover, turf/target, height=1.5,air_group=0)
	if(!target) return 0

	if(istype(mover)) // turf/Enter(...) will perform more advanced checks
		return !density

	else // Now, doing more detailed checks for air movement and air group formation
		for(var/obj/obstacle in src)
			if(!obstacle.CanPass(mover, target, height, air_group))
				return 0
		if(target != src)
			for(var/obj/obstacle in target)
				if(!obstacle.CanPass(mover, src, height, air_group))
					return 0
		return 1

/turf/New()
	..()
	for(var/atom/movable/AM as mob|obj in src)
		spawn( 0 )
			src.Entered(AM)
			return
	turfs |= src

	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	if(movement_cost && pathweight == 1) // This updates pathweight automatically.
		pathweight = movement_cost

/turf/Destroy()
	turfs -= src
	..()
	return QDEL_HINT_IWILLGC

/turf/ex_act(severity)
	return 0

/turf/proc/is_space()
	return 0

/turf/proc/is_intact()
	return 0

/turf/attack_hand(mob/user)
	if(!(user.canmove) || user.restrained() || !(user.pulling))
		return 0
	if(user.pulling.anchored || !isturf(user.pulling.loc))
		return 0
	if(user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1)
		return 0
	if(ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return 1

turf/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = W
		if(S.use_to_pickup && S.collection_mode)
			S.gather_all(src, user)
	return ..()

// Hits a mob on the tile.
/turf/proc/attack_tile(obj/item/weapon/W, mob/living/user)
	if(!istype(W))
		return FALSE

	var/list/viable_targets = list()
	var/success = FALSE // Hitting something makes this true. If its still false, the miss sound is played.

	for(var/mob/living/L in contents)
		if(L == user) // Don't hit ourselves.
			continue
		viable_targets += L

	if(!viable_targets.len) // No valid targets on this tile.
		if(W.can_cleave)
			success = W.cleave(user, src)
	else
		var/mob/living/victim = pick(viable_targets)
		success = W.resolve_attackby(victim, user)

	user.setClickCooldown(user.get_attack_speed(W))
	user.do_attack_animation(src, no_attack_icons = TRUE)

	if(!success) // Nothing got hit.
		user.visible_message("<span class='warning'>\The [user] swipes \the [W] over \the [src].</span>")
		playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	return success

/turf/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	var/turf/T = get_turf(user)
	var/area/A = T.loc
	if((istype(A) && !(A.has_gravity)) || (istype(T,/turf/space)))
		return
	if(istype(O, /obj/screen))
		return
	if(user.restrained() || user.stat || user.stunned || user.paralysis || (!user.lying && !istype(user, /mob/living/silicon/robot)))
		return
	if((!(istype(O, /atom/movable)) || O.anchored || !Adjacent(user) || !Adjacent(O) || !user.Adjacent(O)))
		return
	if(!isturf(O.loc) || !isturf(user.loc))
		return
	if(isanimal(user) && O != user)
		return
	if (do_after(user, 25 + (5 * user.weakened)) && !(user.stat))
		step_towards(O, src)
		if(ismob(O))
			animate(O, transform = turn(O.transform, 20), time = 2)
			sleep(2)
			animate(O, transform = turn(O.transform, -40), time = 4)
			sleep(4)
			animate(O, transform = turn(O.transform, 20), time = 2)

/atom/Cross()
	return TRUE

/turf/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		to_chat(usr, "<span class='warning'>Movement is admin-disabled.</span>") //This is to identify lag problems
		return

	..()

	if (!mover || !isturf(mover.loc))
		return 1

	//First, check objects to block exit that are not on the border
	for(var/obj/obstacle in mover.loc)
		if(!(obstacle.flags & ON_BORDER) && (mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				mover.Bump(obstacle, 1)
				return 0

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in mover.loc)
		if((border_obstacle.flags & ON_BORDER) && (mover != border_obstacle) && (forget != border_obstacle))
			if(!border_obstacle.CheckExit(mover, src))
				mover.Bump(border_obstacle, 1)
				return 0

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src)
		if(border_obstacle.flags & ON_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				mover.Bump(border_obstacle, 1)
				return 0

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		mover.Bump(src, 1)
		return 0

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src)
		if(!(obstacle.flags & ON_BORDER))
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != obstacle))
				mover.Bump(obstacle, 1)
				return 0
	return 1 //Nothing found to block so return success!

var/const/enterloopsanity = 100
/turf/Entered(atom/atom as mob|obj)

	if(movement_disabled)
		to_chat(usr, "<span class='warning'>Movement is admin-disabled.</span>") //This is to identify lag problems
		return
	..()

	if(!istype(atom, /atom/movable))
		return

	var/atom/movable/A = atom

	if(ismob(A))
		var/mob/M = A
		if(!M.lastarea)
			M.lastarea = get_area(M.loc)
		if(M.lastarea.has_gravity == 0)
			inertial_drift(M)
		else if(!is_space())
			M.inertia_dir = 0
			M.make_floating(0)
		if(isliving(M))
			var/mob/living/L = M
			L.handle_footstep(src)
	..()
	var/objects = 0
	if(A && (A.flags & PROXMOVE))
		for(var/atom/movable/thing in range(1))
			if(objects > enterloopsanity) break
			objects++
			spawn(0)
				if(A) //Runtime prevention
					A.HasProximity(thing, 1)
					if ((thing && A) && (thing.flags & PROXMOVE))
						thing.HasProximity(A, 1)
	return

/turf/proc/adjacent_fire_act(turf/simulated/floor/source, temperature, volume)
	return

/turf/proc/is_plating()
	return 0

/turf/proc/inertial_drift(atom/movable/A as mob|obj)
	if(!(A.last_move))	return
	if((istype(A, /mob/) && src.x > 2 && src.x < (world.maxx - 1) && src.y > 2 && src.y < (world.maxy-1)))
		var/mob/M = A
		if(M.Process_Spacemove(1))
			M.inertia_dir  = 0
			return
		spawn(5)
			if((M && !(M.anchored) && !(M.pulledby) && (M.loc == src)))
				if(M.inertia_dir)
					step(M, M.inertia_dir)
					return
				M.inertia_dir = M.last_move
				step(M, M.inertia_dir)
	return

/turf/proc/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && !is_plating())

/turf/proc/AdjacentTurfs()
	var/L[] = new()
	for(var/turf/simulated/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/CardinalTurfs()
	var/L[] = new()
	for(var/turf/simulated/T in AdjacentTurfs())
		if(T.x == src.x || T.y == src.y)
			L.Add(T)
	return L

/turf/proc/Distance(turf/t)
	if(get_dist(src,t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		cost *= (pathweight+t.pathweight)/2
		return cost
	else
		return get_dist(src,t)

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/process()
	return PROCESS_KILL

/turf/proc/contains_dense_objects()
	if(density)
		return 1
	for(var/atom/A in src)
		if(A.density && !(A.flags & ON_BORDER))
			return 1
	return 0

//expects an atom containing the reagents used to clean the turf
/turf/proc/clean(atom/source, mob/user)
	if(source.reagents.has_reagent("water", 1) || source.reagents.has_reagent("cleaner", 1))
		clean_blood()
		if(istype(src, /turf/simulated))
			var/turf/simulated/T = src
			T.dirt = 0
		for(var/obj/effect/O in src)
			if(istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay))
				qdel(O)
	else
		to_chat(user, "<span class='warning'>\The [source] is too dry to wash that.</span>")
	source.reagents.trans_to_turf(src, 1, 10)	//10 is the multiplier for the reaction effect. probably needed to wet the floor properly.

/turf/proc/update_blood_overlays()
	return

// Called when turf is hit by a thrown object
/turf/hitby(atom/movable/AM as mob|obj, var/speed)
	if(src.density)
		spawn(2)
			step(AM, turn(AM.last_move, 180))
		if(isliving(AM))
			var/mob/living/M = AM
			M.turf_collision(src, speed)

/turf/AllowDrop()
	return TRUE

// Returns false if stepping into a tile would cause harm (e.g. open space while unable to fly, water tile while a slime, lava, etc).
/turf/proc/is_safe_to_enter(mob/living/L)
	if(LAZYLEN(dangerous_objects))
		for(var/obj/O in dangerous_objects)
			if(!O.is_safe_to_step(L))
				return FALSE
	return TRUE

// Tells the turf that it currently contains something that automated movement should consider if planning to enter the tile.
// This uses lazy list macros to reduce memory footprint, since for 99% of turfs the list would've been empty anyways.
/turf/proc/register_dangerous_object(obj/O)
	if(!istype(O))
		return FALSE
	LAZYADD(dangerous_objects, O)
//	color = "#FF0000"

// Similar to above, for when the dangerous object stops being dangerous/gets deleted/moved/etc.
/turf/proc/unregister_dangerous_object(obj/O)
	if(!istype(O))
		return FALSE
	LAZYREMOVE(dangerous_objects, O)
	UNSETEMPTY(dangerous_objects) // This nulls the list var if it's empty.
//	color = "#00FF00"

/turf/proc/can_engrave()
	return FALSE

/turf/proc/try_graffiti(var/mob/vandal, var/obj/item/tool)

	if(!tool.sharp || !can_engrave())
		return FALSE

	if(jobban_isbanned(vandal, "Graffiti"))
		to_chat(vandal, SPAN_WARNING("You are banned from leaving persistent information across rounds."))
		return

	var/too_much_graffiti = 0
	for(var/obj/effect/decal/writing/W in src)
		too_much_graffiti++
	if(too_much_graffiti >= 5)
		to_chat(vandal, "<span class='warning'>There's too much graffiti here to add more.</span>")
		return FALSE

	var/message = sanitize(input("Enter a message to engrave.", "Graffiti") as null|text, trim = TRUE)
	if(!message)
		return FALSE

	if(!vandal || vandal.incapacitated() || !Adjacent(vandal) || !tool.loc == vandal)
		return FALSE

	vandal.visible_message("<span class='warning'>\The [vandal] begins carving something into \the [src].</span>")

	trigger_lot_security_system(vandal, /datum/lot_security_option/graffiti, "Attempting to carve graffiti into \the [src] with \a [tool].")

	if(!do_after(vandal, max(20, length(message)), src))
		return FALSE

	vandal.visible_message("<span class='danger'>\The [vandal] carves some graffiti into \the [src].</span>")
	var/obj/effect/decal/writing/graffiti = new(src)
	graffiti.message = message
	graffiti.author = vandal.ckey

	if(lowertext(message) == "elbereth")
		to_chat(vandal, "<span class='notice'>You feel much safer.</span>")

	return TRUE

/turf/proc/is_wall()
	return FALSE

/turf/proc/is_open()
	return FALSE

/turf/proc/is_floor()
	return FALSE

/turf/update_icon()
	//update_flood_overlay()
	queue_ao(FALSE)
