#define RUNECHAT_SPAWN_TIME		0.2 SECONDS
#define RUNECHAT_LIFESPAN		5 SECONDS
#define RUNECHAT_EOL_FADE		0.7 SECONDS
#define RUNECHAT_WIDTH			96 // pixels
#define RUNECHAT_MAX_LENGTH		110 // characters
#define WXH_TO_HEIGHT(x)		text2num(copytext((x), findtextEx((x), "x") + 1)) // thanks lummox

#define RC_COLOR_SAT_MIN   0.6
#define RC_COLOR_SAT_MAX   0.7
#define RC_COLOR_LUM_MIN   0.65
#define RC_COLOR_LUM_MAX   0.75

/mob
	var/runechat_last_voice
	var/runechat_color
	var/runechat_font = "Small Fonts"

/mob/proc/generate_runechat_color()
	var/voice = name
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		voice = H.GetVoice()

	if(runechat_last_voice == voice)
		return

	runechat_last_voice = voice

	var/hash = copytext(md5(voice), 1, 6)
	var/h = hex2num(copytext(hash, 1, 3)) * (360 / 255)
	var/s = (hex2num(copytext(hash, 3, 5)) >> 2) * ((RC_COLOR_SAT_MAX - RC_COLOR_SAT_MIN) / 63) + RC_COLOR_SAT_MIN
	var/l = (hex2num(copytext(hash, 5, 7)) >> 2) * ((RC_COLOR_LUM_MAX - RC_COLOR_LUM_MIN) / 63) + RC_COLOR_LUM_MIN

	var/h_int = round(h / 60) // mapping each section of H to 60 degree sections
	var/c = (1 - abs(2 * l - 1)) * s
	var/x = c * (1 - abs((h / 60) % 2 - 1))
	var/m = l - c * 0.5
	x = (x + m) * 255
	c = (c + m) * 255
	m *= 255
	switch(h_int)
		if(0)
			runechat_color = "#[num2hex(c, 2)][num2hex(x, 2)][num2hex(m, 2)]"
		if(1)
			runechat_color = "#[num2hex(x, 2)][num2hex(c, 2)][num2hex(m, 2)]"
		if(2)
			runechat_color = "#[num2hex(m, 2)][num2hex(c, 2)][num2hex(x, 2)]"
		if(3)
			runechat_color = "#[num2hex(m, 2)][num2hex(x, 2)][num2hex(c, 2)]"
		if(4)
			runechat_color = "#[num2hex(x, 2)][num2hex(m, 2)][num2hex(c, 2)]"
		if(5)
			runechat_color = "#[num2hex(c, 2)][num2hex(m, 2)][num2hex(x, 2)]"

/client
	var/list/datum/runechat_message_holder/seen_runechat_messages

/datum/runechat_message_holder
	var/image/image
	var/lines
	var/client/client
	var/loc

/datum/runechat_message_holder/Destroy()
	LAZYREMOVE(client.seen_runechat_messages[loc], src)
	UNSETEMPTY(client.seen_runechat_messages[loc])
	UNSETEMPTY(client.seen_runechat_messages)

/datum/runechat_message_holder/proc/fadeout()
	animate(image, alpha = 0, time = RUNECHAT_EOL_FADE, flags = ANIMATION_PARALLEL)
	spawn(RUNECHAT_EOL_FADE)
		qdel(src)

/mob/handle_hear(text, italics, mob/speaker)
	. = ..()

	if(!client)
		return

	if(length_char(text) > RUNECHAT_MAX_LENGTH)
		text = copytext_char(text, 1, RUNECHAT_MAX_LENGTH + 1) + "…"

	var/static/regex/url_scheme = new(@"[A-Za-z][A-Za-z0-9+-\.]*:\/\/", "g")
	text = replacetext(text, url_scheme, "")

	// Reject whitespace
	var/static/regex/whitespace = new(@"^\s*$")
	if (whitespace.Find(text))
		return

	var/datum/runechat_message_holder/msg = new

	var/message_loc
	
	var/speaker_loc = speaker
	if(!isturf(speaker.loc))
		speaker_loc = speaker.loc

	if(!(speaker_loc in view(src)))
		return

	message_loc = speaker_loc

	var/maptext_style = "font-family: '[speaker.runechat_font]';"
	var/shadow_color = "0 2px 3px black"
	var/style = "color:[speaker.runechat_color]; text-shadow: [shadow_color]; [maptext_style]"
	var/complete_text = "<center><span style=\"[style]\">[text]</span></center>"

	var/static/regex/html_metachars = new(@"&[A-Za-z]{1,7};", "g")
	var/mheight = WXH_TO_HEIGHT(client.MeasureText(replacetext(complete_text, html_metachars, "m"), null, RUNECHAT_WIDTH))

	if(client.seen_runechat_messages)
		for(var/datum/runechat_message_holder/M as anything in client.seen_runechat_messages[message_loc])
			animate(M.image, pixel_y = M.image.pixel_y + mheight, time = RUNECHAT_SPAWN_TIME)

	msg.image = image(loc = message_loc, layer = LAYER_HUD_RUNECHAT)

	var/image/message       = msg.image
	message.plane           = PLANE_PLAYER_HUD
	message.appearance_flags= APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	message.maptext_width 	= RUNECHAT_WIDTH
	message.maptext_height 	= mheight
	message.maptext_x       = (RUNECHAT_WIDTH - bound_width) * -0.5
	message.maptext         = complete_text
	message.alpha           = 0

	msg.client = client
	msg.loc    = message_loc

	LAZYINITLIST(client.seen_runechat_messages)
	LAZYINITLIST(client.seen_runechat_messages[message_loc])

	client.seen_runechat_messages[message_loc] += msg
	client.images += message

	animate(message, pixel_y = bound_height * 0.95, time = RUNECHAT_SPAWN_TIME, flags = ANIMATION_PARALLEL)
	animate(message, alpha = 255, time = RUNECHAT_SPAWN_TIME, flags = ANIMATION_PARALLEL)

	spawn(RUNECHAT_LIFESPAN - RUNECHAT_EOL_FADE)
		msg?.fadeout()
