/datum/job/chief_engineer
	title = "Chief Engineer"
	flag = CHIEF
	faction = "City"
	head_position = 1
	department_flag = ENGSEC
	department = DEPT_COUNCIL
	total_positions = 0
	spawn_positions = 0
	supervisors = "the Mayor"
	subordinates = "the maintenance department"
	selection_color = "#7F6E2C"
	idtype = /obj/item/weapon/card/id/engineering/head
	req_admin_notify = 1

	wage = 1050
	allows_synths = FALSE


	minimum_character_age = 25
	ideal_character_age = 50


	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_external_airlocks, access_atmospherics, access_emergency_storage,
			            access_construction, access_sec_doors,
			            access_ce, access_tcomsat, access_heads)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_external_airlocks, access_atmospherics, access_emergency_storage,
			            access_construction, access_sec_doors,
			            access_ce, access_tcomsat, access_heads)
	alt_titles = list("Public Works Director", "Maintenance Director")
	minimal_player_age = 7

	outfit_type = /decl/hierarchy/outfit/job/engineering/chief_engineer
	clean_record_required = TRUE

/datum/job/chief_engineer/get_job_email()	// whatever this is set to will be the job's communal email. should be persistent.
	return using_map.council_email

/datum/job/engineer
	title = "Engineer"
	flag = ENGINEER
	department_flag = ENGSEC
	faction = "City"
	department = DEPT_MAINTENANCE
	total_positions = 0
	spawn_positions = 0
	supervisors = "the Chief Engineer"
	selection_color = "#5B4D20"
	idtype = /obj/item/weapon/card/id/engineering/engineer
	wage = 160
	access = list(access_engine, access_engine_equip, access_tech_storage, access_construction, access_atmospherics, access_external_airlocks, access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_construction, access_atmospherics, access_external_airlocks, access_maint_tunnels, access_external_airlocks)
	minimum_character_age = 18
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/engineering/engineer
	alt_titles = list("Factory Engineer", "Public Works Staff", "Electrician", "Exosuit Technician")
/*
/datum/job/atmos
	title = "Maintenance Worker"

	flag = ATMOSTECH
	department_flag = ENGSEC
	faction = "City"

	department = DEPT_MAINTENANCE
	total_positions = 3
	spawn_positions = 2
	supervisors = "the Chief Engineer"
	selection_color = "#5B4D20"
	idtype = /obj/item/weapon/card/id/engineering/atmos
	wage = 150
	synth_wage = 75

	access = list(access_engine, access_engine_equip, access_janitor, access_tech_storage, access_construction, access_atmospherics, access_external_airlocks, access_eva, access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_engine, access_engine_equip, access_janitor, access_tech_storage, access_construction, access_atmospherics, access_external_airlocks, access_medical, access_medical_equip, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks)

	minimal_player_age = 3
	minimum_character_age = 18

	outfit_type = /decl/hierarchy/outfit/job/engineering/atmos
	alt_titles = list("Civil Engineer", "Public Works Staff", "Electrician")
*/
// Popping Paramedic In right here.

/datum/job/janitor
	title = "Sanitation Technician"
	flag = JANITOR
	faction = "City"
	department_flag = CIVILIAN
	department = DEPT_MAINTENANCE
	total_positions = 0
	spawn_positions = 0
	supervisors = "the Chief Engineer"
	selection_color = "#515151"

	idtype = /obj/item/weapon/card/id/civilian/janitor
	access = list(access_engine, access_engine_equip, access_external_airlocks, access_janitor, access_maint_tunnels)
	minimal_access = list(access_janitor, access_maint_tunnels)
	minimum_character_age = 16 //Not making it any younger because being a janitor requires a lot of labor, or maybe it just means I'm very lazy? Oh well
	wage = 120
	synth_wage = 75

	outfit_type = /decl/hierarchy/outfit/job/service/janitor
	alt_titles = list("Recycling Technician", "Sanitation Engineer")

/datum/job/factory_chief
	title = "Factory General Director"
	flag = GENDIRECTOR
	faction = "City"
	head_position = 1
	department_flag = ENGSEC
	department = DEPT_COUNCIL
	total_positions = 0
	spawn_positions = 0
	supervisors = "the Mayor"
	subordinates = "the whole factory"
	selection_color = "#ccc91a"
	idtype = /obj/item/weapon/card/id/engineering/head
	req_admin_notify = 1

	wage = 3000
	allows_synths = FALSE


	minimum_character_age = 35
	ideal_character_age = 50


	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors,
			            access_ce, access_janitor, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload, access_medical,
						access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station, access_factory_pmc,
						access_factory_pmchead, access_factory_director)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors,
			            access_ce, access_janitor, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload, access_medical,
						access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station, access_factory_pmc,
						access_factory_pmchead, access_factory_director)
	minimal_player_age = 7

	outfit_type = /decl/hierarchy/outfit/job/engineering/chief_engineer
	clean_record_required = TRUE

/datum/job/factory_chief/get_job_email()	// whatever this is set to will be the job's communal email. should be persistent.
	return using_map.council_email

/datum/job/factory_pmc
	title = "Factory PMC"
	flag = ENGINEER
	department_flag = ENGSEC
	faction = "City"
	department = DEPT_MAINTENANCE
	total_positions = 0
	spawn_positions = 0
	supervisors = "the Factory PMC Chief"
	selection_color = "#d61919"
	idtype = /obj/item/weapon/card/id/engineering/pmc
	wage = 150
	access = list(access_engine, access_construction, access_atmospherics, access_external_airlocks, access_maint_tunnels, access_external_airlocks, access_factory_pmc, access_cargo)
	minimal_access = list(access_engine, access_construction, access_atmospherics, access_external_airlocks, access_maint_tunnels, access_external_airlocks, access_factory_pmc, access_cargo)
	minimum_character_age = 18
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/security/officer
	alt_titles = list("Factory PMC Operative", "PMC Operative")

/datum/job/factory_pmc_head
	title = "Factory PMC Chief"
	flag = ENGINEER
	department_flag = ENGSEC
	faction = "City"
	department = DEPT_MAINTENANCE
	total_positions = 0
	spawn_positions = 0
	supervisors = "the Factory PMC Chief"
	selection_color = "#d61919"
	idtype = /obj/item/weapon/card/id/engineering/pmc_head
	wage = 1000
	access = list(access_engine, access_construction, access_atmospherics, access_external_airlocks, access_maint_tunnels, access_external_airlocks, access_factory_pmc, access_cargo, access_factory_pmchead)
	minimal_access = list(access_engine, access_construction, access_atmospherics, access_external_airlocks, access_maint_tunnels, access_external_airlocks, access_factory_pmc, access_cargo, access_factory_pmchead)
	minimum_character_age = 18
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/security/hos
	alt_titles = list("Factory PMC Chief", "PMC Chief")
