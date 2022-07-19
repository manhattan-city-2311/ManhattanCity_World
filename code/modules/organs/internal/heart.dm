#define HEART_NC_DT 0.1
#define HEART_PULSE_DT 0.5

/obj/item/organ/internal/heart
	name = "heart"
	icon_state = "heart-on"
	organ_tag = "heart"
	parent_organ = BP_TORSO
	dead_icon = "heart-off"
	var/pulse = 60
	var/cardiac_output = 1
	var/list/pulse_modificators = list()
	var/list/cardiac_output_modificators = list() // *
	var/list/arrythmias = list()
	var/ischemia = 0
	var/heartbeat = 0
	var/beat_sound = 'sound/effects/singlebeat.ogg'
	var/tmp/next_blood_squirt = 0
	max_damage = 100
	var/open
	influenced_hormones = list(
		"adrenaline",
		"noradrenaline",
		"dopamine"
	)
	var/last_arrythmia_gain

	var/cpr = 0

/obj/item/organ/internal/heart/rejuvenate()
	. = ..()
	pulse_modificators.Cut()
	cardiac_output_modificators.Cut()
	arrythmias.Cut()
	ischemia = 0

/obj/item/organ/internal/heart/New()
	..()
	if(!owner.client)
		return
	damage = owner.client.prefs.heart_data?["damage"] || 0
	pulse = owner.client.prefs.heart_data?["pulse"] || initial(pulse)
	cardiac_output = owner.client.prefs.heart_data?["cardiac_output"] || 1
	ischemia = owner.client.prefs.heart_data?["ischemia"] || 0
	germ_level = owner.client.prefs.heart_data?["germ_level"] || 0


/obj/item/organ/internal/heart/influence_hormone(T, amount)
	if(ishormone(T, adrenaline))
		owner.add_chemical_effect(CE_PULSE, amount * 5)
		owner.add_chemical_effect(CE_CARDIAC_OUTPUT, 1 + amount * 0.05)
	if(ishormone(T, noradrenaline))
		owner.add_chemical_effect(CE_PRESSURE, 1 + amount * 1.2)
		owner.add_chemical_effect(CE_CARDIAC_OUTPUT, 1 + amount * -0.01)
		owner.add_chemical_effect(CE_PULSE, amount * 2)
	if(ishormone(T, dopamine))
		owner.add_chemical_effect(CE_PRESSURE, 1 + amount * 2)
		owner.add_chemical_effect(CE_CARDIAC_OUTPUT, 1 + amount * 0.005)
		owner.add_chemical_effect(CE_ARRYTHMIC, amount / 15)


/obj/item/organ/internal/heart/die()
	make_arrythmia(/datum/arrythmia/asystole)
	pulse = 0
	ischemia = 100
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

		owner.consume_oxygen((pulse * owner.k) / 60)
	else
		pulse_modificators["!should_work"] = -initial(pulse) - 1
		owner.consume_oxygen(0.15 * owner.k)

	cardiac_output_modificators["damage"] = 1 - (damage / max_damage)

	handle_rythme()
	handle_ischemia()

	handle_pulse()
	handle_cardiac_output()

	handle_blood()
	post_handle_rythme()

	handle_heartbeat()

	make_up_to_hormone("ast", 30 + ((damage / max_damage) * 2))
	make_up_to_hormone("alt", 25 + ((damage / max_damage) * 0.1))

/obj/item/organ/internal/heart/proc/handle_pulse()
	var/n_pulse = max(initial(pulse) + sumListAndCutAssoc(pulse_modificators), cpr)
	cpr = 0
	pulse = LERP(pulse, n_pulse, HEART_PULSE_DT)
	pulse = round(Clamp(pulse, 0, 476))

/obj/item/organ/internal/heart/proc/handle_cardiac_output()
	cardiac_output = initial(cardiac_output) * mulListAndCutAssoc(cardiac_output_modificators) * (owner?.k || 1)

/obj/item/organ/internal/heart/proc/make_chem_modificators()
	if(CE_PULSE in owner.chem_effects)
		pulse_modificators["chem"] = owner.chem_effects[CE_PULSE]
	if(CE_CARDIAC_OUTPUT in owner.chem_effects)
		cardiac_output_modificators["chem"] = owner.chem_effects[CE_CARDIAC_OUTPUT]

