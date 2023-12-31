/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/weapon/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	var/associated_account_number
	var/associated_pin_number = 0

	unique_save_vars = list("associated_account_number", "associated_pin_number")

	var/list/files = list(  )

/obj/item/weapon/card/proc/get_account()
	return global.get_account(associated_account_number)

/obj/item/weapon/card/debit
	name = "debit card"
	desc = "Common card for accessing banking account"
	icon_state = "dept_cargo"

/obj/item/weapon/card/debit/examine(mob/user, distance)
	. = ..()
	var/n = associated_pin_number % 100
	to_chat(user, "It's associated with [associated_account_number] account. There is '[n < 10 ? "0" : ""][n]' printed at back side.")
/obj/item/weapon/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"

/obj/item/weapon/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if (t)
		src.name = text("data disk- '[]'", t)
	else
		src.name = "data disk"
	src.add_fingerprint(usr)
	return

/obj/item/weapon/card/data/clown
	name = "\proper the coordinates to clown planet"
	icon_state = "data"
	item_state = "card-id"
	level = 2
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"

/*
 * ID CARDS
 */

/obj/item/weapon/card/emag_broken
	desc = "It's a card with a magnetic strip attached to some circuitry. It looks too busted to be used for anything but salvage."
	name = "broken cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)

/obj/item/weapon/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	var/uses = 10

	unique_save_vars = list("uses")

/obj/item/weapon/card/emag/resolve_attackby(atom/A, mob/user)
	var/used_uses = A.emag_act(uses, user, src)
	if(used_uses < 0)
		return ..(A, user)

	uses -= used_uses
	A.add_fingerprint(user)
	log_and_message_admins("emagged \an [A].")

	if(uses<1)
		user.visible_message("<span class='warning'>\The [src] fizzles and sparks - it seems it's been used once too often, and is now spent.</span>")
		user.drop_item()
		var/obj/item/weapon/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		qdel(src)

	return 1

/obj/item/weapon/card/emag/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/stack/telecrystal))
		var/obj/item/stack/telecrystal/T = O
		if(T.amount < 1)
			to_chat(usr, "<span class='notice'>You are not adding enough telecrystals to fuel \the [src].</span>")
			return
		uses += T.amount/2 //Gives 5 uses per 10 TC
		uses = ceil(uses) //Ensures no decimal uses nonsense, rounds up to be nice
		to_chat(usr, "<span class='notice'>You add \the [O] to \the [src]. Increasing the uses of \the [src] to [uses].</span>")
		qdel(O)
