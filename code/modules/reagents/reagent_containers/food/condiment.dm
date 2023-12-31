
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/weapon/reagent_containers/food/condiment
	name = "Condiment Container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/food.dmi'
	icon_state = "emptycondiment"
	flags = OPENCONTAINER
	possible_transfer_amounts = list(1,5,10)
	center_of_mass = list("x"=16, "y"=6)
	volume = 50
	drop_sound = 'sound/items/drop/bottle.ogg'

/obj/item/weapon/reagent_containers/food/condiment/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	return

/obj/item/weapon/reagent_containers/food/condiment/attack_self(var/mob/user as mob)
	return

/obj/item/weapon/reagent_containers/food/condiment/attack(var/mob/M as mob, var/mob/user as mob, var/def_zone)
	if(standard_feed_mob(user, M))
		return

/obj/item/weapon/reagent_containers/food/condiment/afterattack(var/obj/target, var/mob/user, var/flag)
	if(!user.Adjacent(target))
		return
	if(standard_dispenser_refill(user, target))
		return
	if(standard_pour_into(user, target))
		return

	if(istype(target, /obj/item/weapon/reagent_containers/food/snacks)) // These are not opencontainers but we can transfer to them
		if(!reagents || !reagents.total_volume)
			to_chat(user, "<span class='notice'>There is no condiment left in \the [src].</span>")
			return

		if(!target.reagents.get_free_space())
			to_chat(user, "<span class='notice'>You can't add more condiment to \the [target].</span>")
			return

		var/trans = reagents.trans_to_obj(target, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You add [trans] units of the condiment to \the [target].</span>")
	else
		..()

/obj/item/weapon/reagent_containers/food/condiment/feed_sound(var/mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/weapon/reagent_containers/food/condiment/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You swallow some of contents of \the [src].</span>")

/obj/item/weapon/reagent_containers/food/condiment/on_reagent_change()
	if(reagents.reagent_list.len > 0)
		switch(reagents.get_master_reagent_id())
			if("ketchup")
				name = "Ketchup"
				desc = "You feel more American already."
				icon_state = "ketchup"
				center_of_mass = list("x"=16, "y"=6)
			if("capsaicin")
				name = "Hotsauce"
				desc = "You can almost TASTE the stomach ulcers now!"
				icon_state = "hotsauce"
				center_of_mass = list("x"=16, "y"=6)
			if("enzyme")
				name = "Universal Enzyme"
				desc = "Used in cooking various dishes."
				icon_state = "enzyme"
				center_of_mass = list("x"=16, "y"=6)
			if("soysauce")
				name = "Soy Sauce"
				desc = "A salty soy-based flavoring."
				icon_state = "soysauce"
				center_of_mass = list("x"=16, "y"=6)
			if("frostoil")
				name = "Coldsauce"
				desc = "Leaves the tongue numb in its passage."
				icon_state = "coldsauce"
				center_of_mass = list("x"=16, "y"=6)
			if("sodiumchloride")
				name = "Salt Shaker"
				desc = "Salt. From space oceans, presumably."
				icon_state = "saltshaker"
				center_of_mass = list("x"=16, "y"=10)
			if("blackpepper")
				name = "Pepper Mill"
				desc = "Often used to flavor food or make people sneeze."
				icon_state = "peppermillsmall"
				center_of_mass = list("x"=16, "y"=10)
			if("cornoil")
				name = "Corn Oil"
				desc = "A delicious oil used in cooking. Made from corn."
				icon_state = "oliveoil"
				center_of_mass = list("x"=16, "y"=6)
			if("sugar")
				name = "Sugar"
				desc = "Tastey space sugar!"
				center_of_mass = list("x"=16, "y"=6)
			else
				name = "Misc Condiment Bottle"
				if (reagents.reagent_list.len==1)
					desc = "Looks like it is [reagents.get_master_reagent_name()], but you are not sure."
				else
					desc = "A mixture of various condiments. [reagents.get_master_reagent_name()] is one of them."
				icon_state = "mixedcondiments"
				center_of_mass = list("x"=16, "y"=6)
	else
		icon_state = "emptycondiment"
		name = "Condiment Bottle"
		desc = "An empty condiment bottle."
		center_of_mass = list("x"=16, "y"=6)
		return

/obj/item/weapon/reagent_containers/food/condiment/enzyme
	name = "Universal Enzyme"
	desc = "Used in cooking various dishes."
	icon_state = "enzyme"

/obj/item/weapon/reagent_containers/food/condiment/enzyme/New()
	. = ..()
	reagents.add_reagent("enzyme", 50)

/obj/item/weapon/reagent_containers/food/condiment/sugar/New()
	. = ..()
	reagents.add_reagent("sugar", 50)

/obj/item/weapon/reagent_containers/food/condiment/ketchup/New()
	. = ..()
	reagents.add_reagent("ketchup", 50)

/obj/item/weapon/reagent_containers/food/condiment/hotsauce/New()
	. = ..()
	reagents.add_reagent("capsaicin", 50)

/obj/item/weapon/reagent_containers/food/condiment/cornoil/New()
	. = ..()
	reagents.add_reagent("cornoil", 50)

/obj/item/weapon/reagent_containers/food/condiment/coldsauce/New()
	. = ..()
	reagents.add_reagent("frostoil", 50)

/obj/item/weapon/reagent_containers/food/condiment/soysauce/New()
	. = ..()
	reagents.add_reagent("soysauce", 50)

/obj/item/weapon/reagent_containers/food/condiment/small
	possible_transfer_amounts = list(4,20)
	amount_per_transfer_from_this = 4
	volume = 40
	center_of_mass = list()

/obj/item/weapon/reagent_containers/food/condiment/small/on_reagent_change()
	return

/obj/item/weapon/reagent_containers/food/condiment/small/saltshaker	//Seperate from above since it's a small shaker rather then
	name = "salt shaker"											//	a large one.
	desc = "Salt. From space oceans, presumably."
	icon_state = "saltshakersmall"

/obj/item/weapon/reagent_containers/food/condiment/small/saltshaker/New()
	..()
	reagents.add_reagent("sodiumchloride", 40)

/obj/item/weapon/reagent_containers/food/condiment/small/peppermill
	name = "pepper mill"
	desc = "Often used to flavor food or make people sneeze."
	icon_state = "peppermillsmall"

/obj/item/weapon/reagent_containers/food/condiment/small/peppermill/New()
	..()
	reagents.add_reagent("blackpepper", 40)

/obj/item/weapon/reagent_containers/food/condiment/small/sugar
	name = "sugar"
	desc = "Sweetness in a bottle"
	icon_state = "sugarsmall"

/obj/item/weapon/reagent_containers/food/condiment/small/sugar/New()
	..()
	reagents.add_reagent("sugar", 40)

/obj/item/weapon/reagent_containers/food/condiment/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon = 'icons/obj/food.dmi'
	icon_state = "flour"

/obj/item/weapon/reagent_containers/food/condiment/flour/on_reagent_change()
	return

/obj/item/weapon/reagent_containers/food/condiment/flour/New()
	..()
	reagents.add_reagent("flour", 40)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

//MRE condiments and drinks.

/obj/item/weapon/reagent_containers/food/condiment/small/packet
	icon_state = "packet_small"
	w_class = ITEMSIZE_TINY
	possible_transfer_amounts = "1;5;10"
	amount_per_transfer_from_this = 2
	volume = 10

/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt
	name = "salt packet"
	desc = "Contains 5u of table salt."
	icon_state = "packet_small_white"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt/New()
	. = ..()
	reagents.add_reagent("sodiumchloride", 10)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper
	name = "pepper packet"
	desc = "Contains 10ml of black pepper."
	icon_state = "packet_small_black"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper/New()
	. = ..()
	reagents.add_reagent("blackpepper", 10)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar
	name = "sugar packet"
	desc = "Contains 10ml of refined sugar."
	icon_state = "packet_small_white"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar/New()
	. = ..()
	reagents.add_reagent("sugar", 10)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/jelly
	name = "jelly packet"
	desc = "Contains 20ml of cherry jelly. Best used for spreading on crackers."
	icon_state = "packet_medium"
	volume = 20

/obj/item/weapon/reagent_containers/food/condiment/small/packet/jelly/New()
	. = ..()
	reagents.add_reagent("cherryjelly", 10)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/honey
	name = "honey packet"
	desc = "Contains 10ml of honey."
	icon_state = "packet_medium"
	volume = 30

/obj/item/weapon/reagent_containers/food/condiment/small/packet/honey/New()
	. = ..()
	reagents.add_reagent("honey", 30)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin
	name = "hot sauce packet"
	desc = "Contains 30ml of hot sauce. Enjoy in moderation."
	icon_state = "packet_small_red"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin/New()
	. = ..()
	reagents.add_reagent("capsaicin", 30)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup
	name = "ketchup packet"
	desc = "Contains 30ml of ketchup."
	icon_state = "packet_small_red"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup/New()
	. = ..()
	reagents.add_reagent("ketchup", 30)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo
	name = "mayonnaise packet"
	desc = "Contains 30ml of mayonnaise."
	icon_state = "packet_small_white"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo/New()
	. = ..()
	reagents.add_reagent("mayo", 30)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/soy
	name = "soy sauce packet"
	desc = "Contains 30ml of soy sauce."
	icon_state = "packet_small_black"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/soy/New()
	. = ..()
	reagents.add_reagent("soysauce", 30)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/coffee
	name = "coffee powder packet"
	desc = "Contains 20ml of coffee powder. Mix with 100ml of water and heat."
	volume = 20

/obj/item/weapon/reagent_containers/food/condiment/small/packet/coffee/New()
	. = ..()
	reagents.add_reagent("coffeepowder", 20)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/decafcoffee
	name = "decaf coffee powder packet"
	desc = "Contains 20ml of decaffeinated coffee powder. Mix with 100ml of water and heat."
	volume = 20

/obj/item/weapon/reagent_containers/food/condiment/small/packet/decafcoffee/New()
	. = ..()
	reagents.add_reagent("decafcoffee", 20)


/obj/item/weapon/reagent_containers/food/condiment/small/packet/tea
	name = "tea powder packet"
	desc = "Contains 20ml of black tea powder. Mix with 100ml of water and heat."
	volume = 20

/obj/item/weapon/reagent_containers/food/condiment/small/packet/tea/New()
	. = ..()
	reagents.add_reagent("tea", 20)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/cocoa
	name = "cocoa powder packet"
	desc = "Contains 20ml of cocoa powder. Mix with 100ml of water and heat."
	volume = 20

/obj/item/weapon/reagent_containers/food/condiment/small/packet/cocoa/New()
	. = ..()
	reagents.add_reagent("coco", 20)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/grape
	name = "grape juice powder packet"
	desc = "Contains 30ml of powdered grape juice. Mix with 90ml of water."

/obj/item/weapon/reagent_containers/food/condiment/small/packet/grape/New()
	. = ..()
	reagents.add_reagent("instantgrape", 30)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/orange
	name = "orange juice powder packet"
	desc = "Contains 30ml of powdered orange juice. Mix with 90ml of water."

/obj/item/weapon/reagent_containers/food/condiment/small/packet/orange/New()
	. = ..()
	reagents.add_reagent("instantorange", 30)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/watermelon
	name = "watermelon juice powder packet"
	desc = "Contains 30ml of powdered watermelon juice. Mix with 90ml of water."

/obj/item/weapon/reagent_containers/food/condiment/small/packet/watermelon/New()
	. = ..()
	reagents.add_reagent("instantwatermelon", 30)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/apple
	name = "apple juice powder packet"
	desc = "Contains 30ml of powdered apple juice. Mix with 90ml of water."

/obj/item/weapon/reagent_containers/food/condiment/small/packet/apple/New()
	. = ..()
	reagents.add_reagent("instantapple", 30)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/protein
	name = "protein powder packet"
	desc = "Contains 30u of powdered protein. Mix with 60u of water."
	icon_state = "packet_medium"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/protein/New()
	. = ..()
	reagents.add_reagent("protein", 30)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon
	name = "crayon powder packet"
	desc = "Contains 10u of powdered crayon. Mix with 30u of water."
/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/generic/New()
	. = ..()
	reagents.add_reagent("crayon_dust", 30)
/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/red/New()
	. = ..()
	reagents.add_reagent("crayon_dust_red", 30)
/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/orange/New()
	. = ..()
	reagents.add_reagent("crayon_dust_orange", 30)
/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/yellow/New()
	. = ..()
	reagents.add_reagent("crayon_dust_yellow", 30)
/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/green/New()
	. = ..()
	reagents.add_reagent("crayon_dust_green", 30)
/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/blue/New()
	. = ..()
	reagents.add_reagent("crayon_dust_blue", 30)
/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/purple/New()
	. = ..()
	reagents.add_reagent("crayon_dust_purple", 30)
/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/grey/New()
	. = ..()
	reagents.add_reagent("crayon_dust_grey", 30)
/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/brown/New()
	. = ..()
	reagents.add_reagent("crayon_dust_brown", 30)

//End of MRE stuff.