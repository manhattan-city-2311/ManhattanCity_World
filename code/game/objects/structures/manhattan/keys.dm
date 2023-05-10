/obj/item/weapon/door/masterkey
	slot_flags = SLOT_ID|SLOT_BELT
	icon = 'icons/obj/manhattan/items.dmi'
	icon_state = "keyring"
	name = "keyring"
	desc = "This holds your keys. Use this when you want to unlock something, dummy."
	w_class = 2

	New()
		update_icon_state()

/obj/item/weapon/door/masterkey/examine(mob/user)
	if (locate(src) in get_step(user, user.dir) || user.contents.Find(src))
		user << "<span class = 'notice'>[desc]. Right now it's holding [print_keys()].</span>"
	..()

/obj/item/weapon/door/masterkey/proc/print_keys()
	if (contents.len == 0)
		return "nothing"
	else
		var/ret = ""
		for (var/obj/item/weapon/door/key/key in contents)
			ret = "[ret],[key]"
		return ret


/obj/item/weapon/door/masterkey/proc/update_icon_state()
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
		if (5 to POSITIVE_INFINITY)
			icon_state = "keyring-5"

/obj/item/weapon/door/masterkey/attack_self(mob/user)
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

/obj/item/weapon/door/masterkey/attackby(obj/item/I as obj, mob/user as mob)
	if (istype(I, /obj/item/weapon/door/key))
		var/obj/item/weapon/door/key/key = I
		if(!user.unEquip(I))
			return
		I.forceMove(src)
		contents += key
		update_icon_state()
		visible_message("<span class = 'notice'>[user] puts a key in their keychain.</span>", "<span class = 'notice'>You put a key in your keychain.</span>")

/obj/item/weapon/door/masterkey/initialize()
	update_icon_state()

/obj/item/weapon/door/key
	name = "key"
	desc = "Used to unlock things."
	icon = 'icons/obj/manhattan/items.dmi'
	icon_state = "keys"
	w_class = 1
	var/key_data = ""
	unique_save_vars = list("key_data")

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

#define DOORKEY(_room, _name, _key_data)/obj/item/weapon/door/key/##_room{name = _name;key_data = _key_data;}

DOORKEY(north1/room1, "house apartment key #1-1", "house1north")
DOORKEY(north1/room2, "house apartment key #2-1", "house2north")
DOORKEY(north1/room3, "house apartment key #3-1", "house3north")
DOORKEY(north1/room4, "house apartment key #4-1", "house4north")
DOORKEY(north1/room5, "house apartment key #5-1", "house5north")
DOORKEY(north1/room6, "house apartment key #6-1", "house6north")
DOORKEY(north1/room7, "house apartment key #7-1", "house7north")
DOORKEY(north1/room8, "house apartment key #8-1", "house8north")
DOORKEY(north1/room9, "house apartment key #9-1", "house9north")

DOORKEY(north1/room10, "house apartment key #10-1", "house10north")
DOORKEY(north1/room11, "house apartment key #11-1", "house11north")
DOORKEY(north1/room12, "house apartment key #12-1", "house12north")

DOORKEY(north2/room1, "house apartment key #1-2", "house1north2")
DOORKEY(north2/room2, "house apartment key #2-2", "house2north2")
DOORKEY(north2/room3, "house apartment key #3-2", "house3north2")
DOORKEY(north2/room4, "house apartment key #4-2", "house4north2")
DOORKEY(north2/room5, "house apartment key #5-2", "house5north2")
DOORKEY(north2/room6, "house apartment key #6-2", "house6north2")

