var/obj/screen/robot_inventory
/*
/mob/living/silicon/robot/instantiate_hud(var/datum/hud/HUD, var/ui_style, var/ui_color, var/ui_alpha)
	HUD.robot_hud(ui_style, ui_color, ui_alpha, src)*/

/datum/hud/proc/robot_hud(ui_style='icons/mob/screen1_robot.dmi', var/ui_color = "#ffffff", var/ui_alpha = 255, var/mob/living/silicon/robot/target)
	if(!mymob)
		stack_trace("robot_hud() called with null mymob")
		return
	if(!isrobot(mymob))
		stack_trace("robot_hud() called on mob that is not type /mob/living/silicon/robot")
		return
	var/mob/living/silicon/robot/robomob = mymob
/*	var/datum/hud_data/hud_data
	if(!istype(target))
		hud_data = new()

	if(hud_data.icon)
		ui_style = hud_data.icon*/

	if(ui_style == 'icons/mob/screen/minimalist.dmi')
		ui_style = 'icons/mob/screen1_robot_minimalist.dmi'
	else
		ui_style = 'icons/mob/screen1_robot.dmi'

	src.adding = list()
	src.other = list()

	var/obj/screen/using

//Radio
	using = new /obj/screen()
	using.name = "radio"
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.color = ui_color
	using.alpha = ui_alpha
	using.icon_state = "radio"
	using.screen_loc = ui_movi
	using.layer = HUD_LAYER
	src.adding += using

//Module select

	using = new /obj/screen()
	using.name = "module1"
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.color = ui_color
	using.alpha = ui_alpha
	using.icon_state = "inv1"
	using.screen_loc = ui_inv1
	using.layer = HUD_LAYER
	using.plane = PLANE_PLAYER_HUD
	src.adding += using
	robomob.inv1 = using

	using = new /obj/screen()
	using.name = "module2"
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.color = ui_color
	using.alpha = ui_alpha
	using.icon_state = "inv2"
	using.screen_loc = ui_inv2
	using.layer = HUD_LAYER
	using.plane = PLANE_PLAYER_HUD
	src.adding += using
	robomob.inv2 = using

	using = new /obj/screen()
	using.name = "module3"
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.color = ui_color
	using.alpha = ui_alpha
	using.icon_state = "inv3"
	using.screen_loc = ui_inv3
	using.layer = HUD_LAYER
	using.plane = PLANE_PLAYER_HUD
	src.adding += using
	robomob.inv3 = using

//End of module select

//Intent
	using = new /obj/screen()
	using.name = "act_intent"
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.alpha = ui_alpha
	using.icon_state = robomob.a_intent
	using.screen_loc = ui_acti
	using.layer = HUD_LAYER
	using.plane = PLANE_PLAYER_HUD
	src.adding += using
	action_intent = using

//Cell
	
	var/obj/screen/cellscreen = new
	cellscreen.icon = ui_style
	cellscreen.icon_state = "charge-empty"
	cellscreen.alpha = ui_alpha
	cellscreen.name = "cell"
	cellscreen.screen_loc = ui_toxin
	robomob.cells = cellscreen
	src.other += robomob.cells

//Health
	robomob.healths = new /obj/screen()
	robomob.healths.icon = ui_style
	robomob.healths.icon_state = "health0"
	robomob.healths.alpha = ui_alpha
	robomob.healths.name = "health"
	robomob.healths.screen_loc = ui_borg_health
	src.other += robomob.healths

//Installed Module
	robomob.hands = new /obj/screen()
	robomob.hands.icon = ui_style
	robomob.hands.icon_state = "nomod"
	robomob.hands.alpha = ui_alpha
	robomob.hands.name = "module"
	robomob.hands.screen_loc = ui_borg_module
	src.other += robomob.hands

//Module Panel
	using = new /obj/screen()
	using.name = "panel"
	using.icon = ui_style
	using.icon_state = "panel"
	using.alpha = ui_alpha
	using.screen_loc = ui_borg_panel
	using.layer = HUD_LAYER-0.01
	using.plane = PLANE_PLAYER_HUD
	src.adding += using

//Store
	robomob.throw_icon = new /obj/screen()
	robomob.throw_icon.icon = ui_style
	robomob.throw_icon.icon_state = "store"
	robomob.throw_icon.alpha = ui_alpha
	robomob.throw_icon.color = ui_color
	robomob.throw_icon.name = "store"
	robomob.throw_icon.screen_loc = ui_borg_store
	src.other += robomob.throw_icon

//Inventory
	robot_inventory = new /obj/screen()
	robot_inventory.name = "inventory"
	robot_inventory.icon = ui_style
	robot_inventory.icon_state = "inventory"
	robot_inventory.alpha = ui_alpha
	robot_inventory.color = ui_color
	robot_inventory.screen_loc = ui_borg_inventory
	src.other += robot_inventory

