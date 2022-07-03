#define ANXIETY_LEVEL_NONE 0
#define ANXIETY_LEVEL_NOISE 1
#define ANXIETY_LEVEL_CAUTION 2
#define ANXIETY_LEVEL_DANGER 3

/mob/living/carbon/human/npc
	var/anxiety = ANXIETY_LEVEL_NONE //Отражает уровень угрозы для НПС.
	var/idle_tick = 0
	var/obj/item/weapon/target_weapon

/mob/living/carbon/human/npc/proc/handle_combat()
	if(anxiety == ANXIETY_LEVEL_NONE)
		idle_tick++
		if(idle_tick >= 30)
			switch_mode()

	if(anxiety == ANXIETY_LEVEL_DANGER && next_resist <= world.time)
		resist()

	if(anxiety >= ANXIETY_LEVEL_CAUTION && !l_arm && !r_arm)
		handle_weapon_pathfinding()

/mob/living/carbon/human/npc/proc/handle_weapon_pathfinding()

	if(!target_weapon)
		find_weapon_on_ground()
		return FALSE

	if(get_dist(src,target_weapon) > 1)
		move_dir = get_dir(src,target_weapon)
		return TRUE

	equip_weapon(target_weapon)

	return FALSE


/mob/living/carbon/human/npc/proc/find_weapon_on_ground()

	var/mob/living/carbon/human/A = owner
	if(A.right_item || A.left_item || !should_find_weapon)
		return FALSE

	var/list/possible_items = list()
	for(var/obj/item/weapon/I in A.held_objects)
		possible_items += I
	for(var/obj/item/weapon/I in A.worn_objects)
		possible_items += I

	if(length(possible_items))
		var/obj/item/I = pick(possible_items)
		equip_weapon(I)
		return FALSE

	if(!target_weapon || !isturf(target_weapon.loc) || get_dist(A,target_weapon.loc) > 6)
		var/list/possible_weapons = list()
		for(var/obj/item/weapon/W in view(6,A))
			if(istype(W,/obj/item/weapon/ranged/))
				var/obj/item/weapon/ranged/R = W
			if(istype(W,/obj/item/weapon/ranged/bullet/))
				var/obj/item/weapon/ranged/bullet/B = W
				if(!B.chambered_bullet)
					continue
			if(!isturf(W.loc))
				continue
			possible_weapons[W] = max(1,(6 + 1) - get_dist(A,W.loc))
		if(!length(possible_weapons))
			return FALSE
		target_weapon = pickweight(possible_weapons)

	return TRUE