/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask
	name = "fitness shaker"
	base_name = "shaker"
	desc = "Big enough to contain enough protein to get perfectly swole. Don't mind the bits."
	icon_state = "fitness-cup_black"
	base_icon = "fitness-cup"
	volume = 800
	matter = list("plastic" = 2000)
	filling_states = list(10,20,30,40,50,60,70,80,90,100)
	possible_transfer_amounts = list(50, 100, 150, 250)
	rim_pos = null // no fruit slices
	var/lid_color = "black"
	smash_when_thrown = FALSE

/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask/New()
	..()
	lid_color = pick("black", "red", "blue")
	update_icon()

/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask/update_icon()
	..()
	icon_state = "[base_icon]_[lid_color]"

/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake
	name = "protein shake"

/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake/New()
	..()
	reagents.add_reagent("nutriment", 300)
	reagents.add_reagent("iron", 100)
	reagents.add_reagent("protein", 350)
	reagents.add_reagent("water", 250)
