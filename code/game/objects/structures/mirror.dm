//wip wip wup
/obj/structure/mirror
	name = "mirror"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = 0
	anchored = 1
	var/shattered = 0
	var/list/ui_users = list()
	var/glass = 1

/obj/structure/mirror/New(var/loc, var/dir, var/building = 0, mob/user as mob)
	if(building)
		glass = 0
		icon_state = "mirror_frame"
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -28 : 28)
		pixel_y = (dir & 3)? (dir == 1 ? -30 : 30) : 0


/obj/structure/mirror/proc/shatter()
	if(!glass) return
	if(shattered)	return
	shattered = 1
	icon_state = "mirror_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"


/obj/structure/mirror/bullet_act(var/obj/item/projectile/Proj)

	if(prob(Proj.get_structure_damage() * 2))
		if(!shattered)
			shatter()
		else if(glass)
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
	..()

/obj/structure/mirror/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/wrench))
		if(!glass)
			if(trigger_lot_security_system(null, /datum/lot_security_option/vandalism, "Attempted to unwrench \the [src] with [I]."))
				return
			playsound(src.loc, I.usesound, 50, 1)
			if(do_after(user, 20 * I.toolspeed))
				to_chat(user, "<span class='notice'>You unfasten the frame.</span>")
				new /obj/item/frame/mirror( src.loc )
				qdel(src)
		return

	if(shattered && glass)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return

	if(prob(I.force * 2))
		if(trigger_lot_security_system(null, /datum/lot_security_option/vandalism, "Attempted to smash \the [src]'s glass with [I]."))
			return
		visible_message("<span class='warning'>[user] smashes [src] with [I]!</span>")
		if(glass)
			shatter()
	else
		visible_message("<span class='warning'>[user] hits [src] with [I]!</span>")
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 70, 1)

/obj/structure/mirror/attack_generic(var/mob/user, var/damage)

	user.do_attack_animation(src)
	if(shattered && glass)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return 0

	if(damage)
		user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
		if(glass)
			shatter()
	else
		user.visible_message("<span class='danger'>[user] hits [src] and bounces off!</span>")
	return 1

/obj/structure/mirror/wide
	name = "wide mirror"
	desc = "A SalonPro Nano-Mirror(TM) brand mirror! The leading technology in hair salon products, utilizing nano-machinery to style your hair just right."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror_wide"
	var/image/overlay

/obj/structure/mirror/wide/initialize()
	. = ..()
	update_icon()

/obj/structure/mirror/wide/shatter()
	if(!glass) return
	if(shattered)	return
	shattered = 1
	icon_state = "mirror_wide_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"

/obj/structure/mirror/wide/update_icon()
	overlays.Cut()
	if(!shattered)
		overlays += image(icon, "mirror_wide_overlay")

/obj/structure/mirror/wide/alt
	icon_state = "mirror_wide_alt"

/obj/structure/mirror/wide/alt/shatter()
	if(!glass) return
	if(shattered)	return
	shattered = 1
	icon_state = "mirror_wide_alt_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"

/obj/structure/mirror/wide/alt/update_icon()
	overlays.Cut()
	if(!shattered)
		overlays += image(icon, "mirror_wide_alt_overlay")

// The following mirror is ~special~.
/obj/structure/mirror/raider
	name = "cracked mirror"
	desc = "Something seems strange about this old, dirty mirror. Your reflection doesn't look like you remember it."
	icon_state = "mirror_broke"
	shattered = 1

/obj/structure/mirror/raider/attack_hand(var/mob/living/carbon/human/user)
	if(istype(get_area(src),/area/syndicate_mothership))
		if(istype(user) && user.mind && user.mind.special_role == "Raider" && user.species.name != SPECIES_VOX && is_alien_whitelisted(user, SPECIES_VOX))
			var/choice = input("Do you wish to become a true Vox of the Shoal? This is not reversible.") as null|anything in list("No","Yes")
			if(choice && choice == "Yes")
				var/mob/living/carbon/human/vox/vox = new(get_turf(src),SPECIES_VOX)
				vox.gender = user.gender
				raiders.equip(vox)
				if(user.mind)
					user.mind.transfer_to(vox)
				spawn(1)
					var/newname = sanitizeSafe(input(vox,"Enter a name, or leave blank for the default name.", "Name change","") as text, MAX_NAME_LEN)
					if(!newname || newname == "")
						var/datum/language/L = all_languages[vox.species.default_language]
						newname = L.get_random_name()
					vox.real_name = newname
					vox.name = vox.real_name
					raiders.update_access(vox)
				qdel(user)
	..()
