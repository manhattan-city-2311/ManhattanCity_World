/datum/erp_action/passionate_look
	name = "Пристальный взгляд"

/datum/erp_action/passionate_look/is_available(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	if(!..())
		return FALSE

	switch(user1.get_position_id())
		if(POS_SITTING)
			switch(user2.get_position_id())
				if(POS_SITTING, POS_STANDING)
					return TRUE
		if(POS_STANDING)
			if(user2.get_position_id() == POS_SITTING)
				return TRUE
	return FALSE

/datum/erp_action/passionate_look/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	switch(user1.get_position_id())
		if(POS_SITTING)
			switch(user2.get_position_id())
				if(POS_SITTING)
					return list(
						"@1 оборачивается к @2, чуть наклоняется, и вот между ними уже почти не остаётся расстояния. Воздух тяжелеет."
					)
				if(POS_STANDING)
					return list(
						"@1 кивает себе и поднимается на ноги, оказываясь прямо лицом к лицу с @2, между ними практически нет расстояния, воздух горячеет."
					)
		if(POS_STANDING)
			if(user2.get_position_id() == POS_SITTING)
				return list(
					"@1 делает шаг вперёд и опускается пониже, оставаясь на одном уровне с @2, между ними всего пара сантиметров расстояния. Воздух тяжелеет."
				)
