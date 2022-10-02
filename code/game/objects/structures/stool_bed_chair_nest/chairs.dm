/obj/structure/bed/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "chair_preview"
	color = "#666666"
	base_icon = "chair"
	plane = -25
	buckle_dir = 0
	buckle_lying = 0 //force people to sit up in chairs when buckled
	var/propelled = 0 // Check for fire-extinguisher-driven chairs
	applies_material_colour = 1 // applies material color if set to 1



/obj/structure/bed/chair/New()
	..() //Todo make metal/stone chairs display as thrones
	spawn(3)	//sorry. i don't think there's a better way to do this.
		update_layer()

/obj/structure/bed/chair/general
	applies_material_colour = 0
	color = COLOR_WHITE

/* До лучших времён   - Danilcus
/obj/structure/bed/chair/proc/update_mob()
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			var/mob/living/L = A
			L.set_dir(dir)
			if(dir == 4)
				L.pixel_x = 5
				L.pixel_y = 1
			if(dir == 8)
				L.pixel_x = -5
				L.pixel_y = 1
			if(dir == 1)
				L.pixel_y = 5
*/

/obj/structure/bed/chair/proc/update_layer()
	if(src.dir == NORTH)
		src.layer = FLY_LAYER
		src.plane = -24
	else
		src.layer = OBJ_LAYER
		src.plane = -35

/obj/structure/bed/chair/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(!padding_material && istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
		if(!SK.status)
			to_chat(user, "<span class='notice'>\The [SK] is not ready to be attached!</span>")
			return
		user.drop_item()
		var/obj/structure/bed/chair/e_chair/E = new (src.loc, material.name)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.set_dir(dir)
		E.part = SK
		SK.loc = E
		SK.master = E
		qdel(src)

/obj/structure/bed/chair/attack_tk(mob/user as mob)
	if(has_buckled_mobs())
		..()
	else
		rotate()
	return

/obj/structure/bed/chair/post_buckle_mob()
	. = ..()
	update_icon()

/obj/structure/bed/chair/unbuckle_mob()
	var/mob/living/M = ..()
	if(M)
		M.pixel_x = 0
		M.pixel_y = 0
	return M


/obj/structure/bed/chair/set_dir()
	..()
	update_layer()
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			var/mob/living/L = A
			L.set_dir(dir)

/obj/structure/bed/chair/verb/rotate()
	set name = "Rotate Chair"
	set category = "Object"
	set src in oview(1)

	if(config.ghost_interaction)
		src.set_dir(turn(src.dir, 90))
		return
	else
		if(istype(usr,/mob/living/simple_mob/animal/passive/mouse))
			return
		if(istype(src,/obj/structure/bed/chair/skameika))
			return
		if(istype(src,/obj/structure/bed/chair/skameika_steel))
			return
		if(istype(src,/obj/structure/bed/chair/couch_metal))
			return
		if(!usr || !isturf(usr.loc))
			return
		if(usr.stat || usr.restrained())
			return

		src.set_dir(turn(src.dir, 90))
		return

/obj/structure/bed/chair/shuttle
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "shuttle_chair"
	color = null
	base_icon = "shuttle_chair"
	applies_material_colour = 0

// Leaving this in for the sake of compilation.
/obj/structure/bed/chair/comfy
	desc = "It's a chair. It looks comfy."
	icon_state = "comfychair"
	applies_material_colour = 1
	base_icon = "comfychair"
	armrest_icon = TRUE

/obj/structure/bed/chair/general_alt1
	icon = 'icons/obj/manhattan/chairs.dmi'
	icon_state = "plastic_chair"
	base_icon = "plastic_chair"
	applies_material_colour = 0
	color = null

/obj/structure/bed/chair/general_alt2
	icon = 'icons/obj/manhattan/chairs.dmi'
	icon_state = "metal_chair_folding"
	base_icon = "metal_chair_folding"
	applies_material_colour = 0
	color = null

/obj/structure/bed/chair/bath
	name = "Bath"
	icon = 'icons/obj/manhattan/bath_large.dmi'
	icon_state = "bath"
	base_icon = "bath"
	buckle_dir = SOUTH
	buckle_lying = 0
	applies_material_colour = 0
	color = null
	armrest_icon = TRUE
	buckle_pixel_shift = list(0, -10, -MOB_PIXEL_Z)

/obj/structure/bed/chair/bath/attack_hand(mob/user as mob)
	if(icon_state == "bath")
		icon_state = "bath_active"
	else
		icon_state = "bath"

/obj/structure/bed/chair/comfy/brown/New(var/newloc,var/newmaterial)
	..(newloc,"steel","leather")

/obj/structure/bed/chair/comfy/red/New(var/newloc,var/newmaterial)
	..(newloc,"steel","carpet")

/obj/structure/bed/chair/comfy/teal/New(var/newloc,var/newmaterial)
	..(newloc,"steel","teal")

/obj/structure/bed/chair/comfy/black/New(var/newloc,var/newmaterial)
	..(newloc,"steel","black")

/obj/structure/bed/chair/comfy/green/New(var/newloc,var/newmaterial)
	..(newloc,"steel","green")

/obj/structure/bed/chair/comfy/purp/New(var/newloc,var/newmaterial)
	..(newloc,"steel","purple")

/obj/structure/bed/chair/comfy/blue/New(var/newloc,var/newmaterial)
	..(newloc,"steel","blue")

/obj/structure/bed/chair/comfy/beige/New(var/newloc,var/newmaterial)
	..(newloc,"steel","beige")

/obj/structure/bed/chair/comfy/lime/New(var/newloc,var/newmaterial)
	..(newloc,"steel","lime")

/obj/structure/bed/chair/comfy/yellow/New(var/newloc,var/newmaterial)
	..(newloc,"steel","yellow")

/obj/structure/bed/chair/office
	anchored = 0
	buckle_movable = 1

/obj/structure/bed/chair/office/update_icon()
	return

/obj/structure/bed/chair/office/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || istype(W, /obj/item/weapon/wirecutters))
		return
	..()

