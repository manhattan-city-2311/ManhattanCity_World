#define VC_FUELTANK "fueltank"

/obj/item/vehicle_part/fueltank
	name = "fueltank"
	desc = "Fueltank. Holds fuel."
	id = VC_FUELTANK

	needs_processing = FALSE

	mass = 10
	var/capacity = 20
	var/contains = 20

/obj/item/vehicle_part/fueltank/initialize(source)
	. = ..()
	if(source != LOADSOURCE_PERSISTENCE)
		contains = capacity

/obj/manhattan/vehicle/proc/consume_fuel(amount)
	var/obj/item/vehicle_part/fueltank/FT = components[VC_FUELTANK]

	if(!FT)
		return amount
	var/val = min(FT.contains, amount)

	FT.contains -= val

	return val

/obj/manhattan/vehicle/proc/get_fuel_amount()
	return components[VC_FUELTANK]?.contains
/obj/manhattan/vehicle/proc/get_fuel_capacity()
	return components[VC_FUELTANK]?.capacity
