var/global/const
	SKILL_UNSKILLED = 0
	SKILL_AMATEUR = 1
	SKILL_TRAINED = 2
	SKILL_PROFESSIONAL = 3

/mob/proc/get_skill(skill_id)
	return LAZYACCESS0(skills, skill_id)

var/global/list/SKILL_PRE = list("Engineer" = SKILL_ENGINEER, "Roboticist" = SKILL_ORGAN_ROBOTICIST, "Police Officer" = SKILL_SECURITY_OFFICER, "Chemist" = SKILL_CHEMIST)
var/list/SKILL_ENGINEER = list("field" = "Engineering", "construction" = SKILL_TRAINED)
var/list/SKILL_ORGAN_ROBOTICIST = list("field" = "Science", "anatomy" = SKILL_UNSKILLED)
var/list/SKILL_SECURITY_OFFICER = list("field" = "Security", SKILL_CLOSE_COMBAT = SKILL_TRAINED)
var/list/SKILL_CHEMIST = list("field" = "Science", SKILL_ATMOS = SKILL_TRAINED)

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

/datum/skill
	var/ID = "none"					// ID of this skill.
	var/name = "None" 				// Name of the skill. This is what the player sees.
	var/desc = "Placeholder skill" 	// Generic description of this skill.
	var/field = "Unset" 			// Category under which this skill will be listed.
	var/secondary = FALSE 			// Whether the skill is secondary. Secondary skills are cheaper and lack the Amateur level.
   	// Specific descriptions for specific skill levels.
	var/desc_unskilled = "Unskilled Descripton"
	var/desc_amateur = "Amateur Description"
	var/desc_trained = "Trained Description"
	var/desc_professional = "Expert Description"
	var/list/costs = list(
		SKILL_AMATEUR = 1,
		SKILL_TRAINED = 3,
		SKILL_PROFESSIONAL = 6
	)

// ONLY SKILL DEFINITIONS BELOW THIS LINE

#define SKILL_CLOSE_COMBAT "combat"
/datum/skill/close_combat
	ID = SKILL_CLOSE_COMBAT
	name = "Close Combat"
	field = "Combat"
	desc = "This skill describes your training in hand-to-hand combat or melee weapon usage. While expertise in this area is rare in the era of firearms, experts still exist among athletes."
	desc_unskilled = "You can throw a punch or a kick, but it'll knock you off-balance. You're inexperienced and have probably never been in a serious hand-to-hand fight. In a fight, you might panic and run, grab whatever's nearby and blindly strike out with it, or (if the other guy is just as much of a beginner as you are) make a fool out of yourself."
	desc_amateur = "You either have some experience with fistfights, or you have some training in a martial art. You can handle yourself if you really have to, and if you're a security officer, can handle a stun baton at least well enough to get the handcuffs onto a criminal."
	desc_trained = "You're good at hand-to-hand combat. You've trained explicitly in a martial art or as a close combatant as part of a military or police unit. You can use weaponry competently and you can think strategically and quickly in a melee. You're in good shape and you spend time training."
	desc_professional = "You specialize in hand-to-hand combat. You're well-trained in a practical martial art, and in good shape. You spend a lot of time practicing. You can take on just about anyone, use just about any weapon, and usually come out on top. You may be a professional athlete or special forces member."

