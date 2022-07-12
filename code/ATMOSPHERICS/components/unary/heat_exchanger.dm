/obj/machinery/atmospherics/unary/heat_exchanger

	icon = 'icons/obj/atmospherics/heat_exchanger.dmi'
	icon_state = "intact"
	pipe_state = "heunary"
	density = 1

	name = "Heat Exchanger"
	desc = "Exchanges heat between two input gases. Setup for fast heat transfer"

	var/obj/machinery/atmospherics/unary/heat_exchanger/partner = null
	var/update_cycle

	update_icon()
		if(node)
			icon_state = "intact"
		else
			icon_state = "exposed"

		return

	atmos_init()
		if(!partner)
			var/partner_connect = turn(dir,180)

			for(var/obj/machinery/atmospherics/unary/heat_exchanger/target in get_step(src,partner_connect))
				if(target.dir & get_dir(src,target))
					partner = target
					partner.partner = src
					break

		..()

	process()
		..()
		return 0
	// TODO: to remove

	attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
		if (!istype(W, /obj/item/weapon/wrench))
			return ..()
		var/turf/T = src.loc
		if (level==1 && isturf(T) && !T.is_plating())
			to_chat(user, "<span class='warning'>You must remove the plating first.</span>")
			return 1
		if (!can_unwrench())
			to_chat(user, "<span class='warning'>You cannot unwrench \the [src], it is too exerted due to internal pressure.</span>")
			add_fingerprint(user)
			return 1
		playsound(src, W.usesound, 50, 1)
		to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
		if (do_after(user, 40 * W.toolspeed))
			user.visible_message( \
				"<span class='notice'>\The [user] unfastens \the [src].</span>", \
				"<span class='notice'>You have unfastened \the [src].</span>", \
				"You hear a ratchet.")
			deconstruct()
