#define HEART_NC_DT 0.1
#define HEART_PULSE_DT 0.5

/obj/item/organ/internal/heart
	name = "heart"
	icon_state = "heart-on"
	organ_tag = "heart"
	parent_organ = BP_TORSO
	dead_icon = "heart-off"
	var/tmp/pulse = 60
	var/tmp/cardiac_output = 1.2
	var/tmp/list/pulse_modificators = list()
	var/tmp/list/cardiac_output_modificators = list() // *
	var/tmp/list/datum/arrythmia/arrythmias = list()
	var/tmp/heartbeat = 0
	var/const/beat_sound = 'sound/effects/singlebeat.ogg'
	var/tmp/next_blood_squirt = 0
	max_damage = 100
	var/open
	influenced_hormones = list(
		CI_ADRENALINE,
		CI_NORADRENALINE,
		CI_DOPAMINE
	)
	var/tmp/last_arrythmia_gain

	var/tmp/cpr = 0

/obj/item/organ/internal/heart/rejuvenate()
	. = ..()
	pulse_modificators.Cut()
	cardiac_output_modificators.Cut()
	arrythmias.Cut()

/obj/item/organ/internal/heart/New()
	..()

/obj/item/organ/internal/heart/influence_hormone(T, amount)
	switch(T)
		if(CI_ADRENALINE)
			owner.add_chemical_effect(CE_PULSE, amount * 5)
			owner.add_chemical_effect(CE_CARDIAC_OUTPUT, 1 + amount * 0.05)
		if(CI_NORADRENALINE)
			owner.add_chemical_effect(CE_PRESSURE, 1 + amount * 1.2)
			owner.add_chemical_effect(CE_CARDIAC_OUTPUT, 1 + amount * -0.01)
			owner.add_chemical_effect(CE_PULSE, amount * 2)
		if(CI_DOPAMINE)
			owner.add_chemical_effect(CE_PRESSURE, 1 + amount * 2)
			owner.add_chemical_effect(CE_CARDIAC_OUTPUT, 1 + amount * 0.005)
			owner.add_chemical_effect(CE_ARRYTHMIC, amount / 15)


/obj/item/organ/internal/heart/die()
	make_arrythmia(/datum/arrythmia/asystole)
	pulse = 0
	if(dead_icon)
		icon_state = dead_icon
	..()

/obj/item/organ/internal/heart/removed(mob/living/user, drop_organ)
	..()
	make_arrythmia(/datum/arrythmia/asystole)

/obj/item/organ/internal/heart/Process()
	..()
	if(!owner)
		return

	var/should_work = TRUE

	for(var/T in arrythmias)
		var/datum/arrythmia/A = arrythmias[T]
		if(A.stop_heart)
			should_work = FALSE
			break

	if(should_work)
		var/should_add_modificators = TRUE

		if(CE_BETABLOCKER in owner.chem_effects)
			should_add_modificators = prob(100 - owner.chem_effects[CE_BETABLOCKER])

		if(should_add_modificators)
			make_modificators()
			make_chem_modificators()

		oxygen_consumption = (pulse * owner.k) / 60
	else
		pulse_modificators["!should_work"] = -initial(pulse) - 1
		oxygen_consumption = 0.15 * owner.k

	cardiac_output_modificators["damage"] = 1 - (damage / max_damage)

	handle_rythme()

	handle_pulse()
	handle_cardiac_output()

	handle_blood()
	post_handle_rythme()

	handle_heartbeat()

	make_up_to_hormone(CI_AST, 30 + ((damage / max_damage) * 2))
	make_up_to_hormone(CI_ALT, 25 + ((damage / max_damage) * 0.1))
	if(damage / max_damage > 0.2)
		make_up_to_hormone(CI_TROPONIN_T, damage / max_damage * 2)

/obj/item/organ/internal/heart/proc/change_heart_rate(nhr)
	owner?.handle_heart_rate_change(nhr)
	pulse = nhr

/obj/item/organ/internal/heart/proc/handle_pulse()
	var/n_pulse = max(initial(pulse) + sumListAndCutAssoc(pulse_modificators), cpr)
	cpr = 0
	n_pulse = LERP(pulse, n_pulse, HEART_PULSE_DT)
	n_pulse = round(clamp(n_pulse, 0, 476))

	change_heart_rate(n_pulse)

/obj/item/organ/internal/heart/proc/handle_cardiac_output()
	var/n_cardiac_output = initial(cardiac_output) * mulListAndCutAssoc(cardiac_output_modificators) * (owner?.k || 1)
	if(cardiac_output != n_cardiac_output)
		cardiac_output = n_cardiac_output
		change_heart_rate(pulse)

/obj/item/organ/internal/heart/proc/make_chem_modificators()
	if(CE_PULSE in owner.chem_effects)
		pulse_modificators["chem"] = owner.chem_effects[CE_PULSE]
	if(CE_CARDIAC_OUTPUT in owner.chem_effects)
		cardiac_output_modificators["chem"] = owner.chem_effects[CE_CARDIAC_OUTPUT]

/obj/item/organ/internal/heart/proc/make_modificators()
	if(owner.get_blood_perfusion() < 0.95 && (owner.mcv + owner.mcv_add) < NORMAL_MCV * owner.k)
		pulse_modificators["hypoperfusion"] = clamp((NORMAL_MCV * owner.k - (owner.mcv + owner.mcv_add)) / 30, 0, 115)
	pulse_modificators["hyposaturation"] = owner.get_deprivation()
	if(owner.get_deprivation() < 1 && ((owner.mcv + owner.mcv_add) > NORMAL_MCV * owner.k))
		pulse_modificators["hypermcv"] = -((owner.mcv + owner.mcv_add) - NORMAL_MCV * owner.k) / owner.get_cardiac_output()
	pulse_modificators["shock"] = clamp(owner.shock_stage * 0.55, 0, 110)

