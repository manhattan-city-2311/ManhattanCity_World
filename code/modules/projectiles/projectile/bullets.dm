/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	damage = 60
	damage_type = BRUTE
	nodamage = 0
	check_armour = "bullet"
	embed_chance = 20	//Modified in the actual embed process, but this should keep embed chance about the same
	sharp = 1
	var/mob_passthrough_check = 0

	muzzle_type = /obj/effect/projectile/bullet/muzzle

/obj/item/projectile/bullet/on_hit(var/atom/target, var/blocked = 0)
	if (..(target, blocked))
		var/mob/living/L = target
		shake_camera(L, 3, 2)

/obj/item/projectile/bullet/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier)
	if(penetrating > 0 && damage > 20 && prob(damage))
		mob_passthrough_check = 1
	else
		mob_passthrough_check = 0
	return ..()

/obj/item/projectile/bullet/can_embed()
	//prevent embedding if the projectile is passing through the mob
	if(mob_passthrough_check)
		return 0
	return ..()

/obj/item/projectile/bullet/check_penetrate(var/atom/A)
	if(!A || !A.density) return 1 //if whatever it was got destroyed when we hit it, then I guess we can just keep going

	if(istype(A, /obj/mecha))
		return 1 //mecha have their own penetration handling

	if(ismob(A))
		if(!mob_passthrough_check)
			return 0
		if(iscarbon(A))
			damage *= 0.7 //squishy mobs absorb KE
		return 1

	var/chance = damage
	if(istype(A, /turf/simulated/wall))
		var/turf/simulated/wall/W = A
		chance = round(damage/W.material.integrity*180)
	else if(istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		chance = round(damage/D.maxhealth*180)
		if(D.glass) chance *= 2
	else if(istype(A, /obj/structure/girder))
		chance = 100

	if(prob(chance))
		if(A.opacity)
			//display a message so that people on the other side aren't so confused
			A.visible_message("<span class='warning'>\The [src] pierces through \the [A]!</span>")
		return 1

	return 0

//For projectiles that actually represent clouds of projectiles
/obj/item/projectile/bullet/pellet
	name = "shrapnel" //'shrapnel' sounds more dangerous (i.e. cooler) than 'pellet'
	damage = 20
	//icon_state = "bullet" //TODO: would be nice to have it's own icon state
	var/pellets = 4			//number of pellets
	var/range_step = 2		//projectile will lose a fragment each time it travels this distance. Can be a non-integer.
	var/base_spread = 90	//lower means the pellets spread more across body parts. If zero then this is considered a shrapnel explosion instead of a shrapnel cone
	var/spread_step = 10	//higher means the pellets spread more across body parts with distance

/obj/item/projectile/bullet/pellet/Bumped()
	. = ..()
	bumped = 0 //can hit all mobs in a tile. pellets is decremented inside attack_mob so this should be fine.

/obj/item/projectile/bullet/pellet/proc/get_pellets(var/distance)
	var/pellet_loss = round((distance - 1)/range_step) //pellets lost due to distance
	return max(pellets - pellet_loss, 1)

/obj/item/projectile/bullet/pellet/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier)
	if (pellets < 0) return 1

	var/total_pellets = get_pellets(distance)
	var/spread = max(base_spread - (spread_step*distance), 0)

	//shrapnel explosions miss prone mobs with a chance that increases with distance
	var/prone_chance = 0
	if(!base_spread)
		prone_chance = max(spread_step*(distance - 2), 0)

	var/hits = 0
	for (var/i in 1 to total_pellets)
		if(target_mob.lying && target_mob != original && prob(prone_chance))
			continue

		//pellet hits spread out across different zones, but 'aim at' the targeted zone with higher probability
		//whether the pellet actually hits the def_zone or a different zone should still be determined by the parent using get_zone_with_miss_chance().
		var/old_zone = def_zone
		def_zone = ran_zone(def_zone, spread)
		if (..()) hits++
		def_zone = old_zone //restore the original zone the projectile was aimed at

	pellets -= hits //each hit reduces the number of pellets left
	if (hits >= total_pellets || pellets <= 0)
		return 1
	return 0

/obj/item/projectile/bullet/pellet/get_structure_damage()
	var/distance = get_dist(loc, starting)
	return ..() * get_pellets(distance)

/obj/item/projectile/bullet/pellet/Move()
	. = ..()

	//If this is a shrapnel explosion, allow mobs that are prone to get hit, too
	if(. && !base_spread && isturf(loc))
		for(var/mob/living/M in loc)
			if(M.lying || !M.CanPass(src, loc)) //Bump if lying or if we would normally Bump.
				if(Bump(M)) //Bump will make sure we don't hit a mob multiple times
					return

/* note that some idiot decided to use THESE instead of proper calibers listed in fmj.dm and the like */

/obj/item/projectile/bullet/pistol // placeholdered
	fire_sound = 'sound/weapons/gunshot/9mm_shot.ogg'
	damage = 15

/obj/item/projectile/bullet/pistol/small // 5.7mm
	fire_sound = 'sound/weapons/gunshot/57_shot.ogg'
	damage = 15
	armor_penetration = 10
	agony = 5

/obj/item/projectile/bullet/pistol/small/ap
	damage = 10
	armor_penetration = 15

/obj/item/projectile/bullet/pistol/small/hollow
	damage = 20
	armor_penetration = 5

/obj/item/projectile/bullet/pistol/ap
	damage = 10
	armor_penetration = 10

/obj/item/projectile/bullet/pistol/medium
	damage = 20.5

/obj/item/projectile/bullet/pistol/medium/ap
	damage = 15
	armor_penetration = 10

