SUBSYSTEM_DEF(vehicles)
	name = "Vehicles"
	flags = SS_NO_INIT
	wait = 1 // deciseconds
	var/list/queue = list()

	var/it = 0

/datum/controller/subsystem/vehicles/fire(resumed = FALSE)
	for(var/obj/manhattan/vehicle/vehicle as anything in queue)
		if(QDELING(vehicle))
			queue -= vehicle
			continue
		var/iterations = vehicle.get_calculation_iterations()
		for(var/i = 0, i < iterations, ++i)
			vehicle.process_vehicle(wait * 0.1 / iterations)
			vehicle.process_movement(wait * 0.1 / iterations)