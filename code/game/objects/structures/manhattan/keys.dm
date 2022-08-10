/obj/item/weapon/masterkey
	slot_flags = SLOT_ID|SLOT_BELT
	icon = 'icons/obj/manhattan/items.dmi'
	icon_state = "keyring"
	name = "keyring"
	desc = "This holds your keys. Use this when you want to unlock something, dummy."
	w_class = 2

	New()
		update_icon_state()

/obj/item/weapon/masterkey/examine(mob/user)
	if (locate(src) in get_step(user, user.dir) || user.contents.Find(src))
		user << "<span class = 'notice'>[desc]. Right now it's holding [print_keys()].</span>"
	..()

/obj/item/weapon/masterkey/proc/print_keys()
	if (contents.len == 0)
		return "nothing"
	else
		var/ret = ""
		for (var/obj/item/weapon/door/key/key in contents)
			ret = "[ret],[key]"
		return ret


/obj/item/weapon/masterkey/proc/update_icon_state()
	switch (contents.len)
		if (0)
			icon_state = "keyring"
		if (1)
			icon_state = "keyring-1"
		if (2)
			icon_state = "keyring-2"
		if (3)
			icon_state = "keyring-3"
		if (4)
			icon_state = "keyring-4"
		if (5 to INFINITY)
			icon_state = "keyring-5"

/obj/item/weapon/masterkey/attack_self(mob/user)
	if (!contents.len)
		return
	else
		var/which
		var/obj/item/weapon/door/key/key
		which = input("Take out which key?", "Key Storage", key) as null|anything in contents
		if(which)
			contents -= which
			user.put_in_hands(which)
			update_icon_state()
			visible_message("<span class = 'notice'>[user] takes a key from their keychain.</span>", "<span class = 'notice'>You take out [which].</span>")

/obj/item/weapon/masterkey/attackby(obj/item/I as obj, mob/user as mob)
	if (istype(I, /obj/item/weapon/door/key))
		var/obj/item/weapon/door/key/key = I
		if(!user.unEquip(I))
			return
		I.forceMove(src)
		contents += key
		update_icon_state()
		visible_message("<span class = 'notice'>[user] puts a key in their keychain.</span>", "<span class = 'notice'>You put a key in your keychain.</span>")

/obj/item/weapon/masterkey/initialize()
	update_icon_state()

/obj/item/weapon/door/key
	name = "key"
	desc = "Used to unlock things."
	icon = 'icons/obj/manhattan/items.dmi'
	icon_state = "keys"
	w_class = 1
	var/key_data = ""

/obj/item/weapon/door/key/New()
	..()
	icon_state = "key[rand(1, 4)]"


/obj/item/weapon/door/key/New(var/newloc,var/data)
	if(data)
		key_data = data
	..(newloc)

/obj/item/weapon/door/key/proc/get_data(var/mob/user)
	return key_data

/obj/item/weapon/door/key/soap
	name = "soap key"
	desc = "a fragile key made using a bar of soap."
	var/uses = 0

/obj/item/weapon/door/key/soap/get_data(var/mob/user)
	uses--
	if(uses == 1)
		user << "<span class='warning'>\The [src] is going to break soon!</span>"
	else if(uses <= 0)
		user.drop_item(src)
		user << "<span class='warning'>\The [src] crumbles in your hands.</span>"
		qdel(src)
	return ..()


/obj/item/weapon/door/key/north1/room1
	name = "house apartment key #1-1"
	key_data = "house1north"

/obj/item/weapon/door/key/north1/room2
	name = "house apartment key #2-1"
	key_data = "house2north"

/obj/item/weapon/door/key/north1/room3
	name = "house apartment key #3-1"
	key_data = "house3north"

/obj/item/weapon/door/key/north1/room4
	name = "house apartment key #4-1"
	key_data = "house4north"

/obj/item/weapon/door/key/north1/room5
	name = "house apartment key #5-1"
	key_data = "house5north"

/obj/item/weapon/door/key/north1/room6
	name = "house apartment key #6-1"
	key_data = "house6north"

/obj/item/weapon/door/key/north1/room7
	name = "house apartment key #7-1"
	key_data = "house7north"

/obj/item/weapon/door/key/north1/room8
	name = "house apartment key #8-1"
	key_data = "house8north"

/obj/item/weapon/door/key/north1/room9
	name = "house apartment key #9-1"
	key_data = "house9north"

