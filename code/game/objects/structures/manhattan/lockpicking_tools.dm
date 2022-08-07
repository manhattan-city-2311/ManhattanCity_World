/obj/item/weapon/lockpick
	slot_flags = SLOT_ID|SLOT_BELT
	icon = 'icons/obj/manhattan/Hardware_Icons.dmi'
	icon_state = "Lockpick_2"
	name = "rusted lockpick"
	desc = "A thing for opening doors illegally."
	w_class = 1
	lock_picking_level = 4
	var/uses = 2

/*/obj/item/weapon/lockpick/afterattack(var/A, var/mob/user)

	if(!in_range(user, A))
		return
	if(/obj/machinery/door/unpowered/manhattan)
		amogus()*/

/*/obj/item/weapon/lockpick/proc/amogus()
	uses -= 1
	if(uses =< 1)
		qdel(src)*/

/obj/item/weapon/lockpick/upgraded
	icon_state = "upgraded_lockpick"
	lock_picking_level = 6
	w_class = 2
	uses = 6