/obj/item/organ/internal/heart/proc/make_modificators()
	if(owner.get_blood_perfusion() < 0.95 && (owner.mcv + owner.mcv_add) < NORMAL_MCV * owner.k && owner.get_cardiac_output())
		pulse_modificators["hypoperfusion"] = clamp((NORMAL_MCV * owner.k - (owner.mcv + owner.mcv_add)) / 30, 0, 115)
	pulse_modificators["shock"] = Clamp(owner.shock_stage * 0.55, 0, 110)

/obj/item/organ/internal/heart/proc/handle_rythme()
	for(var/T in arrythmias)
		var/datum/arrythmia/A = arrythmias[T]
		ischemia += A.ischemia_mod
		cardiac_output_modificators[A.name] = A.co_mod
		pulse_modificators[A.name] = A.get_hr_mod(src)
	ischemia = max(0, ischemia - 0.25)


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
		var/arrythmic = get_arrythmic()

		if(arrythmic >= 1 && (get_arrythmia_score() < arrythmic))
			make_common_arrythmia(arrythmic)
		if(get_arrythmia_score() >= (ARRYTHMIA_SEVERITY_OVERWRITING - 1) || get_arrythmic() >= (ARRYTHMIA_SEVERITY_OVERWRITING - 1))
			make_specific_arrythmia(ARRYTHMIA_SEVERITY_OVERWRITING)


/obj/item/organ/internal/heart/proc/handle_heartbeat()
	// This is very weird..
	if(pulse >= 90 || owner.shock_stage >= 10 || is_below_sound_pressure(get_turf(owner)))
		var/rate = 0.0119 * pulse - 0.1795

		if(heartbeat >= rate)
			heartbeat = 0
			sound_to(owner, sound(beat_sound, 0, 0, 0, 50))
		else
			heartbeat++

/obj/item/organ/internal/heart/proc/handle_ischemia()
	var/infarct_strength = 0
	if(/datum/organ_disease/infarct in diseases)
		var/datum/organ_disease/infarct/I = locate() in diseases
		infarct_strength = I.strength

	ischemia = min(ischemia, 100 + infarct_strength)

	if(ischemia > 30)
		damage += lerp(0.1, 0.5, (ischemia - 30) / 70)
	cardiac_output_modificators["ischemia"] = max(1 - (ischemia / 100), 0.3)
	if(damage / max_damage > (20 / max_damage))
		make_up_to_hormone("troponint", damage / max_damage * 2)


/obj/item/organ/internal/heart/proc/handle_blood()
	if(!owner)
		return

	if(owner.stat == DEAD)
		return

	if(owner.mpressure <= 5)
		return
	//Bleeding out
	var/blood_max = 0
	var/list/do_spray = list()
	for(var/obj/item/organ/external/temp in owner.organs_by_name)
		var/open_wound
		if(temp.status & ORGAN_BLEEDING)
			for(var/datum/wound/W in temp.wounds)
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
					blood_max += max(min_eff_damage, W.damage - 30) * 0.016
				else
					blood_max += W.damage * 0.016

		if(temp.is_artery_cut())
			var/bleed_amount = temp.get_artery_cut_damage()
			if(temp.applied_pressure)
				bleed_amount *= 0.5
			if(open_wound)
				blood_max += bleed_amount * 0.005
			else
				owner.vessel.remove_reagent("blood", bleed_amount * 0.005 * owner.mpressure / BLOOD_PRESSURE_NORMAL)

		blood_max *= owner.mpressure / BLOOD_PRESSURE_NORMAL

		if(world.time >= next_blood_squirt && isturf(owner.loc) && do_spray.len)
			owner.visible_message("<span class='danger'>Blood squirts from [pick(do_spray)]!</span>")
			// It becomes very spammy otherwise. Arterial bleeding will still happen outside of this block, just not the squirt effect.
			next_blood_squirt = world.time + 100
			var/turf/sprayloc = get_turf(owner)
			blood_max -= owner.drip(ceil(blood_max/3), sprayloc)
			if(blood_max > 0)
				blood_max -= owner.blood_squirt(blood_max, sprayloc)
				owner.drip(blood_max, get_turf(owner))
		else
			owner.drip(blood_max)

/obj/item/organ/internal/heart/proc/is_working()
	if(!is_usable())
		return FALSE

	return pulse

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
			speed = "extreme fast"
		if(220 to INFINITY)
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
		return "Normal"