/obj/item/weapon/door/key/north1/room10
	name = "house apartment key #10-1"
	key_data = "house10north"

/obj/item/weapon/door/key/north1/room11
	name = "house apartment key #11-1"
	key_data = "house11north"

/obj/item/weapon/door/key/north1/room12
	name = "house apartment key #12-1"
	key_data = "house12north"

/obj/item/weapon/door/key/north2/room1
	name = "house apartment key #1-2"
	key_data = "house1north2"

/obj/item/weapon/door/key/north2/room2
	name = "house apartment key #2-2"
	key_data = "house2north2"

/obj/item/weapon/door/key/north2/room3
	name = "house apartment key #3-2"
	key_data = "house3north2"

/obj/item/weapon/door/key/north2/room4
	name = "house apartment key #4-2"
	key_data = "house4north2"

/obj/item/weapon/door/key/north2/room5
	name = "house apartment key #5-2"
	key_data = "house5north2"

/obj/item/weapon/door/key/north2/room6
	name = "house apartment key #6-2"
	key_data = "house6north2"

/obj/item/weapon/door/key/north2/room7
	name = "house apartment key #7-2"
	key_data = "house7north2"

/obj/item/weapon/door/key/north2/room8
	name = "house apartment key #8-2"
	key_data = "house8north2"

/obj/item/weapon/door/key/north2/room9
	name = "house apartment key #9-2"
	key_data = "house9north2"

/obj/item/weapon/door/key/north2/room10
	name = "house apartment key #10-2"
	key_data = "house10north2"

/obj/item/weapon/door/key/north2/room11
	name = "house apartment key #11-2"
	key_data = "house11north2"

/obj/item/weapon/door/key/north2/room12
	name = "house apartment key #12-2"
	key_data = "house12north2"

/obj/item/weapon/door/key/north3/room1
	name = "house apartment key #1-3"
	key_data = "house1north2"

/obj/item/weapon/door/key/north3/room2
	name = "house apartment key #2-3"
	key_data = "house2north3"

/obj/item/weapon/door/key/north3/room3
	name = "house apartment key #3-3"
	key_data = "house3north3"

/obj/item/weapon/door/key/north3/room4
	name = "house apartment key #4-3"
	key_data = "house4north3"

/obj/item/weapon/door/key/north3/room5
	name = "house apartment key #5-3"
	key_data = "house5north3"

/obj/item/weapon/door/key/north3/room6
	name = "house apartment key #6-3"
	key_data = "house6north3"

// FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK I WANT TO DIE FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK

/obj/item/weapon/door/key/hotel/room1
	name = "hotel apartment key #1"
	key_data = "hotel1"

/obj/item/weapon/door/key/hotel/room2
	name = "hotel apartment key #2"
	key_data = "hotel2"

/obj/item/weapon/door/key/hotel/room3
	name = "hotel apartment key #3"
	key_data = "hotel3"

/obj/item/weapon/door/key/hotel/room4
	name = "hotel apartment key #4"
	key_data = "hotel4"

/obj/item/weapon/door/key/hotel/room5
	name = "hotel apartment key #5"
	key_data = "hotel5"

/obj/item/weapon/door/key/hotel/room6
	name = "hotel apartment key #6"
	key_data = "hotel6"

/obj/item/weapon/door/key/hotel/room7
	name = "hotel apartment key #7"
	key_data = "hotel7"

/obj/item/weapon/door/key/hotel/room8
	name = "hotel apartment key #8"
	key_data = "hotel8"

/obj/item/weapon/door/key/hotel/room9
	name = "hotel apartment key #9"
	key_data = "hotel9"

/obj/item/weapon/door/key/hotel/room11
	name = "hotel apartment key #11"
	key_data = "hotel11"

/obj/item/weapon/door/key/hotel/room12
	name = "hotel apartment key #12"
	key_data = "hotel12"

/obj/item/weapon/door/key/hotel/room13
	name = "hotel apartment key #13"
	key_data = "hotel13"

// АААААААААААААААААААААААААААААААААА БЛЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯАААААААААААААААТЬ

/obj/item/weapon/door/key/northelite/house1
	name = "House key #11"
	key_data = "elite1"

/obj/item/weapon/door/key/northelite/house2
	name = "House key #12"
	key_data = "elite2"

/obj/item/weapon/door/key/northelite/house3
	name = "House key #13"
	key_data = "elite3"