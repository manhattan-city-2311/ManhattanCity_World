var/global/list/persistent_inventories

/proc/check_persistent_storage_exists(unique_id)
	for(var/datum/persistent_inventory/PI in global.persistent_inventories)
		if(PI.unique_id == unique_id)
			return PI

	var/full_path = "data/persistent/inventories/[unique_id].sav"
	if(fexists(full_path))
		return new /datum/persistent_inventory(unique_id)

// datums for persistent inventory
/datum/persistent_inventory
	var/unique_id

	var/list/stored_items = list()

/datum/persistent_inventory/New(uuid)
	..()
	unique_id = uuid
	LAZYADD(global.persistent_inventories, src)

/datum/persistent_inventory/proc/add_item(slot_type, obj/item/O)
	var/datum/map_object/MO = full_item_save(O)

	stored_items["[slot_type]"] = MO

	return MO

/datum/persistent_inventory/proc/save()
	var/full_path = "data/persistent/inventories/[unique_id].sav"

	var/savefile/S = new(full_path)
	if(!fexists(full_path) || !S)
		return 0

	if(!S)
		return 0
	S.cd = "/"

	to_save(S, unique_id)
	to_save(S, stored_items)

	return 1

/datum/persistent_inventory/proc/load()
	var/full_path = "data/persistent/inventories/[unique_id].sav"

	var/savefile/S = new(full_path)
	if(!fexists(full_path) || !S)
		return 0
	S.cd = "/"

	from_save(S, unique_id)
	from_save(S, stored_items)

	listclearnulls(stored_items)

	return 1


/proc/delete_persistent_inventory(unique_id)
	var/full_path = "data/persistent/inventories/[unique_id].sav"
	if(!fexists(full_path))
		return 0

	fdel(full_path)

	return 1
