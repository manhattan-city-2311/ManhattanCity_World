#define SSMACHINES_MACHINERY 1
#define SSMACHINES_POWERNETS 2
#define SSMACHINES_POWER_OBJECTS 3

//
// SSmachines subsystem - Processing machines, pipenets, and powernets!
//
// Implementation Plan:
// PHASE 1 - Add subsystem using the existing global list vars
// PHASE 2 - Move the global list vars into the subsystem.

SUBSYSTEM_DEF(machines)
	name = "Machines"
	priority = FIRE_PRIORITY_MACHINES
	init_order = INIT_ORDER_MACHINES
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/static/tmp/current_step = SSMACHINES_MACHINERY

	var/static/tmp/cost_pipenets = 0
	var/static/tmp/cost_machinery = 0
	var/static/tmp/cost_powernets = 0
	var/static/tmp/cost_power_objects = 0
	var/static/tmp/list/machinery = list()
	var/static/tmp/list/powernets = list()
	var/static/tmp/list/power_objects = list()
	var/static/tmp/list/processing = list()
	var/static/tmp/list/queue = list()

/datum/controller/subsystem/machines/Recover()
	current_step = SSMACHINES_MACHINERY
	queue.Cut()

/datum/controller/subsystem/machines/Initialize(timeofday)
	makepowernets()
	fire()
	. = ..()

/datum/controller/subsystem/machines/fire(resumed, no_mc_tick)
	var/timer
	if(current_step == SSMACHINES_MACHINERY)
		timer = TICK_USAGE
		process_machinery(resumed, no_mc_tick)
		cost_machinery = MC_AVERAGE(cost_machinery, TICK_DELTA_TO_MS(TICK_USAGE - timer))
		if(state != SS_RUNNING)
			return
		current_step = SSMACHINES_POWERNETS
		resumed = FALSE
	if(current_step == SSMACHINES_POWERNETS)
		timer = TICK_USAGE
		process_powernets(resumed, no_mc_tick)
		cost_powernets = MC_AVERAGE(cost_powernets, TICK_DELTA_TO_MS(TICK_USAGE - timer))
		if(state != SS_RUNNING)
			return
		current_step = SSMACHINES_POWER_OBJECTS
		resumed = FALSE
	if(current_step == SSMACHINES_POWER_OBJECTS)
		timer = TICK_USAGE
		process_power_objects(resumed, no_mc_tick)
		cost_power_objects = MC_AVERAGE(cost_power_objects, TICK_DELTA_TO_MS(TICK_USAGE - timer))
		if (state != SS_RUNNING)
			return
		current_step = SSMACHINES_MACHINERY

/// Rebuilds power networks from scratch. Called by world initialization and elevators.
/datum/controller/subsystem/machines/proc/makepowernets()
	for(var/datum/powernet/powernet as anything in powernets)
		qdel(powernet)
	powernets.Cut()
	setup_powernets_for_cables(cable_list)

/datum/controller/subsystem/machines/proc/setup_powernets_for_cables(list/cables)
	for (var/obj/structure/cable/cable as anything in cables)
		if (cable.powernet)
			continue
		var/datum/powernet/network = new
		network.add_cable(cable)
		propagate_network(cable, cable.powernet)

/datum/controller/subsystem/machines/stat_entry()
	var/msg = list()
	msg += "C:{"
	msg += "MC:[round(cost_machinery,1)]|"
	msg += "PN:[round(cost_powernets,1)]|"
	msg += "PO:[round(cost_power_objects,1)]"
	msg += "} "
	msg += "MC:[global.machines.len]|"
	msg += "PN:[global.powernets.len]|"
	msg += "PO:[global.processing_power_items.len]|"
	msg += "MC/MS:[round((cost ? global.machines.len/cost_machinery : 0),0.1)]"
	..(jointext(msg, null))

/datum/controller/subsystem/machines/proc/process_machinery(resumed, no_mc_tick)
	if (!resumed)
		queue = global.machines.Copy()

	var/obj/machinery/machine
	for(var/i = queue.len to 1 step -1)
		machine = queue[i]

		if(QDELETED(machine) || machine.process(wait) == PROCESS_KILL)
			machine?.is_processing = null
			global.machines -= machine
			continue
		else if(machine.use_power)
			machine.auto_use_power()

		if(no_mc_tick)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			queue.Cut(i)
			return

/datum/controller/subsystem/machines/proc/process_powernets(resumed, no_mc_tick)
	if(!resumed)
		queue = powernets.Copy()
	var/datum/powernet/network
	for(var/i = queue.len to 1 step -1)
		network = queue[i]
		if(QDELETED(network))
			network?.is_processing = null
			powernets -= network
			continue
		network.reset(wait)

		if(no_mc_tick)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			queue.Cut(i)
			return

/datum/controller/subsystem/machines/proc/process_power_objects(resumed, no_mc_tick)
	if(!resumed)
		queue = power_objects.Copy()
	var/obj/item/item
	for(var/i = queue.len to 1 step -1)
		item = queue[i]
		if(QDELETED(item))
			if (item)
				item.is_processing = null
			power_objects -= item
			continue
		if(!item.pwr_drain(wait))
			item.is_processing = null
			power_objects -= item
		if(no_mc_tick)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			queue.Cut(i)
			return

#undef SSMACHINES_MACHINERY
#undef SSMACHINES_POWER_OBJECTS
