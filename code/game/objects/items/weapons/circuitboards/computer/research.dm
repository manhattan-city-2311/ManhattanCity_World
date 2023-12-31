#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/rdconsole
	name = T_BOARD("R&D control console")
	build_path = /obj/machinery/computer/rdconsole/core

/obj/item/weapon/circuitboard/rdconsole/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/weapon/screwdriver))
		playsound(src, I.usesound, 50, 1)
		user.visible_message("<span class='notice'>\The [user] adjusts the jumper on \the [src]'s access protocol pins.</span>", "<span class='notice'>You adjust the jumper on the access protocol pins.</span>")
		if(build_path == /obj/machinery/computer/rdconsole/core)
			name = T_BOARD("RD Console - Robotics")
			build_path = /obj/machinery/computer/rdconsole/robotics
			to_chat(user, "<span class='notice'>Access protocols set to robotics.</span>")
		else
			name = T_BOARD("RD Console")
			build_path = /obj/machinery/computer/rdconsole/core
			to_chat(user, "<span class='notice'>Access protocols set to default.</span>")
	return

/obj/item/weapon/circuitboard/rdconsole/business
	name = T_BOARD("Independent R&D control console")
	build_path = /obj/machinery/computer/rdconsole/business

/obj/item/weapon/circuitboard/rdconsole/attackby(obj/item/I as obj, mob/user as mob)
	return //override - do nothing

/obj/item/weapon/circuitboard/rdserver/business
	name = T_BOARD("Independent Research Server")
	build_path = /obj/machinery/r_n_d/server/business