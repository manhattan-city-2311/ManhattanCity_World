/datum/persistent/item
	name = "item"

/datum/persistent/item/LabelTokens(var/list/tokens)
	var/list/labelled_tokens = ..()
	labelled_tokens["path"] = text2path(tokens[LAZYLEN(labelled_tokens)+1])
	return labelled_tokens

/datum/persistent/item/IsValidEntry(var/atom/entry)
	. = ..() && entry.invisibility == 0

/datum/persistent/item/CheckTokenSanity(var/list/tokens)
	return ..() && ispath(tokens["path"])

/datum/persistent/item/CheckTurfContents(var/turf/T, var/list/tokens)
	var/_path = tokens["path"]
	return (locate(_path) in T) ? FALSE : TRUE

/datum/persistent/item/CreateEntryInstance(var/turf/creating, var/list/tokens)
	var/_path = tokens["path"]
	new _path(creating, tokens["age"]+1)

/datum/persistent/item/GetEntryAge(var/atom/entry)
	var/obj/item/item = entry
	return item.age

/datum/persistent/item/proc/GetEntryPath(var/atom/entry)
	var/obj/item/item = entry
	return item.type

/datum/persistent/item/CompileEntry(var/atom/entry)
	. = ..()
	LAZYADD(., "[GetEntryPath(entry)]")