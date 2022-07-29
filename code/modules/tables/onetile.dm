/obj/structure/table/bar_metal
	name = "steel table"
	desc = "Small steel table with circle shape."
	icon = 'icons/obj/manhattan/standalone_tables.dmi'
	icon_state = "table_metal_round"
	can_plate = 0
	can_reinforce = 0
	flipped = -1

/obj/structure/table/bar_metal/New()
	..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put

/obj/structure/table/bar_metal/update_connections()
	return

/obj/structure/table/bar_metal/update_desc()
	return

/obj/structure/table/bar_metal/update_icon()
	return

/obj/structure/table/home_wooden
	name = "wooden table"
	desc = "Small wooden table with circle shape."
	icon = 'icons/obj/manhattan/standalone_tables.dmi'
	icon_state = "table_wood_round"
	can_plate = 0
	can_reinforce = 0
	flipped = -1

/obj/structure/table/home_wooden/New()
	..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put

/obj/structure/table/home_wooden/update_connections()
	return

/obj/structure/table/home_wooden/update_desc()
	return

/obj/structure/table/home_wooden/update_icon()
	return

/obj/structure/table/home_wooden/dice
	name = "dice table"
	desc = "" // TODO: 
	icon_state = "dice_clean"


/obj/structure/table/home_wooden/low
	name = "low wooden table"
	desc = "" // TODO: 
	icon_state = "table_wood_low"