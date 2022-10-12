/decl/crafting_recipe
	var/item1 // typepath
	var/item2 // typepath
	var/strict_order = FALSE
	var/result // typepath
	var/list/required_skills
	var/list/workbenches

/decl/crafting_recipe/proc/can_be_crafted(mob/M, item1, item2)
	if(!(istype(item1, src.item1) && istype(item2, src.item2)))
		if(!strict_order)
			if(!(istype(item1, src.item2) && istype(item2, src.item1)))
				return FALSE
		else
			return FALSE

	for(var/skill in required_skills)
		if(M.get_skill(skill) < required_skills[skill])
			return FALSE

	for(var/W in workbenches)
		if(!(locate(W) in view(1, M)))
			return FALSE

	return TRUE

/decl/crafting_recipe/proc/consume_item1(atom/item)
	qdel(item)

/decl/crafting_recipe/proc/consume_item2(atom/item)
	qdel(item)

/decl/crafting_recipe/proc/new_result(loc, atom/item1, atom/item2)
	return new result(loc)

/decl/crafting_recipe/proc/get_required_time(atom/item1, atom/item2)
	return 2 SECONDS

/decl/crafting_recipe/proc/craft(mob/M, atom/item1, atom/item2)
	if(!do_after(M, get_required_time(item1, item2), target = item1))
		return

	var/loc = item1.loc

	. = new_result(loc, item1, item2)

	consume_item1(item1)
	consume_item2(item2)

	if(loc == M)
		M.put_in_inactive_hand(.)

var/global/list/crafting_recipes

/hook/roundstart/proc/create_crafting_recipes()
	global.crafting_recipes = list()
	for(var/T in subtypesof(/decl/crafting_recipe))
		global.crafting_recipes += new T
	
	return TRUE

/obj/item/attackby(obj/item/weapon/W, mob/user)
	. = ..()
	if(.)
		return

	for(var/decl/crafting_recipe/CR as anything in global.crafting_recipes)
		if(CR.can_be_crafted(user, src, W))
			CR.craft(user, src, W)
			return TRUE

