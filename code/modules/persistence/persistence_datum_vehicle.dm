/datum/persistent/vehicle
	name = "vehicle"

/datum/persistent/vehicle/LabelTokens(var/list/tokens)
	var/list/labelled_tokens = ..()
	labelled_tokens["path"] = text2path(tokens[LAZYLEN(labelled_tokens)+1])
	return labelled_tokens

/datum/persistent/vehicle/IsValidEntry(var/atom/entry)
	. = ..() && entry.invisibility == 0

/datum/persistent/vehicle/CheckTokenSanity(var/list/tokens)
	return ..() && ispath(tokens["path"])

/datum/persistent/vehicle/CheckTurfContents(var/turf/T, var/list/tokens)
	var/_path = tokens["path"]
	return (locate(_path) in T) ? FALSE : TRUE

/datum/persistent/vehicle/CreateEntryInstance(var/turf/creating, var/list/tokens)
	var/_path = tokens["path"]
	new _path(creating, tokens["age"]+1)

/datum/persistent/vehicle/GetEntryAge(var/atom/entry)
	return 0

/datum/persistent/vehicle/proc/GetEntryPath(var/atom/entry)
	var/obj/manhattan/vehicle/V = entry
	return V.type

/datum/persistent/vehicle/CompileEntry(var/atom/entry)
	. = ..()
	LAZYADD(., "[GetEntryPath(entry)]")