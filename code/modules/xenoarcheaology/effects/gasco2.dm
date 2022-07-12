/datum/artifact_effect/gasco2
	name = "CO2 creation"
	contraband_level = CONTRABAND_ARTIFACTSHARMFUL

/datum/artifact_effect/gasco2/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)
