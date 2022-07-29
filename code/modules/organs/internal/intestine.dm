/obj/item/organ/internal/intestine
	name = "intestine"
	icon_state = "intestine"
	organ_tag = O_INTESTINE
	parent_organ = BP_TORSO

/obj/item/organ/internal/intestine/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!.) return

	//Viral Gastroenteritis
	if (. >= INFECTION_LEVEL_ONE)
		if(prob(1))
			owner.custom_pain("There's a twisting pain in your abdomen!",1)
			owner.vomit()
	if (. >= INFECTION_LEVEL_TWO)
		if(prob(1))
			owner.custom_pain("Your abdomen feels like it's tearing itself apart!",1)

/obj/item/organ/internal/intestine/xeno
	color = "#555555"