DOORKEY(north2/room7,  "house apartment key #7-2",  "house7north2" )
DOORKEY(north2/room8,  "house apartment key #8-2",  "house8north2" )
DOORKEY(north2/room9,  "house apartment key #9-2",  "house9north2" )
DOORKEY(north2/room10, "house apartment key #10-2", "house10north2")
DOORKEY(north2/room11, "house apartment key #11-2", "house11north2")
DOORKEY(north2/room12, "house apartment key #12-2", "house12north2")
DOORKEY(north3/room1,  "house apartment key #1-3",  "house1north2" )
DOORKEY(north3/room2,  "house apartment key #2-3",  "house2north3" )
DOORKEY(north3/room3,  "house apartment key #3-3",  "house3north3" )
DOORKEY(north3/room4,  "house apartment key #4-3",  "house4north3" )
DOORKEY(north3/room5,  "house apartment key #5-3",  "house5north3" )
DOORKEY(north3/room6,  "house apartment key #6-3",  "house6north3" )
// FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK I WANT TO DIE FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK
DOORKEY(hotel/room1,  "hotel apartment key #1",  "hotel1" )
DOORKEY(hotel/room2,  "hotel apartment key #2",  "hotel2" )
DOORKEY(hotel/room3,  "hotel apartment key #3",  "hotel3" )
DOORKEY(hotel/room4,  "hotel apartment key #4",  "hotel4" )
DOORKEY(hotel/room5,  "hotel apartment key #5",  "hotel5" )
DOORKEY(hotel/room6,  "hotel apartment key #6",  "hotel6" )
DOORKEY(hotel/room7,  "hotel apartment key #7",  "hotel7" )
DOORKEY(hotel/room8,  "hotel apartment key #8",  "hotel8" )
DOORKEY(hotel/room9,  "hotel apartment key #9",  "hotel9" )
DOORKEY(hotel/room11, "hotel apartment key #11", "hotel11")
DOORKEY(hotel/room12, "hotel apartment key #12", "hotel12")
DOORKEY(hotel/room13, "hotel apartment key #13", "hotel13")
// АААААААААААААААААААААААААААААААААА БЛЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯАААААААААААААААТЬ
DOORKEY(northelite/house1, "House key #11", "elite1")
DOORKEY(northelite/house2, "House key #12", "elite2")
DOORKEY(northelite/house3, "House key #13", "elite3")
// ЁБАНЫЙ РООООООООТ ЭТОГО КАЗИНОООООООООООО
DOORKEY(casino, "Casino storage key", "casino")
// ГОСПИТАЛЬ
DOORKEY(medbay, "Hospital key", "medbay")
DOORKEY(medbay/pharmacy, "Hospital pharmacy key", "pharmacy")
DOORKEY(medbay/lockerroom, "Hospital locker room key", "lockerroom")
DOORKEY(medbay/archive, "Hospital archives key", "archive")
DOORKEY(medbay/cabinet1, "#1 cabinet key", "cabinet1")
DOORKEY(medbay/cabinet2, "#2 cabinet key", "cabinet2")
DOORKEY(medbay/cabinet3, "#3 cabinet key", "cabinet3")
DOORKEY(medbay/cabinet4, "#4 cabinet key", "cabinet4")
DOORKEY(medbay/head, "Hospital Head cabinet key", "head")
// ЮЖНЫЙ
//Так как у Вани нет никаких нормальных обозначений жилых зданий, я буду помечать их по расположению и названию зону, где они находятся
DOORKEY(south/teotr, "TEotR bar key", "south_teotr34")
// Двухэтажка у Теотра, F3, квартиры с 113-й по 118-ю
DOORKEY(south/f3/first,  "F3-1-N113 Key", "south_f3_n1")
DOORKEY(south/f3/second, "F3-2-N114 Key", "south_f3_n2")
DOORKEY(south/f3/third,  "F3-3-N115 Key", "south_f3_n3")
DOORKEY(south/f3/fourth, "F3-4-N116 Key", "south_f3_n4")
DOORKEY(south/f3/fifth,  "F3-5-N117 Key", "south_f3_n5")
DOORKEY(south/f3/sixth,  "F3-6-N118 Key", "south_f3_n6")
//Трёхэтажка, южнее автосалона с квадриками, F2, квартиры с 107-й по 112-ю
DOORKEY(south/f2/first,  "F2-1-N107 Key", "south_f2_n1")
DOORKEY(south/f2/second, "F2-2-N108 Key", "south_f2_n2")
DOORKEY(south/f2/third,  "F2-3-N109 Key", "south_f2_n3")
DOORKEY(south/f2/fourth, "F2-4-N110 Key", "south_f2_n4")
DOORKEY(south/f2/fifth,  "F2-5-N111 Key", "south_f2_n5")
DOORKEY(south/f2/sixth,  "F2-6-N112 Key", "south_f2_n6")
//Гаражи севернее F2
DOORKEY(south/f2/garage/first,  "Garage #1", "garage-f2-1")
DOORKEY(south/f2/garage/second, "Garage #2", "garage-f2-2")
DOORKEY(south/f2/garage/third,  "Garage #3", "garage-f2-3")
DOORKEY(south/f2/garage/fourth, "Garage #4", "garage-f2-4")
DOORKEY(south/f2/garage/fifth,  "Garage #5", "garage-f2-5")
//Автосалон с квадриками
DOORKEY(south/carshop, "South car dealership key", "carshopsouth")
