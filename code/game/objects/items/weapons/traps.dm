/obj/item/weapon/beartrap
	name = "mechanical trap"
	throw_speed = 2
	throw_range = 1
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "beartrap0"
	desc = "A mechanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	throwforce = 0
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 18750)
	var/deployed = 0

	unique_save_vars = list("deployed")

/obj/item/weapon/beartrap/suicide_act(mob/user)
	var/datum/gender/T = gender_datums[user.get_visible_gender()]
	viewers(user) << "<span class='danger'>[user] is putting the [src.name] on [T.his] head! It looks like [T.hes] trying to commit suicide.</span>"
	return (BRUTELOSS)

/obj/item/weapon/beartrap/proc/can_use(mob/user)
	return (user.IsAdvancedToolUser() && !issilicon(user) && !user.stat && !user.restrained())

/obj/item/weapon/beartrap/attack_self(mob/user as mob)
	..()
	if(!deployed && can_use(user))
		user.visible_message(
			"<span class='danger'>[user] starts to deploy \the [src].</span>",
			"<span class='danger'>You begin deploying \the [src]!</span>",
			"You hear the slow creaking of a spring."
			)

		if (do_after(user, 60))
			user.visible_message(
				"<span class='danger'>[user] has deployed \the [src].</span>",
				"<span class='danger'>You have deployed \the [src]!</span>",
				"You hear a latch click loudly."
				)
			playsound(src.loc, 'sound/machines/click.ogg',70, 1)

			deployed = 1
			user.drop_from_inventory(src)
			update_icon()
			anchored = 1

/obj/item/weapon/beartrap/attack_hand(mob/user as mob)
	if(has_buckled_mobs() && can_use(user))
		var/victim = english_list(buckled_mobs)
		user.visible_message(
			"<span class='notice'>[user] begins freeing [victim] from \the [src].</span>",
			"<span class='notice'>You carefully begin to free [victim] from \the [src].</span>",
			)
		if(do_after(user, 60))
			user.visible_message("<span class='notice'>[victim] has been freed from \the [src] by [user].</span>")
			for(var/A in buckled_mobs)
				unbuckle_mob(A)
			anchored = 0
	else if(deployed && can_use(user))
		user.visible_message(
			"<span class='danger'>[user] starts to disarm \the [src].</span>",
			"<span class='notice'>You begin disarming \the [src]!</span>",
			"You hear a latch click followed by the slow creaking of a spring."
			)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)

		if(do_after(user, 60))
			user.visible_message(
				"<span class='danger'>[user] has disarmed \the [src].</span>",
				"<span class='notice'>You have disarmed \the [src]!</span>"
				)
			deployed = 0
			anchored = 0
			update_icon()
	else
		..()

/obj/item/weapon/beartrap/proc/attack_mob(mob/living/L)

	var/target_zone
	if(L.lying)
		target_zone = ran_zone()
	else
		target_zone = pick("l_foot", "r_foot", "l_leg", "r_leg")

	//armour
	var/blocked = L.run_armor_check(target_zone, "melee")
	var/soaked = L.get_armor_soak(target_zone, "melee")

	if(blocked >= 100)
		return

	if(soaked >= 30)
		return

	if(!L.apply_damage(30, BRUTE, target_zone, blocked, soaked, used_weapon=src))
		return 0

	//trap the victim in place
	set_dir(L.dir)
	can_buckle = 1
	buckle_mob(L)
	to_chat(L, "<span class='danger'>The steel jaws of \the [src] bite into you, trapping you in place!</span>")
	deployed = 0
	can_buckle = initial(can_buckle)

/obj/item/weapon/beartrap/Crossed(AM as mob|obj)
	if(deployed && isliving(AM))
		var/mob/living/L = AM
		if(L.m_intent == M_RUN)
			L.visible_message(
				"<span class='danger'>[L] steps on \the [src].</span>",
				"<span class='danger'>You step on \the [src]!</span>",
				"<b>You hear a loud metallic snap!</b>"
				)
			attack_mob(L)
			if(!has_buckled_mobs())
				anchored = 0
			deployed = 0
			update_icon()
	..()

/obj/item/weapon/beartrap/update_icon()
	..()

	if(!deployed)
		icon_state = "beartrap0"
	else
		icon_state = "beartrap1"
