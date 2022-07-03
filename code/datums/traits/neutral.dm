/datum/quirk/high_pain_threshold
	name = QUIRK_HIGH_PAIN_THRESHOLD
	desc = "Вы легче переносите боль. Эта особенность влияет лишь на звуки, издаваемые вами."
	value = 0
	mob_trait = TRAIT_HIGH_PAIN_THRESHOLD
	gain_text = "<span class='danger'>Вы хотите показать, насколько вы сильны. Вы попытаетесь игнорировать любую боль.</span>"
	lose_text = "<span class='notice'>Вы устали превозмогать боль.</span>"

	req_species_flags = list(
		NO_PAIN = FALSE,
	)



/datum/quirk/low_pain_threshold
	name = QUIRK_LOW_PAIN_THRESHOLD
	desc = "Боль для вас более мучительна. Эта особенность влияет лишь на звуки, издаваемые вами. "
	value = 0
	mob_trait = TRAIT_LOW_PAIN_THRESHOLD
	gain_text = "<span class='danger'>От одной лишь мысли о боли вас начинает трясти от страха.</span>"
	lose_text = "<span class='notice'>Вы больше не хотите казаться слизняком в глазах окружающих. Теперь вы будете пытаться игнорировать боль.</span>"

	req_species_flags = list(
		NO_PAIN = FALSE,
	)

/datum/quirk/daltonism
	name = QUIRK_DALTONISM
	desc = "Вы не различаете цвета."
	value = 0
	mob_trait = TRAIT_DALTONISM
	gain_text = "<span class='notice'>Вы перестали различать цвета!</span>"
	lose_text = "<span class='notice'>Вы снова можете насладиться красками этого мира!</span>"

	var/current_type = "greyscale"

/datum/quirk/daltonism/post_add()
	var/mob/living/carbon/human/H = quirk_holder

	var/list/types = list(
		"Серый"            = "greyscale",
		"Красный"             = "thermal",
		"Синий"            = "rbg_d",
		"Тёмно зелёный"      = "nvg_military",
		"Зелёный"           = "meson",
		"Оранжевый"          = "sepia",
		"Жёлтый-синий"     = "bgr_d",
		"Фиолетовый-жёлтый"     = "brg_d",
		"Зелёный-синий"      = "gbr_d",
		"Фиолетовый-красный"      = "grb_d",
		)

	var/choose = input(H, "Выберите тип дальтонизма", "Цвет") in types
	current_type = types[choose]