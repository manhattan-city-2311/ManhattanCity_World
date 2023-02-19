/obj/effect/mining_generation_marker
	anchored = TRUE
	invisibility = 99
	icon = 'icons/effects/map_effects.dmi'
	var/w = 80
	var/h = 80

/obj/effect/mining_generation_marker/ex_act()
	return

/obj/structure/mine_dull
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "dug_overlay"
	anchored = TRUE

/obj/structure/mine_dull/ex_act(severity)
	if(severity >= 1)
		SSmining.dulls -= src
		qdel(src)

/obj/machinery/mine_lift_button
	name = "mine lift button"
	icon = 'icons/obj/turbolift.dmi'
	icon_state = "panel"
	plane = WALL_OBJ_PLANE
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4
	var/datum/coords/marker
	var/list/turf/transferred
	var/transfering = FALSE

/obj/machinery/mine_lift_button/proc/close_doors()
	set waitfor = FALSE
	for(var/obj/machinery/door/airlock/door in get_area(src))
		sleep(rand(0, 3))
		door.close()

/obj/machinery/mine_lift_button/proc/open_doors()
	set waitfor = FALSE
	for(var/obj/machinery/door/airlock/door in get_area(src))
		sleep(rand(0, 3))
		door.open()

/obj/machinery/mine_lift_button/proc/deploy()
	close_doors()
	transfering = 1
	if(marker)
		spawn(150)
			if(!transfering) // Cancel
				return
			var/area/A = marker.locate_turf().loc
			move_contents(transferred, get_area_turfs(A.type))
			open_doors()
			marker = null
			transferred = null
			SSmining.clean()
			transfering = 0
			SSpersistent_world.resolve_obstruction("mine")
	else
		SSmining.generate()
		spawn(150)
			if(!transfering) // Cancel
				return
			var/obj/effect/mining_generation_marker/marker = SSmining.marker
			var/turf/dest = pick(block( \
				locate(marker.x + 20, marker.y - 20, marker.z), \
				locate(marker.x + marker.w - 20, marker.y - marker.h + 21, marker.z)))
			src.marker = new(x, y, z)
			transferred = get_area(src).move_contents_to(dest.loc, /turf/simulated/floor, xoff = dest.x, yoff = dest.y, destroy = TRUE)
			open_doors()
			transfering = 0
			SSmining.next_invasion = world.time + rand(13 MINUTES, 16 MINUTES)
			SSmining.invasion_destination = get_turf(src)
			SSpersistent_world.add_obstruction("mine", "Mine is deployed.")
	spawn(100)
		if(!transfering) // Cancel
			return
		transfering = 2
		for(var/x in 1 to 5)
			if(!transfering) // Cancel
				return
			visible_message("[icon2html(src, hearers(src))] [6-x]...")
			sleep(10)

/obj/machinery/mine_lift_button/attack_hand(mob/user)
	if(!transfering)
		visible_message("[icon2html(src, hearers(src))]\The [src] beeps as when transfering begins.")
		deploy()
	else if(transfering == 1)
		visible_message("[icon2html(src, hearers(src))]\The [src] beeps as when transfer was cancelled.")
		transfering = 0
	else
		to_chat(user, "Transferring cannot be cancelled in current state.")

/decl/mine_structure
	var/min_level = 0.3
	var/max_level = 0.5
	var/density = FALSE
	var/chance = 100
	var/min_amount
	var/max_amount

/decl/mine_structure/proc/generate(turf/T)
	return

/decl/mine_structure/dull
	min_amount = 15
	max_amount = 20

/decl/mine_structure/dull/generate(turf/T)
	LAZYADD(SSmining.dulls, new /obj/structure/mine_dull(T))

/decl/mine_structure/spider
	min_amount = 25
	max_amount = 40

/decl/mine_structure/spider/generate(turf/T)
	new /obj/random/mob/spider(T)

/decl/mine_structure/spider/mutant
	min_amount = 10
	max_amount = 15

/decl/mine_structure/spider/mutant/generate(turf/T)
	new /obj/random/mob/spider/mutant(T)
/decl/mine_structure/spiderweb
	min_amount = 2
	max_amount = 5

/decl/mine_structure/spiderweb/generate(turf/B)
	for(var/turf/T in circlerange(B, rand(3, 5)))
		if(!T.density && prob(66))
			new /obj/effect/spider/stickyweb(T)
