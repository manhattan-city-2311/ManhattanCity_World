/mob/living/carbon/human/proc/handle_medicine()
	if(stat == DEAD)
		handle_decay()
		return
	//Organs and blood
	handle_organs()

	stabilize_body_temperature() //Body temperature adjusts itself (self-regulation)

	handle_shock()

	handle_pain()

	handle_medical_side_effects()

	handle_heartbeat()

	handle_nourishment()

	handle_weight()

	update_cm()

	handle_glucose_level()

	handle_additictions()

	consume_oxygen(REST_OXYGEN_CONSUMING * k) // muscles resting

	oxy_last_tick_demand = oxy_demand
	oxy_demand = 0

	avail_oxygen_last_tick = avail_oxygen
	avail_oxygen = 0