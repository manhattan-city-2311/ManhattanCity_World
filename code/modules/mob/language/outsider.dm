/datum/language/ling
	name = LANGUAGE_CHANGELING
	desc = "Although they are normally wary and suspicious of each other, changelings can commune over a distance."
	speech_verb = "says"
	colour = "changeling"
	key = "g"
	machine_understands = 0
	flags = RESTRICTED | HIVEMIND

/datum/language/ling/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	if(speaker.mind && speaker.mind.changeling)
		..(speaker,message,speaker.mind.changeling.changelingID)
	else
		..(speaker,message)

/datum/language/corticalborer
	name = "Cortical Link"
	desc = "Cortical borers possess a strange link between their tiny minds."
	speech_verb = "sings"
	ask_verb = "sings"
	exclaim_verb = "sings"
	colour = "alien"
	key = "x"
	machine_understands = 0
	flags = RESTRICTED | HIVEMIND

/datum/language/corticalborer/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	var/mob/living/simple_mob/animal/borer/B

	if(istype(speaker,/mob/living/carbon))
		var/mob/living/carbon/M = speaker
		B = M.has_brain_worms()
	else if(istype(speaker,/mob/living/simple_mob/animal/borer))
		B = speaker

	if(B)
		speaker_mask = B.true_name
	..(speaker,message,speaker_mask)

/datum/language/vox
	name = LANGUAGE_VOX
	desc = "The common tongue of the various Vox ships making up the Shoal. It sounds like chaotic shrieking to everyone else."
	speech_verb = "shrieks"
	ask_verb = "creels"
	exclaim_verb = "SHRIEKS"
	colour = "vox"
	key = "5"
	flags = WHITELISTED
	syllables = list("ti","ti","ti","hi","hi","ki","ki","ki","ki","ya","ta","ha","ka","ya","chi","cha","kah", \
	"SKRE","AHK","EHK","RAWK","KRA","AAA","EEE","KI","II","KRI","KA")
	machine_understands = 0

/datum/language/vox/get_random_name()
	return ..(FEMALE,1,6)

/datum/language/cultcommon
	name = LANGUAGE_CULT
	desc = "The chants of the occult, the incomprehensible."
	speech_verb = "intones"
	ask_verb = "intones"
	exclaim_verb = "chants"
	colour = "cult"
	key = "f"
	flags = RESTRICTED
	space_chance = 100
	machine_understands = 0
	syllables = list("ire","ego","nahlizet","certum","veri","jatkaa","mgar","balaq", "karazet", "geeri", \
		"orkan", "allaq", "sas'so", "c'arta", "forbici", "tarem", "n'ath", "reth", "sh'yro", "eth", "d'raggathnor", \
		"mah'weyh", "pleggh", "at", "e'ntrath", "tok-lyr", "rqa'nap", "g'lt-ulotf", "ta'gh", "fara'qha", "fel", "d'amar det", \
		"yu'gular", "faras", "desdae", "havas", "mithum", "javara", "umathar", "uf'kal", "thenar", "rash'tla", \
		"sektath", "mal'zua", "zasan", "therium", "viortia", "kla'atu", "barada", "nikt'o", "fwe'sh", "mah", "erl", "nyag", "r'ya", \
		"gal'h'rfikk", "harfrandid", "mud'gib", "il", "fuu", "ma'jin", "dedo", "ol'btoh", "n'ath", "reth", "sh'yro", "eth", \
		"d'rekkathnor", "khari'd", "gual'te", "nikka", "nikt'o", "barada", "kla'atu", "barhah", "hra" ,"zar'garis", "spiri", "malum")

/datum/language/cult
	name = LANGUAGE_OCCULT
	desc = "The initiated can share their thoughts by means defying all reason."
	speech_verb = "intones"
	ask_verb = "intones"
	exclaim_verb = "chants"
	colour = "cult"
	key = "y"
	machine_understands = 0
	flags = RESTRICTED | HIVEMIND

/datum/language/xenocommon
	name = "Xenomorph"
	colour = "alien"
	desc = "The common tongue of the xenomorphs."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "hisses"
	key = "u"
	flags = RESTRICTED
	syllables = list("sss","sSs","SSS")

/datum/language/xenos
	name = "Hivemind"
	desc = "Xenomorphs have the strange ability to commune over a psychic hivemind."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "hisses"
	colour = "alien"
	key = "a"
	flags = RESTRICTED | HIVEMIND

/datum/language/xenos/check_special_condition(var/mob/other)

	var/mob/living/carbon/M = other
	if(!istype(M))
		return 1
	if(locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs_by_name)
		return 1

	return 0

//for your antag purposes.
/datum/language/minbus
	name = LANGUAGE_MINBUS
	desc = "The Powers That Be have seen it fit to grace you with a special language that sounds like Russian for some reason."
	speech_verb = "says"
	ask_verb = "asks"
	exclaim_verb = "shouts"
	colour = "deadsay"
	key = "r"
	machine_understands = 0
	flags = RESTRICTED
	syllables = list("rus","zem","ave","groz","ski","ska","ven","konst","pol","lin","svy",
	"danya","da","mied","zan","das","krem","myka","cyka","blyat","to","st","no","na","ni",
	"ko","ne","en","po","ra","li","on","byl","cto","eni","ost","ol","ego","ver","stv","pro")


/datum/language/zombie
	name = "Zombie Hivemind"
	colour = "alien"
	desc = "Only zombies and hippies on lsd can understand this."
	speech_verb = "growls"
	ask_verb = "growls"
	exclaim_verb = "growls"
	colour = "alien"
	key = "z"
	machine_understands = 0
	flags = RESTRICTED | NO_STUTTER| NONVERBAL | HIVEMIND

/datum/language/precursor
	name = LANGUAGE_PRECURSOR
	desc = "A language spoken by a poorly understood precursor race."
	speech_verb = "voices"
	ask_verb = "inquires"
	exclaim_verb = "bellows"
	colour = COLOR_SEDONA
	key = "x"
	flags = WHITELISTED | NO_STUTTER
	machine_understands = 0
	space_chance = 50
	syllables = list(
			"aw", "ew", "ow", "li", "mi", "ma", "ta", "sha", "scha", "a", "ruk", "re", "stru", "ron", "pyu", "luk",
			"ng", "ey", "oe", "ka", "me", "te", "le", "she", "sche", "e", "rok", "san", "sen", "ren", "pyo", "lok",
			"sil", "ri", "quo", "xa", "mo", "ti", "ri", "shi", "schi", "i", "rak", "son", "sey", "ton", "pa", "lek"
		)
