#define ANXIETY_LEVEL_NONE 0
#define ANXIETY_LEVEL_NOISE 1
#define ANXIETY_LEVEL_CAUTION 2
#define ANXIETY_LEVEL_DANGER 3

/mob/living/carbon/human/npc
	var/anxiety = ANXIETY_LEVEL_NONE //Отражает уровень угрозы для НПС.
	var/idle_tick = 0
	var/obj/item/weapon/target_weapon
	var/next_resist = 0
	var/should_find_weapon = FALSE

/mob/living/carbon/human/npc/proc/handle_combat()
	if(anxiety == ANXIETY_LEVEL_NONE)
		idle_tick++
		if(idle_tick >= 30)
			switch_mode()
			attack_target = null

	if(anxiety == ANXIETY_LEVEL_DANGER && next_resist <= world.time)
		resist()
		next_resist = world.time + 30

	if(anxiety >= ANXIETY_LEVEL_CAUTION && !get_left_hand() && !get_right_hand())
		handle_weapon_pathfinding()

/mob/living/carbon/human/npc/proc/handle_weapon_pathfinding()

	if(!target_weapon)
		find_weapon_on_ground()
		return FALSE

	if(get_dist(src,target_weapon) > 1)
		move_dir = get_dir(src,target_weapon)
		return TRUE

	target_weapon.pickup(src)

	return FALSE


/mob/living/carbon/human/npc/proc/find_weapon_on_ground()
	if(get_right_hand() || get_left_hand() || !should_find_weapon)
		return FALSE

	var/list/possible_items = list()
	for(var/obj/item/weapon/I in contents)
		possible_items += I

	if(length(possible_items))
		var/obj/item/I = pick(possible_items)
		I.pickup(src)
		return FALSE

	if(!target_weapon || !isturf(target_weapon.loc) || get_dist(src,target_weapon.loc) > 6)
		var/list/possible_weapons = list()
		for(var/obj/item/weapon/W in view(6,src))
			if(!isturf(W.loc))
				continue
			possible_weapons[W] = max(1,(6 + 1) - get_dist(src,W.loc))
		if(!length(possible_weapons))
			return FALSE
		target_weapon = pickweight(possible_weapons)

	return TRUE