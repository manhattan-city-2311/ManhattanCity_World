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
				return "@1 кивает для себя, берет член в руку и без особенных раздумий кладет его себе в рот, на язык, смотря вверх на @2."
			else if(poses ~= list(POS_KNEELING, POS_SITTING))
				return "@1 хлопает себя по щекам и опускается ниже, поддевает член @2 носом, приподнимает его и берёт в рот."
			else
				return "@1 сползает пониже, утыкается лицом в член @2. Недолго раздумывая берет его в губы и начинает посасывать."
		if(1)
			advance_stage(user1)
			if(poses ~= list(POS_KNEELING, POS_STANDING))
				return "@1 усердно посасывает ствол и головку, чуть помогая себе руками у основания, по подбородку @1 текут слюни."
			else if(poses ~= list(POS_KNEELING, POS_SITTING))
				return "@1 засасывает головку в рот, и отпускает с причмокиванием, облизывает ствол и снова берёт головку в рот."
			else
				return "@1 причмокивает губами и дразнит головку языком в своем рту, иногда берет глубже немного задыхаясь."
		if(2)
			if(poses ~= list(POS_KNEELING, POS_STANDING))
				return "@1 дёргает головой, насаживаясь ртом на ствол не до основания, задыхается, [pronounce_helper(user2)] лицо краснеет."
			else if(poses ~= list(POS_KNEELING, POS_SITTING))
				return "@1 активно засасывает чувствительную плоть, играя языком внутри своего рта, [pronounce_helper(user1)] глаза слезятся от усердия."
			else
				return "@1 довольно быстро двигает головой и плотно обхватывает ствол губами, практически дроча член @2 своим ртом."

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

/datum/erp_action/blowjob/passionate
	name = "Страстный минет"
	action_type = ERP_ACTION_PASSIONATE

/datum/erp_action/blowjob/passionate/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	var/list/poses = get_poses(user1, user2)

	switch(get_stage(user1))
		if(0)
			advance_stage(user1)
			if(poses ~= list(POS_KNEELING, POS_STANDING))
				return "@1 сглатывает и принюхивается, оказавшись напротив паха @2, затем резко движется вперёд, впиваясь ладонями в колени @2, прикасается щекой к члену, и трётся ею об него словно котёнок. Затуманеными глазами секунду смотрит в упор на член @2, в потом берет его в рот, да сразу по середину."
			else if(poses ~= list(POS_KNEELING, POS_SITTING))
				return "@1 оказавшись прямо перед членом @2, довольно улыбается, несколько раз облизывает свою ладонь и начинает ритмично надрачивать ствол, взяв головку в губы."
			else
				return "@1 сползает пониже, и начинает выцеловывать внутренние стороны бедер @2, лижет яички, и все это время довольно улыбается. Наконец [pronounce_helper(user1, "он", "она")] берет головку в губы."
		if(1)
			advance_stage(user1)
			if(poses ~= list(POS_KNEELING, POS_STANDING))
				return "@1 причмокивая и давясь [pronounce_helper(user1, "он", "она")] движет головой, заглатывая чувствительную плоть глубже, удерживаясь за колени @2."
			else if(poses ~= list(POS_KNEELING, POS_SITTING))
				return "@1 усердно сосет чувствительную головку, облизывая ту языком, и обильно капая слюной на себя же, так же работает ручками, наглажмвая ствол."
			else
				return "@1 плотно смыкает губы вокруг члена @2, и берется двигать головой в медетативном ритме, уложив свои ладони чуть выше бедер @2, и возвысившись над ним."
		if(2)
			if(poses ~= list(POS_KNEELING, POS_STANDING))
				return "@1 продолжает двигать головой, засасывая член глубже, высовывая язык наружу, [pronounce_helper(user1)] глаза закатываются."
			else if(poses ~= list(POS_KNEELING, POS_SITTING))
				return "@1 крутит кисти рук вокруг ствола, плотно сжимая его, губы @1 сильно заалели от усердной работы, раздаются громкие причмокивания."
			else
				return "@1 надавливает на живот @2 ладонями, заглатывает член практически до основания, задыхаясь, из [pronounce_helper(user1)] глаз текут слёзы от слюней перекрывших дыхание, лицо покраснело."
