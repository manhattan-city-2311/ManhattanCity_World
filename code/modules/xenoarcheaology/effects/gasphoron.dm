/datum/artifact_effect/gasphoron
	name = "phoron creation"
	contraband_level = CONTRABAND_ARTIFACTSHARMFUL

/datum/artifact_effect/gasphoron/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)
