// Communicators
//
// Allows ghosts to roleplay with crewmembers without having to commit to joining the round, and also allows communications between two communicators.

var/global/list/obj/item/device/communicator/all_communicators = list()

// List of core tabs the communicator can switch to
#define HOMETAB 1
#define PHONTAB 2
#define CONTTAB 3
#define MESSTAB 4
// #define NEWSTAB 5
#define NOTETAB 6
#define WTHRTAB 7
#define MANITAB 8
#define SETTTAB 9
#define EXTRTAB 10
#define HOTLINETAB 11

/obj/item/device/communicator
	name = "communicator"
	desc = "A personal device used to enable long range dialog between two people, utilizing existing telecommunications infrastructure to allow \
	communications across different cities, planets, or even star systems."
	icon = 'icons/obj/device.dmi'
	icon_state = "tier1-off"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	show_messages = 1

	origin_tech = list(TECH_ENGINEERING = 2, TECH_MAGNET = 2, TECH_BLUESPACE = 2, TECH_DATA = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 30,"glass" = 10,"copper" = 5)

	var/video_range = 4
	var/tmp/obj/machinery/camera/communicator/video_source	// Their camera
	var/tmp/obj/machinery/camera/communicator/camera		// Our camera

	var/list/voice_mobs = list()
	var/list/voice_requests = list()
	var/list/voice_invites = list()

	var/list/im_contacts = list()
	var/list/im_list = list()

	var/note = "Thank you for choosing the T-14.2 Communicator, this is your notepad!" //Current note in the notepad function
	var/notehtml = ""

	var/obj/item/weapon/commcard/cartridge = null //current cartridge
	var/flashlight_on = 0 // Internal light
	var/flashlight_lum = 4 // Brightness

	var/tmp/obj/item/weapon/card/id/id = null //add the ID slot
	var/tmp/obj/item/modular_computer/communicator_internal/computer	//the integrated modular computer.

	var/static/list/modules = list(
			list("module" = "Phone", "icon" = "phone64", "number" = PHONTAB),
			list("module" = "Contacts", "icon" = "person64", "number" = CONTTAB),
			list("module" = "Messaging", "icon" = "comment64", "number" = MESSTAB),
			list("module" = "Note", "icon" = "note64", "number" = NOTETAB),
//			list("module" = "Weather", "icon" = "sun64", "number" = WTHRTAB),
//			list("module" = "Crew Manifest", "icon" = "note64", "number" = MANITAB), // Need a different icon,
			list("module" = "Settings", "icon" = "gear64", "number" = SETTTAB),
//			list("module" = "Emergency Hotline", "icon" = "service64", "number" = HOTLINETAB)
		)	//list("module" = "Name of Module", "icon" = "icon name64", "number" = "what tab is the module")

	var/tmp/selected_tab = HOMETAB
	var/owner = ""
	// var/occupation = ""
	var/tmp/alert_called = 0
	var/tmp/obj/machinery/exonet_node/node = null //Reference to the Exonet node, to avoid having to look it up so often.

	var/tmp/target_address = ""
	var/tmp/target_address_name = ""
	var/network_visibility = 1
	var/ringer = 1
	var/list/contacts = list() // list("number" = 0, "name" = "A")
	var/tmp/list/known_devices = list()
	var/tmp/datum/exonet_protocol/exonet = null
	var/tmp/list/communicating = list()
	var/tmp/update_ticks = 0
	var/panel_open
	var/init_number = null// No! Memes are prohibitten! var/init_numba = null

/obj/item/device/communicator/vars_to_save()
	return ..() + list("init_number", "owner", "ringer", "network_visibility", "panel_open", "contacts", "selected_wallpaper", "note", "notehtml")

/obj/item/device/communicator/on_persistence_save()
	init_number = exonet?.address
	. = ..()

/obj/item/device/communicator/on_persistence_load()
	. = ..()
	change_wallpaper(selected_wallpaper)
	if(!exonet)
		initialize_exonet()
	else
		existing_phone_numbers -= exonet.address
		exonet.address = init_number

