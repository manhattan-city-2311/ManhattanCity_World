/obj/item/weapon/grenade/flashbang
	name = "flashbang"
	icon_state = "flashbang"
	item_state = "flashbang"
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	var/banglet = 0

/obj/item/weapon/grenade/flashbang/prime()
	..()
	for(var/obj/structure/closet/L in hear(7, get_turf(src)))
		if(locate(/mob/living/carbon/, L))
			for(var/mob/living/carbon/M in L)
				bang(get_turf(src), M)

	for(var/mob/living/carbon/M in hear(7, get_turf(src)))
		bang(get_turf(src), M)

	for(var/obj/structure/blob/B in hear(8,get_turf(src)))       		//Blob damage here
		var/damage = round(30/(get_dist(B,get_turf(src))+1))
		if(B.overmind)
			damage *= B.overmind.blob_type.burn_multiplier
		B.adjust_integrity(-damage)

	new/obj/effect/effect/sparks(src.loc)
	new/obj/effect/effect/smoke/illumination(src.loc, 5, range=30, power=30, color="#FFFFFF")
	qdel(src)
	return

/obj/item/weapon/grenade/flashbang/proc/bang(var/turf/T , var/mob/living/carbon/M)					// Added a new proc called 'bang' that takes a location and a person to be banged.
	to_chat(M, "<span class='danger'>BANG</span>")						// Called during the loop that bangs people in lockers/containers and when banging
	playsound(src.loc, 'sound/effects/bang.ogg', 50, 1, 30)		// people in normal view.  Could theroetically be called during other explosions.
																	// -- Polymorph

	//Checking for protections
	var/eye_safety = 0
	var/ear_safety = 0
	if(iscarbon(M))
		eye_safety = M.eyecheck()
		ear_safety = M.get_ear_protection()

	//Flashing everyone
	if(eye_safety < 1)
		M.flash_eyes()
		M.Confuse(2)
		M.Weaken(5)

	//Now applying sound
	if((get_dist(M, T) <= 2 || src.loc == M.loc || src.loc == M))
		if(ear_safety > 0)
			M.Confuse(2)
			M.Weaken(1)
		else
			M.Confuse(10)
			M.Weaken(3)
			if ((prob(14) || (M == src.loc && prob(70))))
				M.ear_damage += rand(1, 10)
			else
				M.ear_damage += rand(0, 5)
				M.ear_deaf = max(M.ear_deaf,15)

	else if(get_dist(M, T) <= 5)
		if(!ear_safety)
			M.Confuse(8)
			M.ear_damage += rand(0, 3)
			M.ear_deaf = max(M.ear_deaf,10)

	else if(!ear_safety)
		M.Confuse(4)
		M.ear_damage += rand(0, 1)
		M.ear_deaf = max(M.ear_deaf,5)

	//This really should be in mob not every check
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
		if (E && E.damage >= E.min_bruised_damage)
			to_chat(M, "<span class='danger'>Your eyes start to burn badly!</span>")
			if(!banglet && !(istype(src , /obj/item/weapon/grenade/flashbang/clusterbang)))
				if (E.damage >= E.min_broken_damage)
					to_chat(M, "<span class='danger'>You can't see anything!</span>")
	if (M.ear_damage >= 15)
		to_chat(M, "<span class='danger'>Your ears start to ring badly!</span>")
		if(!banglet && !(istype(src , /obj/item/weapon/grenade/flashbang/clusterbang)))
			if (prob(M.ear_damage - 10 + 5))
				to_chat(M, "<span class='danger'>You can't hear anything!</span>")
				M.sdisabilities |= DEAF
	else if(M.ear_damage >= 5)
		to_chat(M, "<span class='danger'>Your ears start to ring!</span>")

	M.update_icons() //Forces matrix transform to proc if they are now laying, I guess?

/obj/item/weapon/grenade/flashbang/Destroy()
	walk(src, 0) // Because we might have called walk_away, we must stop the walk loop or BYOND keeps an internal reference to us forever.
	return ..()

/obj/item/weapon/grenade/flashbang/clusterbang//Created by Polymorph, fixed by Sieve
	desc = "Use of this weapon may constiute a war crime in your area, consult your local Colony Director."
	name = "clusterbang"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "clusterbang"


/obj/item/weapon/grenade/flashbang/clusterbang/prime()
	var/numspawned = rand(6, 6)
	var/again = 0
	for(var/more = numspawned,more > 0,more--)
		if(prob(35))
			again++
			numspawned --

	for(,numspawned > 0, numspawned--)
		spawn(0)
			new /obj/item/weapon/grenade/flashbang/cluster(src.loc)//Launches flashbangs
			playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)

	for(,again > 0, again--)
		spawn(0)
			new /obj/item/weapon/grenade/flashbang/clusterbang/segment(src.loc)//Creates a 'segment' that launches a few more flashbangs
			playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	qdel(src)
	return

/obj/item/weapon/grenade/flashbang/clusterbang/segment
	desc = "A smaller segment of a clusterbang. Better run."
	name = "clusterbang segment"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "clusterbang_segment"

/obj/item/weapon/grenade/flashbang/clusterbang/segment/New()//Segments should never exist except part of the clusterbang, since these immediately 'do their thing' and asplode
	icon_state = "clusterbang_segment_active"
	active = 1
	banglet = 1
	var/stepdist = rand(1,4)//How far to step
	var/temploc = src.loc//Saves the current location to know where to step away from
	walk_away(src,temploc,stepdist)//I must go, my people need me
	var/dettime = rand(15,60)
	spawn(dettime)
		prime()
	..()

/obj/item/weapon/grenade/flashbang/clusterbang/segment/prime()
	var/numspawned = rand(4,8)
	for(var/more = numspawned,more > 0,more--)
		if(prob(35))
			numspawned --

	for(,numspawned > 0, numspawned--)
		spawn(0)
			new /obj/item/weapon/grenade/flashbang/cluster(src.loc)
			playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	qdel(src)
	return

/obj/item/weapon/grenade/flashbang/cluster/New()//Same concept as the segments, so that all of the parts don't become reliant on the clusterbang
	spawn(0)
		icon_state = "flashbang_active"
		active = 1
		banglet = 1
		var/stepdist = rand(1,3)
		var/temploc = src.loc
		walk_away(src,temploc,stepdist)
		var/dettime = rand(15,60)
		spawn(dettime)
		prime()
	..()


/obj/item/weapon/grenade/flashbang/clusterbang/geminus
	desc = "The pinnacle of non-lethal grenade weaponry, the Corusco model grenade is designed to deploy 6 additional flashbangs upon detonation."
	name = "corusco grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "clusterbang"
