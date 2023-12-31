//Due to how large this one is it gets its own file
/datum/job/chaplain
	title = "Chaplain"
	flag = CHAPLAIN
	faction = "City"
	department = DEPT_PUBLIC
	department_flag = CIVILIAN
	total_positions = 0
	spawn_positions = 0
	minimum_character_age = 18

	supervisors = "the city clerk"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian/chaplain
	wage = 75

	access = list(access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels)
	minimal_access = list(access_chapel_office, access_crematorium)
	alt_titles = list("Counselor", "Priest", "Preacher")

	outfit_type = /decl/hierarchy/outfit/job/civilian/chaplain


	description = "As a chaplain you are expected to provide spiritual or counselling services for the city. \
	You can also provide marriage ceromonies or host private events in the chapel."

	duties = list("Light candles", "Attempt to convert people to your religion", "Get ignored")


/datum/job/chaplain/equip(mob/living/carbon/human/H, alt_title, ask_questions = TRUE)
	. = ..()
	if(!.)
		return
	if(!ask_questions)
		return

	var/obj/item/weapon/storage/bible/B = locate(/obj/item/weapon/storage/bible) in H
	if(!B)
		return

	spawn(0)
		var/religion_name = "Unitarianism"
		var/new_religion = sanitize(input(H, "You are the city's priest. Would you like to change your religion? Default is Unitarianism", "Name change", religion_name), MAX_NAME_LEN)

		if (!new_religion)
			new_religion = religion_name
		switch(lowertext(new_religion))
			if("unitarianism")
				B.name = "The Talmudic Quran"
			if("christianity")
				B.name = pick("The Holy Bible","The Dead Sea Scrolls")
			if("Judaism")
				B.name = "The Torah"
			if("satanism")
				B.name = "The Satanic Bible"
			if("cthulhu")
				B.name = "The Necronomicon"
			if("islam")
				B.name = "Quran"
			if("scientology")
				B.name = pick("The Biography of L. Ron Hubbard","Dianetics")
			if("chaos")
				B.name = "The Book of Lorgar"
			if("imperium")
				B.name = "Uplifting Primer"
			if("toolboxia")
				B.name = "Toolbox Manifesto"
			if("homosexuality")
				B.name = "Guys Gone Wild"
			if("science")
				B.name = pick("Principle of Relativity", "Quantum Enigma: Physics Encounters Consciousness", "Programming the Universe", "Quantum Physics and Theology", "String Theory for Dummies", "How To: Build Your Own Warp Drive", "The Mysteries of Bluespace", "Playing God: Collector's Edition")
			if("capitalism")
				B.name = "Wealth of Nations"
			if("communism")
				B.name = "The Communist Manifesto"
			else
				B.name = "The Holy Book of [new_religion]"
		feedback_set_details("religion_name","[new_religion]")

	spawn(1)
		var/deity_name = "Hashem"
		var/new_deity = sanitize(input(H, "Would you like to change your deity? Default is Hashem", "Name change", deity_name), MAX_NAME_LEN)

		if ((length(new_deity) == 0) || (new_deity == "Hashem") )
			new_deity = deity_name
		B.deity_name = new_deity

		var/accepted = 0
		var/outoftime = 0
		spawn(200) // 20 seconds to choose
			outoftime = 1
		var/new_book_style = "Bible"

		while(!accepted)
			if(!B) break // prevents possible runtime errors
			new_book_style = input(H,"Which bible style would you like?") in list("Bible", "Koran", "Scrapbook", "Pagan", "White Bible", "Holy Light", "Athiest", "Tome", "The King in Yellow", "Ithaqua", "Scientology", "the bible melts", "Necronomicon","Orthodox","Torah")
			switch(new_book_style)
				if("Koran")
					B.icon_state = "koran"
					B.item_state = "koran"
				if("Scrapbook")
					B.icon_state = "scrapbook"
					B.item_state = "scrapbook"
				if("White Bible")
					B.icon_state = "white"
					B.item_state = "syringe_kit"
				if("Holy Light")
					B.icon_state = "holylight"
					B.item_state = "syringe_kit"
				if("Athiest")
					B.icon_state = "athiest"
					B.item_state = "syringe_kit"
				if("Tome")
					B.icon_state = "tome"
					B.item_state = "syringe_kit"
				if("The King in Yellow")
					B.icon_state = "kingyellow"
					B.item_state = "kingyellow"
				if("Ithaqua")
					B.icon_state = "ithaqua"
					B.item_state = "ithaqua"
				if("Scientology")
					B.icon_state = "scientology"
					B.item_state = "scientology"
				if("the bible melts")
					B.icon_state = "melted"
					B.item_state = "melted"
				if("Necronomicon")
					B.icon_state = "necronomicon"
					B.item_state = "necronomicon"
				if("Pagan")
					B.icon_state = "shadows"
					B.item_state = "syringe_kit"
				if("Orthodox")
					B.icon_state = "orthodoxy"
					B.item_state = "bible"
				if("Torah")
					B.icon_state = "torah"
					B.item_state = "clipboard"
				else
					B.icon_state = "bible"
					B.item_state = "bible"

			H.update_inv_l_hand() // so that it updates the bible's item_state in his hand

			switch(input(H,"Look at your bible - is this what you want?") in list("Yes","No"))
				if("Yes")
					accepted = 1
				if("No")
					if(outoftime)
						to_chat(H, "Welp, out of time, buddy. You're stuck. Next time choose faster.")
						accepted = 1

		if(ticker)
			ticker.Bible_icon_state = B.icon_state
			ticker.Bible_item_state = B.item_state
			ticker.Bible_name = B.name
			ticker.Bible_deity_name = B.deity_name
		feedback_set_details("religion_deity","[new_deity]")
		feedback_set_details("religion_book","[new_book_style]")
	return 1

/datum/job/chaplain/equip_preview(mob/living/carbon/human/H, alt_title)
	return equip(H, alt_title, FALSE)
