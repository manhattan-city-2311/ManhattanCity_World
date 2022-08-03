/obj/item/weapon/passport
	name = "passport"
	desc = "This is an electronic passport that contains all open information about owner."
	icon = 'icons/obj/passport.dmi'
	icon_state = "passport"
	w_class = ITEMSIZE_SMALL

	var/forged = FALSE
	var/list/records // references boy
	slot_flags = SLOT_ID

/obj/item/weapon/passport/examine(mob/user)
	..()
	if(in_range(user, src) || istype(user, /mob/observer/dead))
		show_passport(usr)
	else
		to_chat(user, SPAN_NOTICE("You have to go closer if you want to read it."))

/obj/item/weapon/passport/proc/show_passport(mob/user)
	if(!records)
		to_chat(user, SPAN_NOTICE("[src] is blank!"))
	var/html = get_records_html(records)
	show_browser(user, "<HTML><meta charset=\"UTF-8\"><BODY>[html]</BODY></HTML>", "window=[user] passport")

/mob/proc/update_passport(obj/item/weapon/passport/pass)
	if(!mind)
		return
	pass.records = mind.prefs.records
	pass.name = "[real_name]'s passport"
	pass.forged = FALSE

/obj/item/weapon/passport/attack_self(mob/user)
	// TODO: editing
	src.add_fingerprint(user)

//Antag options - Forgery
/obj/item/weapon/passport/emag_act(remaining_charges, mob/user)
	return ..()

/******************************************************************
  Temporary passports in case it gets lost, destroyed, or stolen.
******************************************************************/
/obj/item/weapon/passport/temporary
	name = "blank temporary passport"
	desc = "This is an electronic temporary passport issued to those who have lost theirs. It only allows you to travel within your birth colony."
	icon_state = "temporary"

/obj/item/weapon/passport/temporary/attack_self(mob/user)
	if(!records.len)
		user.visible_message("\The [user] places their fingerprint on \the [src.name]'s scanner.",\
			SPAN_NOTICE("The microscanner scans your identity and automatically updates \the [src.name]'s details."))
		user.update_passport(src)
	src.add_fingerprint(user)

/obj/item/weapon/passport/temporary/emag_act(remaining_charges, mob/user)
	// TODO:
	return ..()

/***************************************************************************************************************************
  Diplomat's passport for events and what-not. May be useful if our lawmakers rule that diplomats have diplomatic immunity.
***************************************************************************************************************************/
/obj/item/weapon/passport/temporary/diplomat
	name = "blank diplomatic passport"
	desc = "This is an electronic passport that allows you to travel between colonies. This one has a diplomatic seal."
	icon_state = "diplomat"

/obj/item/weapon/passport/temporary/diplomat/emag_act(remaining_charges, mob/user)
	to_chat(user, "<span class='warning'>The [src] has heavily encrypted subroutines, preventing you from emagging it!")
	return
