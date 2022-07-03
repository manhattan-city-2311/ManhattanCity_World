//predominantly negative traits

/datum/quirk/blindness
	name = QUIRK_BLIND
	desc = "Ваши глаза повреждены, вы не смогли получить замену до этого момента."
	value = -8
	disability = TRUE
	mob_trait = TRAIT_BLIND
	gain_text = "<span class='danger'>Эй, кто выключил свет?</span>"
	lose_text = "<span class='notice'>К вам чудесным образом вернулось зрение!</span>"


/datum/quirk/cough
	name = QUIRK_COUGHING
	desc = "У вас неизлечимый хронический кашель."
	value = -1
	mob_trait = TRAIT_COUGH
	gain_text = "<span class='danger'>Вы не можете перестать кашлять!</span>"
	lose_text = "<span class='notice'>Вы чувствуете облегчение, кашель больше вас не побеспокоит.</span>"

	req_species_flags = list(
		NO_BREATHE = FALSE,
	)



/datum/quirk/deafness
	name = QUIRK_DEAF
	desc = "Вы полностью и неизлечимо глухи."
	value = -7
	disability = TRUE
	mob_trait = TRAIT_DEAF
	gain_text = "<span class='danger'>Тут подозрительно тихо.</span>"
	lose_text = "<span class='notice'>Вы снова слышите!</span>"



/datum/quirk/epileptic
	name = QUIRK_SEIZURES
	desc = "Вы испытываете эпилептические припадки."
	value = -4
	mob_trait = TRAIT_EPILEPSY
	gain_text = "<span class='danger'>Вы начинаете испытывать эпилептические припадки!</span>"
	lose_text = "<span class='notice'>Вы чувствуете облегчение, припадки больше вас не побеспокоят.</span>"

	req_species_flags = list(
		NO_EMOTION = FALSE,
	)



/datum/quirk/fatness
	name = QUIRK_FATNESS
	desc = "Вы заплываете жиром."
	value = -3
	mob_trait = TRAIT_FAT
	gain_text = "<span class='danger'>Вы чувствуете, что набрали несколько лишних килограмм.</span>"
	lose_text = "<span class='notice'>Вы снова в форме!</span>"

	req_species_flags = list(
		NO_FAT = FALSE,
		IS_PLANT = FALSE,
		IS_SYNTHETIC = FALSE,
	)


/datum/quirk/tourette
	name = QUIRK_TOURETTE
	desc = "У вас неизлечимые нервные тики."
	value = -2
	mob_trait = TRAIT_TOURETTE
	gain_text = "<span class='danger'>Вас начинает трясти!</span>"
	lose_text = "<span class='notice'>Вас перестаёт трясти.</span>"

	req_species_flags = list(
		NO_EMOTION = FALSE,
	)



/datum/quirk/nearsighted
	name = QUIRK_NEARSIGHTED
	desc = "Вы плохо видите без очков."
	value = -3
	mob_trait = TRAIT_NEARSIGHT
	gain_text = "<span class='danger'>Всё на расстоянии от вас выглядит размыто.</span>"
	lose_text = "<span class='notice'>Вы стали нормально видеть!</span>"


/datum/quirk/nervous
	name = QUIRK_NERVOUS
	desc = "Вы постоянно на взводе."
	value = -2
	mob_trait = TRAIT_NERVOUS
	gain_text = "<span class='danger'>Вы весь на нервах.</span>"
	lose_text = "<span class='notice'>Вы чувствуете себя более расслабленно.</span>"

	req_species_flags = list(
		NO_EMOTION = FALSE,
	)



/datum/quirk/stress_eater
	name = QUIRK_STRESS_EATER
	desc = "Когда вы испытываете боль, ваш голод усиливается."
	value = -2
	mob_trait = TRAIT_STRESS_EATER
	gain_text = "<span class='danger'>Когда вам больно, вы чувствуете неутолимый голод.</span>"
	lose_text = "<span class='notice'>Вы перестали заедать боль.</span>"

	req_species_flags = list(
		NO_PAIN = FALSE,
	)



/datum/quirk/mute
	name = QUIRK_MUTE
	desc = "Вы полностью и неизлечимо немы."
	disability = TRUE
	value = -6
	mob_trait = TRAIT_MUTE
	gain_text = "<span class='danger'>Голосовой аппарат ощущается странновато.</span>"
	lose_text = "<span class='notice'>Ваш голосовой аппарат, похоже, снова исправен.</span>"



/datum/quirk/light_drinker
	name = QUIRK_LIGHT_DRINKER
	desc = "Вы очень быстро напиваетесь."
	value = -1
	mob_trait = TRAIT_LIGHT_DRINKER
	gain_text = "<span class='danger'>От одной лишь мысли об алкоголе у вас кружится голова.</span>"
	lose_text = "<span class='notice'>Вы перестали быть слишком чувствительными к алкоголю.</span>"

	req_species_flags = list(
		IS_PLANT = FALSE,
		IS_SYNTHETIC = FALSE,
	)


/datum/quirk/genetic_degradation
	name = QUIRK_GENETIC_DEGRADATION
	desc = "Ваше ДНК повреждено, ваша регенерация медленна и непредсказуема."
	value = -3

	mob_trait = TRAIT_NO_CLONE
	
	req_species_flags = list(
		NO_DNA = FALSE,
		NO_SCAN = FALSE,
		IS_PLANT = FALSE,
		IS_SYNTHETIC = FALSE,
	)

/datum/quirk/heartproblem
	name = QUIRK_HEARTPROBLEM
	desc = "Ваше сердце уже пережило своё время, и значительно слабее."
	value = -3

/datum/quirk/heartfailure
	name = QUIRK_HEARTFAILURE
	desc = "Ваше сердце постепенно теряет свою способность качать кровь, вам срочно нужно получить новое, или умереть..."
	value = -10

/datum/quirk/asthtmatic
	name = QUIRK_ASTHTMATIC
	desc = "Ваши лёгкие постепенно ослабевают, без постоянного приёма медикаментов вы быстро умрёте."
	value = -4

/datum/quirk/transplant
	name = QUIRK_TRANSPLANT
	desc = "Один из ваших органов - не ваш. Вам нужно постоянно принимать имунносупрессоры, иначе ваша имунная быстро уничтожит его."
	value = -6

/datum/quirk/smoking
	name = QUIRK_SMOKING
	desc = "Вы зависимы от никотина."
	value = -1