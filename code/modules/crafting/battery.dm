/decl/crafting_recipe/battery_pt1
	item1 = /obj/item/weapon/stock_parts/micro_laser
	item2 = /obj/item/weapon/circuitboard
	result = /obj/item/weapon/manhattan/craft/electronics/unfinished_bat
	strict_order = FALSE
	workbenches = list(/obj/structure/manhattan/workbench)

/decl/crafting_recipe/battery_pt1/get_required_time(atom/item1, atom/item2)
	return 5 SECONDS

/decl/crafting_recipe/battery_pt1/new_result(loc, atom/item1, atom/item2)
	var/obj/item/weapon/manhattan/craft/electronics/unfinished_bat/R = ..()
	return R

/decl/crafting_recipe/battery_pt2
	item1 = /obj/item/weapon/manhattan/craft/electronics/unfinished_bat
	item2 = /obj/item/weapon/stock_parts/capacitor
	result = /obj/item/weapon/cell
	strict_order = TRUE
	workbenches = list(/obj/structure/manhattan/workbench)

/decl/crafting_recipe/battery_pt2/get_required_time(atom/item1, atom/item2)
	return 5 SECONDS

/decl/crafting_recipe/battery_pt2/new_result(loc, atom/item1, atom/item2)
	var/obj/item/weapon/cell/R = ..()
	return R