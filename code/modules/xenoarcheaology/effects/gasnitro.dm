/datum/artifact_effect/gasnitro
	name = "N2 creation"
	contraband_level = CONTRABAND_ARTIFACTSHARMFUL

/datum/artifact_effect/gasnitro/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)