// Thanks to Burger from Burgerstation for the foundation for this.
// This code was written by Chinsky for Nebula, I just made it compatible with Eris. - Matt
GLOBAL_LIST_INIT(floating_chat_colors, list())

/atom/movable
	var/list/stored_chat_text

/atom/movable/proc/animate_chat(message, datum/language/language, small, list/show_to, duration)
	set waitfor = FALSE

	var/style	//additional style params for the message
	var/fontsize = 5
	if(small)
		fontsize = 4
	var/limit = 50
	if(copytext(message, length(message) - 1) == "!!")
		fontsize = 8
		limit = 30
		style += "font-weight: bold;"

	if(length(message) > limit)
		message = "[copytext(message, 1, limit)]..."

	if(!GLOB.floating_chat_colors[name])
		GLOB.floating_chat_colors[name] = get_random_colour(0,160,230)
	style += "color: [GLOB.floating_chat_colors[name]];"
	// create 2 messages, one that appears if you know the language, and one that appears when you don't know the language
	var/image/understood = generate_floating_text(src, capitalize(message), style, fontsize, duration, show_to)
	var/image/gibberish = language ? generate_floating_text(src, language.scramble(message), style, fontsize, duration, show_to) : understood

	for(var/client/C in show_to)
		if(!isdeaf(C.mob) && C.is_preference_enabled(/datum/client_preference/floating_messages))
			if(C.mob.say_understands(null, language))
				C.images += understood
			else
				C.images += gibberish

/proc/generate_floating_text(atom/movable/holder, message, style, size, duration, show_to)
	var/image/I = image(null, holder)
	I.layer = FLY_LAYER
	I.alpha = 0
	I.maptext_width = 80
	I.maptext_height = 64
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	I.pixel_x = -round(I.maptext_width/2) + 16

	style = "font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: [size]px; [style]"
	I.maptext = "<center><span style=\"[style]\">[message]</span></center>"
	animate(I, 1, alpha = 255, pixel_y = 16)

	for(var/image/old in holder.stored_chat_text)
		animate(old, 2, pixel_y = old.pixel_y + 8)
	LAZYADD(holder.stored_chat_text, I)

	spawn(duration)
		remove_floating_text(holder, I)
	spawn(duration + 2)
		remove_images_from_clients(I, show_to)

	return I

/proc/remove_floating_text(atom/movable/holder, image/I)
	animate(I, 2, pixel_y = I.pixel_y + 10, alpha = 0)
	LAZYREMOVE(holder.stored_chat_text, I)

/proc/remove_images_from_clients(image/I, list/show_to)
	for(var/client/C in show_to)
		C.images -= I
		qdel(I)

/proc/refresh_lobby_browsers()
	for(var/mob/new_player/player in player_list)
		INVOKE_ASYNC(using_map, /datum/map/proc/show_titlescreen, player.client)
	return

/proc/change_lobbyscreen(new_screen)
	using_map.current_lobby_screen = new_screen || pick(using_map.lobby_screens)
	refresh_lobby_browsers()