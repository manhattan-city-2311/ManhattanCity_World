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
	spawn(3)	//sorry. i don't think there's a better way to do this.
	update_layer()

/obj/structure/bed/chair/skameika/right
	icon_state = "bench_wood_right"
	base_icon = "bench_wood_right"

/obj/structure/bed/chair/skameika/left
	icon_state = "bench_wood_left"
	base_icon = "bench_wood_left"

/obj/structure/bed/chair/skameika_steel
	name = "steel bench"
	icon = 'icons/obj/manhattan/furniture.dmi'
	icon_state = "bench_center"
	anchored = 1
	plane = UNDER_MOB_PLANE
	color = COLOR_GRAY
	base_icon = "bench_center"
	applies_material_colour = 1

/obj/structure/bed/chair/skameika_steel/New(var/newloc,var/newmaterial)
	..(newloc,"steel","steel")
	spawn(3)	//sorry. i don't think there's a better way to do this.
	update_layer()

/obj/structure/bed/chair/skameika_steel/right
	icon_state = "bench_right"
	base_icon = "bench_right"

/obj/structure/bed/chair/skameika_steel/left
	icon_state = "bench_left"
	base_icon = "bench_left"

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
	icon_state = "posterbig[rand(1,15)]"
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

/obj/structure/sign/manhattan/hotel_number
	name = "number"
	desc = "Room number"
	icon = 'icons/obj/manhattan/mnhtn_paintings.dmi'
	icon_state = "door1"

/obj/structure/sign/manhattan/hotel_number/second
	name = "number"
	desc = "Room number"
	icon = 'icons/obj/manhattan/mnhtn_paintings.dmi'
	icon_state = "door2"

/obj/structure/sign/manhattan/hotel_number/third
	name = "number"
	desc = "Room number"
	icon = 'icons/obj/manhattan/mnhtn_paintings.dmi'
	icon_state = "door3"

/obj/structure/sign/manhattan/hotel_number/four
	name = "number"
	desc = "Room number"
	icon = 'icons/obj/manhattan/mnhtn_paintings.dmi'
	icon_state = "door4"

/obj/structure/sign/manhattan/hotel_number/five
	name = "number"
	desc = "Room number"
	icon = 'icons/obj/manhattan/mnhtn_paintings.dmi'
	icon_state = "door5"

/obj/structure/sign/manhattan/hotel_number/six
	name = "number"
	desc = "Room number"
	icon = 'icons/obj/manhattan/mnhtn_paintings.dmi'
	icon_state = "door6"

/obj/structure/sign/manhattan/hotel_number/seven
	name = "number"
	desc = "Room number"
	icon = 'icons/obj/manhattan/mnhtn_paintings.dmi'
	icon_state = "door7"

/obj/structure/sign/manhattan/hotel_number/eight
	name = "number"
	desc = "Room number"
	icon = 'icons/obj/manhattan/mnhtn_paintings.dmi'
	icon_state = "door8"

/obj/structure/sign/manhattan/hotel_number/nine
	name = "number"
	desc = "Room number"
	icon = 'icons/obj/manhattan/mnhtn_paintings.dmi'
	icon_state = "door9"

/obj/structure/manhattan/rails
	name = "rails"
	icon = 'icons/obj/manhattan/rails.dmi'
	desc = "A rails for some kind of train."
	icon_state = "rail"

/obj/structure/manhattan/rails/tie
	name = "rails"
	icon = 'icons/obj/manhattan/rails.dmi'
	desc = "A rails for some kind of train."
	icon_state = "tie"

/obj/structure/manhattan/statue
	name = "statue"
	icon = 'icons/obj/manhattan/64x64.dmi'
	desc = "A big stone statue."
	icon_state = "statue"
	density = 1
	anchored = TRUE
	bound_height = 64
	bound_width = 64

/obj/structure/manhattan/workbench
	name = "workbench"
	icon = 'icons/obj/manhattan/workbenches.dmi'
	desc = "A big working bench."
	icon_state = "tinkerbench"
	density = 1
	anchored = TRUE
	bound_width = 64

/obj/structure/manhattan/writers
	name = "typewriter"
	desc = "Old typewriter."
	icon = 'icons/obj/manhattan/structures.dmi'
	density = 1
	anchored = TRUE
	icon_state = "writers"
	var/amount = 30
	var/list/papers = new/list()
	var/paper_type = /obj/item/weapon/paper
	var/paper_type_carbon = /obj/item/weapon/paper/carbon
	var/has_carbon_paper = 1

	unique_save_vars = list("amount")

/obj/structure/manhattan/writers/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if (H.hand)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return

	if (user.a_intent == I_GRAB)
		return ..()

	var/response = ""
	if(!papers.len > 0)
		if(has_carbon_paper)
			response = alert(user, "Do you take regular paper, or Carbon copy paper?", "Paper type request", "Regular", "Carbon-Copy", "Cancel")
		else
			response = "Regular"
		if (response != "Regular" && response != "Carbon-Copy")
			add_fingerprint(user)
			return
	if(amount >= 1)
		amount--
		if(amount==0)
			update_icon()

		var/obj/item/weapon/paper/P
		if(papers.len > 0)	//If there's any custom paper on the stack, use that instead of creating a new paper.
			P = papers[papers.len]
			papers.Remove(P)
		else
			if(response == "Regular")
				P = new paper_type
				if(Holiday == "April Fool's Day")
					if(prob(30))
						P.info = "<font face=\"[P.crayonfont]\" color=\"red\"><b>HONK HONK HONK HONK HONK HONK HONK<br>HOOOOOOOOOOOOOOOOOOOOOONK<br>APRIL FOOLS</b></font>"
						P.rigged = 1
						P.updateinfolinks()
			else if (response == "Carbon-Copy")
				P = new paper_type_carbon

		P.loc = user.loc
		user.put_in_hands(P)
		to_chat(user, "<span class='notice'>You take [P] out of the [src].</span>")
	else
		to_chat(user, "<span class='notice'>[src] is empty!</span>")

	add_fingerprint(user)


/obj/structure/manhattan/writers/attackby(obj/item/weapon/paper/i as obj, mob/user as mob)
	if(!istype(i))
		return

	user.drop_item()
	i.loc = src
	to_chat(user, "<span class='notice'>You put [i] in [src].</span>")
	papers.Add(i)
	update_icon()
	amount++

/obj/structure/bed/chair/sofa/divan/left
	name = "sofa"
	icon = 'icons/obj/manhattan/furniture.dmi'
	icon_state = "sofa_left"

/obj/structure/bed/chair/sofa/divan/right
	name = "sofa"
	icon = 'icons/obj/manhattan/furniture.dmi'
	icon_state = "sofa_right"

/obj/structure/sink/modern
	density = 0
	icon = 'icons/obj/manhattan/furniture.dmi'
	icon_state = "sink_modern"

/obj/structure/sink/modern/update_icon()
	icon_state = "sink_modern[busy ? "_busy" : ""]"

/obj/structure/manhole
	name = "manhole"
	anchored = 1
	icon = 'icons/obj/manhattan/ladders.dmi'
	icon_state = "manhole_closed"

/obj/effect/invisiblebarrier
	name = "barrier"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	invisibility = 101 		//nope, can't see this
	anchored = 1
	density = 1
	opacity = 0
