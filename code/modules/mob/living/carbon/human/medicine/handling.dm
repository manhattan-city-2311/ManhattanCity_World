/mob/living/carbon/human/proc/handle_medicine()
	if(stat == DEAD)
		handle_decay()
		handle_organs()
		stabilize_body_temperature()
		update_cm()
		handle_glucose_level()
		consume_oxygen(REST_OXYGEN_CONSUMING * k) // muscles resting
		oxy_last_tick_demand = oxy_demand
		oxy_demand = 0
		avail_oxygen_last_tick = avail_oxygen
		avail_oxygen = 0
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
	absorb_hormone("glucose", DEFAULT_HUNGER_FACTOR)
	absorb_hormone("potassium_hormone", max(DEFAULT_HUNGER_FACTOR * 10, 0.1))

	oxy_last_tick_demand = oxy_demand
	oxy_demand = 0

	avail_oxygen_last_tick = avail_oxygen
	avail_oxygen = 0