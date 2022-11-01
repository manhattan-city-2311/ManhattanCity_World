/decl/crafting_recipe/bat_upgr1
	item1 = /obj/item/weapon/material/twohanded/baseballbat
	item2 = /obj/item/weapon/manhattan/craft/stuff/barber
	result = /obj/item/weapon/material/twohanded/baseballbat/upgraded
	strict_order = TRUE

/decl/crafting_recipe/bat_upgr1/get_required_time(atom/item1, atom/item2)
	return 20 SECONDS

/decl/crafting_recipe/bat_upgr1/new_result(loc, atom/item1, atom/item2)
	var/obj/item/weapon/material/twohanded/baseballbat/upgraded/R = ..()
	return R