#define SKILL_WEAPONS "weapons"
/datum/skill/weapons
	ID = SKILL_WEAPONS
	name = "Weapons Expertise"
	field = "Combat"
	desc = "This skill describes your expertise with and knowledge of weapons. A low level in this skill implies knowledge of simple weapons, for example flashes. A high level in this skill implies knowledge of complex weapons, such as unconfigured grenades, riot shields, pulse rifles or bombs. A low-medium level in this skill is typical for security officers, a high level of this skill is typical for special agents and soldiers."
	desc_unskilled = "You know how to recognize a weapon when you see one. You can probably use pepper spray or a flash, though you might fumble and turn them on yourself by mistake. You're likely to shoot yourself in the foot or forget to take the safety off. Your lack of training may make you more dangerous to your allies than your enemies."
	desc_amateur = "You know how to handle weapons safely, and you're comfortable using simple weapons. Your aim is decent and you can be trusted not to do anything stupid with a weapon, but your training isn't automatic yet and your performance will degrade in high-stress situations."
	desc_trained = "You've used firearms and other ranged weapons in a high-stress situation, and your skills have become automatic. You spend time practicing at the firing range. Your aim is good. You can maintain and repair your weaponry. You may have military or police experience and you probably carry a weapon on the job."
	desc_professional = "You are an exceptional shot with a variety of weapons, from simple to exotic. You can depend on hitting not just your target, but a specific part of your target, such as shooting someone in the leg. You use a weapon as naturally as though it were a part of your own body. You may be a professional marksman of some kind. You probably know a good deal about tactics, and you may have designed or modified your own weaponry."

// TODO: make desc
#define SKILL_CRAFTING "crafting"
/datum/skill/crafting
	ID = SKILL_CRAFTING
	name = "Crafting"
	field = "Engineering"
	desc = "Your ability to craft various things."

#define SKILL_CONSTRUCTION "construction"
/datum/skill/construction
	ID = SKILL_CONSTRUCTION
	name = "Construction"
	field = "Engineering"
	desc = "Your ability to construct various buildings, such as walls, floors, tables and so on. Note that constructing devices such as APCs additionally requires the Electronics skill. A low level of this skill is typical for janitors, a high level of this skill is typical for engineers."
	desc_unskilled = "You can move furniture, assemble or disassemble chairs and tables (sometimes they even stay assembled), bash your way through a window, open a crate, or pry open an unpowered airlock. You can recognize and use basic hand tools and inflatable barriers, though not very well."
	desc_amateur = "You can dismantle or build a wall or window, build furniture, redecorate a room, and replace floor tiles and carpeting. You can safely use a welder without burning your eyes, and using hand tools is second nature to you."
	desc_trained = "You know how to seal a breach, rebuild broken piping, and repair major damage. You know the basics of structural engineering."
	desc_professional = "You are a construction worker or engineer. You could pretty much rebuild the installation from the ground up, given supplies, and you're efficient and skilled at repairing damage."

#define SKILL_ELECTRICAL "electrical"
/datum/skill/electrical
	ID = SKILL_ELECTRICAL
	name = "Electrical Engineering"
	field = "Engineering"
	desc = "This skill describes your knowledge of electronics and the underlying physics. A low level of this skill implies you know how to lay out wiring and configure powernets, a high level of this skill is required for working complex electronic devices such as circuits or bots."
	desc_unskilled = "You know that electrical wires are dangerous and getting shocked is bad; you can see and report electrical malfunctions such as broken wires or malfunctioning APCs. You can change a light bulb, and you know how to replace a battery or charge up the equipment you normally use."
	desc_amateur = "You can do basic wiring; you can lay cable for solars or the engine. You can repair broken wiring and build simple electrical equipment like light fixtures or APCs. You know the basics of circuits and understand how to protect yourself from electrical shock. You can probably hack a vending machine."
	desc_trained = "You can repair and build electrical equipment and do so on a regular basis. You can troubleshoot an electrical system and monitor the installation power grid. You can probably hack an airlock."
	desc_professional = "You are an electrical engineer or the equivalent. You can design, upgrade, and modify electrical equipment and you are good at maximizing the efficiency of your power network. You can hack anything on the installation you can deal with power outages and electrical problems easily and efficiently."

