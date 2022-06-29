#define NPC_MODE_SLEEP      0
#define NPC_MODE_IDLE       1
#define NPC_MODE_PATROL     2
#define NPC_MODE_ATTACK     4
#define NPC_MODE_ROUTE      5
#define NPC_MODE_SEEKHELP   6


/mob/living/carbon/human/npc
    npc = TRUE
    var/mode = NPC_MODE_IDLE

    var/atom/target = null
    var/mob/living/attack_target = null
    var/list/ignore_list = list()
    var/list/patrol_path = list()
    var/list/target_path = list()
    var/turf/obstacle = null

    var/target_patience = 5
    var/frustration = 0
    var/max_frustration = 0

/mob/living/carbon/human/npc/New()
    ..()
    switch_intent()

/mob/living/carbon/human/npc/Life()
    ..()
    if(mode == NPC_MODE_ROUTE)
        handle_route()
    if(mode == NPC_MODE_PATROL)
        handlePatrol()
        if(prob(5))
            switch_mode()

/mob/living/carbon/human/npc/proc/switch_mode()
    resetTarget()
    lookForTargets()
    if(will_patrol && !target)
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
		for(var/i = 1 to patrol_speed)
			sleep(20 / (patrol_speed + 1))
			handlePatrol()
		if(max_frustration && frustration > max_frustration * patrol_speed)
			handleFrustrated(0)
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
        for(var/i = 1 to target_speed)
            sleep(20 / (target_speed + 1))
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
    if(get_dist(src, target) > min_target_dist)
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

/mob/living/carbon/human/npc/proc/handlePatrol()
	makeStep(patrol_path)
	return

/mob/living/carbon/human/npc/proc/startPatrol()
	var/turf/T = getPatrolTurf()
	if(T)
		patrol_path = AStar(get_turf(loc), T, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, max_patrol_dist, id = botcard, exclude = obstacle)
		if(!patrol_path)
			patrol_path = list()
		obstacle = null
	return

/mob/living/carbon/human/npc/proc/getPatrolTurf()
	var/minDist = INFINITY
	var/obj/machinery/navbeacon/targ = locate() in get_turf(src)

	if(!targ)
		for(var/obj/machinery/navbeacon/N in navbeacons)
			if(!N.codes["patrol"])
				continue
			if(get_dist(src, N) < minDist)
				minDist = get_dist(src, N)
				targ = N

	if(targ && targ.codes["next_patrol"])
		for(var/obj/machinery/navbeacon/N in navbeacons)
			if(N.location == targ.codes["next_patrol"])
				targ = N
				break

	if(targ)
		return get_turf(targ)
	return null

/mob/living/carbon/human/npc/proc/handleIdle()
	return

/mob/living/carbon/human/npc/proc/calcTargetPath()
	target_path = AStar(get_turf(loc), get_turf(target), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, max_target_dist, id = botcard, exclude = obstacle)
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
		return makeStep(path)

	return step_towards(src, T)

/mob/living/carbon/human/npc/proc/resetTarget()
	target = null
	target_path = list()
	frustration = 0
	obstacle = null
