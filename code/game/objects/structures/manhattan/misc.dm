/obj/structure/bed/chair/skameika
	name = "old ratty bench"
	icon = 'icons/obj/manhattan/furniture.dmi'
	icon_state = "bench_wood_center"
	anchored = 1
	plane = UNDER_MOB_PLANE
	color = WOOD_COLOR_GENERIC
	base_icon = "bench_wood_center"
	applies_material_colour = 1

/obj/structure/bed/chair/skameika/New(var/newloc,var/newmaterial)
	..(newloc,"wood")

/obj/structure/bed/chair/skameika/New()
	..()
	if(dir == 1)
		buckle_dir = NORTH
		plane = -35
	if(dir == 2)
		buckle_dir = SOUTH
		plane = -35
	if(dir == 4)
		buckle_dir = EAST
		plane = -35
	if(dir == 8)
		buckle_dir = WEST
		plane = -35

/obj/structure/bed/chair/skameika/right
	icon_state = "bench_wood_right"
	base_icon = "bench_wood_right"

/obj/structure/bed/chair/skameika/left
	icon_state = "bench_wood_left"
	base_icon = "bench_wood_left"

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

/obj/structure/bed/chair/skameika_steel
	name = "bench"
	icon = 'icons/obj/manhattan/furniture.dmi'
	icon_state = "bench_center"
	anchored = 1
	plane = UNDER_MOB_PLANE
	color = COLOR_GRAY
	base_icon = "bench_center"
	applies_material_colour = 1

/obj/structure/bed/chair/skameika_steel/New()
	..()
	if(dir == 1)
		buckle_dir = NORTH
		plane = -35
	if(dir == 2)
		buckle_dir = SOUTH
		plane = -35
	if(dir == 4)
		buckle_dir = EAST
		plane = -35
	if(dir == 8)
		buckle_dir = WEST
		plane = -35

/obj/structure/bed/chair/skameika_steel/New(var/newloc,var/newmaterial)
	..(newloc,"steel","steel")

/obj/structure/bed/chair/skameika_steel/right
	icon_state = "bench_right"
	base_icon = "bench_right"

/obj/structure/bed/chair/skameika_steel/left
	icon_state = "bench_left"
	base_icon = "bench_left"


/obj/structure/bed/chair/skameika_steel/post_buckle_mob(mob/living/M)
	update_mob()
	return ..()

/obj/structure/bed/chair/skameika_steel/proc/update_mob()
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

/obj/structure/bed/chair/skameika_steel/unbuckle_mob()
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

/obj/structure/sign/neon/big/transit
	name = "transit station sign"
	desc = "A sign for the city transit station."
	icon_state = "transit"
	light_color = COLOR_YELLOW

/obj/structure/sign/neon/big/train
	name = "transit station sign"
	desc = "A sign for the city transit station."
	icon_state = "train"
	light_color = "#F070FF"

/obj/structure/sign/neon/big/direction1
	name = "direction sign"
	desc = "A sign for the navigation inside of the city."
	icon_state = "directions"
	light_color = "#63C4D6"

/obj/structure/sign/neon/big/direction2
	name = "direction sign"
	desc = "A sign for the navigation inside of the city."
	icon_state = "directions-large"
	light_color = "#63C4D6"

/obj/structure/sign/neon/big/rent
	name = "rent sign"
	desc = "A sign that saying this place are for rent."
	icon_state = "cryo"
	light_color = "#63C4D6"

/obj/structure/sign/neon/big/menu
	name = "neon menu screen"
	desc = "A sign with some options to choose."
	icon_state = "options"
	light_color = "#63C4D6"

/obj/structure/sign/neon/big/bar
	name = "neon bar sign"
	desc = "A sign for the city local bar."
	icon_state = "bar"
	light_color = "#F070FF"

/obj/structure/sign/neon/big/casino
	name = "neon casino sign"
	desc = "A sign for the city local casino."
	icon_state = "casino"
	light_color = COLOR_YELLOW