#define LOCK_LOCKED 1
#define LOCK_BROKEN 2


/datum/lock
	var/status = 1 //unlocked, 1 == locked 2 == broken
	var/lock_data = "" //basically a randomized string. The longer the string the more complex the lock.
	var/atom/holder

/datum/lock/New(var/atom/h, var/complexity = 1)
	holder = h
	if(istext(complexity))
		lock_data = complexity
	else
		lock_data = generateRandomString(complexity)

/datum/lock/Destroy()
	holder = null
	..()

/datum/lock/proc/unlock(var/key = "", var/mob/user)
	if(status ^ LOCK_LOCKED)
		user << "<span class='warning'>Its already unlocked!</span>"
		return 2
	key = get_key_data(key, user)
	if(cmptext(lock_data,key) && (status ^ LOCK_BROKEN))
		status &= ~LOCK_LOCKED
		return 1
	return 0

/datum/lock/proc/lock(var/key = "", var/mob/user)
	if(status & LOCK_LOCKED)
		user << "<span class='warning'>Its already locked!</span>"
		return 2
	key = get_key_data(key, user)
	if(cmptext(lock_data,key) && (status ^ LOCK_BROKEN))
		status |= LOCK_LOCKED
		return 1
	return 0

/datum/lock/proc/toggle(var/key = "", var/mob/user)
	if(status & LOCK_LOCKED)
		return unlock(key, user)
	else
		return lock(key, user)

/datum/lock/proc/getComplexity()
	return length(lock_data)

/datum/lock/proc/get_key_data(var/key = "", var/mob/user)
	if(istype(key,/obj/item/weapon/door/key))
		var/obj/item/weapon/door/key/K = key
		return K.get_data(user)
	if(istext(key))
		return key
	return null

/datum/lock/proc/isLocked()
	return status & LOCK_LOCKED

/datum/lock/proc/pick_lock(var/obj/item/I, var/mob/user)
	if(!istype(I) || (status ^ LOCK_LOCKED))
		return 0
	var/unlock_power = I.lock_picking_level
	if(!unlock_power)
		return 0
	user.visible_message("\The [user] takes out \the [I], picking \the [holder]'s lock.")
	if(!do_after(user, 20, holder))
		return 0
	if(prob(20*(unlock_power/getComplexity())))
		to_chat(user, "<span class='notice'>You pick open \the [holder]'s lock!</span>")
		unlock(lock_data)
		return 1
	else if(prob(5 * unlock_power))
		to_chat(user, "<span class='warning'>You accidently break \the [holder]'s lock with your [I]!</span>")
		status |= LOCK_BROKEN
	else
		to_chat(user, "<span class='warning'>You fail to pick open \the [holder].</span>")
	return 0

/obj/item/weapon/material/lock_construct
	name = "lock"
	desc = "a crude but useful lock and bolt."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largebinemag"
	w_class = 1
	var/lock_data

/obj/item/weapon/material/lock_construct/New()
	..()
	force = 0
	throwforce = 0
	lock_data = generateRandomString(round(material.integrity/50))

/obj/item/weapon/material/lock_construct/attackby(var/obj/item/I, var/mob/user)
	if(istype(I,/obj/item/weapon/door/key))
		var/obj/item/weapon/door/key/K = I
		if(!K.key_data)
			to_chat(user, "<span class='notice'>You fashion \the [I] to unlock \the [src]</span>")
			K.key_data = src.lock_data
		else
			to_chat(user, "<span class='warning'>\The [I] already unlocks something...</span>")
		return
	if(istype(I,/obj/item/weapon/material/lock_construct))
		var/obj/item/weapon/material/lock_construct/L = I
		src.lock_data = L.lock_data
		to_chat(user, "<span class='notice'>You copy the lock from \the [L] to \the [src], making them identical.</span>")
		return
	..()

/obj/item/weapon/material/lock_construct/proc/create_lock(var/atom/target, var/mob/user)
	. = new /datum/lock(target,lock_data)
	user.drop_item(src)
	user.visible_message("\The [user] attaches \the [src] to \the [target]")
	qdel(src)