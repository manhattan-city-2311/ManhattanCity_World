#if !defined(USING_MAP_DATUM)

	#include "example-1.dmm"

	#include "example_defines.dm"
	#include "example_elevator.dm"
	#include "example_areas.dm"
	#include "interiors.dmm"
	#include "mining.dmm"

	#define USING_MAP_DATUM /datum/map/example

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Northern Star

#endif