#define PROGRESSBAR_ICON_HEIGHT 7

/client
	var/list/progressbars

/datum/progressbar
	var/goal = 1
	var/image/bar
	var/shown = 0
	var/mob/user
	var/client/client
	var/atom/target
	var/id

/datum/progressbar/New(mob/user, goal_number, atom/target)
	. = ..()
	if(!target)
		target = user
	if(!istype(target))
		EXCEPTION("Invalid target given")
	if(goal_number)
		goal = goal_number

	bar = image('icons/effects/progressbar.dmi', target, "prog_bar_0")
	bar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	bar.plane = PLANE_PLAYER_HUD
	bar.layer = LAYER_HUD_ABOVE

	src.user = user
	if(!user?.client)
		return
	client = user.client
	LAZYINITLIST(client.progressbars)
	client.progressbars[target] = client.progressbars[target] || 0
	id = client.progressbars[target]++
	src.target = target

/datum/progressbar/Destroy()
	if(client)
		client.images -= bar
		if(target in client.progressbars)
			if(--client.progressbars[target] <= 0)
				LAZYREMOVE(client.progressbars, target)
	QDEL_NULL(bar)
	user = null
	client = null
	return ..()

/datum/progressbar/proc/update(progress)
	if(!user || !user.client)
		shown = 0
		return
	if(user.client != client)
		if(client)
			client.images -= bar
			--client.progressbars[target]
			shown = 0
		id = client.progressbars[target]++

	progress = clamp(progress, 0, goal)

	if(id > client.progressbars[target])
		id = client.progressbars[target]

	bar.icon_state = "prog_bar_[round(((progress / goal) * 100), 2.5)]"
	bar.pixel_y = WORLD_ICON_SIZE + id * PROGRESSBAR_ICON_HEIGHT

	if(!shown && user.is_preference_enabled(/datum/client_preference/show_progress_bar))
		user.client.images += bar
		shown = 1

#undef PROGRESSBAR_ICON_HEIGHT
