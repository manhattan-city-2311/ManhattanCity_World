////////////////////HOLOSIGN///////////////////////////////////////
/obj/machinery/holosign
	name = "holosign"
	desc = "Small wall-mounted holographic projector"
	icon = 'icons/obj/holosign.dmi'
	icon_state = "sign_off"
	plane = MOB_PLANE
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4
	anchored = 1
	var/lit = 0
	var/id = null
	var/on_icon = "sign_on"
	var/off_icon = "sign_off"

	unique_save_vars = list("id", "lit")

/obj/machinery/holosign/on_persistence_load()
	update_icon()

/obj/machinery/holosign/proc/toggle()
	if(stat & (BROKEN|NOPOWER))
		return
	lit = !lit
	use_power = lit ? 2 : 1
	update_icon()

/obj/machinery/holosign/update_icon()
	if(!lit)
		icon_state = off_icon
	else
		icon_state = on_icon

/obj/machinery/holosign/power_change()
	if(stat & NOPOWER)
		lit = 0
		use_power = 0
	update_icon()

/obj/machinery/holosign/surgery
	name = "surgery holosign"
	desc = "Small wall-mounted holographic projector. This one reads SURGERY."
	on_icon = "surgery"

/obj/machinery/holosign/exit
	name = "exit holosign"
	desc = "Small wall-mounted holographic projector. This one reads EXIT."
	on_icon = "emergencyexit"

/obj/machinery/holosign/bar
	name = "bar holosign"
	desc = "Small wall-mounted holographic projector. This one reads OPEN."
	icon_state = "barclosed"
	on_icon = "baropen"
	off_icon = "barclosed"


////////////////////SWITCH///////////////////////////////////////

/obj/machinery/button/holosign
	name = "holosign switch"
	desc = "A remote control switch for holosign."
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"

/obj/machinery/button/holosign/on_persistence_load()
	icon_state = "light[active]"

/obj/machinery/button/holosign/attack_hand(mob/user as mob)
	if(..())
		return
	add_fingerprint(user)

	//use_power(5)

	active = !active
	icon_state = "light[active]"

	for(var/obj/machinery/holosign/M in machines)
		if(M.id == id)
			spawn(0)
				M.toggle()
				return

	return