/obj/structure/bed/chair/office/Move()
	..()
	playsound(src, 'sound/effects/roll.ogg', 100, 1)
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			var/mob/living/occupant = A
			occupant.buckled = null
			occupant.Move(src.loc)
			occupant.buckled = src
			if (occupant && (src.loc != occupant.loc))
				if (propelled)
					for (var/mob/O in src.loc)
						if (O != occupant)
							Bump(O)
				else
					unbuckle_mob()

/obj/structure/bed/chair/office/Bump(atom/A)
	..()
	if(!has_buckled_mobs())	return

	if(propelled)
		for(var/a in buckled_mobs)
			var/mob/living/occupant = unbuckle_mob(a)

			var/def_zone = ran_zone()
			var/blocked = occupant.run_armor_check(def_zone, "melee")
			var/soaked = occupant.get_armor_soak(def_zone, "melee")
			occupant.throw_at(A, 3, propelled)
			occupant.apply_effect(6, STUN, blocked)
			occupant.apply_effect(6, WEAKEN, blocked)
			occupant.apply_effect(6, STUTTER, blocked)
			occupant.apply_damage(10, BRUTE, def_zone, blocked, soaked)
			playsound(src.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
			if(istype(A, /mob/living))
				var/mob/living/victim = A
				def_zone = ran_zone()
				blocked = victim.run_armor_check(def_zone, "melee")
				soaked = victim.get_armor_soak(def_zone, "melee")
				victim.apply_effect(6, STUN, blocked)
				victim.apply_effect(6, WEAKEN, blocked)
				victim.apply_effect(6, STUTTER, blocked)
				victim.apply_damage(10, BRUTE, def_zone, blocked, soaked)
			occupant.visible_message("<span class='danger'>[occupant] crashed into \the [A]!</span>")

/obj/structure/bed/chair/office/light
	icon_state = "officechair_white"

/obj/structure/bed/chair/office/dark
	icon_state = "officechair_dark"

/obj/structure/bed/chair/office/blue_modern
	icon = 'icons/obj/manhattan/chairs.dmi'
	icon_state = "office_chair_blue"
	applies_material_colour = 0
	color = null

/obj/structure/bed/chair/office/green_modern
	icon = 'icons/obj/manhattan/chairs.dmi'
	icon_state = "office_chair_green"
	applies_material_colour = 0
	color = null

// Chair types
/obj/structure/bed/chair/wood
	name = "classic chair"
	desc = "Old is never too old to not be in fashion."
	base_icon = "wooden_chair"
	icon_state = "wooden_chair"
	color = WOOD_COLOR_GENERIC
	var/chair_material = MATERIAL_WOOD

/obj/structure/bed/chair/wood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || istype(W, /obj/item/weapon/wirecutters))
		return
	..()

