/mob/living/carbon/human/proc/handle_medicine()
	if(stat != DEAD)
		//Organs and blood
		handle_organs()
		stabilize_body_temperature() //Body temperature adjusts itself (self-regulation)

		handle_shock()

		handle_pain()

		handle_medical_side_effects()

		handle_heartbeat()

		handle_nourishment()

		handle_weight()
		process()