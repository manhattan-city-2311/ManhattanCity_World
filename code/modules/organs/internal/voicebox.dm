/*
 *	Voicebox/Vocal Synthesizers
 *	TL;DR: Assists with speaking languages that a species doesn't normally have,
 *	such as EAL. Not standard or organic, because at the moment it's undesireable to completely mute characters. - - Can now actually cause muting, if destroyed / removed.
 */

/obj/item/organ/internal/voicebox
	name = "larynx"
	icon_state = "larynx"
	parent_organ = BP_HEAD		// We don't have a neck area
	organ_tag = O_VOICE
	var/list/blacklist_languages = list(LANGUAGE_EAL)
	var/mute = FALSE

/obj/item/organ/internal/voicebox/New()
	..()
	amend_assist_langs()

/obj/item/organ/internal/voicebox/proc/amend_assist_langs()	// Adds the list of language datums assisted by the voicebox to the list used in speaking
	return

/obj/item/organ/internal/voicebox/proc/add_assistable_langs(var/language)	// Adds a new language (by string/define) to the list of things the voicebox can assist
	blacklist_languages.Remove(language)
	amend_assist_langs()	// Can't think of a better place to put this, makes the voicebox actually start to assist with the added language

/////////////////////////////////
//		Voicebox Subtypes
/////////////////////////////////

/obj/item/organ/internal/voicebox/assist	// In the off chance we get a species that doesn't speak GalCom by default
	blacklist_languages = list()

/obj/item/organ/internal/voicebox/assist/New()
	..()
	mechassist()

/obj/item/organ/internal/voicebox/robot
	name = "vocal synthesizer"
	blacklist_languages = list() // Synthetics spawn with this by default

/obj/item/organ/internal/voicebox/robot/New()
	..()
	robotize()
