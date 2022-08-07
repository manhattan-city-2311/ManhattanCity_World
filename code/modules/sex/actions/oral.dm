/datum/erp_action/blowjob
	name = "Минет"
	active_id = "blowjob"
	allowed_poses = list(
		list(POS_KNEELING, POS_STANDING),
		list(POS_KNEELING, POS_SITTING),
		list(POS_LYING	 , POS_LYING)
	)
	category = ERP_ACTION_CATEGORY_SEX
	sbp = SBP_ORAL
	needs_access = SBP_PENIS

/datum/erp_action/blowjob/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	var/list/poses = get_poses(user1, user2)
	switch(get_stage(user1))
		if(0)
			advance_stage(user1)
			if(poses ~= list(POS_KNEELING, POS_STANDING))
				return "@1 кивает для себя, берет член в руку и без особенных раздумий кладет его себе в рот, на язык, смотря вверх, на @2."
			else if(poses ~= list(POS_KNEELING, POS_SITTING))
				return "@1 хлопает себя по щекам и опускается ниже, поддевает член @2 носом, приподнимает и берёт его в рот."
			else
				return "@1 сползает пониже, утыкается лицом в член @2. Недолго раздумывая берет его в губы, начиная посасывать."
/datum/erp_action/blowjob/gentle
	name = "Нежный минет"
	action_type = ERP_ACTION_GENTLE

/datum/erp_action/blowjob/gentle/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	var/list/poses = get_poses(user1, user2)

	switch(get_stage(user1))
		if(0)
			advance_stage(user1)
			if(poses ~= list(POS_KNEELING, POS_STANDING))
				return "@1 касается носом бедра @2, проводит щекой по члену, целует головку, и наконец берет ее в рот, помогая себе руками."
			else if(poses ~= list(POS_KNEELING, POS_SITTING))
				return "@1 кладет ладони на бедра @2, и чуть пододвигается ближе, утыкается лицом а пах @2, вдыхает запах его кожи. Проводит своим языком по внутренней стороне бедра @2, и берет головку его члена в рот."
			else
				return "@1 подползает ближе к @2, и спускается ниже, [pronounce_helper(user1)] голова оказывается прямо напротив члена @2, и не долго думая @1 проводит языком по стволу снизу вверх, берет головку в рот."
		if(1)
			advance_stage(user1)
			if(poses ~= list(POS_KNEELING, POS_STANDING))
				return "@1 причмокивая начинает посасывать головку, смотря вверх, прямо на @2, умудряется немного улыбаться, работая губками."
			else if(poses ~= list(POS_KNEELING, POS_SITTING))
				return "@1 начинает посасывать головку, поглаживая бедра @2, несколько раз двигает головой, беря член поглубже."
			else
				return "@1 обводит головку языком, причмокивает губами. [pronounce_helper(user1, "Его", "Её")] глаза направлены в лицо @2."
		if(2)
			if(poses ~= list(POS_KNEELING, POS_STANDING))
				return "@1 берет ствол глубже, но все так же медленно и неспешно, по [pronounce_helper(user1)] подбородку стекает слюна."
			else if(poses ~= list(POS_KNEELING, POS_SITTING))
				return "@1 заглатывает член сильнее но не быстро, работая языком, плотно впиваясь пальцами в бедра @2."
			else
				return "@1 не отрывает глаз от лица @2, движет головой, пытаясь привнести динамики в свою работу, но чуть давится."
		