#define WALLPAPER_COMM(name, file_name, color) list("file" = file_name, "name" = name, "color" = color)
/obj/item/device/communicator
	var/selected_wallpaper = "blade.png"
	var/tmp/wallpaper_color
	var/static/list/wallpapers = list(
		WALLPAPER_COMM("Desert City", "blade.png", "#040603"),
		WALLPAPER_COMM("Cloudy", "cloudy.png", "#090013"),
		//WALLPAPER_COMM("Grid", "grid.png", "#040603"),
		WALLPAPER_COMM("Heavens", "heavens.png", "#6A252C"),
		WALLPAPER_COMM("Hermit", "hermit.png", "#96A45F"),
		WALLPAPER_COMM("Night", "night.png", "#41269B"),
		WALLPAPER_COMM("Sweet Home", "home.png", "#000235"),
		WALLPAPER_COMM("Shadowfell", "shadowfell.png", "#000000"),
		WALLPAPER_COMM("Terra", "terra.png", "#01066A"),
		WALLPAPER_COMM("Shade", "shade.png", "#040603")
	) //filename:CustomName_for_UI
/obj/item/device/communicator/proc/change_wallpaper(value)
	for(var/i in wallpapers)
		if(wallpapers["file"] == value)
			wallpaper_color = wallpapers["color"]
			break
