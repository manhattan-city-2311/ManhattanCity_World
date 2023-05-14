
#if !defined(USING_MAP_DATUM)

	#include "manhattan-1.dmm"
	#include "manhattan-2.dmm"
	#include "manhattan-3.dmm"
	#include "manhattan-4.dmm"
	#include "../service/service.dmm"

	#include "manhattan_defines.dm"
	#include "manhattan_areas.dm"
	#include "manhattan_npcs.dm"
	#include "manhattan_elevator.dm"

	#define USING_MAP_DATUM /datum/map/new_manhattan

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Manhattan

#endif