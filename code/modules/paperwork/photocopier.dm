/obj/machinery/photocopier
	name = "photocopier"
	icon = 'icons/obj/library.dmi'
	icon_state = "photocopier"
	var/insert_anim = "photocopier_animation"
	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = EQUIP
	circuit = /obj/item/weapon/circuitboard/photocopier
	var/obj/item/copyitem = null	//what's in the copier!
	var/copies = 1	//how many copies to print!
	var/toner = 30 //how much toner is left! woooooo~
	var/maxcopies = 10	//how many copies can be copied at once- idea shamelessly stolen from bs12's copier!
	unique_save_vars = list("toner") //you thought you could get away with free toner every round? I think not. --redd

/obj/machinery/photocopier/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/motor(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	RefreshParts()

/obj/machinery/photocopier/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/photocopier/attack_hand(mob/user as mob)
	user.set_machine(src)

	ui_interact(user)

/**
 *  Display the NanoUI window for the photocopier.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/photocopier/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	data["copyItem"] = copyitem
	data["toner"] = toner
	data["copies"] = copies
	data["maxCopies"] = maxcopies
	if(istype(user,/mob/living/silicon))
		data["isSilicon"] = 1
	else
		data["isSilicon"] = null

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "photocopier.tmpl", src.name, 300, 250)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(10)

/obj/machinery/photocopier/Topic(href, href_list)
	if(href_list["copy"])
		if(stat & (BROKEN|NOPOWER))
			return

		for(var/i = 0, i < copies, i++)
			if(toner <= 0)
				break

			if (istype(copyitem, /obj/item/weapon/paper))
				playsound(loc, "sound/machines/copier.ogg", 100, 1)
				sleep(11)
				copy(copyitem)
			else if (istype(copyitem, /obj/item/weapon/photo))
				playsound(loc, "sound/machines/copier.ogg", 100, 1)
				sleep(11)
				photocopy(copyitem)
			else if (istype(copyitem, /obj/item/weapon/paper_bundle))
				sleep(11)
				playsound(loc, "sound/machines/copier.ogg", 100, 1)
				var/obj/item/weapon/paper_bundle/B = bundlecopy(copyitem)
				sleep(11*B.pages.len)
			else if (istype(copyitem,/obj/item/weapon/paper/card/business))
				playsound(loc, "sound/machines/copier.ogg", 100, 1)
				sleep(11)
				copy(copyitem)
			else
				to_chat(usr, "<span class='warning'>\The [copyitem] can't be copied by \the [src].</span>")
				break

			//use_power(active_power_usage)
	else if(href_list["remove"])
		if(copyitem)
			copyitem.loc = usr.loc
			usr.put_in_hands(copyitem)
			to_chat(usr, "<span class='notice'>You take \the [copyitem] out of \the [src].</span>")
			copyitem = null
	else if(href_list["min"])
		if(copies > 1)
			copies--
	else if(href_list["add"])
		if(copies < maxcopies)
			copies++
	else if(href_list["aipic"])
		if(!istype(usr,/mob/living/silicon)) return
		if(stat & (BROKEN|NOPOWER)) return

		if(toner >= 5)
			var/mob/living/silicon/tempAI = usr
			var/obj/item/device/camera/siliconcam/camera = tempAI.aiCamera

			if(!camera)
				return
			var/obj/item/weapon/photo/selection = camera.selectpicture()
			if (!selection)
				return

			var/obj/item/weapon/photo/p = photocopy(selection)
			if (p.desc == "")
				p.desc += "Copied by [tempAI.name]"
			else
				p.desc += " - Copied by [tempAI.name]"
			toner -= 5
			sleep(15)

	SSnanoui.update_uis(src)

/obj/machinery/photocopier/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/paper) || istype(O, /obj/item/weapon/photo) || istype(O, /obj/item/weapon/paper_bundle))
		//DO NOT let sticky notes be put into printer. It WILL dupe.
		if (!istype(O,/obj/item/weapon/paper/sticky))
			if(!copyitem)
				user.drop_item()
				copyitem = O
				O.loc = src
				to_chat(user, "<span class='notice'>You insert \the [O] into \the [src].</span>")
				playsound(loc, "sound/machines/click.ogg", 100, 1)
				flick(insert_anim, src)
			else
				to_chat(user, "<span class='notice'>There is already something in \the [src].</span>")
		else
			to_chat(user, "<span class='notice'>You cannot put that in \the [src].</span>")
	else if(istype(O, /obj/item/device/toner))
		if(toner <= 10) //allow replacing when low toner is affecting the print darkness
			user.drop_item()
			to_chat(user, "<span class='notice'>You insert the toner cartridge into \the [src].</span>")
			var/obj/item/device/toner/T = O
			toner += T.toner_amount
			qdel(O)
		else
			to_chat(user, "<span class='notice'>This cartridge is not yet ready for replacement! Use up the rest of the toner.</span>")
	else if(istype(O, /obj/item/weapon/wrench))
		playsound(loc, O.usesound, 50, 1)
		anchored = !anchored
		to_chat(user, "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")

	else if(default_deconstruction_screwdriver(user, O))
		return
	else if(default_deconstruction_crowbar(user, O))
		return

	return

/obj/machinery/photocopier/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(50))
				qdel(src)
			else
				if(toner > 0)
					new /obj/effect/decal/cleanable/blood/oil(get_turf(src))
					toner = 0
		else
			if(prob(50))
				if(toner > 0)
					new /obj/effect/decal/cleanable/blood/oil(get_turf(src))
					toner = 0
	return
//hacky code time by yours truly
/obj/machinery/photocopier/proc/copy(var/obj/item/weapon/paper/copy, var/need_toner=1)
	//a check to determine paper type please end me -redd
	// I WISH I COULD USE A GODDAMN SWITCH HERE -redd
	var/obj/item/weapon/paper/c
	//thanks cassie, very cool -redd
	//tl;dr sticky cards have their color var set -redd
	//it is now 2 am -redd
	var/is_sticky = 0
	if (istype(copy,/obj/item/weapon/paper/card/business))
		c = new /obj/item/weapon/paper/card/business (loc)
		//i forgot about color for this -redd
		is_sticky = 1
	//happy card -redd
	else if (istype(copy,/obj/item/weapon/paper/card/smile))
		c = new /obj/item/weapon/paper/card/smile (loc)
	//cat card -redd
	else if (istype(copy,/obj/item/weapon/paper/card/cat))
		c = new /obj/item/weapon/paper/card/cat (loc)
	//flower -redd
	else if (istype(copy,/obj/item/weapon/paper/card/flower))
		c = new /obj/item/weapon/paper/card/flower (loc)
	//heart card -redd
	else if (istype(copy,/obj/item/weapon/paper/card/heart))
		c = new /obj/item/weapon/paper/card/heart (loc)
	//invitation card -redd
	else if (istype(copy,/obj/item/weapon/paper/card/invitation))
		c = new /obj/item/weapon/paper/card/invitation (loc)
		//i forgot about color for this -redd
		is_sticky = 1
	//poster card -redd
	else if (istype(copy,/obj/item/weapon/paper/card/poster))
		c = new /obj/item/weapon/paper/card/poster (loc)
	//blank card -redd
	else if (istype(copy,/obj/item/weapon/paper/card))
		c = new /obj/item/weapon/paper/card (loc)
	//do not enable until /obj/item/sticky_pad/attack_hand(var/mob/user) gets a check <- PLEASE CASSIE, GIVE IT A CHECK I ACCIDENTALLY STUMBLED ON A BUG -redd
	// else if (istype(copy,/obj/item/weapon/paper/sticky/poster))
	// 	c = new /obj/item/weapon/paper/sticky/poster (loc)
	// 	is_sticky = 1
	//regular goddamn paper. -redd
	else if (istype(copy,/obj/item/weapon/paper))
		c = new /obj/item/weapon/paper (loc)
	if(toner > 10)	//lots of toner, make it dark
		c.info = "<font color = #101010>"
	else			//no toner? shitty copies for you!
		c.info = "<font color = #808080>"
	var/copied = html_decode(copy.info)
	// there is no use for this until the sticky poster bs gets updated <- jk. Business cards and invitation cards can have different colors. -redd
	if (is_sticky == 1)
		c.color = copy.color
	copied = replacetext_char(copied, "<font face=\"[c.deffont]\" color=", "<font face=\"[c.deffont]\" nocolor=")	//state of the art techniques in action
	copied = replacetext_char(copied, "<font face=\"[c.crayonfont]\" color=", "<font face=\"[c.crayonfont]\" nocolor=")	//This basically just breaks the existing color tag, which we need to do because the innermost tag takes priority.
	c.info += copied
	c.info += "</font>"//</font>
	c.name = copy.name // -- Doohl
	c.fields = copy.fields
	c.stamps = copy.stamps
	c.stamped = copy.stamped
	c.ico = copy.ico
	c.offset_x = copy.offset_x
	c.offset_y = copy.offset_y
	var/list/temp_overlays = copy.overlays       //Iterates through stamps
	var/image/img                                //and puts a matching
	for (var/j = 1, j <= min(temp_overlays.len, copy.ico.len), j++) //gray overlay onto the copy
		if (findtext(copy.ico[j], "cap") || findtext(copy.ico[j], "cent"))
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-circle")
		else if (findtext(copy.ico[j], "deny"))
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-x")
		else
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-dots")
		img.pixel_x = copy.offset_x[j]
		img.pixel_y = copy.offset_y[j]
		c.overlays += img
	c.updateinfolinks()
	if(need_toner)
		toner--
	if(toner == 0)
		visible_message("<span class='notice'>A red light on \the [src] flashes, indicating that it is out of toner.</span>")
	return c


/obj/machinery/photocopier/proc/photocopy(var/obj/item/weapon/photo/photocopy, var/need_toner=1)
	var/obj/item/weapon/photo/p = photocopy.copy()
	p.loc = src.loc

	var/icon/I = icon(photocopy.icon, photocopy.icon_state)
	if(toner > 10)	//plenty of toner, go straight greyscale
		I.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))		//I'm not sure how expensive this is, but given the many limitations of photocopying, it shouldn't be an issue.
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
		p.tiny.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	else			//not much toner left, lighten the photo
		I.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		p.tiny.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
	p.icon = I
	if(need_toner)
		toner -= 5	//photos use a lot of ink!
	if(toner < 0)
		toner = 0
		visible_message("<span class='notice'>A red light on \the [src] flashes, indicating that it is out of toner.</span>")

	return p

//If need_toner is 0, the copies will still be lightened when low on toner, however it will not be prevented from printing. TODO: Implement print queues for fax machines and get rid of need_toner
/obj/machinery/photocopier/proc/bundlecopy(var/obj/item/weapon/paper_bundle/bundle, var/need_toner=1)
	var/obj/item/weapon/paper_bundle/p = new /obj/item/weapon/paper_bundle (src)
	for(var/obj/item/weapon/W in bundle.pages)
		if(toner <= 0 && need_toner)
			toner = 0
			visible_message("<span class='notice'>A red light on \the [src] flashes, indicating that it is out of toner.</span>")
			break

		if(istype(W, /obj/item/weapon/paper))
			W = copy(W)
		else if(istype(W, /obj/item/weapon/photo))
			W = photocopy(W)
		W.loc = p
		p.pages += W

	p.loc = src.loc
	p.update_icon()
	p.icon_state = "paper_words"
	p.name = bundle.name
	p.pixel_y = rand(-8, 8)
	p.pixel_x = rand(-9, 9)
	return p

/obj/item/device/toner
	name = "toner cartridge"
	icon_state = "tonercartridge"
	var/toner_amount = 30