/obj/structure/bed/chair/wood/New(var/newloc)
	..(newloc, chair_material)

/obj/structure/bed/chair/wood/mahogany
	color = WOOD_COLOR_RICH
	chair_material = MATERIAL_MAHOGANY

/obj/structure/bed/chair/wood/maple
	color = WOOD_COLOR_PALE
	chair_material = MATERIAL_MAPLE

/obj/structure/bed/chair/wood/ebony
	color = WOOD_COLOR_BLACK
	chair_material = MATERIAL_EBONY

/obj/structure/bed/chair/wood/walnut
	color = WOOD_COLOR_CHOCOLATE
	chair_material = MATERIAL_WALNUT

/obj/structure/bed/chair/wood/wings
	name = "winged chair"
	base_icon = "wooden_chair_wings"
	icon_state = "wooden_chair_wings"

/obj/structure/bed/chair/wood/wings/mahogany
	color = WOOD_COLOR_RICH
	chair_material = MATERIAL_MAHOGANY

/obj/structure/bed/chair/wood/wings/maple
	color = WOOD_COLOR_PALE
	chair_material = MATERIAL_MAPLE

/obj/structure/bed/chair/wood/wings/ebony
	color = WOOD_COLOR_BLACK
	chair_material = MATERIAL_EBONY

/obj/structure/bed/chair/wood/wings/walnut
	color = WOOD_COLOR_CHOCOLATE
	chair_material = MATERIAL_WALNUT


/obj/structure/bed/chair/sofa
	name = "sofa"
	icon = 'icons/obj/sofas.dmi'
	icon_state = "sofamiddle"
	anchored = 1
	buckle_lying = 0
	buckle_dir = 0
	plane = UNDER_MOB_PLANE
	applies_material_colour = 1
	var/sofa_material = "carpet"

/obj/structure/bed/chair/sofa/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/New()
	..()
	update_icon()

/obj/structure/bed/chair/sofa/update_icon()
	if(applies_material_colour && sofa_material)
		material = get_material_by_name(sofa_material)
		color = material.icon_colour

		if(sofa_material == "carpet")
			name = "red [initial(name)]"
		else
			name = "[sofa_material] [initial(name)]"

//color variations

/obj/structure/bed/chair/sofa
	sofa_material = "carpet"

/obj/structure/bed/chair/sofa/brown
	sofa_material = "leather"

/obj/structure/bed/chair/sofa/teal
	sofa_material = "teal"

/obj/structure/bed/chair/sofa/black
	sofa_material = "black"

/obj/structure/bed/chair/sofa/green
	sofa_material = "green"

/obj/structure/bed/chair/sofa/purp
	sofa_material = "purple"

/obj/structure/bed/chair/sofa/blue
	sofa_material = "blue"

/obj/structure/bed/chair/sofa/beige
	sofa_material = "beige"

/obj/structure/bed/chair/sofa/lime
	sofa_material = "lime"

/obj/structure/bed/chair/sofa/yellow
	sofa_material = "yellow"

//sofa directions

/obj/structure/bed/chair/sofa/corner/New()
	..()
	buckle_dir = SOUTH
	plane = UNDER_MOB_PLANE

