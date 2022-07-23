SUBSYSTEM_DEF(vehicles)
	name = "Vehicles"
	flags = SS_NO_INIT
	wait = 1 // deciseconds
	var/list/queue = list()

/datum/controller/subsystem/vehicles/fire(resumed = FALSE)
	for(var/obj/manhattan/vehicle/vehicle in queue)
		if(QDELETED(vehicle))
			queue -= vehicle
			continue
		vehicle.process_vehicle(wait / 10)

