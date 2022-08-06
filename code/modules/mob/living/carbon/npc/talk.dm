/mob/living/carbon/human/npc
	var/mob/living/carbon/human/npc/talking_to = null
	var/speech_theme = "smalltalk" //smalltalk, deeptalk, argument and romance
	var/list/smalltalk_dialogues = list()
	var/list/deeptalk_dialogues = list()
	var/list/argument_dialogues = list()
	var/list/romance_dialogues = list()
	var/list/active_dialogue = list()
	var/speech_i = 0
	var/talking = FALSE

/mob/living/carbon/human/npc/proc/handle_speech(var/mob/living/carbon/human/npc/N)
	talking_to = N
	if(!talking_to)
		return
	var/list/possible_speech_themes = null //possible dialogues with chances
	switch(intelligence)
		if(INTELLIGENCE_STUPID)
			possible_speech_themes = list(
				"smalltalk" = 40,
				"deeptalk" = 5,
				"argument" = 50,
				"romance" = 5
			)
		if(INTELLIGENCE_AVERAGE)
			possible_speech_themes = list(
				"smalltalk" = 50,
				"deeptalk" = 20,
				"argument" = 20,
				"romance" = 10
			)
		if(INTELLIGENCE_SMART)
			possible_speech_themes = list(
				"smalltalk" = 20,
				"deeptalk" = 70,
				"argument" = 5,
				"romance" = 5
			)
	//TODO: Make weight system for this
	var/list/theme = pick(smalltalk_dialogues, deeptalk_dialogues, argument_dialogues, romance_dialogues)
	var/final_speech_chance = clamp(theme[pick(possible_speech_themes)] + social_score + get_sexuality() + get_physical_attractiveness(), 0, 90)
	if(!prob(final_speech_chance))
		return
	active_dialogue = theme

/mob/living/carbon/human/npc/proc/process_speech()
	if(!LAZYLEN(active_dialogue))
		return
	
	var/speechtext = active_dialogue[1 + (speech_i++) % active_dialogue.len]
	set_typing_indicator(FALSE)
	say(speechtext)
