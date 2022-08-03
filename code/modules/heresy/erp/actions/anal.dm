/datum/erp_action/doggystyle/anal
	name = "Собачья поза - Анал"
	description = "."
	etype = ERPTYPEANAL
	pleasure = 360
	arousal = 20

/datum/erp_action/doggystyle/anal/process()
	..()
	if(giver.client.ckey == "doctoralex")
		to_chat(giver, "Соболезную... Пошёл нахуй.")
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
			visible_message("[giver] насилует [recipient], как маленькую собачку в задний проход!")
			if(prob(1) && recipient.owner.gender == "male" && giver.owner.gender == "male")
				visible_message("В МАНХЭТТЭНЕ ВВОДИТСЯ ВОЕННОЕ ПОЛОЖЕНИЕ!!!")
				to_chat(recipient, "Соболезную...")