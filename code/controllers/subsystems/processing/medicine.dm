PROCESSING_SUBSYSTEM_DEF(medicine)
	name = "Medicine"
	priority = FIRE_PRIORITY_MEDICINE
	flags = SS_NO_INIT
	wait = 10
	process_proc = /mob/living/carbon/human/proc/update_cm

/datum/controller/subsystem/processing/medicine/stat_entry(text)
	text = {"\
		[text] | \
		Mobs: [processing.len] \
	"}
	..(text)