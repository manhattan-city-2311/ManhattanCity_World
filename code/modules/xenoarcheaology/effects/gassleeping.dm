/datum/artifact_effect/gassleeping
	name = "N2O creation"
	contraband_level = CONTRABAND_ARTIFACTSHARMFUL

/datum/artifact_effect/gassleeping/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)

