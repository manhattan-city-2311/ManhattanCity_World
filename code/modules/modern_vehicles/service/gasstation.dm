#define FUEL_PRICE 30

/obj/structure/gas_station
	icon = 'icons/vehicles/service/gas.dmi'
	icon_state = "gas_station"
	var/payed_fuel = 0
	var/obj/item/weapon/fuel_gun/gun = null
	var/waiting_payment = FALSE
	density = TRUE
	luminosity = TRUE

/obj/structure/gas_station/old
	icon_state = "gas_station_old"

/obj/structure/gas_station/initialize()
	. = ..()
	gun = new(src)
	update_icon()

/obj/structure/gas_station/update_icon()
	. = ..()

	if(gun.loc != src)
		icon_state = "[initial(icon_state)]-in_use"
	else
		icon_state = initial(icon_state)

	add_overlay(emissive_appearance(icon, "[initial(icon_state)]-emissive"))

/obj/structure/gas_station/proc/return_gun()
	if(ismob(gun.loc))
		var/mob/M = gun.loc
		M.drop_from_inventory(gun, src)
	else
		gun.forceMove(src)
	payed_fuel = 0
	waiting_payment = FALSE
	update_icon()

/obj/structure/gas_station/attack_hand(mob/user)
	if(payed_fuel)
		if(gun.loc == src)
			user.put_in_hands(gun)
			update_icon()
		return

	if(!waiting_payment)
		var/fuel = input(user, "Amount of fuel", "Fuel", 0) as num
		fuel = round(clamp(fuel, 0, 50), 0.5)
		if(!fuel)
			return_gun()
			return
		var/cost = fuel * FUEL_PRICE
		to_chat(user, "Now deposit [cost] credits.")
		waiting_payment = cost
		return
	else if(gun.loc == user)
		return_gun()
		to_chat(user, "Fueling was cancelled.")
		return

	. = ..()

/obj/structure/gas_station/attackby(obj/item/W, mob/living/carbon/human/user)
	if(!istype(user))
		return ..()

	if(W == gun)
		var/cash = round(payed_fuel * FUEL_PRICE)
		return_gun()
		if(cash)
			spawn_money(cash, get_turf(src), user)
		return


	if(!waiting_payment)
		return ..()

	var/cash = min(user.get_available_money(), waiting_payment)

	// FIXME: department
	if(!user.take_money(cash, loc, null, "gas station", "[payed_fuel] L's of fuel", "Gas station in [get_area(src)]"))
		return

	payed_fuel = cash / FUEL_PRICE

	waiting_payment = FALSE

/obj/item/weapon/fuel_gun
	icon = 'icons/vehicles/service/gas.dmi'
	icon_state = "gun"
	var/obj/structure/gas_station/gas_station = null
	dont_save = TRUE

/obj/item/weapon/fuel_gun/New(gas_station)
	. = ..()
	src.gas_station = gas_station

/obj/item/weapon/fuel_gun/Destroy()
	if(!QDELETED(gas_station))
		gas_station.gun = null
		QDEL_NULL(gas_station)
	. = ..()


/obj/manhattan/vehicle/var/fueling = FALSE
/obj/manhattan/vehicle/attackby(obj/item/weapon/fuel_gun/G, mob/user)
	if(!istype(G))
		. = ..()
		return

	if(fueling)
		to_chat(user, "Vehicle are already fueling.")
		return
	var/obj/item/vehicle_part/fueltank/FT = components[VC_FUELTANK]
	if(!FT)
		to_chat(user, "This vehicle doesn't have fueltank...")
		return
	if(!fueltank_open)
		to_chat(user, "You need opened fuel tank cap to fuel vehicle.")
		return

	ASSERT(!QDELETED(G.gas_station))

	var/dfuel = min(G.gas_station.payed_fuel, FT.capacity - FT.contains)

	if(dfuel < 0.1)
		return

	fueling = TRUE
	visible_message("[user] have started fueling [icon2html(src, viewers(src))].")
	if(!do_after(user, max(30, dfuel * 5), src, needhand = TRUE))
		return
	fueling = FALSE
	to_chat(user, "You have finished fueling [icon2html(src, user)][src]")

	FT.contains += dfuel
	G.gas_station.payed_fuel -= dfuel
