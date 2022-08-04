/datum/erp_position
	var/name // used in "Вы: [name]"
	var/id

/datum/erp_position/standing
	name = "стоите"
	id = POS_STANDING

/datum/erp_position/sitting
	name = "сидите"
	id = POS_SITTING

/datum/erp_position/lying
	name = "лежите"
	id = POS_LYING

/datum/erp_position/kneeling
	name = "на коленях"
	id = POS_KNEELING