#define SKILL_ATMOS "atmos"
/datum/skill/atmos
	ID = SKILL_ATMOS
	name = "Atmospherics"
	field = "Engineering"
	desc = "Describes your knowledge of piping, air distribution and gas dynamics."
	desc_unskilled = "You know that the air monitors flash orange when the air is bad and red when it's deadly. You know that a flashing fire door means danger on the other side. You know that some gases are poisonous, that pressure has to be kept in a safe range, and that most creatures need oxygen to live. You can use a fire extinguisher or deploy an inflatable barrier."
	desc_amateur = "You know how to read an air monitor, how to use an air pump, how to analyze the atmosphere in a space, and how to help seal a breach. You can lay piping and work with gas tanks and canisters. If you work with the engine, you can set up the cooling system. You can use a fire extinguisher easily and place inflatable barriers so that they allow convenient access and airtight breach containment."
	desc_trained = "You can run the Atmospherics system. You know how to monitor the air quality across the installation detect problems, and fix them. You're trained in dealing with fires, breaches, and gas leaks, and may have exosuit or fire gear training."
	desc_professional = "You are an atmospherics specialist. You monitor, modify, and optimize the installation atmospherics system, and you can quickly and easily deal with emergencies. You can modify atmospherics systems to do pretty much whatever you want them to. You can easily handle a fire or breach, and are proficient at securing an area and rescuing civilians, but you're equally likely to have simply prevented it from happening in the first place."

#define SKILL_ENGINES "engines"
/datum/skill/engines
	ID = SKILL_ENGINES
	name = "Engines"
	field = "Engineering"
	desc = "Describes your knowledge of the various engine types common on space stations, such as the singularity, supermatter or RUST engine."
	desc_unskilled = "You know that \"delamination\" is a bad thing and that you should stay away from the singularity. You know the engine provides power, but you're unclear on the specifics. If you were to try to set up the engine, you would need someone to talk you through every detail--and even then, you'd probably make deadly mistakes."
	desc_amateur = "You know the basic theoretical principles of engine operation. You can try to set up the engine by yourself, but you are likely to need some assistance and supervision, otherwise you are likely to make mistakes."
	desc_trained = "You can set up the engine, and you probably won't botch it up too badly. You know how to protect yourself from radiation in the engine room. You can read the engine monitors and keep the engine going. You're familiar with engine types other than the one you work with. An engine malfunction may stump you, but you can probably work out how to fix it... let's just hope you do so quickly enough to prevent serious damage."
	desc_professional = "Your engine is your baby and you know every minute detail of its workings. You can optimize the engine and you probably have your own favorite custom setup. You could build an engine from the ground up. When things go wrong, you know exactly what has happened and how to fix the problem. You can safely handle singularities and supermatter."
// Category: Medical

#define SKILL_MEDICAL "acls"
/datum/skill/acls
	ID = SKILL_MEDICAL
	name = "Medical"
	desc = "Understanding of advanced cardiovascular life support, cpr and defibrillation quality."
	field = "Medical"
	desc_unskilled = "You know the signs of cases, what requires advanced medical help. You can make bad-quality CPR."
	desc_amateur = "You know the difference between shockable and not-shockable rythme. You can perform bad-quality precordial blow, medium-quality CPR and bad-quality defibrillation."
	desc_trained = "You are experienced in reanimation. You can perform medium-quality precordial blow, high-quality CPR and defibrillation."
	desc_professional = "You are an professional in reanimation. You can be sure, patient you are giving CPR will never die from hypoxia. Precordial blows that you perform are not really worse than amateur defibrillation."

#define SKILL_ANATOMY "anatomy"
/datum/skill/anatomy
	ID = SKILL_ANATOMY
	name = "Anatomy"
	desc = "Understanding of human's body, surgery performing."
	field = "Medical"
	desc_unskilled = "You can bandage, suture and splint the injury. You know the signs of the vessel trauma, broken bone."
	desc_amateur = "You can diagnose common injuries, like fractures, BMI, hemorrage, you can cleary say where is each organ located, perform simple surgeries like appendictomia, bone melting, suture ruptured organs and vessels, amputate limbs."
	// TODO: write description.