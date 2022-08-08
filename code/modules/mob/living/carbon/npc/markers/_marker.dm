/obj/effect/npc
	name = "npc marker"
	icon = 'icons/effects/effects.dmi'

/obj/effect/npc/initialize()
	..()
	GLOB.npcmarkers += src

/obj/effect/npc/patrol
	name = "npc patrol marker"
	icon_state = "patrol"
	var/in_nuse = FALSE

/obj/effect/npc/danger
	name = "npc danger marker"
	icon_state = "danger"

/obj/effect/npc/interest
	name = "npc point of interest marker"
	icon_state = "interest"