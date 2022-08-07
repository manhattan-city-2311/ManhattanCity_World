/datum/erp_position
	var/name // used in "Вы: [name]"
	var/id

/datum/erp_position/standing
	name = "Стоя"
	id = POS_STANDING

/datum/erp_position/sitting
	name = "Сидя"
	id = POS_SITTING

/datum/erp_position/lying
	name = "Лёжа"
	id = POS_LYING

/datum/erp_position/kneeling
	name = "На коленях"
	id = POS_KNEELING
