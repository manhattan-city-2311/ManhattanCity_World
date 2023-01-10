#define SSMACHINES_MACHINERY 1

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

	var/static/tmp/cost_machinery = 0
	var/static/tmp/list/machinery = list()
	var/static/tmp/list/processing = list()
	var/static/tmp/list/queue = list()

/datum/controller/subsystem/machines/Recover()
	queue.Cut()

/datum/controller/subsystem/machines/Initialize(timeofday)
	fire()
	. = ..()

/datum/controller/subsystem/machines/fire(resumed, no_mc_tick)
	var/timer = TICK_USAGE
	process_machinery(resumed, no_mc_tick)
	cost_machinery = MC_AVERAGE(cost_machinery, TICK_DELTA_TO_MS(TICK_USAGE - timer))
	if(state != SS_RUNNING)
		return
	resumed = FALSE

/datum/controller/subsystem/machines/stat_entry()
	var/msg = list()
	msg += "C:{"
	msg += "MC:[round(cost_machinery,1)]|"
	msg += "} "
	msg += "MC:[global.machines.len]|"
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

		if(no_mc_tick)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			queue.Cut(i)
			return

#undef SSMACHINES_MACHINERY
