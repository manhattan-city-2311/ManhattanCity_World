#define CARDAN_BASE_FRICTION_LOSS 100

#define VC_CARDAN "cardan"

/obj/item/vehicle_part/cardan
	name = "cardan"
	desc = "Cardan shaft. Transfers torque from the gearbox to the wheels."
	id = VC_CARDAN

	needs_processing = TRUE

	var/rpm = 0
	var/torque = 0
	var/mass = 10
	var/ratio = 3.42

/obj/item/vehicle_part/cardan/proc/get_friction_loss()
	return (CARDAN_BASE_FRICTION_LOSS + (100 - integrity)) / mass

/obj/item/vehicle_part/cardan/proc/receive_torque(torque, rpm)
	if((rpm / ratio) < src.rpm)
		return
	rpm += torque / mass / ratio
	torque += torque * ratio

/obj/item/vehicle_part/cardan/part_process()
	. = ..()
	
	rpm = max(0, rpm - get_friction_loss())
