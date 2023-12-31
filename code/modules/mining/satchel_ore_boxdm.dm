
/**********************Ore box**************************/
//Why the hell is this file called satchel_ore_boxdm.dm? -CK
/obj/structure/ore_box
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	name = "ore box"
	desc = "A heavy box used for storing ore."
	density = 1
	burn_state = 0 //Burnable
	burntime = LONG_BURN
	var/last_update = 0
	var/list/stored_ore = list()

/obj/structure/ore_box/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/ore))
		user.remove_from_mob(W)
		src.contents += W

	else if (istype(W, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = W
		if(!S.contents.len)
			return
		S.hide_from(usr)
		for(var/obj/item/weapon/ore/O in S.contents)
			S.remove_from_storage(O, src) //This will move the item to this item's contents
		to_chat(user,"<span class='notice'>You empty the satchel into the box.</span>")

	update_ore_count()

	return

/obj/structure/ore_box/proc/update_ore_count()

	stored_ore = list()

	for(var/obj/item/weapon/ore/O in contents)

		if(stored_ore[O.name])
			stored_ore[O.name]++
		else
			stored_ore[O.name] = 1

/obj/structure/ore_box/examine(mob/user)
	to_chat(user, "That's an [src].")
	user << desc

	// Borgs can now check contents too.
	if((!istype(user, /mob/living/carbon/human)) && (!istype(user, /mob/living/silicon/robot)))
		return

	if(!Adjacent(user)) //Can only check the contents of ore boxes if you can physically reach them.
		return

	add_fingerprint(user)

	if(!contents.len)
		to_chat(user, "It is empty.")
		return

	if(world.time > last_update + 10)
		update_ore_count()
		last_update = world.time

	to_chat(user, "It holds:")
	for(var/ore in stored_ore)
		to_chat(user, "- [stored_ore[ore]] [ore]")
	return

/obj/structure/ore_box/verb/empty_box()
	set name = "Empty Ore Box"
	set category = "Object"
	set src in view(1)

	if(!istype(usr, /mob/living/carbon/human) && !istype(usr, /mob/living/silicon/robot)) //Only living, intelligent creatures with gripping aparatti can empty ore boxes.
		to_chat(usr, "<font color='red'>You are physically incapable of emptying the ore box.</font>")
		return

	if( usr.stat || usr.restrained() )
		return

	if(!Adjacent(usr)) //You can only empty the box if you can physically reach it
		to_chat(usr, "You cannot reach the ore box.")
		return

	add_fingerprint(usr)

	if(contents.len < 1)
		to_chat(usr, "<font color='red'>The ore box is empty.</font>")
		return

	for (var/obj/item/weapon/ore/O in contents)
		contents -= O
		O.loc = src.loc
	to_chat(usr, SPAN_INFO("You empty the ore box."))

	return

/obj/structure/ore_box/ex_act(severity)
	if(severity == 1.0 || (severity < 3.0 && prob(50)))
		for (var/obj/item/weapon/ore/O in contents)
			O.loc = src.loc
			O.ex_act(severity++)
		qdel(src)
		return