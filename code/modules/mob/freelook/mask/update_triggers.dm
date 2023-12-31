//UPDATE TRIGGERS, when the chunk (and the surrounding chunks) should update.

#define CULT_UPDATE_BUFFER 30

/mob/living/var/updating_cult_vision = 0

/mob/living/Move()
	var/oldLoc = src.loc
	. = ..()
	if(.)
		if(cultnet.provides_vision(src))
			if(!updating_cult_vision)
				updating_cult_vision = 1
				spawn(CULT_UPDATE_BUFFER)
					if(oldLoc != src.loc)
						cultnet.updateVisibility(oldLoc, 0)
						cultnet.updateVisibility(loc, 0)
					updating_cult_vision = 0

#undef CULT_UPDATE_BUFFER

/mob/living/New()
	..()
	cultnet.updateVisibility(src, 0)

/mob/living/Destroy()
	cultnet.updateVisibility(src, 0)
	return ..()

/mob/living/death(gibbed, deathmessage="seizes up and falls limp...")
	if(..(gibbed, deathmessage))
		// If true, the mob went from living to dead (assuming everyone has been overriding as they should...)
		cultnet.updateVisibility(src)