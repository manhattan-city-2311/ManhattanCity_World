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

	var/obj/manhattan/vehicle/V
	for(var/i = current_run.len to 1 step -1)
		V = current_run[i]

		if(!QDELETED(V))
			var/iterations = V.get_calculation_iterations()
			for(var/j = 0, j < iterations, ++j)
				V.process_vehicle(0.1 / iterations)
				V.process_movement(0.1 / iterations)
			V.update_ui()
		else
			queue -= V

		if (MC_TICK_CHECK)
			current_run.Cut(i)
			return
