// TODO: for removal
datum/pipeline
	var/datum/gas_mixture/air

	var/list/obj/machinery/atmospherics/pipe/members
	var/list/obj/machinery/atmospherics/pipe/edges //Used for building networks

	var/datum/pipe_network/network

	var/alert_pressure = 0

	Destroy()
		QDEL_NULL(network)

		if(air && air.volume)
			temporarily_store_air()
		for(var/obj/machinery/atmospherics/pipe/P in members)
			P.parent = null
		members = null
		edges = null
		. = ..()

	process()//This use to be called called from the pipe networks

		//Check to see if pressure is within acceptable limits
		var/pressure = air.return_pressure()
		if(pressure > alert_pressure)
			for(var/obj/machinery/atmospherics/pipe/member in members)
				if(!member.check_pressure(pressure))
					break //Only delete 1 pipe per process

	proc/temporarily_store_air()
		//Update individual gas_mixtures by volume ratio

		for(var/obj/machinery/atmospherics/pipe/member in members)
			member.air_temporary = new
			member.air_temporary.copy_from(air)
			member.air_temporary.volume = member.volume
			member.air_temporary.multiply(member.volume / air.volume)

	proc/build_pipeline(obj/machinery/atmospherics/pipe/base)
		air = new

		var/list/possible_expansions = list(base)
		members = list(base)
		edges = list()

		var/volume = base.volume
		base.parent = src
		alert_pressure = base.alert_pressure

		if(base.air_temporary)
			air = base.air_temporary
			base.air_temporary = null
		else
			air = new

		while(possible_expansions.len>0)
			for(var/obj/machinery/atmospherics/pipe/borderline in possible_expansions)

				var/list/result = borderline.pipeline_expansion()
				var/edge_check = result.len

				if(result.len>0)
					for(var/obj/machinery/atmospherics/pipe/item in result)
						if(!members.Find(item))
							members += item
							possible_expansions += item

							volume += item.volume
							item.parent = src

							alert_pressure = min(alert_pressure, item.alert_pressure)

							if(item.air_temporary)
								air.merge(item.air_temporary)

						edge_check--

				if(edge_check>0)
					edges += borderline

				possible_expansions -= borderline

		air.volume = volume

	proc/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)

		if(new_network.line_members.Find(src))
			return 0

		new_network.line_members += src

		network = new_network

		for(var/obj/machinery/atmospherics/pipe/edge in edges)
			for(var/obj/machinery/atmospherics/result in edge.pipeline_expansion())
				if(!istype(result,/obj/machinery/atmospherics/pipe) && (result!=reference))
					result.network_expand(new_network, edge)

		return 1

	proc/return_network(obj/machinery/atmospherics/reference)
		if(!network)
			network = new /datum/pipe_network()
			network.build_network(src, null)
				//technically passing these parameters should not be allowed
				//however pipe_network.build_network(..) and pipeline.network_extend(...)
				//		were setup to properly handle this case

		return network

	proc/mingle_with_turf(turf/simulated/target, mingle_volume)
		return

	proc/temperature_interact(turf/target, share_volume, thermal_conductivity)
		return

	//surface must be the surface area in m^2
	proc/radiate_heat_to_space(surface, thermal_conductivity)
		var/gas_density = air.total_moles/air.volume
		thermal_conductivity *= min(gas_density / ( RADIATOR_OPTIMUM_PRESSURE/(R_IDEAL_GAS_EQUATION*GAS_CRITICAL_TEMPERATURE) ), 1) //mult by density ratio

		// We only get heat from the star on the exposed surface area.
		// If the HE pipes gain more energy from AVERAGE_SOLAR_RADIATION than they can radiate, then they have a net heat increase.
		var/heat_gain = AVERAGE_SOLAR_RADIATION * (RADIATOR_EXPOSED_SURFACE_AREA_RATIO * surface) * thermal_conductivity

		// Previously, the temperature would enter equilibrium at 26C or 294K.
		// Only would happen if both sides (all 2 square meters of surface area) were exposed to sunlight.  We now assume it aligned edge on.
		// It currently should stabilise at 129.6K or -143.6C
		heat_gain -= surface * STEFAN_BOLTZMANN_CONSTANT * thermal_conductivity * (air.temperature - COSMIC_RADIATION_TEMPERATURE) ** 4

		air.add_thermal_energy(heat_gain)
		if(network)
			network.update = 1
