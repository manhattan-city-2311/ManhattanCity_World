/obj/item/weapon/lockpick
	slot_flags = SLOT_ID|SLOT_BELT
	icon = 'icons/obj/manhattan/Hardware_Icons.dmi'
	icon_state = "Lockpick_2"
	name = "rusted lockpick"
	desc = "A thing for opening doors illegally."
	w_class = 1
	lock_picking_level = 4
	var/uses = 2

/obj/item/weapon/lockpick/afterattack(var/A, var/mob/user)

	if(!in_range(user, A))
		return
	if(/obj/machinery/door/unpowered/manhattan)
		amogus()

/obj/item/weapon/lockpick/proc/amogus(var/mob/user)
	uses--
	if(uses == 2)
		user << "<span class='warning'>\The [src] is going to break soon!</span>"
	else if(uses <= 1)
		user.drop_item(src)
		user << "<span class='warning'>\The [src] crumbles in your hands.</span>"
		qdel(src)
	return ..()

/obj/item/weapon/lockpick/upgraded
	icon_state = "upgraded_lockpick"
	lock_picking_level = 6
	w_class = 2
	uses = 6