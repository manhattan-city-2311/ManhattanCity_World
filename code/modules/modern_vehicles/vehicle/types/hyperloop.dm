/obj/vehicles/track_bound/hyperloop
	name = "magnet-driven vacuum transit system capsule"
	desc = "An extraordinary aerodynamic capsule suspended above a magnet structure that is used for propelling it in a vacuum tunnel."
	icon = 'icons/vehicles/hyperloop.dmi'
	track_obj_type = /obj/structure/track/magnet
	bound_x = 160
	bound_y = 256
	var/locked = TRUE
	var/departurecooldown = 300
	var/active = FALSE
	var/list/occupants = list()

/obj/vehicles/track_bound/hyperloop/process()
	. = ..()
	if(!active)
		return

	pixel_y = sin(world.time * 5) 

	if(departurecooldown)
		departurecooldown -= 2
	else
		depart()

/obj/vehicles/track_bound/hyperloop/attack_hand(mob/user)
	. = ..()
	enterinterior()

/obj/vehicles/track_bound/hyperloop/proc/enterinterior(mob/user)
	occupants += user

/obj/vehicles/track_bound/hyperloop/proc/exitinterior(mob/user)
	occupants -= user

/obj/vehicles/track_bound/hyperloop/proc/depart()
	Move()

/obj/vehicles/track_bound/hyperloop/ex_act()
	return



/obj/structure/track/magnet
	name = "electromagnetic suspension track"

/obj/structure/track/magnet/ex_act()
	return