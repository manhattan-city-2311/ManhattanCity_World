//Procedures in this file: Gneric surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/generic/
	can_infect = 1

/datum/surgery_step/generic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (isslime(target))
		return 0
	if (target_zone == O_EYES)	//there are specific steps for eye surgery
		return 0
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected == null)
		return 0
	if (affected.is_stump())
		return 0
	if (affected.robotic >= ORGAN_ROBOT)
		return 0
	return 1

///////////////////////////////////////////////////////////////
// Scalpel Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/cut_open
	allowed_tools = list(
	/obj/item/weapon/surgical/scalpel = 70,
	/obj/item/weapon/material/knife = 50,	\
	/obj/item/weapon/material/shard = 15, 		\
	)
	req_open = 0

	min_duration = 90
	max_duration = 110

/datum/surgery_step/generic/cut_open/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && !affected.gauzed && affected.open == 0 && target_zone != O_MOUTH

/datum/surgery_step/generic/cut_open/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts the incision on [target]'s [affected.name] with \the [tool].", \
	"You start the incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible pain as if from a sharp knife in your [affected.name]!", 40)
	if(istype(tool, /obj/item/weapon/surgical/scalpel))
		var/obj/item/weapon/surgical/scalpel/scalpel = tool
		min_duration = scalpel.speed - 10
		max_duration = scalpel.speed + 10
	..()

/datum/surgery_step/generic/cut_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_INFO("[user] has made an incision on [target]'s [affected.name] with \the [tool]."), \
	SPAN_INFO("You have made an incision on [target]'s [affected.name] with \the [tool]."),)
	affected.open = 1

	if(istype(target) && target.should_have_organ(O_HEART))
		affected.status |= ORGAN_BLEEDING

	affected.createwound(CUT, 1)

/datum/surgery_step/generic/cut_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!</font>", \
	"<font color='red'>Your hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!</font>")
	affected.createwound(CUT, 10)


/datum/surgery_step/generic/remove_gauze
	allowed_tools = list(
	/obj/item/weapon/surgical/scalpel = 100,		\
	/obj/item/weapon/material/knife = 100,	\
	/obj/item/weapon/material/shard = 100, 		\
	)
	req_open = 0

	min_duration = 50
	max_duration = 80

/datum/surgery_step/generic/remove_gauze/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.gauzed && target_zone != O_MOUTH

/datum/surgery_step/generic/remove_gauze/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts removing gauze on [target]'s [affected.name] with \the [tool].", \
	"You start removing gauze on [target]'s [affected.name] with \the [tool].")
	..()

/datum/surgery_step/generic/remove_gauze/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_INFO("[user] has removed gauze on [target]'s [affected.name] with \the [tool]."), \
	SPAN_INFO("You have removed gauze on [target]'s [affected.name] with \the [tool]."),)
	affected.gauzed = 0

/datum/surgery_step/generic/remove_gauze/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, slicing over [target]'s [affected.name] with \the [tool]!</font>", \
	"<font color='red'>Your hand slips, slicing over [target]'s [affected.name]  with \the [tool]!</font>")
	affected.createwound(CUT, 3)


///////////////////////////////////////////////////////////////
// Hemostat Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/clamp_bleeders
	allowed_tools = list(
	/obj/item/weapon/surgical/hemostat = 90,	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/device/assembly/mousetrap = 20
	)

	min_duration = 40
	max_duration = 60

/datum/surgery_step/generic/clamp_bleeders/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && !affected.gauzed && affected.open && (affected.status & ORGAN_BLEEDING)

/datum/surgery_step/generic/clamp_bleeders/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts clamping bleeders in [target]'s [affected.name] with \the [tool].", \
	"You start clamping bleeders in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is maddening!", 40)
	..()

/datum/surgery_step/generic/clamp_bleeders/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_INFO("[user] clamps bleeders in [target]'s [affected.name] with \the [tool]."),	\
	SPAN_INFO("You clamp bleeders in [target]'s [affected.name] with \the [tool]."))
	affected.surgical_clamp()
	spread_germs_to_organ(affected, user)

/datum/surgery_step/generic/clamp_bleeders/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.name] with \the [tool]!</font>",	\
	"<font color='red'>Your hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.name] with \the [tool]!</font>",)
	affected.createwound(CUT, 10)

///////////////////////////////////////////////////////////////
// Retractor Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/retract_skin
	allowed_tools = list(
	/obj/item/weapon/surgical/retractor = 90, 	\
	/obj/item/weapon/crowbar = 50,	\
	/obj/item/weapon/material/kitchen/utensil/fork = 15
	)

	min_duration = 30
	max_duration = 40

/datum/surgery_step/generic/retract_skin/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && !affected.gauzed && affected.open == 1 //&& !(affected.status & ORGAN_BLEEDING)

