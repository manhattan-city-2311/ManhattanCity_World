#define INTELLIGENCE_STUPID 0
#define INTELLIGENCE_AVERAGE 1
#define INTELLIGENCE_SMART 2

/mob/living/carbon/human/npc
    var/social_score = 0 //Влияет на отношения между перснажами

    var/sexuality = 0 //Зависит от количества обнаженных частей тела
    var/physical_attractiveness = 0 //Зависит от здоровья
    var/smell = 0 
    var/popularity = 0

    var/anger_if_pulled = FALSE //TRUE - Атака при грабе/пулле

    var/intelligence = INTELLIGENCE_STUPID //Определяет интеллект ИИ
    var/reaction_time = 6