/obj/item/organ/internal/heart/proc/handle_rythme()
	for(var/T in arrythmias)
		var/datum/arrythmia/A = arrythmias[T]
		cardiac_output_modificators[A.name] = A.co_mod
		pulse_modificators[A.name] = A.get_hr_mod(src)


/obj/item/organ/internal/heart/proc/post_handle_rythme()
	for(var/T in arrythmias)
		var/datum/arrythmia/A = arrythmias[T]
		if(!A.is_over_period())
			break
		if(A.can_weaken(src))
			A.weak(src)
			break
		if(A.can_strengthen(src))
			A.strengthen(src)
			break
	var/period = world.time - last_arrythmia_gain

	if(prob(1) && period > 1.5 MINUTES && !get_ow_arrythmia())
		var/arrythmic = 0//get_arrythmic()

		if(arrythmic > 1 && (get_arrythmia_score() < arrythmic))
			make_common_arrythmia(arrythmic)
		if(get_arrythmia_score() >= (ARRYTHMIA_SEVERITY_OVERWRITING - 1) || get_arrythmic() >= (ARRYTHMIA_SEVERITY_OVERWRITING - 1))
			make_specific_arrythmia(ARRYTHMIA_SEVERITY_OVERWRITING)

/obj/item/organ/internal/heart/proc/handle_heartbeat()
	// This is very weird..
	if(pulse >= 140 || owner.shock_stage >= 10)
		var/rate = 0.0119 * pulse - 0.1795

		if(heartbeat++ >= rate)
			heartbeat = 0
			sound_to(owner, sound(beat_sound, 0, 0, 0, 50))

/obj/item/organ/internal/heart/proc/handle_blood()
	if(!owner)
		return

	if(owner.mpressure <= 5)
		return
	//Bleeding out
	var/blood_max = 0
	var/bpcoef = min(1.25, owner.mpressure / BLOOD_PRESSURE_NORMAL)
	var/list/do_spray = list()
	for(var/obj/item/organ/external/temp in owner.organs_by_name)
		var/open_wound
		if(temp.status & ORGAN_BLEEDING)
			for(var/datum/wound/W as anything in temp.wounds)
				if(!open_wound && (W.damage_type == CUT || W.damage_type == PIERCE) && W.damage && !W.is_treated())
					open_wound = TRUE

				if(!W.bleeding())
					continue

				if(temp.applied_pressure)
					if(ishuman(temp.applied_pressure))
						var/mob/living/carbon/human/H = temp.applied_pressure
						H.bloody_hands(src, 0)
					//somehow you can apply pressure to every wound on the organ at the same time
					//you're basically forced to do nothing at all, so let's make it pretty effective
					var/min_eff_damage = max(0, W.damage - 10) / 6 //still want a little bit to drip out, for effect
					blood_max += max(min_eff_damage, W.damage - 30)
				else
					blood_max += W.damage * 0.25

		if(temp.is_artery_cut())
			var/bleed_amount = temp.get_artery_cut_damage() * 0.1
			if(temp.applied_pressure)
				bleed_amount *= 0.5
			if(open_wound)
				blood_max += bleed_amount
				do_spray += "the [temp.artery_name] in \the [owner]'s [temp]"
			else
				owner.remove_blood(bleed_amount * bpcoef)

	blood_max *= bpcoef

	if(world.time >= next_blood_squirt && isturf(owner.loc) && do_spray.len)
		owner.visible_message("<span class='danger'>Blood squirts from [pick(do_spray)]!</span>")
		// It becomes very spammy otherwise. Arterial bleeding will still happen outside of this block, just not the squirt effect.
		next_blood_squirt = world.time + 200
		var/turf/sprayloc = get_turf(owner)
		blood_max -= owner.drip(ceil(blood_max/3), sprayloc)
		if(blood_max > 0)
			blood_max -= owner.blood_squirt(blood_max, sprayloc)
			owner.drip(blood_max, get_turf(owner))
	else
		owner.drip(blood_max)

/obj/item/organ/internal/heart/proc/is_working()
	return is_usable() && pulse

/obj/item/organ/internal/heart/listen()
	if(pulse <= 0)
		return "no pulse."

	var/strength
	if(cardiac_output <= (initial(cardiac_output) / 2))
		strength = "faint "
	var/rythme_d = (get_arrythmia_score() < 3) ? "regular " : "irregular "

	var/speed
	switch(pulse)
		if(0 to 40)
			speed = "slow"
		if(90 to 140)
			speed = "fast"
		if(140 to 170)
			speed = "very fast"
		if(170 to 220)
			speed = "extremely fast"
		if(220 to POSITIVE_INFINITY)
			speed = "thready"

	. = "[strength][rythme_d][speed] pulse."

/obj/item/organ/internal/heart/proc/get_rythme_fluffy()
	var/list/rythmes = list()
	for(var/T in arrythmias)
		var/datum/arrythmia/A = arrythmias[T]
		rythmes += A.name
	if(rythmes.len)
		return english_list(rythmes)
	else
		if(pulse < 1)
			return "Asystole"
		return "Normal"
