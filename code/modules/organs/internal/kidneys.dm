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

	generate_hormone("noradrenaline", 0.1, 2.5)
	generate_hormone("adrenaline", 0.1, 2.5)

	if(owner.get_blood_perfusion() <= BLOOD_PERFUSION_OKAY)
		var/pressure_diff = BLOOD_PRESSURE_NORMAL
		free_up_to_hormone("noradrenaline", pressure_diff / 7 / 2)
		free_up_to_hormone("adrenaline", pressure_diff / 8 / 2)