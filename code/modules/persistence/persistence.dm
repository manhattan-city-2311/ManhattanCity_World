/*
* Returns a byond list that can be passed to the "deserialize" proc
* to bring a new instance of this atom to its original state
*
* If we want to store this info, we can pass it to `json_encode` or some other
* interface that suits our fancy, to make it into an easily-handled string
*/
/datum/proc/serialize()
	var/data = list("type" = "[type]")
	return data

/*
* This is given the byond list from above, to bring this atom to the state
* described in the list.
* This will be called after `New` but before `initialize`, so linking and stuff
* would probably be handled in `initialize`
*
* Also, this should only be called by `json_to_object` in persistence.dm - at least
* with current plans - that way it can actually initialize the type from the list
*/
/datum/proc/deserialize(var/list/data)
	return
/atom
	var/persistence_flags = PF_SAVE_CONTENTS

	var/unique_save_vars = list()

	var/dont_save = FALSE // For atoms that are temporary by necessity - like lighting overlays

/atom/proc/on_persistence_load()
	persistence_flags &= ~PF_PERSISTENCE_LOADED

/atom/proc/on_persistence_save()
	persistence_flags |= PF_PERSISTENCE_LOADED

/atom/proc/persistence_track()
	return

/atom/Destroy()
	. = ..()
	persistence_forget()

/atom/proc/persistence_forget()
	return

/atom/proc/make_persistent()
	dont_save = FALSE

	for(var/obj/I in get_saveable_contents())
		I.dont_save = FALSE


/atom/proc/make_nonpersistent()
	dont_save = TRUE

	for(var/obj/I in get_saveable_contents())
		I.dont_save = TRUE


/atom/proc/get_persistent_metadata()
	return

/atom/proc/load_persistent_metadata(metadata)
	return

/atom/proc/sanitize_for_saving()
	return TRUE

/atom/proc/get_saveable_contents()
	return contents

/obj/sanitize_for_saving()	// these things build up with time, so this gradually limits the amount so we don't have 5000 fingerprints or anything.
	if(!suit_fibers)
		suit_fibers = list()

	if(!fingerprints)
		fingerprints = list()

	if(!fingerprintshidden)
		fingerprintshidden = list()

	if(islist(suit_fibers) && !LAZYLEN(suit_fibers))
		truncate_oldest(suit_fibers, MAX_FINGERPRINTS)
	if(islist(fingerprints) && !LAZYLEN(fingerprints))
		truncate_oldest(fingerprints, MAX_FINGERPRINTS)
	if(islist(fingerprintshidden) && !LAZYLEN(fingerprintshidden))
		truncate_oldest(fingerprintshidden, MAX_FINGERPRINTS)

	return TRUE

/atom/proc/pack_persistence_data()
	. = list()

	for(var/datum/reagent/R as anything in reagents.reagent_list)
		var/datum/map_reagent_data/reagent_holder = new()

		reagent_holder.id = R.id
		reagent_holder.amount = R.volume

		if(R.get_data())
			var/list/datalist = R.get_data()

			if(islist(datalist))
				var/list/metadata = list()
				for(var/V in datalist)
					if(!istext(datalist[V]) && !isnum(datalist[V]))
						continue
					metadata[V] = datalist[V]

				reagent_holder.data = metadata
			else
				if(!istext(R.get_data()) && !isnum(R.get_data()))
					continue

				reagent_holder.data = R.get_data()

		. += reagent_holder

/obj/proc/unpack_persistence_data(var/list/saved_reagents)
	if(!reagents)
		return

	if(LAZYLEN(saved_reagents))
		return FALSE

	reagents.reagent_list.Cut()

	for(var/datum/map_reagent_data/reagent_holder in saved_reagents)
		var/datum/reagent/new_reagent = reagents.add_reagent(reagent_holder.id, reagent_holder.amount)
		if(!new_reagent)
			continue
		if(reagent_holder.data)
			new_reagent.data = reagent_holder.data

	return TRUE

// This is so specific atoms can override these, and ignore certain ones
/atom/proc/vars_to_save()
	return list("color","dir","alpha","plane","pixel_x","pixel_y","icon_state") + unique_save_vars

/atom/proc/map_important_vars()
	// A list of important things to save in the map editor
	return list("color","dir","layer","plane","pixel_x","pixel_y") + unique_save_vars

/area
	unique_save_vars = null
	var/should_objects_be_saved = TRUE
	var/should_turfs_be_saved = FALSE

/atom/serialize()
	var/list/data = ..()
	for(var/thing in vars_to_save())
		if(vars[thing] != initial(vars[thing]))
			data[thing] = vars[thing]

	return data


/atom/deserialize(var/list/data)
	for(var/thing in vars_to_save())
		if(thing in data)
			vars[thing] = data[thing]
	..()


/proc/json_to_object(var/json_data, var/loc)
	var/data = json_decode(json_data)
	return list_to_object(data, loc)

/proc/list_to_object(var/list/data, var/loc)
	if(!islist(data))
		throw EXCEPTION("You didn't give me a list, bucko")
	if(!("type" in data))
		throw EXCEPTION("No 'type' field in the data")
	var/path = text2path(data["type"])
	if(!path)
		throw EXCEPTION("Path not found: [path]")

	var/atom/movable/thing = new path(loc)
	thing.deserialize(data)
	return thing


// Custom vars-to-save/persistence load list

/obj
	persistence_flags = PF_SAVE_CONTENTS | PF_SAVE_FORENSICS

/obj/vars_to_save()
	return list("density","anchored","color","dir","layer","plane","pixel_x","pixel_y","icon_state") + unique_save_vars

/obj/item/weapon/clipboard
	unique_save_vars = list("haspen","toppaper")

/obj/structure/safe
	unique_save_vars = list("open","tumbler_1_pos","tumbler_1_open","tumbler_2_pos","tumbler_2_open","dial")

/obj/structure/on_persistence_load()
	update_connections()
	update_icon()

// Don't save list - Better to keep a track of things here.
/mob
	unique_save_vars = null
	dont_save = TRUE

/atom/movable/lighting_overlay
	unique_save_vars = null
	dont_save = TRUE

/obj/singularity		// lmao just in case
	unique_save_vars = null
	dont_save = TRUE

/obj/effect
	unique_save_vars = null
	dont_save = TRUE

/obj/screen
	unique_save_vars = null
	dont_save = TRUE 	// what?

/area
	unique_save_vars = null
	dont_save = TRUE

/obj/machinery/organ_printer
	unique_save_vars = null
	dont_save = TRUE

/obj/structure/sign/rent
	unique_save_vars = null
	dont_save = TRUE

/obj/machinery/vending
	unique_save_vars = null
	dont_save = TRUE // TODO:
