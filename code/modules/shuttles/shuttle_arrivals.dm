// The new arrivals shuttle.
/datum/shuttle/ferry/arrivals
	name = "Arrivals"
	location = 1
	warmup_time = 25 // Warmup takes 5 seconds, so 30 total.
	always_process = TRUE
	var/launch_delay = 3

	area_offsite = /area/shuttle/arrival/pre_game // not really 'pre game' but this area is already defined and unused
	area_station = /area/shuttle/arrival/station
	docking_controller_tag = "arrivals_shuttle"
	dock_target_station = "arrivals_dock"

// For debugging.
/obj/machinery/computer/shuttle_control/arrivals
	name = "shuttle control console"
	req_access = list(access_cent_general)
	shuttle_tag = "Arrivals"

// Unlike most shuttles, the arrivals shuttle is completely automated, so we need to put some additional code here.

/*
/datum/shuttle/ferry/arrivals/current_dock_target()
	if(location) // If we're off station.
		return null // Nothing to dock to in space.
	return ..()
*/
