var/global/const
	SKILL_UNSKILLED = 0
	SKILL_AMATEUR = 1
	SKILL_TRAINED = 2
	SKILL_PROFESSIONAL = 3

/datum/skill/var
	ID = "none" // ID of the skill, used in code
	name = "None" // name of the skill
	desc = "Placeholder skill" // detailed description of the skill
	field = "Misc" // the field under which the skill will be listed
	secondary = 0 // secondary skills only have two levels and cost significantly less

var/global/list/SKILLS = null
var/list/SKILL_ENGINEER = list("field" = "Engineering", "EVA" = SKILL_AMATEUR, "construction" = SKILL_TRAINED, "electrical" = SKILL_AMATEUR, "engines" = SKILL_TRAINED)
var/list/SKILL_ORGAN_ROBOTICIST = list("field" = "Science", "devices" = SKILL_TRAINED, "electrical" = SKILL_AMATEUR, "computer" = SKILL_TRAINED, "anatomy" = SKILL_AMATEUR)
var/list/SKILL_SECURITY_OFFICER = list("field" = "Security", "combat" = SKILL_AMATEUR, "weapons" = SKILL_TRAINED, "law" = SKILL_TRAINED, "forensics" = SKILL_AMATEUR)
var/list/SKILL_CHEMIST = list("field" = "Science", "chemistry" = SKILL_TRAINED, "science" = SKILL_TRAINED, "medical" = SKILL_AMATEUR, "devices" = SKILL_AMATEUR)
var/global/list/SKILL_PRE = list("Engineer" = SKILL_ENGINEER, "Roboticist" = SKILL_ORGAN_ROBOTICIST, "Police Officer" = SKILL_SECURITY_OFFICER, "Chemist" = SKILL_CHEMIST)

/datum/skill/management
	ID = "management"
	name = "Command"
	desc = "Your ability to manage and commandeer other crew members."

/datum/skill/combat
	ID = "combat"
	name = "Close Combat"
	desc = "This skill describes your training in hand-to-hand combat or melee weapon usage. While expertise in this area is rare in the era of firearms, experts still exist among athletes."
	field = "Security"

/datum/skill/weapons
	ID = "weapons"
	name = "Weapons Expertise"
	desc = "This skill describes your expertise with and knowledge of weapons. A low level in this skill implies knowledge of simple weapons, for example tazers and flashes. A high level in this skill implies knowledge of complex weapons, such as grenades, riot shields, pulse rifles or bombs. A low level in this skill is typical for security officers, a high level of this skill is typical for special agents and soldiers."
	field = "Security"

/datum/skill/EVA
	ID = "EVA"
	name = "Extra-vehicular activity"
	desc = "This skill describes your skill and knowledge of space-suits and working in vacuum."
	field = "Engineering"
	secondary = 1

/datum/skill/forensics
	ID = "forensics"
	name = "Forensics"
	desc = "Describes your skill at performing forensic examinations and identifying vital evidence. Does not cover analytical abilities, and as such isn't the only indicator for your investigation skill. Note that in order to perform autopsy, the surgery skill is also required."
	field = "Security"

/datum/skill/construction
	ID = "construction"
	name = "Construction"
	desc = "Your ability to construct various buildings, such as walls, floors, tables and so on. Note that constructing devices such as APCs additionally requires the Electronics skill. A low level of this skill is typical for janitors, a high level of this skill is typical for engineers."
	field = "Engineering"

/datum/skill/management
	ID = "management"
	name = "Command"
	desc = "Your ability to manage and commandeer other crew members."

/datum/skill/knowledge/law
	ID = "law"
	name = "Corporate Law"
	desc = "Your knowledge of corporate law and procedures. This includes Corporate Regulations, as well as general city rulings and procedures. A low level in this skill is typical for security officers, a high level in this skill is typical for Colony Directors."
	field = "Security"
	secondary = 1

/datum/skill/devices
	ID = "devices"
	name = "Complex Devices"
	desc = "Describes the ability to assemble complex devices, such as computers, circuits, printers, robots or gas tank assemblies(bombs). Note that if a device requires electronics or programming, those skills are also required in addition to this skill."
	field = "Science"

/datum/skill/electrical
	ID = "electrical"
	name = "Electrical Engineering"
	desc = "This skill describes your knowledge of electronics and the underlying physics. A low level of this skill implies you know how to lay out wiring and configure powernets, a high level of this skill is required for working complex electronic devices such as circuits or bots."
	field = "Engineering"

/datum/skill/atmos
	ID = "atmos"
	name = "Atmospherics"
	desc = "Describes your knowledge of piping, air distribution and gas dynamics."
	field = "Engineering"

