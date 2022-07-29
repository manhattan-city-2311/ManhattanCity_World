/obj/item/organ/internal/spleen
	name = "spleen"
	icon_state = "spleen"
	organ_tag = O_SPLEEN
	parent_organ = BP_TORSO
	w_class = ITEMSIZE_TINY

	var/spleen_tick = 20 // The number of ticks between Spleen cycles.
	var/spleen_efficiency = 1 // A multiplier for how efficient this spleen is.

/obj/item/organ/internal/spleen/process()
	..()
	if(!owner) return

	if(owner.life_tick % spleen_tick == 0)

		//High toxins levels are dangerous
		if(owner.getToxLoss() >= 30 && !owner.reagents.has_reagent("anti_toxin"))
			//Healthy liver suffers on its own
			if (src.damage < min_broken_damage)
				src.damage += 0.2 * spleen_tick
			//Damaged one shares the fun
			else
				var/obj/item/organ/internal/O = pick(owner.internal_organs_by_name)
				if(O)
					O.damage += 0.2 * spleen_tick

		//Detox can heal small amounts of damage
		if (src.damage && src.damage < src.min_bruised_damage && owner.reagents.has_reagent("anti_toxin"))
			src.damage -= 0.2 * spleen_tick * spleen_efficiency

		if(src.damage < 0)
			src.damage = 0

/obj/item/organ/internal/spleen/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!.) return

	// Low levels can cause pain and haemophilia, high levels can cause brain infections.
	if (. >= INFECTION_LEVEL_ONE)
		if(prob(1))
			owner.custom_pain("There's a sharp pain in your [owner.get_organ(parent_organ)]!",1)
			owner.add_modifier(/datum/modifier/trait/haemophilia, 2 MINUTES * spleen_efficiency)
	if (. >= INFECTION_LEVEL_TWO)
		if(prob(1))
			if(owner.getToxLoss() < owner.getMaxHealth() * 0.2 * spleen_efficiency)
				owner.adjustToxLoss(2 * spleen_efficiency)

/obj/item/organ/internal/spleen/die()
	..()
	if(owner)
		owner.add_modifier(/datum/modifier/trait/haemophilia, round(15 MINUTES * spleen_efficiency))
		var/obj/item/organ/external/Target = owner.get_organ(parent_organ)
		var/datum/wound/W = new /datum/wound/internal_bleeding(round(20 * spleen_efficiency))
		owner.adjustToxLoss(15 * spleen_efficiency)
		Target.wounds += W

/obj/item/organ/internal/spleen/skrell
	name = "lymphatic hub"
	icon_state = "spleen"
	parent_organ = BP_HEAD
	spleen_efficiency = 0.5

/obj/item/organ/internal/spleen/skrell/New()
	..()
	adjust_scale(0.8,0.7)

/obj/item/organ/internal/spleen/minor
	name = "vestigial spleen"
	parent_organ = BP_GROIN
	spleen_efficiency = 0.3
	spleen_tick = 15

/obj/item/organ/internal/spleen/minor/New()
	..()
	adjust_scale(0.7)
