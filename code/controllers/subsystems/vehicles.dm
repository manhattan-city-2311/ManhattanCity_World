SUBSYSTEM_DEF(vehicles)
	name = "Vehicles"
	flags = SS_NO_INIT
	wait = 1 // deciseconds
	var/list/queue = list()
	var/n = 5

/datum/controller/subsystem/vehicles/fire(resumed = FALSE)
	for(var/obj/manhattan/vehicle/vehicle in queue)
		if(QDELETED(vehicle))
			queue -= vehicle
			continue
		for(var/i = 0, i < n, ++i)
			vehicle.process_vehicle(wait / 10.0 / n)
			vehicle.process_movement(wait / 10.0 / n)

