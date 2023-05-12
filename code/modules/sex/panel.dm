/mob/living/carbon/human/var/erp_panel_selected_category = ERP_ACTION_CATEGORY_ROMANCE
/mob/living/carbon/human/proc/show_erp_panel()
	if(erp_participient && get_dist(get_turf(src), get_turf(erp_participient)) > 1)
		quit_erp()
		return

	var/dat = "<table><tr>"
	var/global/list/categories = list(
		ERP_ACTION_CATEGORY_ROMANCE,
		ERP_ACTION_CATEGORY_FOREPLAY,
		ERP_ACTION_CATEGORY_SEX,
		ERP_ACTION_CATEGORY_RAPE,
		ERP_ACTION_CATEGORY_POSITIONING
	)
	for(var/id in categories)
		if(id == erp_panel_selected_category)
			dat += "<td><b>[id]</b></td>"
		else
			dat += "<td><a href='?src=\ref[src];erp_category=[id]'>[id]</a></td>"
	dat += "</tr></table><br/>"
/*
	dat += "Ваша позиция: <b>[erp_position?.name]</b><br/>"
	if(erp_participient && erp_participient != src)
		dat += "Позиция партнёра: <b>[erp_participient.erp_position?.name]</b><br/>"
	dat += "[get_self_pleasure_message()]<br/>"
	if(erp_participient)
		dat += erp_participient.get_erp_description()
	dat += "<hr><br/>"
*/

	dat += "<table><tr>"
	dat += "<td>"
	for(var/ID in get_available_actions())
		if(global.erp_actions_cache[ID].category == erp_panel_selected_category)
			dat += "<a href='?src=\ref[src];erp_action=[ID]'><b>[global.erp_actions_cache[ID].name]</b></a><br>"
	dat += "</td>"
	dat += "<td>"
	for(var/ID in get_available_self_actions())
		if(global.erp_actions_cache[ID].category == erp_panel_selected_category)
			dat += "<a href='?src=\ref[src];erp_action=[ID]'><b>[global.erp_actions_cache[ID].name]</b></a><br>"
	dat += "</td>"
	dat += "</tr></table>"

	var/datum/browser/popup = new (src, "erp_panel", "Взаимодействия", nwidth = 400, nheight = 600)
	popup.set_content("<html><body>[dat]</body></html>")
	popup.open()

/mob/living/carbon/human/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(!erp_position)
		return

	if(get_dist(get_turf(src), get_turf(erp_participient)) > 1)
		quit_erp()
		return

	if(href_list["erp_category"])
		erp_panel_selected_category = href_list["erp_category"]
	else if(href_list["erp_action"])
		var/datum/erp_action/A = global.erp_actions_cache[href_list["erp_action"]]
		A?.act(src, erp_participient)
	else
		return

	show_erp_panel()
