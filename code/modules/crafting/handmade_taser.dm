/decl/crafting_recipe/taser_unfinished
	item1 = /obj/item/weapon/manhattan/craft/weapon_part/energy_main
	item2 = /obj/item/weapon/manhattan/craft/weapon_part/taser_handle
	result = /obj/item/weapon/manhattan/craft/weapon_part/taser_unfinished
	strict_order = FALSE
	workbenches = list(/obj/structure/manhattan/workbench)

/decl/crafting_recipe/taser_handle/get_required_time(atom/item1, atom/item2)
	return 15 SECONDS

/decl/crafting_recipe/taser_handle/new_result(loc, atom/item1, atom/item2)
	var/obj/item/weapon/manhattan/craft/weapon_part/taser_unfinished/R = ..()
	return R

/decl/crafting_recipe/handmade_taser_complete
	item1 = /obj/item/weapon/manhattan/craft/weapon_part/taser_unfinished
	item2 = /obj/item/weapon/cell
	result = /obj/item/weapon/gun/energy/taser/handmade
	strict_order = FALSE
	workbenches = list(/obj/structure/manhattan/workbench)

/decl/crafting_recipe/handmade_taser_complete/get_required_time(atom/item1, atom/item2)
	return 15 SECONDS

/decl/crafting_recipe/handmade_taser_complete/new_result(loc, atom/item1, atom/item2)
	var/obj/item/weapon/gun/energy/taser/handmade/R = ..()
	return R