/obj/item/projectile/bullet/pistol/medium/hollow
	damage = 20
	armor_penetration = -10

/obj/item/projectile/bullet/pistol/strong // .44 mag
	fire_sound = 'sound/weapons/gunshot/44_shot.ogg'
	damage = 50

/obj/item/projectile/bullet/pistol/rubber //"rubber" bullets
	name = "rubber bullet"
	damage = 5
	agony = 40
	embed_chance = 0
	sharp = 0
	check_armour = "melee"

/obj/item/projectile/bullet/pistol/rubber/strong //"rubber" bullets for revolvers and matebas
	fire_sound = 'sound/weapons/gunshot/44_shot.ogg'
	damage = 10
	agony = 60
	embed_chance = 0
	sharp = 0
	check_armour = "melee"

/* shotgun projectiles */

/obj/item/projectile/bullet/shotgun
	name = "slug"
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	damage = 40
	armor_penetration = 10

/obj/item/projectile/bullet/shotgun/beanbag		//because beanbags are not bullets
	name = "beanbag"
	damage = 20
	agony = 60
	embed_chance = 0
	sharp = 0
	check_armour = "melee"

//Should do about 80 damage at 1 tile distance (adjacent), and 50 damage at 3 tiles distance.
//Overall less damage than slugs in exchange for more damage at very close range and more embedding
/obj/item/projectile/bullet/pellet/shotgun
	name = "shrapnel"
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	damage = 13
	pellets = 6
	range_step = 1
	spread_step = 10


//EMP shotgun 'slug', it's basically a beanbag that pops a tiny emp when it hits. //Not currently used
/obj/item/projectile/bullet/shotgun/ion
	name = "ion slug"
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 15
	embed_chance = 0
	sharp = 0
	check_armour = "melee"

	combustion = FALSE

/obj/item/projectile/bullet/shotgun/ion/on_hit(var/atom/target, var/blocked = 0)
	..()
	empulse(target, 0, 0, 0, 0)	//Only affects what it hits
	return 1


/* "Rifle" rounds */

/obj/item/projectile/bullet/rifle
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	armor_penetration = 25
	penetrating = 1

/obj/item/projectile/bullet/rifle/a762
	fire_sound = 'sound/weapons/gunshot/762r_shot.ogg'
	damage = 35

/obj/item/projectile/bullet/rifle/a762/ap
	damage = 30
	armor_penetration = 25

/obj/item/projectile/bullet/rifle/a762/hollow
	damage = 40
	armor_penetration = 10
	penetrating = 0

//we don't need these, trust me
/*/obj/item/projectile/bullet/rifle/a762/hunter // Optimized for killing simple animals and not people, because Balance.
#	damage = 20
#	SA_bonus_damage = 50 // 70 total on animals.
#	SA_vulnerability = SA_ANIMAL
*/

/obj/item/projectile/bullet/rifle/a545
	damage = 25

/obj/item/projectile/bullet/rifle/a545/ap
	damage = 20
	armor_penetration = 20

/obj/item/projectile/bullet/rifle/a545/hollow
	damage = 35
	armor_penetration = 10
	penetrating = 0

/*
/obj/item/projectile/bullet/rifle/a545/hunter
	damage = 15
	SA_bonus_damage = 35 // 50 total on animals.
	SA_vulnerability = SA_ANIMAL
*/

/obj/item/projectile/bullet/rifle/a145
	fire_sound = 'sound/weapons/gunshot/sniper.ogg'
	damage = 80
	stun = 3
	weaken = 3
	penetrating = 5
	armor_penetration = 20
	hitscan = 1 //so the PTR isn't useless as a sniper weapon

/* Miscellaneous */

/obj/item/projectile/bullet/suffocationbullet//How does this even work?
	name = "co bullet"
	damage = 20
	damage_type = OXY

/obj/item/projectile/bullet/cyanideround
	name = "poison bullet"
	damage = 40
	damage_type = TOX

/obj/item/projectile/bullet/burstbullet
	name = "exploding bullet"
	fire_sound = 'sound/effects/Explosion1.ogg'
	damage = 20
	embed_chance = 0
	edge = 1

/obj/item/projectile/bullet/burstbullet/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		explosion(target, -1, 0, 2)
	..()

/* Incendiary */

/obj/item/projectile/bullet/incendiary
	name = "incendiary bullet"
	icon_state = "bullet_alt"
	damage = 15
	damage_type = BURN
	incendiary = 1
	flammability = 2

/obj/item/projectile/bullet/incendiary/flamethrower
	name = "ball of fire"
	desc = "Don't stand in the fire."
	icon_state = "fireball"
	damage = 10
	embed_chance = 0
	incendiary = 2
	flammability = 4
	agony = 30
	kill_count = 4
	vacuum_traversal = 0

/obj/item/projectile/bullet/incendiary/flamethrower/large
	damage = 15
	kill_count = 6

/obj/item/projectile/bullet/blank
	invisibility = 101
	damage = 1
	embed_chance = 0

/* Practice */

/obj/item/projectile/bullet/pistol/practice
	damage = 5

/obj/item/projectile/bullet/rifle/practice
	damage = 5
	penetrating = 0

/obj/item/projectile/bullet/shotgun/practice
	name = "practice"
	damage = 5

/obj/item/projectile/bullet/pistol/cap
	name = "cap"
	damage_type = HALLOSS
	fire_sound = null
	damage = 0
	nodamage = 1
	embed_chance = 0
	sharp = 0

	combustion = FALSE

/obj/item/projectile/bullet/pistol/cap/process()
	loc = null
	qdel(src)