/datum/skill/engines
	ID = "engines"
	name = "Engines"
	desc = "Describes your knowledge of the various power-generation machines used in modern cities."
	field = "Engineering"
	secondary = 1

/datum/skill/computer
	ID = "computer"
	name = "Information Technology"
	desc = "Describes your understanding of computers, software and communication. Not a requirement for using computers, but definitely helps. Used in telecommunications and programming of computers and AIs."
	field = "Science"

/datum/skill/pilot
	ID = "pilot"
	name = "Heavy Machinery Operation"
	desc = "Describes your experience and understanding of operating heavy machinery, which includes mechs and other large exosuits. Used in piloting mechs."
	field = "Engineering"

/datum/skill/medical
	ID = "medical"
	name = "Medicine"
	desc = "Covers an understanding of the human body and medicine. At a low level, this skill gives a basic understanding of applying common types of medicine, and a rough understanding of medical devices like the health analyzer. At a high level, this skill grants exact knowledge of all the medicine available on the city, as well as the ability to use complex medical devices like the body scanner or mass spectrometer."
	field = "Medical"

/datum/skill/anatomy
	ID = "anatomy"
	name = "Anatomy"
	desc = "Gives you a detailed insight of the human body. A high skill in this is required to perform surgery.This skill may also help in examining alien biology."
	field = "Medical"

/datum/skill/virology
	ID = "virology"
	name = "Virology"
	desc = "This skill implies an understanding of microorganisms and their effects on humans."
	field = "Medical"

/datum/skill/genetics
	ID = "genetics"
	name = "Genetics"
	desc = "Implies an understanding of how DNA works and the structure of the human DNA."
	field = "Science"

/datum/skill/chemistry
	ID = "chemistry"
	name = "Chemistry"
	desc = "Experience with mixing chemicals, and an understanding of what the effect will be. This doesn't cover an understanding of the effect of chemicals on the human body, as such the medical skill is also required for medical chemists."
	field = "Science"

/datum/skill/botany
	ID = "botany"
	name = "Botany"
	desc = "Describes how good a character is at growing and maintaining plants."

/datum/skill/cooking
	ID = "cooking"
	name = "Cooking"
	desc = "Describes a character's skill at preparing meals and other consumable goods. This includes mixing alcoholic beverages."

/datum/skill/science
	ID = "science"
	name = "Science"
	desc = "Your experience and knowledge with scientific methods and processes."
	field = "Science"

/datum/attribute/var
	ID = "none"
	name = "None"
	desc = "This is a placeholder"


/proc/setup_skills()
	if(SKILLS == null)
		SKILLS = list()
		for(var/T in (typesof(/datum/skill)-/datum/skill))
			var/datum/skill/S = new T
			if(S.ID != "none")
				if(!SKILLS.Find(S.field))
					SKILLS[S.field] = list()
				var/list/L = SKILLS[S.field]
				L += S


/mob/living/carbon/human/proc/GetSkillClass(points)
	return CalculateSkillClass(points, age)

/proc/show_skill_window(mob/user, mob/living/carbon/human/M)
	if(!istype(M)) return
	if(SKILLS == null)
		setup_skills()

	if(!M.skills || M.skills.len == 0)
		to_chat(user, "There are no skills to display.")
		return

	var/HTML = "<body>"
	HTML += "<b>Select your Skills</b><br>"
	HTML += "Current skill level: <b>[M.GetSkillClass(M.used_skillpoints)]</b> ([M.used_skillpoints])<br>"
	HTML += "<table>"
	for(var/V in SKILLS)
		HTML += "<tr><th colspan = 5><b>[V]</b>"
		HTML += "</th></tr>"
		for(var/datum/skill/S in SKILLS[V])
			var/level = M.skills[S.ID]
			HTML += "<tr style='text-align:left;'>"
			HTML += "<th>[S.name]</th>"
			HTML += "<th><font color=[(level == SKILL_UNSKILLED) ? "red" : "black"]>\[Untrained\]</font></th>"
			// secondary skills don't have an amateur level
			if(S.secondary)
				HTML += "<th></th>"
			else
				HTML += "<th><font color=[(level == SKILL_AMATEUR) ? "red" : "black"]>\[Amateur\]</font></th>"
			HTML += "<th><font color=[(level == SKILL_TRAINED) ? "red" : "black"]>\[Trained\]</font></th>"
			HTML += "<th><font color=[(level == SKILL_PROFESSIONAL) ? "red" : "black"]>\[Professional\]</font></th>"
			HTML += "</tr>"
	HTML += "</table>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=show_skills;size=600x800")
	return

/mob/living/carbon/human/verb/show_skills()
	set category = "IC"
	set name = "Show Own Skills"

	show_skill_window(src, src)
