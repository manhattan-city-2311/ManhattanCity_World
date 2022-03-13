/obj/structure/bed/chair/skameika
	name = "old ratty bench"
	icon = 'icons/obj/manhattan/sofas.dmi'
	icon_state = "pews"
	anchored = 1
	plane = UNDER_MOB_PLANE
	color = null
	base_icon = "pews"
	applies_material_colour = 0

/obj/structure/bed/chair/skameika/New()
	..()
	if(dir == 1)
		buckle_dir = WEST
		plane = -35
	if(dir == 2)
		buckle_dir = WEST
		plane = -35
	if(dir == 4)
		buckle_dir = WEST
		plane = -35
	if(dir == 8)
		buckle_dir = WEST
		plane = -35

/obj/structure/bed/chair/skameika/alt
	icon_state = "pews_f"
	base_icon = "pews_f"

/obj/structure/bed/chair/skameika/alt/New()
	..()
	if(dir == 1)
		buckle_dir = EAST
		plane = -35
	if(dir == 2)
		buckle_dir = EAST
		plane = -35
	if(dir == 4)
		buckle_dir = EAST
		plane = -35
	if(dir == 8)
		buckle_dir = EAST
		plane = -35

/obj/structure/bed/chair/skameika/post_buckle_mob(mob/living/M)
	update_mob()
	return ..()

/obj/structure/bed/chair/skameika/proc/update_mob()
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			var/mob/living/L = A
			L.set_dir(dir)
			if(WEST && dir == 1)
				L.pixel_x = -3
				L.pixel_y = -5
			if(EAST && dir == 1)
				L.pixel_x = 3
				L.pixel_y = -5

/obj/structure/bed/chair/skameika/unbuckle_mob()
	var/mob/living/M = ..()
	if(M)
		M.pixel_x = 0
		M.pixel_y = 0
	return M

/obj/structure/bed/chair/couch_metal
	name = "metal bench"
	icon = 'icons/obj/manhattan/sofas.dmi'
	icon_state = "couch_hori2"
	anchored = 1
	color = null
	base_icon = "couch_hori2"
	applies_material_colour = 0

/obj/structure/bed/chair/couch_metal/right
	name = "metal bench"
	icon = 'icons/obj/manhattan/sofas.dmi'
	icon_state = "couch_hori3"
	base_icon = "couch_hori3"

/obj/structure/bed/chair/couch_metal/left
	name = "metal bench"
	icon = 'icons/obj/manhattan/sofas.dmi'
	icon_state = "couch_hori1"
	base_icon = "couch_hori1"

/obj/structure/sign/manhattan/posters
	name = "city poster"
	icon = 'icons/obj/manhattan/posters.dmi'
	desc = "A sign with some picture."
	icon_state = "poster1"

/obj/structure/sign/manhattan/posters/random/standart
	icon_state = "poster5"

/obj/structure/sign/manhattan/posters/random/standart/New()
	. = ..()
	icon_state = "poster[rand(1,21)]"
	return .

/obj/structure/sign/manhattan/posters/random/big
	icon_state = "posterbig1"

/obj/structure/sign/manhattan/posters/random/big/New()
	. = ..()
	icon_state = "posterbig[rand(1,12)]"
	return .

/obj/structure/sign/manhattan/posters/random/small
	icon_state = "postersmall1"

/obj/structure/sign/manhattan/posters/random/small/New()
	. = ..()
	icon_state = "postersmall[rand(1,5)]"
	return .

/obj/structure/sign/manhattan/posters/random/science
	icon_state = "poster_sci1"

/obj/structure/sign/manhattan/posters/random/science/New()
	. = ..()
	icon_state = "poster_sci[rand(1,5)]"
	return .

/obj/structure/sign/manhattan/rewards
	icon = 'icons/obj/manhattan/wallsigns.dmi'
	icon_state = "frame"
	desc = "Frame with some kind of reward"

/obj/structure/sign/manhattan/rewards/text
	name = "honorary certificate"
	icon_state = "rddiploma"

/obj/structure/sign/manhattan/rewards/medal
	name = "gold medal"
	icon_state = "medal"