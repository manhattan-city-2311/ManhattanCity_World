//#define MEDICINE_SUBSYSTEM_CATCH_RUNTIMES
SUBSYSTEM_DEF(medicine)
	name = "Medicine"
	priority = FIRE_PRIORITY_MEDICINE
	wait = 2.5 SECONDS
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/queue = list()

/datum/controller/subsystem/medicine/stat_entry()
	..("P: [queue.len]")

/datum/controller/subsystem/medicine/fire(resumed = FALSE)
	if(!resumed)
		queue = global.mob_list.Copy()

	var/list/current_run = src.queue

	var/mob/living/carbon/human/H
	for(var/i = current_run.len to 1 step -1)
		H = current_run[i]

		if(!ishuman(H))
			continue

		if(!QDELETED(H))
#ifdef MEDICINE_SUBSYSTEM_CATCH_RUNTIMES
			try
#else
			do
#endif
				H.handle_medicine()
				H.update_cm()
#ifdef MEDICINE_SUBSYSTEM_CATCH_RUNTIMES
			catch(var/exception/e)
				log_runtime(e, H, "Caught by [name] subsystem")
#else
			while(FALSE);
#endif
		else
			current_run -= H

		if (MC_TICK_CHECK)
			current_run.Cut(i)
			return
