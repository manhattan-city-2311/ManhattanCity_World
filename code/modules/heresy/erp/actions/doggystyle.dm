/datum/erp_action/doggystyle
    name = "Собачья поза"
    description = "."
    etype = ERPTYPEVAGINAL
    pleasure = 340
    arousal = 30

/datum/erp_action/doggystyle/process()
    ..()
    switch(roughness)
        if(1)
            visible_message("[giver] трахает [recipient]")
        if(2)
            visible_message("[giver] трахает [recipient]")
        if(3)
            visible_message("[giver] трахает [recipient]")
        if(4)
            visible_message("[giver] трахает [recipient]")
        if(5)
            visible_message("[giver] насилует [recipient], как маленькую собачку!")