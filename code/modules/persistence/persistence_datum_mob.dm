/datum/persistent/mob
	name = "mob"

/datum/persistent/mob/LabelTokens(var/list/tokens)
	var/list/labelled_tokens = ..()
	labelled_tokens["path"] = text2path(tokens[LAZYLEN(labelled_tokens)+1])
	return labelled_tokens

/datum/persistent/mob/IsValidEntry(var/atom/entry)
	. = ..() && entry.invisibility == 0

/datum/persistent/mob/CheckTokenSanity(var/list/tokens)
	return ..() && ispath(tokens["path"])

/datum/persistent/mob/CheckTurfContents(var/turf/T, var/list/tokens)
	var/_path = tokens["path"]
	return (locate(_path) in T) ? FALSE : TRUE

/datum/persistent/mob/CreateEntryInstance(var/turf/creating, var/list/tokens)
	var/_path = tokens["path"]
	new _path(creating, tokens["age"]+1)

/datum/persistent/mob/GetEntryAge(var/atom/entry)
	return 0

/datum/persistent/mob/proc/GetEntryPath(var/atom/entry)
	var/mob/mob = entry
	return mob.type

/datum/persistent/mob/CompileEntry(var/atom/entry)
	. = ..()
	LAZYADD(., "[GetEntryPath(entry)]")