#define ERPTYPEOTHER "other"
#define ERPTYPEVAGINAL "vaginal"
#define ERPTYPEFELLATIONAL "fellational"
#define ERPTYPEANAL "anal"
#define ERPTYPEORAL "oral"

/datum/erp_action
    var/name
    var/description
    var/needs_special_knowledge = FALSE
    var/datum/erp_datum/recipient = null
    var/datum/erp_datum/giver = null
    var/datum/erp_session/erp_session = null
    var/etype = ERPTYPEOTHER //vaginal, fellational, anal and oral. Can't have actions of the same type
    var/pleasure = 0
    var/arousal = 0
    var/roughness = 1 //1-5. Defines the comfort of the recipient and the pleasure of the giver

/datum/erp_action/process()
    recipient.pleasure += pleasure / roughness
    giver.pleasure += pleasure * roughness
    recipient.arousal += arousal
    giver.arousal += arousal

/datum/erp_action/proc/start(var/datum/erp_session/new_es, var/datum/erp_datum/new_recipient, var/datum/erp_datum/new_giver)
    erp_session = new_es
    recipient = new_recipient
    giver = new_giver
    for(var/datum/erp_action/ea)
        if(ea.type == type)
            ea.stop()

/datum/erp_action/proc/stop()
    qdel(src)

/datum/erp_action/proc/visible_message(var/message)
    giver.owner.visible_message(message)