/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff, is_global, frequency = null, channel = 0, pressure_affected = TRUE, ignore_walls = TRUE, preference = null)
	if(isarea(source))
		throw EXCEPTION("playsound(): source is an area")
		return

	var/turf/turf_source = get_turf(source)

	//allocate a channel if necessary now so its the same for everyone
	channel = channel || open_sound_channel()

 	// Looping through the player list has the added bonus of working for mobs inside containers
	var/sound/S = sound(get_sfx(soundin))
	var/maxdistance = (8 + extrarange) * 3
	var/list/listeners = player_list
	if(!ignore_walls) //these sounds don't carry through walls
		listeners = listeners & hearers(maxdistance,turf_source)
	for(var/P in listeners)
		var/mob/M = P
		if(!M || !M.client)
			continue
		var/turf/T = get_turf(M)
		var/distance = get_dist(T, turf_source)

		if(distance <= maxdistance)
			if(T && T.z == turf_source.z)
				M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff, is_global, channel, pressure_affected, S)

/mob/proc/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff, is_global, channel = 0, pressure_affected = FALSE, sound/S, preference)
	if(!client || ear_deaf > 0)
		return
	if(preference && !client.is_preference_enabled(preference))
		return

	if(!S)
		S = sound(get_sfx(soundin))

	S.wait = 0 //No queue
	S.channel = channel || open_sound_channel()
	S.volume = vol

	if(vary)
		if(frequency)
			S.frequency = frequency
		else
			S.frequency = get_rand_frequency()

	if(isturf(turf_source))
		var/turf/T = get_turf(src)

		//sound volume falloff with distance
		var/distance = get_dist(T, turf_source)

		S.volume -= max(distance - 8, 0) * 2 //multiplicative falloff to add on top of natural audio falloff.

		//Don't bother with doing anything below.
		if(S.volume <= 0)
			return //No sound

		//Apply a sound environment.
		if(!is_global)
			S.environment = get_sound_env(1)

		var/dx = turf_source.x - T.x // Hearing from the right/left
		S.x = dx
		var/dz = turf_source.y - T.y // Hearing from infront/behind
		S.z = dz
		// The y value is for above your head, but there is no ceiling in 2d spessmens.
		S.y = 1
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)

	src << S

/proc/sound_to_playing_players(sound, volume = 100, vary)
	sound = get_sfx(sound)
	for(var/M in player_list)
		if(ismob(M) && !isnewplayer(M))
			var/mob/MO = M
			MO.playsound_local(get_turf(MO), sound, volume, vary, pressure_affected = FALSE)

/proc/open_sound_channel()
	var/static/next_channel = 1	//loop through the available 1024 - (the ones we reserve) channels and pray that its not still being used
	. = ++next_channel
	if(next_channel > CHANNEL_HIGHEST_AVAILABLE)
		next_channel = 1

/mob/proc/stop_sound_channel(chan)
	src << sound(null, repeat = 0, wait = 0, channel = chan)

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/client/proc/playtitlemusic()
	if(!ticker || !ticker.login_music)	return
	if(is_preference_enabled(/datum/client_preference/play_lobby_music))
		src << sound(ticker.login_music, repeat = 0, wait = 0, volume = 50, channel = 1) // MAD JAMS

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg')
			if ("explosion") soundin = pick('sound/effects/Explosion1.ogg','sound/effects/Explosion2.ogg','sound/effects/Explosion3.ogg','sound/effects/Explosion4.ogg','sound/effects/Explosion5.ogg','sound/effects/Explosion6.ogg')
			if ("sparks") soundin = pick('sound/effects/sparks1.ogg','sound/effects/sparks2.ogg','sound/effects/sparks3.ogg','sound/effects/sparks5.ogg','sound/effects/sparks6.ogg','sound/effects/sparks7.ogg')
			if ("rustle") soundin = pick('sound/effects/rustle1.ogg','sound/effects/rustle2.ogg','sound/effects/rustle3.ogg','sound/effects/rustle4.ogg','sound/effects/rustle5.ogg')
			if ("punch") soundin = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
			if ("clownstep") soundin = pick('sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg')
			if ("swing_hit") soundin = pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
			if ("hiss") soundin = pick('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
			if ("sharp") soundin = pick('sound/effects/sound_effects_gore_stab1.ogg', 'sound/effects/sound_effects_gore_stab2.ogg', 'sound/effects/sound_effects_gore_stab3.ogg')
			if ("chop") soundin = pick('sound/effects/sound_effects_gore_chop.ogg', 'sound/effects/sound_effects_gore_chop2.ogg', 'sound/effects/sound_effects_gore_chop3.ogg', 'sound/effects/sound_effects_gore_chop4.ogg', 'sound/effects/sound_effects_gore_chop5.ogg', 'sound/effects/sound_effects_gore_chop6.ogg')
			if ("pageturn") soundin = pick('sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg')
			if ("fracture") soundin = pick('sound/effects/sound_effects_gore_trauma1.ogg', 'sound/effects/sound_effects_gore_trauma2.ogg', 'sound/effects/sound_effects_gore_trauma3.ogg')
			if ("canopen") soundin = pick('sound/effects/can_open1.ogg','sound/effects/can_open2.ogg','sound/effects/can_open3.ogg','sound/effects/can_open4.ogg')
			if ("mechstep") soundin = pick('sound/mecha/mechstep1.ogg', 'sound/mecha/mechstep2.ogg')
			if ("geiger") soundin = pick('sound/items/geiger1.ogg', 'sound/items/geiger2.ogg', 'sound/items/geiger3.ogg', 'sound/items/geiger4.ogg', 'sound/items/geiger5.ogg')
			if ("geiger_weak") soundin = pick('sound/items/geiger_weak1.ogg', 'sound/items/geiger_weak2.ogg', 'sound/items/geiger_weak3.ogg', 'sound/items/geiger_weak4.ogg')
			if ("keyboard") soundin = pick('sound/effects/keyboard/keyboard1.ogg','sound/effects/keyboard/keyboard2.ogg','sound/effects/keyboard/keyboard3.ogg', 'sound/effects/keyboard/keyboard4.ogg')
			if ("thunder") soundin = pick('sound/effects/thunder/thunder1.ogg', 'sound/effects/thunder/thunder2.ogg', 'sound/effects/thunder/thunder3.ogg', 'sound/effects/thunder/thunder4.ogg',
			'sound/effects/thunder/thunder5.ogg', 'sound/effects/thunder/thunder6.ogg', 'sound/effects/thunder/thunder7.ogg', 'sound/effects/thunder/thunder8.ogg', 'sound/effects/thunder/thunder9.ogg',
			'sound/effects/thunder/thunder10.ogg')

	return soundin

//Are these even used?

var/list/casing_sound = list ('sound/weapons/casingfall1.ogg','sound/weapons/casingfall2.ogg','sound/weapons/casingfall3.ogg')
var/list/keyboard_sound = list ('sound/effects/keyboard/keyboard1.ogg','sound/effects/keyboard/keyboard2.ogg','sound/effects/keyboard/keyboard3.ogg', 'sound/effects/keyboard/keyboard4.ogg')
var/list/bodyfall_sound = list('sound/effects/bodyfall1.ogg','sound/effects/bodyfall2.ogg','sound/effects/bodyfall3.ogg','sound/effects/bodyfall4.ogg')

/client/verb/stop_sounds()
	set name = "Stop All Sounds"
	set desc = "Stop all sounds that are currently playing on your client."
	set category = "OOC"

	sound_to(usr, sound(null))