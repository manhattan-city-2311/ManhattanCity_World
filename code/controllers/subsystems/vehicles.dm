SUBSYSTEM_DEF(vehicles)
	name = "Vehicles"
	flags = SS_NO_INIT
	wait = 1 // deciseconds
	priority = FIRE_PRIORITY_VEHICLES
	var/list/vehicles = list()
	var/list/queue

/datum/controller/subsystem/vehicles/fire(resumed = FALSE)
	if(!resumed)
		queue = vehicles.Copy()

	var/list/current_run = queue

	while(length(current_run))
		var/obj/manhattan/vehicle/V = current_run[length(current_run)]
		--current_run.len

		if(QDELETED(V))
			continue

		var/iterations = V.get_calculation_iterations()
		for(var/j = 0, j < iterations, ++j)
			V.process_vehicle(0.1 / iterations)
			V.process_movement(0.1 / iterations)
		V.update_ui()

		if(MC_TICK_CHECK)
			return

