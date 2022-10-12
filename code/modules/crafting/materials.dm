/decl/crafting_recipe/metal_rod_melee_energy
	item1 = /obj/item/stack/material/steel
	item2 = /obj/item/weapon/melee/energy
	result = /obj/item/stack/rods
	strict_order = TRUE

/decl/crafting_recipe/metal_rod_melee_energy/consume_item2(atom/item)
	return

/decl/crafting_recipe/metal_rod_melee_energy/get_required_time(obj/item/stack/material/steel/item1, atom/item2)
	return item1.amount * (1.5 SECONDS)

/decl/crafting_recipe/metal_rod_melee_energy/new_result(loc, obj/item/stack/material/steel/item1, atom/item2)
	var/obj/item/stack/rods/R = ..()
	R.amount = 4 * item1.amount
	R.update_icon()
	return R

/decl/crafting_recipe/metal_rod_melee_energy/can_be_crafted(mob/M, atom/item1, obj/item/weapon/melee/energy/item2)
	return ..() && item2.active
