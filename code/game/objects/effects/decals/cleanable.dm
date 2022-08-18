/obj/effect/decal/cleanable
	plane = DIRTY_PLANE
	var/persistent = FALSE
	var/generic_filth = FALSE
	var/age = 0
	var/list/random_icon_states = list()
	dont_save = FALSE

/obj/effect/decal/cleanable/on_persistence_load()
	. = ..()
	alpha = rand(180, 220)

/obj/effect/decal/cleanable/initialize(var/ml, var/_age)
	if(!isnull(_age))
		age = _age
	if(LAZYLEN(random_icon_states))
		icon_state = pick(random_icon_states)
	. = ..()

/obj/effect/decal/cleanable/clean_blood(var/ignore = 0)
	if(!ignore)
		qdel(src)
		return
	..()

/obj/effect/decal/cleanable/New()
	if (random_icon_states && length(src.random_icon_states) > 0)
		src.icon_state = pick(src.random_icon_states)
	..()
