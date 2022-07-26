/*Our program, who art in memory,
	called by thy name;
  thy operating system run;
thy function be done at runtime
  as it was on development.
Give us this day our daily output.
And forgive us our code duplication,
	as we forgive those who
  duplicate code against us.
And lead us not into frustration;
  but deliver us from GOTOs.
	For thine is algorithm,
the computation, and the solution,
	looping forever and ever.
		  Return;*/

//Let's make it detachable, for god's sake. ~Pl3asejust3ndMypain

#define AROUSAL_PASSIVE_FALLOFF 5
#define MALE_ORGASM_CAP 250
#define FEMALE_ORGASM_CAP 400

#define MALE_ORGASM_PLEASURE 500
#define FEMALE_ORGASM_PLEASURE 300

/datum/erp_session
	var/name = "ERP Session"
	var/description = ""
	var/list/datum/erp_datum/erp_datums = list() //contains erp datums of all patricipants
	var/list/datum/erp_action/actions = list()

/datum/erp_session/process()
	if(!erp_datums)
		close_session()
	for(var/datum/erp_datum/E in erp_datums)
		E.process()
	for(var/datum/erp_action/A in actions)
		A.process()

/datum/erp_session/proc/close_session()
	qdel(src)

/datum/erp_session/proc/add_datum(datum/erp_datum/erp_datum)
	if(!erp_datum)
		return
	
	erp_datum.erp_session = src
	erp_datums += erp_datum

/datum/erp_datum
	var/mob/living/carbon/human/owner = null
	var/datum/erp_session/erp_session = null

	var/arousal = 0 //0-500
	var/edging = 0 //Times a character was edged
	var/pleasure = 0 //0-1000 perhaps
	var/recovery = 0 //Can't have an orgasm in that amount of ticks
	var/list/known_tricks = list("Kiss") //"Special" actions

/mob/living/carbon/human/var/datum/erp_datum/erp_datum = null

/mob/living/carbon/human/proc/join_erp_session(datum/erp_session/erp_session)
	if(!erp_session)
		return
	
	erp_datum = new
	erp_datum.owner = src
	erp_session.add_datum(erp_datum)

/mob/living/carbon/human/proc/start_erp_session()
	if(erp_datum)
		return

	var/datum/erp_session/erp_session/session = new
	join_erp_session(session)

	return session

/mob/living/carbon/human/proc/leave_erp_session()
	if(erp_datum)
		qdel(erp_datum)

/datum/erp_datum/Destroy()
	erp_session.erp_datums -= src
	owner?.erp_datum = null

/datum/erp_datum/proc/can_leave()
	return TRUE

/datum/erp_datum/proc/handle_erp()
	arousal = max(0, arousal - AROUSAL_PASSIVE_FALLOFF)
	pleasure = 0
	recovery -= 20
	if(owner.gender == "female")
		if(pleasure > FEMALE_ORGASM_CAP && recovery <= 0)
			orgasm()
	else
		if(pleasure > MALE_ORGASM_CAP && recovery <= 0)
			orgasm()
	handle_pleasure()

/datum/erp_datum/proc/orgasm()
	recovery = owner.age * 14

	if(owner.gender == "male")
		arousal = arousal * 0.5
		pleasure = max(MALE_ORGASM_PLEASURE, pleasure)
		to_chat(owner, pick(erp_session.male_orgasm_messages))
	else
		arousal = arousal * 1.5
		pleasure = max(FEMALE_ORGASM_PLEASURE, pleasure)
		to_chat(owner, pick(erp_session.female_orgasm_messages))

/datum/erp_datum/proc/handle_pleasure()
