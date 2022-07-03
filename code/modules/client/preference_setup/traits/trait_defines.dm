// This contains character setup datums for traits.
// The actual modifiers (if used) for these are stored inside code/modules/mob/_modifiers/traits.dm

/datum/trait/modifier
	var/modifier_type = null // Type to add to the mob post spawn.

/datum/trait/modifier/apply_trait_post_spawn(mob/living/L)
	L.add_modifier(modifier_type)

/datum/trait/modifier/generate_desc()
	var/new_desc = desc
	if(!modifier_type)
		new_desc = "[new_desc] This trait is not implemented yet."
		return new_desc
	var/datum/modifier/M = new modifier_type()
	if(!desc)
		new_desc = M.desc // Use the modifier's description, if the trait doesn't have one defined.
	var/modifier_effects = M.describe_modifier_effects()
	new_desc = "[new_desc][modifier_effects ? "<br>[modifier_effects]":""]" // Now describe what the trait actually does.
	qdel(M)
	return new_desc


// Physical traits are what they sound like, and involve the character's physical body, as opposed to their mental state.
/datum/trait/modifier/physical
	category = "Телесные"


/datum/trait/modifier/physical/flimsy
	name = "Хрупкий"
	desc = "Вы более хрупки, чем большинство, и у вас меньше возможностей терпеть вред."
	modifier_type = /datum/modifier/trait/flimsy
	mutually_exclusive = list(/datum/trait/modifier/physical/frail)


/datum/trait/modifier/physical/frail
	name = "Хилый"
	desc = "Ваше тело очень хрупкое и еще меньше способно переносить вред."
	modifier_type = /datum/modifier/trait/frail
	mutually_exclusive = list(/datum/trait/modifier/physical/flimsy)


/datum/trait/modifier/physical/haemophilia
	name = "Гемофилия"
	desc = "Вы быстро истекаете кровью"
	modifier_type = /datum/modifier/trait/haemophilia

/datum/trait/modifier/physical/haemophilia/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics cannot bleed."
	// If a species lacking blood is added, it is suggested to add a check for them here.
	return ..()


/datum/trait/modifier/physical/weak
	name = "Слабый"
	desc = "Недостаток физической силы снижает возможности к ближнем бою."
	modifier_type = /datum/modifier/trait/weak
	mutually_exclusive = list(/datum/trait/modifier/physical/wimpy)


/datum/trait/modifier/physical/wimpy
	name = "Хлюпик"
	desc = "Чрезвычайная нехватка физической силы приводит к значительному снижению способностей к ближнему бою."
	modifier_type = /datum/modifier/trait/wimpy
	mutually_exclusive = list(/datum/trait/modifier/physical/weak)


/datum/trait/modifier/physical/inaccurate
	name = "Неточный"
	desc = "Ты неопытен в обращении с оружием, ты никогда в жизни им не пользовался, или очень давно. \
	Вам довольно сложно попасть туда, куда вы хотите."
	modifier_type = /datum/modifier/trait/inaccurate

/datum/trait/modifier/physical/shorter
	name = "Очень низкий"
	desc = "Небольшой рост увеличивает вашу устойчивость и улучшает кровообращение."
	modifier_type = /datum/modifier/trait/shorter
	mutually_exclusive = list(/datum/trait/modifier/physical/short, /datum/trait/modifier/physical/tall, /datum/trait/modifier/physical/taller)

/datum/trait/modifier/physical/short
	name = "Низкий"
	modifier_type = /datum/modifier/trait/short
	mutually_exclusive = list(/datum/trait/modifier/physical/shorter, /datum/trait/modifier/physical/tall, /datum/trait/modifier/physical/taller)

/datum/trait/modifier/physical/tall
	name = "Высокий"
	modifier_type = /datum/modifier/trait/tall
	mutually_exclusive = list(/datum/trait/modifier/physical/shorter, /datum/trait/modifier/physical/short, /datum/trait/modifier/physical/taller)

/datum/trait/modifier/physical/taller
	name = "Очень высокий"
	desc = "Большой рост понижает вашу устойчивость и способность сердца качать кровь. \
	Вам легче накладывать шины и оказывать первую помощь, проводить инженерные работы и управлять транспортом."
	modifier_type = /datum/modifier/trait/taller
	mutually_exclusive = list(/datum/trait/modifier/physical/shorter, /datum/trait/modifier/physical/short, /datum/trait/modifier/physical/tall)

/datum/trait/modifier/physical/thin
	name = "Худой"
	modifier_type = /datum/modifier/trait/thin
	mutually_exclusive = list(/datum/trait/modifier/physical/fat, /datum/trait/modifier/physical/obese, /datum/trait/modifier/physical/thinner)
	selectable = 0