//Temp
	robomob.bodytemp = new /obj/screen()
	robomob.bodytemp.icon_state = "temp0"
	robomob.bodytemp.name = "body temperature"
	robomob.bodytemp.screen_loc = ui_temp

	robomob.oxygen = new /obj/screen()
	robomob.oxygen.icon = ui_style
	robomob.oxygen.icon_state = "oxy0"
	robomob.oxygen.alpha = ui_alpha
	robomob.oxygen.name = "oxygen"
	robomob.oxygen.screen_loc = ui_oxygen
	src.other += robomob.oxygen

	robomob.fire = new /obj/screen()
	robomob.fire.icon = ui_style
	robomob.fire.icon_state = "fire0"
	robomob.fire.alpha = ui_alpha
	robomob.fire.name = "fire"
	robomob.fire.screen_loc = ui_fire
	src.other += robomob.fire

	robomob.pullin = new /obj/screen()
	robomob.pullin.icon = ui_style
	robomob.pullin.icon_state = "pull0"
	robomob.pullin.alpha = ui_alpha
	robomob.pullin.color = ui_color
	robomob.pullin.name = "pull"
	robomob.pullin.screen_loc = ui_borg_pull
	src.other += robomob.pullin

	robomob.zone_sel = new /obj/screen/zone_sel()
	robomob.zone_sel.icon = ui_style
	robomob.zone_sel.alpha = ui_alpha
	robomob.zone_sel.overlays.Cut()
	robomob.zone_sel.overlays += image('icons/mob/zone_sel.dmi', "[robomob.zone_sel.selecting]")

	//Handle the gun settings buttons
	robomob.gun_setting_icon = new /obj/screen/gun/mode(null)
	robomob.gun_setting_icon.icon = ui_style
	robomob.gun_setting_icon.alpha = ui_alpha
	robomob.item_use_icon = new /obj/screen/gun/item(null)
	robomob.item_use_icon.icon = ui_style
	robomob.item_use_icon.alpha = ui_alpha
	robomob.gun_move_icon = new /obj/screen/gun/move(null)
	robomob.gun_move_icon.icon = ui_style
	robomob.gun_move_icon.alpha = ui_alpha
	robomob.radio_use_icon = new /obj/screen/gun/radio(null)
	robomob.radio_use_icon.icon = ui_style
	robomob.radio_use_icon.alpha = ui_alpha

	robomob.client.screen = list()

	robomob.client.screen += list( robomob.throw_icon, robomob.zone_sel, robomob.oxygen, robomob.fire, robomob.hands, robomob.healths, robomob.cells, robomob.pullin, robot_inventory, robomob.gun_setting_icon)
	robomob.client.screen += src.adding + src.other
	robomob.client.screen += robomob.client.void

	return


/datum/hud/proc/toggle_show_robot_modules()
	if(!isrobot(mymob))
		return

	var/mob/living/silicon/robot/r = mymob

	r.shown_robot_modules = !r.shown_robot_modules
	update_robot_modules_display()


/datum/hud/proc/update_robot_modules_display()
	if(!isrobot(mymob))
		return

	var/mob/living/silicon/robot/r = mymob

	if(r.shown_robot_modules)
		//Modules display is shown
		//r.client.screen += robot_inventory	//"store" icon

		if(!r.module)
			to_chat(usr, "<span class='danger'>No module selected</span>")
			return

		if(!r.module.modules)
			to_chat(usr, "<span class='danger'>Selected module has no modules to select</span>")
			return

		if(!r.robot_modules_background)
			return

		var/display_rows = -round(-(r.module.modules.len) / 8)
		r.robot_modules_background.screen_loc = "CENTER-4:16,SOUTH+1:7 to CENTER+3:16,SOUTH+[display_rows]:7"
		r.client.screen += r.robot_modules_background

		var/x = -4	//Start at CENTER-4,SOUTH+1
		var/y = 1

		//Unfortunately adding the emag module to the list of modules has to be here. This is because a borg can
		//be emagged before they actually select a module. - or some situation can cause them to get a new module
		// - or some situation might cause them to get de-emagged or something.
		if(r.emagged || r.emag_items)
			if(!(r.module.emag in r.module.modules))
				r.module.modules.Add(r.module.emag)
		else
			if(r.module.emag in r.module.modules)
				r.module.modules.Remove(r.module.emag)

		for(var/atom/movable/A in r.module.modules)
			if( (A != r.module_state_1) && (A != r.module_state_2) && (A != r.module_state_3) )
				//Module is not currently active
				r.client.screen += A
				if(x < 0)
					A.screen_loc = "CENTER[x]:16,SOUTH+[y]:7"
				else
					A.screen_loc = "CENTER+[x]:16,SOUTH+[y]:7"
				A.hud_layerise()

				x++
				if(x == 4)
					x = -4
					y++

	else
		//Modules display is hidden
		//r.client.screen -= robot_inventory	//"store" icon
		for(var/atom/A in r.module.modules)
			if( (A != r.module_state_1) && (A != r.module_state_2) && (A != r.module_state_3) )
				//Module is not currently active
				r.client.screen -= A
		r.shown_robot_modules = 0
		r.client.screen -= r.robot_modules_background

/mob/living/silicon/robot/update_hud()
	if(modtype)
		hands.icon_state = lowertext(modtype)
	..()
