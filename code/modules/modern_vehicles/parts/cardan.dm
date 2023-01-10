#define CARDAN_BASE_FRICTION_LOSS 100

#define VC_CARDAN "cardan"

/obj/item/vehicle_part/cardan
	name = "cardan"
	desc = "Cardan shaft. Transfers torque from the gearbox to the wheels."
	id = VC_CARDAN

	needs_processing = FALSE

	mass = 10
	var/ratio = 3.42