/datum/trait/modifier/physical/thin/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics cannot gain or lose weight."
	return ..()

/datum/trait/modifier/physical/thinner
	name = "Дрыщ"
	modifier_type = /datum/modifier/trait/thinner
	mutually_exclusive = list(/datum/trait/modifier/physical/fat, /datum/trait/modifier/physical/obese, /datum/trait/modifier/physical/thin)
	selectable = 0
/datum/trait/modifier/physical/thinner/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics cannot gain or lose weight."
	return ..()

/datum/trait/modifier/physical/fat
	name = "Толстый"
	modifier_type = /datum/modifier/trait/fat
	mutually_exclusive = list(/datum/trait/modifier/physical/thin, /datum/trait/modifier/physical/obese, /datum/trait/modifier/physical/thinner)
	selectable = 0
/datum/trait/modifier/physical/fat/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics cannot gain or lose weight."
	return ..()

/datum/trait/modifier/physical/obese
	name = "Жирдяй"
	modifier_type = /datum/modifier/trait/obese
	mutually_exclusive = list(/datum/trait/modifier/physical/fat, /datum/trait/modifier/physical/thinner, /datum/trait/modifier/physical/thin)
	selectable = 0
/datum/trait/modifier/physical/obese/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics cannot gain or lose weight."
	return ..()

// These two traits might be borderline, feel free to remove if they get abused.
/datum/trait/modifier/physical/high_metabolism
	name = "Высокий метаболизм"
	modifier_type = /datum/modifier/trait/high_metabolism
	mutually_exclusive = list(/datum/trait/modifier/physical/low_metabolism)

/datum/trait/modifier/physical/high_metabolism/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics do not have a metabolism."
	return ..()


/datum/trait/modifier/physical/low_metabolism
	name = "Низкий метаболизм"
	modifier_type = /datum/modifier/trait/low_metabolism
	mutually_exclusive = list(/datum/trait/modifier/physical/high_metabolism)

/datum/trait/modifier/physical/low_metabolism/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics do not have a metabolism."
	return ..()


/datum/trait/modifier/physical/cloned
	name = "Клонированный"
	desc = "Когда-то вас клонировали."
	modifier_type = /datum/modifier/cloned

/datum/trait/modifier/physical/cloned/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics cannot be cloned."
	return ..()


/datum/trait/modifier/physical/no_clone
	name = "Генетическое повреждение"
	desc = "Ваше ДНК повреждено, вас не могут клонировать. Регенерация и фильтрация крови ослаблена."
	modifier_type = /datum/modifier/no_clone

/datum/trait/modifier/physical/no_clone/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics cannot be cloned anyways."
	return ..()


/datum/trait/modifier/physical/no_borg
	name = "Не совместим с кибернетикой"
	modifier_type = /datum/modifier/no_borg

/datum/trait/modifier/physical/no_borg/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics are already partly or fully mechanical."
	return ..()



// 'Mental' traits are just those that only sapients can have, for now, and generally involves fears.
// So far, all of them are just for fluff/don't have mechanical effects.
/datum/trait/modifier/mental
	category = "Фобии"

/datum/trait/modifier/mental/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		if(setup.get_FBP_type() == PREF_FBP_SOFTWARE)
			return "Drone Intelligences cannot feel emotions."
	return ..()


/datum/trait/modifier/mental/arachnophobe
	name = "Арахнофоб"
	desc = "Вы очень сильно боитесь пауков."
	modifier_type = /datum/modifier/trait/phobia/arachnophobe


/datum/trait/modifier/mental/nyctophobe
	name = "Никтофоб"
	desc = "Вы боитесь темноты."
	modifier_type = /datum/modifier/trait/phobia/nyctophobe


/datum/trait/modifier/mental/haemophobe
	name = "Гемофобия"
	desc = "Вы очень боитесь крови."
	modifier_type = /datum/modifier/trait/phobia/haemophobia


/datum/trait/modifier/mental/claustrophobe
	name = "Клаустрофоб"
	desc = "Вы боитесь маленьких пространств."
	modifier_type = /datum/modifier/trait/phobia/claustrophobe


/datum/trait/modifier/mental/blennophobe
	name = "Бленнофобия"
	desc = "Слаймы очень пугают вас."
	modifier_type = /datum/modifier/trait/phobia/blennophobe

/datum/trait/modifier/mental/trypanophobe
	name = "Трипанофобия"
	desc = "Вы боитесь шприцов"
	modifier_type = /datum/modifier/trait/phobia/trypanophobe

