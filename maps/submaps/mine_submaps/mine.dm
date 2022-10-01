// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
#include "ore_boxes1.dmm"
#include "drill_point.dmm"
#include "transport.dmm"
#include "crystal_lake.dmm"
#include "oasis.dmm"
#include "oldman_body.dmm"
#include "lava.dmm"
#include "totem.dmm"
#include "experiment.dmm"
#include "ancient_evil.dmm"
#include "gold_rush.dmm"
#include "warehouse.dmm"
#include "grass.dmm"
#include "grass2.dmm"
#include "grave.dmm"
#endif

/datum/map_template/mine
	name = "Mine"

/datum/map_template/mine/ore_boxes1
	name = "ore_boxes1"
	mappath = 'maps/submaps/mine_submaps/ore_boxes1.dmm'
	cost = 20
	allow_duplicates = TRUE

/datum/map_template/mine/drill_point
	name = "drill_point"
	mappath = 'maps/submaps/mine_submaps/drill_point.dmm'
	cost = 30
	allow_duplicates = FALSE

/datum/map_template/mine/transport
	name = "transport"
	mappath = 'maps/submaps/mine_submaps/transport.dmm'
	cost = 40
	allow_duplicates = FALSE

/datum/map_template/mine/oasis
	name = "oasis"
	mappath = 'maps/submaps/mine_submaps/oasis.dmm'
	cost = 20
	allow_duplicates = TRUE

/datum/map_template/mine/crystal_lake
	name = "crystal_lake"
	mappath = 'maps/submaps/mine_submaps/crystal_lake.dmm'
	cost = 10
	allow_duplicates = TRUE

/datum/map_template/mine/oldman_body
	name = "oldman_body"
	mappath = 'maps/submaps/mine_submaps/oldman_body.dmm'
	cost = 10
	allow_duplicates = FALSE

/datum/map_template/mine/totem
	name = "totem"
	mappath = 'maps/submaps/mine_submaps/totem.dmm'
	cost = 20
	allow_duplicates = FALSE

/datum/map_template/mine/experiment
	name = "experiment"
	mappath = 'maps/submaps/mine_submaps/experiment.dmm'
	cost = 20
	allow_duplicates = FALSE

/datum/map_template/mine/ancient_evil
	name = "ancient_evil"
	mappath = 'maps/submaps/mine_submaps/ancient_evil.dmm'
	cost = 40
	allow_duplicates = FALSE

/datum/map_template/mine/warehouse
	name = "warehouse"
	mappath = 'maps/submaps/mine_submaps/warehouse.dmm'
	cost = 40
	allow_duplicates = FALSE

/datum/map_template/mine/lava
	name = "lava"
	mappath = 'maps/submaps/mine_submaps/lava.dmm'
	cost = 10
	allow_duplicates = TRUE

/datum/map_template/mine/grave
	name = "grave"
	mappath = 'maps/submaps/mine_submaps/grave.dmm'
	cost = 30
	allow_duplicates = TRUE

/datum/map_template/mine/grass
	name = "grass"
	mappath = 'maps/submaps/mine_submaps/grass.dmm'
	cost = 10
	allow_duplicates = TRUE

/datum/map_template/mine/grass2
	name = "grass2"
	mappath = 'maps/submaps/mine_submaps/grass2.dmm'
	cost = 10
	allow_duplicates = TRUE

/datum/map_template/mine/gold_rush
	name = "gold_rush"
	mappath = 'maps/submaps/mine_submaps/gold_rush.dmm'
	cost = 30
	allow_duplicates = TRUE