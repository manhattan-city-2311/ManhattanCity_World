/obj/item/organ/internal/lungs
	name = "lungs"
	icon_state = "lungs"
	gender = PLURAL
	organ_tag = O_LUNGS
	parent_organ = BP_TORSO
	w_class = ITEMSIZE_NORMAL
	min_bruised_damage = 25
	min_broken_damage = 50
	max_damage = 70

	var/breath_cycle = 0
	var/respiratory_rate = 15
	var/list/respiratory_rate_modificators = list()
	var/last_breath = 0

/obj/item/organ/internal/lungs/New()
	..()

/obj/item/organ/internal/lungs/robotize()
	. = ..()
	icon_state = "lungs-prosthetic"

/obj/item/organ/internal/lungs/proc/can_breathe()
	return (!owner.nervous_system_failure()) && (damage < min_broken_damage) && (owner.losebreath <= 0)

/obj/item/organ/internal/lungs/proc/is_breathing()
	return respiratory_rate > 0

/mob/living/carbon/proc/is_breathing()
	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]

	return L ? (L.is_breathing()) : FALSE

/obj/item/organ/internal/lungs/proc/make_modificators()
	if(!can_breathe())
		respiratory_rate_modificators["losebreath"] = -100
		return

/obj/item/organ/internal/lungs/proc/handle_respiratory_rate()
	respiratory_rate = max(0, initial(respiratory_rate) + sumListAndCutAssoc(respiratory_rate_modificators))

/obj/item/organ/internal/lungs/Process()
	..()
	if(!owner)
		return

	if (germ_level > INFECTION_LEVEL_ONE && is_breathing())
		if(prob(5))
			owner.emote("cough")

	if(is_bruised())
		if(prob(2))
			if(is_breathing())
				owner.visible_message(
					"<B>\The [owner]</B> coughs up blood!",
					SPAN_DANGER("You cough up blood!"),
					"You hear someone coughing!",
				)
			owner.drip(50)

	make_modificators()
	handle_respiratory_rate()

	if(is_breathing())
		breath_cycle += respiratory_rate / 30
	else
		breath_cycle = 0
		handle_failed_breath()

	if(breath_cycle >= 1)
		handle_breath(breath_cycle)
		breath_cycle = 0

	oxygen_consumption = 0.013 * respiratory_rate * owner.k

/obj/item/organ/internal/lungs/proc/rupture()
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	if(istype(parent))
		owner.custom_pain("You feel a stabbing pain in your [parent.name]!", 50)

// TODO: oxygen alert
// TODO: breathloss chem effect

/obj/item/organ/internal/lungs/proc/handle_breath(number)
	if(!owner)
		return

	var/volume           = BREATH_VOLUME * number * (1 - damage / max_damage)
	var/oxygen_volume    = volume * O2STANDARD * 0.55

	var/minutes_passed   = (world.time - last_breath) / (1.0 MINUTE)

	var/max_delta_oxygen = owner.get_max_blood_oxygen_delta() * minutes_passed
	var/max_delta_co2    = owner.get_max_blood_co2_delta() * minutes_passed

	owner.remove_co2(max_delta_co2)
	owner.make_oxygen(min(max_delta_oxygen, oxygen_volume))

	last_breath = world.time

/obj/item/organ/internal/lungs/proc/handle_failed_breath()
	if(prob(5))
		if(can_breathe())
			owner.emote("gasp")
		else if(prob(25))
			to_chat(owner, SPAN_DANGER("You're having trouble getting enough oxygen!"))
	if(owner.losebreath > 0)
		--owner.losebreath

// TODO: lungs listening
/obj/item/organ/internal/lungs/listen()
	if(!is_breathing())
		return "no respiration"

	if(robotic == ORGAN_ROBOT)
		if(is_bruised())
			return "malfunctioning fans"
		else
			return "air flowing"

	. = list()
	if(is_bruised())
		. += "[pick("wheezing", "gurgling")] sounds"

	var/list/breathtype = list()
	if(owner.shock_stage > 50)
		breathtype += pick("shallow and rapid")
	if(!breathtype.len)
		breathtype += "healthy"

	. += "[english_list(breathtype)] breathing"

	return english_list(.)
