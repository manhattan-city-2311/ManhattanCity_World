
/obj/item/organ/internal/liver
	name = "liver"
	icon_state = "liver"
	w_class = ITEMSIZE_SMALL
	organ_tag = O_LIVER
	parent_organ = BP_GROIN
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 70
	influenced_hormones = list(
		CI_GLUCAGONE
	)
	hormones = list(
		CI_GLUCOSE = 50
	)

	var/bilirubine_norm = -1
	oxygen_consumption = 2
	var/absorbed = 0
	var/absorbed_max = 30

/obj/item/organ/internal/liver/influence_hormone(T, amount)
	if(T == CI_GLUCAGONE)
		free_hormone(CI_GLUCOSE, min(amount, 1))
		absorb_hormone(T, min(amount, 0.1) * 10)

/obj/item/organ/internal/liver/Process()
	..()
	if(!owner)
		return

	if(bilirubine_norm < 0)
		bilirubine_norm = rand(5, 21)

	make_up_to_hormone(CI_BILIRUBINE, bilirubine_norm)
	make_up_to_hormone(CI_AST, 30 + ((damage / max_damage) * 0.1))
	make_up_to_hormone(CI_ALT, 25 + ((damage / max_damage) * 2))

	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(1))
			to_chat(owner, SPAN_DANGER("Your skin itches."))
	if (germ_level > INFECTION_LEVEL_TWO)
		if(prob(1))
			spawn()
				owner.vomit()

	//Detox can heal small amounts of damage
	if (damage < max_damage && !owner.chem_effects[CE_TOXIN])
		heal_damage(0.2 * owner.chem_effects[CE_ANTITOX])

	if(owner.chem_effects[CE_ALCOHOL_TOXIC])
		take_damage(owner.chem_effects[CE_ALCOHOL_TOXIC], prob(90)) // Chance to warn them

	if(absorbed > 0)
		absorbed = max(0, absorbed - 0.15 + LAZYACCESS0(owner.chem_effects, CE_ANTITOX))
	if(absorbed > absorbed_max)
		take_damage(absorbed - absorbed_max)
		absorbed = absorbed_max
	else if(damage > 0)
		var/to_regen = min(damage, absorbed_max - absorbed)
		heal_damage(to_regen)
		absorbed += to_regen

	if(prob(2) && (absorbed || damage))
		switch(absorbed + damage)
			if(8 to 15)
				to_chat(owner, SPAN_WARNING("You fill faint."))
			if(15 to 22)
				to_chat(owner, SPAN_WARNING("You feel poisoned."))
			if(22 to 30)
				to_chat(owner, SPAN_DANGER("You feel extremely poisoned and faint."))

	//Blood regeneration if there is some space
	owner.regenerate_blood(1 + owner.chem_effects[CE_BLOODRESTORE])
