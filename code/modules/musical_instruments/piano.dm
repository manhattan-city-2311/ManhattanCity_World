/obj/structure/device/piano
	name = "space piano"
	desc = "This is a space piano, like a regular piano, but always in tune! Even if the musician isn't."
	icon = 'icons/obj/musician.dmi'
	icon_state = "piano"
	anchored = TRUE
	density = TRUE

	var/datum/music_player/MP = null
	var/sound_path = "sound/musical_instruments/piano"

/obj/structure/device/piano/unable_to_play(mob/living/user)
	return ..() || !Adjacent(user) || !anchored

/obj/structure/device/piano/initialize()
	. = ..()
	MP = new(src, sound_path)

/obj/structure/device/piano/Destroy()
	QDEL_NULL(MP)
	return ..()

/obj/structure/device/piano/attack_hand(mob/living/user)
	if(!anchored)
		return
	MP.interact(user)

/*
/obj/structure/device/piano/attackby(obj/item/O, mob/user)
	if(iswrench(O))
		if (anchored)
			to_chat(user, "<span class='notice'>You begin to loosen \the [src]'s casters...</span>")
			user.visible_message(
				"<span class='notice'>[user] loosens \the [src]'s casters.</span>",
				"<span class='notice'>You hear ratchet.</span>"
			)
		else
			to_chat(user, "<span class='notice'>You begin to tighten \the [src] to the floor...</span>")
			user.visible_message(
				"<span class='notice'>[user] tightens \the [src]'s casters.</span>",
				"<span class='notice'>You hear ratchet.</span>"
				)

		anchored = !anchored
	else
		..()
*/

/obj/structure/device/piano/minimoog
	name = "space minimoog"
	desc = "Space minimoog. For a long time even doesn't exist in reality."
	icon_state = "minimoog"

/obj/structure/device/piano/royal
	name = "space grand piano"
	desc = "Like a regular space piano, but way more grand!"
	icon_state = "piano"

	sound_path = "sound/musical_instruments/royal"