/datum/trait/modifier/physical/colorblind_protanopia
	name = "Протанопия"
	desc = "У вас форма красно-зеленого дальтонизма. Вы не видите красные цвета и с трудом отличаете их от желтых и зеленых."
	modifier_type = /datum/modifier/trait/colorblind_protanopia
	mutually_exclusive = list(/datum/trait/modifier/physical/colorblind_deuteranopia, /datum/trait/modifier/physical/colorblind_tritanopia, /datum/trait/modifier/physical/colorblind_monochrome)

/datum/trait/modifier/physical/colorblind_deuteranopia
	name = "Дейтеранопия"
	desc = "У вас форма красно-зеленого дальтонизма. Вы не видите зеленые цвета и с трудом отличаете их от желтых и красных."
	modifier_type = /datum/modifier/trait/colorblind_deuteranopia
	mutually_exclusive = list(/datum/trait/modifier/physical/colorblind_protanopia, /datum/trait/modifier/physical/colorblind_tritanopia, /datum/trait/modifier/physical/colorblind_monochrome)

/datum/trait/modifier/physical/colorblind_tritanopia
	name = "Тританопия"
	desc = "У вас форма сине-желтой дальтонизма. Вы с трудом различаете синий, зеленый и желтый цвета и видите синий и фиолетовый цвета тусклые."
	modifier_type = /datum/modifier/trait/colorblind_tritanopia
	mutually_exclusive = list(/datum/trait/modifier/physical/colorblind_protanopia, /datum/trait/modifier/physical/colorblind_deuteranopia, /datum/trait/modifier/physical/colorblind_monochrome)

/datum/trait/modifier/physical/colorblind_monochrome
	name = "Монохромность"
	desc = "Вы полный дальтоник. Ваше состояние редкое, но вы вообще не видите цветов."
	modifier_type = /datum/modifier/trait/colorblind_monochrome
	mutually_exclusive = list(/datum/trait/modifier/physical/colorblind_protanopia, /datum/trait/modifier/physical/colorblind_deuteranopia, /datum/trait/modifier/physical/colorblind_tritanopia)

/*
// Uncomment this when/if these get finished.
/datum/trait/modifier/mental/synthphobe
	name = "Synthphobic"
	desc = "You know, deep down, that synthetics cannot be trusted, and so you are always on guard whenever you see one wandering around.  No one knows how a Positronic's mind works, \
	Drones are just waiting for the right time for Emergence, and the poor brains trapped in the cage of Man Machine Interfaces are now soulless, despite being unaware of it.  None \
	can be trusted."

/datum/trait/modifier/mental/xenophobe
	name = "Xenophobic"
	desc = "The mind of the Alien is unknowable, and as such, their intentions cannot be known.  You always watch the xenos closely, as they most certainly are watching you \
	closely, waiting to strike."
	mutually_exclusive = list(
		/datum/trait/modifier/mental/humanphobe,
		/datum/trait/modifier/mental/skrellphobe,
		/datum/trait/modifier/mental/tajaraphobe,
		/datum/trait/modifier/mental/unathiphobe,
		/datum/trait/modifier/mental/teshariphobe,
		/datum/trait/modifier/mental/prometheanphobe
	)

/datum/trait/modifier/mental/humanphobe
	name = "Human-phobic"
	desc = "Boilerplate racism for monkeys goes here."
	mutually_exclusive = list(/datum/trait/modifier/mental/xenophobe)

/datum/trait/modifier/mental/skrellphobe
	name = "Skrell-phobic"
	desc = "Boilerplate racism for squid goes here."
	mutually_exclusive = list(/datum/trait/modifier/mental/xenophobe)

/datum/trait/modifier/mental/tajaraphobe
	name = "Tajaran-phobic"
	desc = "Boilerplate racism for cats goes here."
	mutually_exclusive = list(/datum/trait/modifier/mental/xenophobe)

/datum/trait/modifier/mental/unathiphobe
	name = "Unathi-phobic"
	desc = "Boilerplate racism for lizards goes here."
	mutually_exclusive = list(/datum/trait/modifier/mental/xenophobe)

// Not sure why anyone would hate/fear these guys but for the sake of completeness here we are.
/datum/trait/modifier/mental/dionaphobe
	name = "Diona-phobic"
	desc = "Boilerplate racism for trees goes here."
	mutually_exclusive = list(/datum/trait/modifier/mental/xenophobe)

/datum/trait/modifier/mental/teshariphobe
	name = "Teshari-phobic"
	desc = "Boilerplate racism for birds goes here."
	mutually_exclusive = list(/datum/trait/modifier/mental/xenophobe)

/datum/trait/modifier/mental/prometheanphobe
	name = "Promethean-phobic"
	desc = "Boilerplate racism for jellos goes here."
	mutually_exclusive = list(/datum/trait/modifier/mental/xenophobe)
*/
