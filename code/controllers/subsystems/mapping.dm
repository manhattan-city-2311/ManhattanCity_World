// Handles map-related tasks, mostly here to ensure it does so after the MC initializes.
SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

	var/list/map_templates = list()
	var/dmm_suite/maploader = null

/datum/controller/subsystem/mapping/Initialize(timeofday)
	//if(subsystem_initialized) //This is not necessary
	//	return
	maploader = new()
	load_map_templates()

	if(config.generate_map)
		// Map-gen is still very specific to the map, however putting it here should ensure it loads in the correct order.
		if(using_map.perform_map_generation())
			using_map.refresh_mining_turfs()


/datum/controller/subsystem/mapping/proc/load_map_templates()
	for(var/T in subtypesof(/datum/map_template))
		var/datum/map_template/template = T
		if(!(initial(template.mappath))) // If it's missing the actual path its probably a base type or being used for inheritence.
			continue
		template = new T()
		// some faction base business.
		if(template.faction_type)
			switch(template.faction_type)
				if("Blue Moon Cartel")
					blue_moon_cartel_bases[template.name] = template
				if("Trust Fund")
					trust_fund_bases[template.name] = template
				if("Quercus Coalition")
					quercus_coalition_bases[template.name] = template
				if("Worker's Union")
					workers_union_bases[template.name] = template
				if("Generic")
					generic_bases[template.name] = template
		else
			map_templates[template.name] = template
	return TRUE