// Proc: New()
// Parameters: None
// Description: Adds the new communicator to the global list of all communicators, sorts the list, obtains a reference to the Exonet node, then tries to
//				assign the device to the holder's name automatically in a spectacularly shitty way.
/obj/item/device/communicator/New()
	..()
	change_wallpaper(selected_wallpaper)
	all_communicators += src
	all_communicators = sortAtom(all_communicators)
	node = get_exonet_node()
	processing_objects |= src
	camera = new()
	camera.name = "[src] #[rand(100,999)]"
	camera.c_tag = camera.name
	computer = new()
	//This is a pretty terrible way of doing this.
	if(ismob(loc))
		register_device(loc.name)
	else if(istype(loc, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = loc
		if(ismob(S.loc))
			register_device(S.loc.name)
	initialize_exonet()
// Proc: examine()
// Parameters: user - the user doing the examining
// Description: Allows the user to click a link when examining to look at video if one is going.
/obj/item/device/communicator/examine(mob/user)
	. = ..(user, 1)
	if(. && video_source)
		to_chat(user, "<span class='notice'>It looks like it's on a video call: <a href='?src=\ref[src];watchvideo=1'>\[view\]</a></span>")

// Proc: initialize_exonet()
// Description: Sets up the exonet datum, gives the device an address, and then gets a node reference.  Afterwards, populates the device
//				list.
/obj/item/device/communicator/proc/initialize_exonet()
	if(!exonet)
		exonet = new/datum/exonet_protocol/phone(src)
	if(!exonet.address)
		if(!init_number)
			if(owner)
				exonet.make_address("communicator-[owner]")
			else
				exonet.make_address("communicator-\ref[src]")
		else
			exonet.address = init_number
	if(!node)
		node = get_exonet_node()
	populate_known_devices()

// Proc: examine()
// Parameters: 1 (user - the person examining the device)
// Description: Shows all the voice mobs inside the device, and their status.
/obj/item/device/communicator/examine(mob/user)
	if(!..(user))
		return

	var/msg = ""
	for(var/mob/living/voice/voice in contents)
		msg += "<span class='notice'>On the screen, you can see a image feed of [voice].</span>\n"
		msg += "<span class='warning'>"

		if(voice && voice.key)
			switch(voice.stat)
				if(CONSCIOUS)
					if(!voice.client)
						msg += "[voice] appears to be asleep.\n" //afk
				if(UNCONSCIOUS)
					msg += "[voice] doesn't appear to be conscious.\n"
				if(DEAD)
					msg += "<span class='deadsay'>[voice] appears to have died...</span>\n" //Hopefully this never has to be used.
		else
			msg += "<span class='notice'>The device doesn't appear to be transmitting any data.</span>\n"
		msg += "</span>"
	to_chat(user, msg)
	return

// Proc: emp_act()
// Parameters: None
// Description: Drops all calls when EMPed, so the holder can then get murdered by the antagonist.
/obj/item/device/communicator/emp_act()
	close_connection(reason = "Hardware error de%#_^@%-BZZZZZZZT")

// Proc: add_to_EPv2()
// Parameters: 1 (hex - a single hexadecimal character)
// Description: Called when someone is manually dialing with nanoUI.  Adds colons when appropiate.
/obj/item/device/communicator/proc/add_to_EPv2(var/hex)
	var/l = length(target_address)
	if(l >= 11)
		return
	// Fucking hardcode, i hate le antichrist!!!!!!!!!!!!!!! ~ _Elar_
	// if(length == 4 || length == 9 || length == 14 || length == 19 || length == 24 || length == 29)
	// 	target_address += ":[hex]"
	// 	return

	// // I love god ~ _Elar_
	// if((l + 1) % 5 == 0)
	// 	target_address += ":"
	if((l+1) % 4 == 0)
		target_address += "-"
	target_address += hex



// Proc: populate_known_devices()
// Parameters: 1 (user - the person using the device)
// Description: Searches all communicators and ghosts in the world, and adds them to the known_devices list if they are 'visible'.
/obj/item/device/communicator/proc/populate_known_devices(mob/user)
	if(!exonet)
		exonet = new(src)
	known_devices.Cut()
	if(!get_connection_to_tcomms()) //If the network's down, we can't see anything.
		return
	for(var/obj/item/device/communicator/comm in all_communicators)
		if(!comm || !comm.exonet || !comm.exonet.address || comm.exonet.address == exonet.address) //Don't add addressless devices, and don't add ourselves.
			continue
		known_devices |= comm
	for(var/mob/observer/dead/O in dead_mob_list)
		if(!O.client || O.client.prefs.communicator_visibility == 0)
			continue
		known_devices |= O

// Proc: get_connection_to_tcomms()
// Parameters: None
// Description: Simple check to see if the exonet node is active.
/obj/item/device/communicator/proc/get_connection_to_tcomms()
	if(node && node.on && node.allow_external_communicators)
		return can_telecomm(src,node, TRUE)
	return 0

// Proc: process()
// Parameters: None
// Description: Ticks the update_ticks variable, and checks to see if it needs to disconnect communicators every five ticks..
/obj/item/device/communicator/process()
	update_ticks++
	if(update_ticks % 5)
		if(!node)
			node = get_exonet_node()
		if(!get_connection_to_tcomms())
			close_connection(reason = "Connection timed out")

// Proc: attack()
// Parameters: 2 (M - what is being attacked. user - the mob that has the communicator)
// Description: When the communicator has an attached commcard with internal devices, relay the attack() through to those devices.
// 		Contents of the for loop are copied from gripper code, because that does approximately what we want to do.
/obj/item/device/communicator/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	..()
	if(cartridge && cartridge.active_devices)
		for(var/obj/item/wrapped in cartridge.active_devices)
			if(wrapped) 	//The force of the wrapped obj gets set to zero during the attack() and afterattack().
				wrapped.attack(M,user)
	return 0

// Proc: attackby()
// Parameters: 2 (C - what is used on the communicator. user - the mob that has the communicator)
// Description: When an ID is swiped on the communicator, the communicator reads the job and checks it against the Owner name, if success, the occupation is added.
/obj/item/device/communicator/attackby(obj/item/weapon/C as obj, mob/user as mob)
	..()
	if(isscrewdriver(C))
		panel_open = !panel_open
		user.visible_message(SPAN_WARNING("[user] screws the [src]'s panel [panel_open ? "open" : "closed"]!"),
		SPAN_NOTICE("You screw the [src]'s panel [panel_open ? "open" : "closed"]."))
		update_icon()
		playsound(get_turf(src), C.usesound, 50, 1)

	else if(istype(C, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/idcard = C
		if(!owner)
			if(panel_open && !owner && idcard.registered_name)
				register_device(idcard.registered_name)
				to_chat(user, SPAN_NOTICE("Occupation updated."))
			else
				to_chat(user, SPAN_NOTICE("\The [src] rejects the ID."))
		else if(((src in user.contents) && (C in user.contents)) || (istype(loc, /turf) && in_range(src, user) && (C in user.contents)) )
			if(id_check(user, 2))
				to_chat(user, SPAN_NOTICE("You put the ID into \the [src]'s slot."))
				updateSelfDialog()//Update self dialog on success.
		updateSelfDialog()

	else if(istype(C, /obj/item/weapon/pen))
		var/obj/item/weapon/pen/O = locate() in src
		if(O)
			to_chat(user, SPAN_NOTICE("There is already a pen in \the [src]."))
		else
			user.drop_item()
			C.forceMove(src)
			to_chat(user, SPAN_NOTICE("You slot \the [C] into \the [src]."))

	else if(istype(C, /obj/item/weapon/commcard) && !cartridge)
		cartridge = C
		user.drop_item()
		cartridge.forceMove(src)
		to_chat(usr, "<span class='notice'>You slot \the [cartridge] into \the [src].</span>")
		modules[++modules.len] = list("module" = "External Device", "icon" = "external64", "number" = EXTRTAB)
		SSnanoui.update_uis(src) // update all UIs attached to src
	return

// Proc: attack_self()
// Parameters: 1 (user - the mob that clicked the device in their hand)
// Description: Makes an exonet datum if one does not exist, allocates an address for it, maintains the lists of all devies, clears the alert icon, and
//				finally makes NanoUI appear.
/obj/item/device/communicator/attack_self(mob/user)
	initialize_exonet()
	alert_called = 0
	update_icon()
	ui_interact(user)
	if(video_source)
		watch_video(user)

// Proc: MouseDrop()
//Same thing PDAs do
/obj/item/device/communicator/MouseDrop(obj/over_object as obj)
	var/mob/M = usr
	if (!(src.loc == usr) || (src.loc && src.loc.loc == usr))
		return
	if(!istype(over_object, /obj/screen))
		return attack_self(M)
	return


// Proc: attack_ghost()
// Parameters: 1 (user - the ghost clicking on the device)
// Description: Recreates the known_devices list, so that the ghost looking at the device can see themselves, then calls ..() so that NanoUI appears.
/obj/item/device/communicator/attack_ghost(mob/user)
	populate_known_devices() //Update the devices so ghosts can see the list on NanoUI.
	..()

/mob/observer/dead
	var/datum/exonet_protocol/exonet = null
	var/list/exonet_messages = list()

// Proc: New()
// Parameters: None
// Description: Gives ghosts an exonet address based on their key and ghost name.
/mob/observer/dead/New()
	. = ..()
	spawn(20)
		exonet = new(src)
		if(client)
			exonet.make_address("communicator-[src.client]-[src.client.prefs.real_name]")
		else
			exonet.make_address("communicator-[key]-[src.real_name]")

// Proc: Destroy()
// Parameters: None
// Description: Removes the ghost's address and nulls the exonet datum, to allow qdel()ing.
/mob/observer/dead/Destroy()
	. = ..()
	if(exonet)
		exonet.remove_address()
		exonet = null
	return ..()

// Proc: register_device()
// Parameters: 1 (user - the person to use their name for)
// Description: Updates the owner's name and the device's name.
/obj/item/device/communicator/proc/register_device(new_name)
	if(!new_name)
		return
	owner = new_name

	if(camera)
		camera.name = name
		camera.c_tag = name

// Proc: Destroy()
// Parameters: None
// Description: Deletes all the voice mobs, disconnects all linked communicators, and cuts lists to allow successful qdel()
/obj/item/device/communicator/Destroy()
	for(var/mob/living/voice/voice in contents)
		voice_mobs.Remove(voice)
		to_chat(voice, "<span class='danger'>\icon[src] Connection timed out with remote host.</span>")
		qdel(voice)
	close_connection(reason = "Connection timed out")

	//Clean up all references we might have to others
	communicating.Cut()
	voice_requests.Cut()
	voice_invites.Cut()
	node = null

	//Clean up references that might point at us
	all_communicators -= src
	listening_objects.Remove(src)
	qdel(camera)
	qdel(exonet)
	qdel(computer)

	return ..()

// Proc: update_icon()
// Parameters: None
// Description: Self explanatory
/obj/item/device/communicator/update_icon()
	if(video_source)
		icon_state = "tier1-call"
		return

	if(voice_mobs.len || communicating.len)
		icon_state = "tier1-on"
		return

	if(alert_called)
		icon_state = "tier1-call"
		return

	icon_state = initial(icon_state)

// A camera preset for spawning in the communicator
/obj/machinery/camera/communicator
	network = list(NETWORK_COMMUNICATORS)

/obj/machinery/camera/communicator/New()
	..()
	client_huds |= global_hud.whitense
	client_huds |= global_hud.darkMask

/obj/item/device/communicator/verb/verb_remove_cartridge()
	set category = "Object"
	set name = "Remove commcard"
	set src in usr

	// Can't remove what isn't there
	if(!cartridge)
		to_chat(usr, "<span class='notice'>There isn't a commcard to remove!</span>")
		return

	// Can't remove if you're physically unable to
	if(usr.stat || usr.restrained() || usr.paralysis || usr.stunned || usr.weakened)
		to_chat(usr, "<span class='notice'>You cannot do this while restrained.</span>")
		return

	var/turf/T = get_turf(src)
	cartridge.loc = T
	// If it's in someone, put the cartridge in their hands
	if (ismob(loc))
		var/mob/M = loc
		M.put_in_hands(cartridge)
	// Else just set it on the ground
	else
		cartridge.loc = get_turf(src)
	cartridge = null
	// We have to iterate through the modules to find EXTRTAB, because list procs don't play nice with a list of lists
	for(var/i = 1, i <= modules.len, i++)
		if(modules[i]["number"] == EXTRTAB)
			modules.Cut(i, i+1)
			break
	to_chat(usr, "<span class='notice'>You remove \the [cartridge] from the [name].</span>")

//It's the 26th century. We should have smart watches by now.
/obj/item/device/communicator/watch
	name = "communicator watch"
	desc = "A personal device used to enable long range dialog between two people, utilizing existing telecommunications infrastructure to allow \
	communications across different cities, planets, or even star systems. You can wear this one on your wrist!"
	icon = 'icons/obj/device.dmi'
	icon_state = "commwatch"
	slot_flags = SLOT_GLOVES

/obj/item/device/communicator/watch/update_icon()
	if(video_source)
		icon_state = "commwatch-video"
		return

	if(voice_mobs.len || communicating.len)
		icon_state = "commwatch-active"
		return

	if(alert_called)
		icon_state = "commwatch-called"
		return

	icon_state = initial(icon_state)

//Id slot

/obj/item/device/communicator/proc/can_use()

	if(!ismob(loc))
		return 0

	var/mob/M = loc
	if(M.stat || M.restrained() || M.paralysis || M.stunned || M.weakened)
		return 0
	if((src in M.contents) || ( istype(loc, /turf) && in_range(src, M) ))
		playsound(loc, 'sound/machines/id_swipe.ogg', 100, 1)
		return 1
	else
		return 0

/obj/item/device/communicator/proc/remove_id()
	if (id)
		if (ismob(loc))
			var/mob/M = loc
			M.put_in_hands(id)
			playsound(loc, 'sound/machines/id_swipe.ogg', 100, 1)
			to_chat(usr, "<span class='notice'>You remove the ID from the [name].</span>")
		else
			id.loc = get_turf(src)
		id = null

/obj/item/device/communicator/AltClick()
	if(issilicon(usr))
		return

	if ( can_use(usr) )
		if(id)
			remove_id()
		else
			to_chat(usr, "<span class='notice'>This communicator does not have an ID in it.</span>")

/obj/item/device/communicator/GetAccess()
	if(id)
		return id.GetAccess()
	else
		return ..()

/obj/item/device/communicator/GetID()
	return id

/obj/item/device/communicator/verb/verb_remove_id()
	set category = "Object"
	set name = "Remove id"
	set src in usr

	if(issilicon(usr))
		return

	if ( can_use(usr) )
		if(id)
			remove_id()
		else
			to_chat(usr, "<span class='notice'>This communicator does not have an ID in it.</span>")
	else
		to_chat(usr, "<span class='notice'>You cannot do this while restrained.</span>")

/obj/item/device/communicator/proc/id_check(mob/user as mob, choice as num)//To check for IDs; 1 for in-pda use, 2 for out of pda use.
	if(choice == 1)
		if (id)
			remove_id()
			return 1
		else
			var/obj/item/I = user.get_active_hand()
			if (istype(I, /obj/item/weapon/card/id) && user.unEquip(I))
				I.loc = src
				id = I
			return 1
	else
		var/obj/item/weapon/card/I = user.get_active_hand()
		if (istype(I, /obj/item/weapon/card/id) && I:registered_name && user.unEquip(I))
			var/obj/old_id = id
			I.loc = src
			id = I
			user.put_in_hands(old_id)
			return 1
	return 0

/obj/item/device/communicator/Destroy()
	all_communicators -= src
	if (src.id && prob(90)) //IDs are kept in 90% of the cases
		src.id.forceMove(get_turf(src.loc))
	else
		QDEL_NULL(src.id)
	return ..()

	// Pen !
/obj/item/device/communicator/verb/verb_remove_pen()
	set category = "Object"
	set name = "Remove pen"
	set src in usr

	if(issilicon(usr))
		return

	if ( can_use(usr) )
		var/obj/item/weapon/pen/O = locate() in src
		if(O)
			if (istype(loc, /mob))
				var/mob/M = loc
				if(M.get_active_hand() == null)
					M.put_in_hands(O)
					to_chat(usr, "<span class='notice'>You remove \the [O] from \the [src].</span>")
					return
			O.loc = get_turf(src)
		else
			to_chat(usr, "<span class='notice'>This communicator does not have a pen in it.</span>")
	else
		to_chat(usr, "<span class='notice'>You cannot do this while restrained.</span>")


/obj/item/device/communicator/initial_data()		//This may be called by the attached computer.
	return computer.initial_data()

/obj/item/device/communicator/get_cell()
	if(computer)
		return computer.battery_module.get_cell()