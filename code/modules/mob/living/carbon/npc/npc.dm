#define NPC_MODE_SLEEP	  1
#define NPC_MODE_IDLE	   2
#define NPC_MODE_PATROL	 3
#define NPC_MODE_ATTACK	 4
#define NPC_MODE_ROUTE	  5
#define NPC_MODE_SEEKHELP   6


/mob/living/carbon/human/npc
	npc = TRUE
	var/mode = NPC_MODE_IDLE

	var/atom/target = null
	var/mob/living/attack_target = null
	var/list/ignore_list = list()
	var/list/patrol_path = list()
	var/list/target_path = list()
	var/obj/effect/npc/patrol/cur_patrol_marker = null
	var/obj/effect/npc/patrol/used_patrol_marker = null
	var/turf/obstacle = null
	var/turf/last_turf = null
	var/turf_procs = 0

	var/target_patience = 5
	var/frustration = 0
	var/max_frustration = 0

	var/patrol_speed = 2
	var/target_speed = 1

	var/botcard

	var/move_dir

	var/flee_pain = 75

/mob/living/carbon/human/npc/initialize()
	..()
	switch_intent()
	switch_mode()
	START_PROCESSING(SSnpc, src)

	gender = pick(MALE, FEMALE)

	age = rand(18, 55)

	s_tone = random_skin_tone()
	h_style = random_hair_style(gender, "Human")
	f_style = random_facial_hair_style(gender, "Human")

	if(gender == MALE)
		name = "[pick(first_names_male)] [pick(last_names)]"
		real_name = name
	else
		name = "[pick(first_names_female)] [pick(last_names)]"
		real_name = name

	var/hair_color = random_hair_color(src)
	r_hair = hair_color[1]
	g_hair = hair_color[2]
	b_hair = hair_color[3]

	r_facial = r_hair
	g_facial = g_hair
	b_facial = b_hair

	var/eye_color = random_eye_color()
	r_eyes = eye_color[1]
	g_eyes = eye_color[2]
	b_eyes = eye_color[3]

	update_glide()

	equip_outfit()

/mob/living/carbon/human/npc/death()
	..()
	mode = NPC_MODE_SLEEP
	STOP_PROCESSING(SSnpc, src)

/mob/living/carbon/human/npc/Life()
	return

/mob/living/carbon/human/npc/proc/domove()
	var/newloc = get_step(src.loc, move_dir)
	Move(newloc, move_dir)

/mob/living/carbon/human/npc/on_attack(mob/living/user)
	if(mode == NPC_MODE_ATTACK)
		return
	else
		spawn(reaction_time)
			mode = NPC_MODE_ATTACK
			anxiety = ANXIETY_LEVEL_DANGER
			attack_target = user
			switch_intent()
			handle_combat()
			say(pick(npc_attack_phrases))

/mob/living/carbon/human/npc/proc/switch_mode()
	resetTarget()
	lookForTargets()
	if(shock_stage > flee_pain)
		mode = NPC_MODE_SEEKHELP
	if(!target)
		mode = NPC_MODE_PATROL
		handle_patrol()
	else
		mode = NPC_MODE_IDLE
		handleIdle()


/mob/living/carbon/human/npc/proc/switch_intent()
	switch(mode)
		if(NPC_MODE_SLEEP || NPC_MODE_IDLE)
			a_intent = I_HELP
		if(NPC_MODE_ATTACK || NPC_MODE_SEEKHELP)
			a_intent = I_HURT
		if(NPC_MODE_PATROL || NPC_MODE_ROUTE)
			a_intent = I_DISARM

/mob/living/carbon/human/npc/proc/handle_patrol()
	if(patrol_path && patrol_path.len)
		if(max_frustration && frustration > max_frustration * patrol_speed)
			handleFrustrated(0)
		makeStep(patrol_path)
	else
		startPatrol()

/mob/living/carbon/human/npc/proc/handle_route()
	if(!target)
		switch_mode()
	if(ignore_list.len)
		for(var/atom/A in ignore_list)
			if(!A || !A.loc)
				ignore_list -= A
	handleRegular()
	if(target && confirmTarget(target))
		if(Adjacent(target))
			handleAdjacentTarget()
		else
			handleRangedTarget()
		stepToTarget()
		if(max_frustration && frustration > max_frustration * target_speed)
			handleFrustrated(1)
	else
		switch_mode()

/mob/living/carbon/human/npc/proc/handleRegular()
	return

/mob/living/carbon/human/npc/proc/handleAdjacentTarget()
	return

/mob/living/carbon/human/npc/proc/handleRangedTarget()
	return

/mob/living/carbon/human/npc/proc/stepToTarget()
	if(!target || !target.loc)
		return
	if(get_dist(src, target) > 1)
		if(!target_path.len || get_turf(target) != target_path[target_path.len])
			calcTargetPath()
		if(makeStep(target_path))
			frustration = 0
		else if(max_frustration)
			++frustration
	return

/mob/living/carbon/human/npc/proc/handleFrustrated(var/targ)
	obstacle = targ ? target_path[1] : patrol_path[1]
	target_path = list()
	patrol_path = list()
	return

/mob/living/carbon/human/npc/proc/lookForTargets()
	return

/mob/living/carbon/human/npc/proc/confirmTarget(var/atom/A)
	if(A.invisibility >= INVISIBILITY_LEVEL_ONE)
		return 0
	if(A in ignore_list)
		return 0
	if(!A.loc)
		return 0
	return 1

/mob/living/carbon/human/npc/proc/startPatrol()
	var/turf/T = getPatrolTurf()
	if(T)
		patrol_path = AStar(get_turf(loc), T, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 50, id = botcard, exclude = obstacle)
		if(!patrol_path)
			patrol_path = list()
		obstacle = null
	return

/mob/living/carbon/human/npc/proc/getPatrolTurf()
	var/maxDist = 50
	var/mob/living/carbon/human/targ

	var/obj/effect/npc/patrol/N = pick(GLOB.npcmarkers)
	if(get_dist(src, N) < maxDist && N != used_patrol_marker && N.in_nuse == FALSE)
		maxDist = get_dist(src, N)
		targ = N
		if(used_patrol_marker)
			used_patrol_marker.in_nuse = FALSE
		used_patrol_marker = N
		cur_patrol_marker = N
		cur_patrol_marker.in_nuse = TRUE

	if(!targ)
		targ = locate() in get_turf(src)

	if(targ)
		return get_turf(targ)
	return null

/mob/living/carbon/human/npc/proc/handleIdle()
	for(var/mob/living/carbon/human/npc/N in range(1, src))
		if(!talking_to)
			handle_speech(N)
		else
			process_speech()
		return
	switch_mode()

/mob/living/carbon/human/npc/proc/calcTargetPath()
	target_path = AStar(get_turf(loc), get_turf(target), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 50, id = botcard, exclude = obstacle)
	if(!target_path)
		if(target && target.loc)
			ignore_list |= target
		resetTarget()
		obstacle = null
	return

/mob/living/carbon/human/npc/proc/makeStep(var/list/path)
	if(!path || !path.len)
		return 0
	var/turf/T = path[1]
	if(get_turf(src) == T)
		path -= T
	move_dir = get_dir(src, T)

/mob/living/carbon/human/npc/proc/resetTarget()
	target = null
	target_path = list()
	frustration = 0
	obstacle = null