/datum/surgery_step/generic/retract_skin/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "[user] starts to pry open the incision on [target]'s [affected.name] with \the [tool]."
	var/self_msg = "You start to pry open the incision on [target]'s [affected.name] with \the [tool]."
	if (target_zone == BP_TORSO)
		msg = "[user] starts to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
		self_msg = "You start to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
	if (target_zone == BP_GROIN)
		msg = "[user] starts to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
		self_msg = "You start to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
	user.visible_message(msg, self_msg)
	target.custom_pain("It feels like the skin on your [affected.name] is on fire!", 40)
	..()

/datum/surgery_step/generic/retract_skin/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = SPAN_INFO("[user] keeps the incision open on [target]'s [affected.name] with \the [tool].")
	var/self_msg = SPAN_INFO("You keep the incision open on [target]'s [affected.name] with \the [tool].")
	if (target_zone == BP_TORSO)
		msg = SPAN_INFO("[user] keeps the ribcage open on [target]'s torso with \the [tool].")
		self_msg = SPAN_INFO("You keep the ribcage open on [target]'s torso with \the [tool].")
	if (target_zone == BP_GROIN)
		msg = SPAN_INFO("[user] keeps the incision open on [target]'s lower abdomen with \the [tool].")
		self_msg = SPAN_INFO("You keep the incision open on [target]'s lower abdomen with \the [tool].")
	user.visible_message(msg, self_msg)
	affected.open = 2

/datum/surgery_step/generic/retract_skin/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "<font color='red'>[user]'s hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!</font>"
	var/self_msg = "<font color='red'>Your hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!</font>"
	if (target_zone == BP_TORSO)
		msg = "<font color='red'>[user]'s hand slips, damaging several organs in [target]'s torso with \the [tool]!</font>"
		self_msg = "<font color='red'>Your hand slips, damaging several organs in [target]'s torso with \the [tool]!</font>"
	if (target_zone == BP_GROIN)
		msg = "<font color='red'>[user]'s hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]!</font>"
		self_msg = "<font color='red'>Your hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]!</font>"
	user.visible_message(msg, self_msg)
	target.apply_damage(12, BRUTE, affected, sharp=1)

///////////////////////////////////////////////////////////////
// Suture Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/stitching
	allowed_tools = list(
	/obj/item/weapon/surgical/suture = 90,
	)

	min_duration = 70
	max_duration = 100

/datum/surgery_step/generic/stitching/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && !affected.gauzed && affected.open && target_zone != O_MOUTH

/datum/surgery_step/generic/stitching/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] is beginning to suture the incision on [target]'s [affected.name] with \the [tool]." , \
	"You are beginning to suture the incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("Your [affected.name] is being sutured!", 10)
	..()

/datum/surgery_step/generic/stitching/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_INFO("[user] sutures the incision on [target]'s [affected.name] with \the [tool]."), \
	SPAN_INFO("You sutures the incision on [target]'s [affected.name] with \the [tool]."))
	affected.open = 0
	affected.status &= ~ORGAN_BLEEDING

/datum/surgery_step/generic/stitching/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, leaving a small cut on [target]'s [affected.name] with \the [tool]!</font>", \
	"<font color='red'>Your hand slips, leaving a small cut on [target]'s [affected.name] with \the [tool]!</font>")
	target.apply_damage(1, CUT, affected)

///////////////////////////////////////////////////////////////
// Amputation Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/amputate
	allowed_tools = list(
	/obj/item/weapon/surgical/circular_saw = 90, \
	/obj/item/weapon/material/knife/machete/hatchet = 75
	)
	req_open = 0

	min_duration = 110
	max_duration = 160

/datum/surgery_step/generic/amputate/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (target_zone == O_EYES)	//there are specific steps for eye surgery
		return 0
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected == null)
		return 0
	return !affected.cannot_amputate

/datum/surgery_step/generic/amputate/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] is beginning to amputate [target]'s [affected.name] with \the [tool]." , \
	"You are beginning to cut through [target]'s [affected.amputation_point] with \the [tool].")
	target.custom_pain("Your [affected.amputation_point] is being ripped apart!", 100)
	..()

/datum/surgery_step/generic/amputate/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_INFO("[user] amputates [target]'s [affected.name] at the [affected.amputation_point] with \the [tool]."), \
	SPAN_INFO("You amputate [target]'s [affected.name] with \the [tool]."))
	affected.droplimb(1,DROPLIMB_EDGE)

/datum/surgery_step/generic/amputate/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, sawing through the bone in [target]'s [affected.name] with \the [tool]!</font>", \
	"<font color='red'>Your hand slips, sawwing through the bone in [target]'s [affected.name] with \the [tool]!</font>")
	affected.createwound(CUT, 30)
	affected.fracture()
