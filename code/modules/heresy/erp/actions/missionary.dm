/datum/erp_action/missionary
    name = "Миссионер"
    description = "Миссионе́рская пози́ция — одна из наиболее популярных сексуальных позиций. В классическом варианте мужчина находится сверху, между раздвинутых ног лежащей на спине женщины."
    etype = ERPTYPEVAGINAL
    pleasure = 240
    arousal = 50

/datum/erp_action/missionary/process()
    ..()
    switch(roughness)
        if(1)
            visible_message("[giver] плавно вводит свой [pick(erp_session.fellational_adjectives)] в [pick(erp_session.vaginal_adjectives)] [recipient]...")
        if(2)
            visible_message("[pick(erp_session.vaginal_adjectives)] [recipient] подвергается вторжению [giver].")
        if(3)
            visible_message("[giver] грубо потрахивает [recipient]")
        if(4)
            visible_message("Бёдра [giver] соприкасаются с телом [recipient] и слегка подрагивают от той силы, с которой [pick(erp_session.fellational_adjectives)] входит в её [pick(erp_session.vaginal_adjectives)].")
        if(5)
            visible_message("[recipient] подвергается жёсткому и насильному миссионерскому сексу!")