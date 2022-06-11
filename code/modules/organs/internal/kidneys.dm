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

	absorb_hormone(/datum/reagent/hormone/potassium, 0.5)

	generate_hormone(/datum/reagent/hormone/noradrenaline, 0.1, 2.5)
	generate_hormone(/datum/reagent/hormone/adrenaline, 0.1, 2.5)

	if(owner.get_blood_perfusion() <= BLOOD_PERFUSION_OKAY)
		var/pressure_diff = BLOOD_PRESSURE_NORMAL
		free_up_to_hormone(/datum/reagent/hormone/noradrenaline, pressure_diff / 7 / 2)
		free_up_to_hormone(/datum/reagent/hormone/adrenaline   , pressure_diff / 8 / 2)