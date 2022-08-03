/mob/living/carbon/human/npc
    var/social_score = 0 //Влияет на отношения между перснажами, 0-100

    var/smell = 0 
    var/popularity = 0

    var/anger_if_pulled = FALSE //TRUE - Атака при грабе/пулле
    var/paranoid = FALSE 

    var/intelligence = INTELLIGENCE_STUPID //Определяет интеллект ИИ
    var/reaction_time = 6

/mob/living/carbon/human/npc/proc/get_sexuality() //Depends on the amount of naked bodyparts
	return 0

/mob/living/carbon/human/npc/proc/get_physical_attractiveness() //Depends on health
	return 100