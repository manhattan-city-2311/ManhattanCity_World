/obj/item/organ/internal/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	gender = PLURAL
	organ_tag = O_KIDNEYS
	parent_organ = BP_GROIN
	min_bruised_damage = 45
	min_broken_damage = 75
	max_damage = 100
	oxygen_consumption = 0.7

/obj/item/organ/internal/kidneys/Process()
	..()

	if(!owner)
		return

	absorb_hormone(CI_POTASSIUM_HORMONE, 0.5)

	generate_hormone(CI_NORADRENALINE, 0.1, 4)
	generate_hormone(CI_ADRENALINE, 0.1, 4)

	if(owner.get_blood_perfusion() <= BLOOD_PERFUSION_OKAY + 0.05)
		var/pressure_diff = BLOOD_PRESSURE_NORMAL - owner.mpressure
		if(pressure_diff < 0)
			return

		free_up_to_hormone(CI_NORADRENALINE, pressure_diff * 0.142)
		free_up_to_hormone(CI_ADRENALINE, pressure_diff * 0.125)

		if(owner.throttle_message("kidneys_rush", "You feel your veins fire!", span = "danger", delay = (120 SECONDS)))
			owner.flash_pain()
