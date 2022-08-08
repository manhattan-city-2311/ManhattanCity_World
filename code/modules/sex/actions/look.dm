/datum/erp_action/passionate_look
	name = "Пристальный взгляд"
	category = ERP_ACTION_CATEGORY_FOREPLAY
	allowed_poses = list(
		list(POS_SITTING, POS_SITTING),
		list(POS_SITTING, POS_STANDING),
		list(POS_STANDING, POS_SITTING)
	)
	sbp = SBP_FACE
	needs_access = SBP_FACE
	base_pleasure = list(1, 1)
	action_type = ERP_ACTION_PASSIONATE

/datum/erp_action/passionate_look/get_messages(user1, user2)
	var/list/poses = get_poses(user1, user2)

	if(poses ~= list(POS_SITTING, POS_SITTING))
		return list(
			"@1 оборачивается к @2, чуть наклоняется, и вот между ними уже почти не остаётся расстояния. Воздух тяжелеет..."
		)
	if(poses ~= list(POS_SITTING, POS_STANDING))
		return list(
			"@1 кивает себе и поднимается на ноги, оказываясь прямо лицом к лицу с @2, между ними практически нет расстояния, воздух горячеет."
		)
	if(poses ~= list(POS_STANDING, POS_SITTING))
		return list(
			"@1 делает шаг вперёд и опускается пониже, оставаясь на одном уровне с @2, между ними всего пара сантиметров расстояния. Воздух тяжелеет."
		)
