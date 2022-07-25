#define VC_CLUTCH "clutch"

/obj/item/vehicle_part/clutch
	name = "clutch"
	desc = "Clutch. Allows to disconnect the gearbox from engine."
	id = VC_CLUTCH

/obj/item/vehicle_part/clutch/proc/is_transfering()
	if(!integrity)
		return FALSE
	if(vehicle.is_clutch_pressed)
		return !prob(integrity)
	return prob(integrity)