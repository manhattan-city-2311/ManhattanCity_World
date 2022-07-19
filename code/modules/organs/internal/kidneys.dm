/obj/item/organ/internal/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	gender = PLURAL
	organ_tag = O_KIDNEYS
	parent_organ = BP_GROIN
	min_bruised_damage = 45
	min_broken_damage = 75
	max_damage = 100

/obj/item/organ/internal/kidneys/Process()
	..()

	if(!owner)
		return

	absorb_hormone("potassium_hormone", 0.5)

	generate_hormone("noradrenaline", 0.1, 4)
	generate_hormone("adrenaline", 0.1, 4)

	if(owner.get_blood_perfusion() <= BLOOD_PERFUSION_OKAY + 0.05)
		var/pressure_diff = BLOOD_PRESSURE_NORMAL - owner.mpressure
		free_up_to_hormone("noradrenaline", pressure_diff / 7)
		free_up_to_hormone("adrenaline", pressure_diff / 8)
		owner.consume_oxygen(0.1 * owner.k)

	owner.consume_oxygen(0.7 * owner.k)