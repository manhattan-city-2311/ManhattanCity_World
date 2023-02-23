/decl/crafting_recipe/energy_main_part
	item1 = /obj/item/stack/material/steel
	item2 = /obj/item/stack/cable_coil
	result = /obj/item/weapon/manhattan/craft/weapon_part/energy_main
	strict_order = TRUE
	workbenches = list(/obj/structure/manhattan/workbench)

/decl/crafting_recipe/energy_main_part/get_required_time(atom/item1, atom/item2)
	return 10 SECONDS

/decl/crafting_recipe/energy_main_part/new_result(loc, atom/item1, atom/item2)
	var/obj/item/weapon/manhattan/craft/weapon_part/energy_main/R = ..()
	return R

/decl/crafting_recipe/energy_main_part/can_be_crafted(mob/M, obj/item/stack/material/steel/item1, atom/item2)
	return ..() && (item1.amount < 5)