/obj/structure/bed/chair/sofa/left
	icon_state = "sofaend_left"


/obj/structure/bed/chair/sofa/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/brown/left
	icon_state = "sofaend_left"


/obj/structure/bed/chair/sofa/brown/right
	icon_state = "sofaend_right"


/obj/structure/bed/chair/sofa/brown/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/teal/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/teal/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/teal/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/black/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/black/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/black/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/green/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/green/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/green/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/purp/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/purp/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/purp/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/blue/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/blue/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/blue/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/beige/left
	icon_state = "sofaend_left"


/obj/structure/bed/chair/sofa/beige/right
	icon_state = "sofaend_right"


/obj/structure/bed/chair/sofa/beige/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/lime/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/lime/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/lime/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/yellow/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/yellow/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/yellow/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/frilly
	desc = "It's a frilly sofa chair. It looks fancy!"
	icon_state = "frillychair"
	applies_material_colour = 1
	base_icon = "frillychair"
	armrest_icon = TRUE

/obj/structure/bed/chair/frilly/brown/New(var/newloc,var/newmaterial)
	..(newloc,"steel","leather")

/obj/structure/bed/chair/frilly/red/New(var/newloc,var/newmaterial)
	..(newloc,"steel","carpet")

/obj/structure/bed/chair/frilly/teal/New(var/newloc,var/newmaterial)
	..(newloc,"steel","teal")

/obj/structure/bed/chair/frilly/black/New(var/newloc,var/newmaterial)
	..(newloc,"steel","black")

/obj/structure/bed/chair/frilly/green/New(var/newloc,var/newmaterial)
	..(newloc,"steel","green")

/obj/structure/bed/chair/frilly/purp/New(var/newloc,var/newmaterial)
	..(newloc,"steel","purple")

/obj/structure/bed/chair/frilly/blue/New(var/newloc,var/newmaterial)
	..(newloc,"steel","blue")

/obj/structure/bed/chair/frilly/beige/New(var/newloc,var/newmaterial)
	..(newloc,"steel","beige")

/obj/structure/bed/chair/frilly/lime/New(var/newloc,var/newmaterial)
	..(newloc,"steel","lime")

/obj/structure/bed/chair/frilly/yellow/New(var/newloc,var/newmaterial)
	..(newloc,"steel","yellow")


/obj/structure/bed/chair/barber
	applies_material_colour = 0
	icon_state = "barberchair"
	base_icon = "barberchair"
	color = COLOR_WHITE

/obj/structure/bed/chair/bosschair
	name = "big chair"
	desc = "A regal looking chair. Looks like big-bad territory."
	icon_state = "capchair"
	applies_material_colour = 1
	base_icon = "capchair"
	armrest_icon = TRUE

/obj/structure/bed/chair/bosschair/red/New(var/newloc,var/newmaterial)
	..(newloc,"steel","carpet")

/obj/structure/bed/chair/bosschair/teal/New(var/newloc,var/newmaterial)
	..(newloc,"steel","teal")

/obj/structure/bed/chair/bosschair/black/New(var/newloc,var/newmaterial)
	..(newloc,"steel","black")

/obj/structure/bed/chair/bosschair/green/New(var/newloc,var/newmaterial)
	..(newloc,"steel","green")

/obj/structure/bed/chair/bosschair/purp/New(var/newloc,var/newmaterial)
	..(newloc,"steel","purple")

/obj/structure/bed/chair/bosschair/blue/New(var/newloc,var/newmaterial)
	..(newloc,"steel","blue")

/obj/structure/bed/chair/bosschair/beige/New(var/newloc,var/newmaterial)
	..(newloc,"steel","beige")

/obj/structure/bed/chair/bosschair/lime/New(var/newloc,var/newmaterial)
	..(newloc,"steel","lime")

/obj/structure/bed/chair/bosschair/yellow/New(var/newloc,var/newmaterial)
	..(newloc,"steel","yellow")

/obj/structure/bed/chair/bosschair/brown/New(var/newloc,var/newmaterial)
	..(newloc,"steel","leather")
