// APC HULL

/obj/item/frame/apc
	name = "\improper APC frame"
	desc = "Used for repairing or building APCs"
	icon = 'icons/obj/apc_repair.dmi'
	icon_state = "apc_frame"
	flags = CONDUCT

/obj/item/frame/apc/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/stack/material/steel( get_turf(src.loc), 2 )
		qdel(src)

/obj/item/frame/apc/try_build(turf/on_wall, mob/user as mob)
	return