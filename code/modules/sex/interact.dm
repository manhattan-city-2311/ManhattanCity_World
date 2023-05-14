/*
/mob/living/carbon/human/verb/interact()
	set name = "Взаимодействовать"
	set src in view(1)

	var/mob/living/carbon/human/user = usr

	user.initialize_erp(src)
	initialize_erp(user)

	show_erp_panel()
	user.show_erp_panel()
*/