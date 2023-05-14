
/material/wood
	name = MAT_WOOD
	stack_type = /obj/item/stack/material/wood
	icon_colour = WOOD_COLOR_GENERIC
	integrity = 50
	icon_base = "wood"
	explosion_resistance = 2
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	hardness = 15
	weight = 18
	protectiveness = 8 // 28%
	conductivity = 1
	melting_point = T0C+300 //okay, not melting in this case, but hot enough to destroy wood
	ignition_point = T0C+288
	stack_origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	dooropen_noise = 'sound/effects/dooropen.ogg'
	door_icon_base = "wood"
	destruction_desc = "splinters"
	sheet_singular_name = "plank"
	sheet_plural_name = "planks"

/material/wood/log
	name = MAT_LOG
	icon_base = "log"
	stack_type = /obj/item/stack/material/log
	sheet_singular_name = null
	sheet_plural_name = "pile"

/material/wood/log/sif
	name = MAT_SIFLOG
	icon_colour = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	stack_type = /obj/item/stack/material/log/sif

/material/wood/holographic
	name = "holowood"
	display_name = "wood"
	stack_type = null
	shard_type = SHARD_NONE

/material/wood/sif
	name = MAT_SIFWOOD
//	stack_type = /obj/item/stack/material/wood/sif
	icon_colour = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2) // Alien wood would presumably be more interesting to the analyzer.

/material/cardboard
	name = "cardboard"
	stack_type = /obj/item/stack/material/cardboard
	flags = MATERIAL_BRITTLE
	integrity = 10
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#AAAAAA"
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"
	radiation_resistance = 1

// To be implemented
/*
/material/paper
	name = "paper"
*/


/material/wood/mahogany
	name = MATERIAL_MAHOGANY
//	lore_text = "Mahogany is prized for its beautiful grain and rich colour, and as such is typically used for fine furniture and cabinetry."
//	adjective_name = MATERIAL_MAHOGANY
	icon_colour = WOOD_COLOR_RICH
	stack_type = /obj/item/stack/material/wood/mahogany
//	construction_difficulty = 2
//	sale_price = 3


/material/wood/maple
	name = MATERIAL_MAPLE
//	lore_text = "Owing to its fast growth and ease of working, silver maple is a popular wood for flooring and furniture."
//	adjective_name = MATERIAL_MAPLE
	icon_colour = WOOD_COLOR_PALE
	stack_type = /obj/item/stack/material/wood/maple

/material/wood/ebony
	name = MATERIAL_EBONY
	icon_colour = WOOD_COLOR_BLACK
	weight = 22
//	sale_price = 4
	stack_type = /obj/item/stack/material/wood/ebony

/material/wood/walnut
	name = MATERIAL_WALNUT
	icon_colour = WOOD_COLOR_CHOCOLATE
	weight = 20
//	sale_price = 2
	stack_type = /obj/item/stack/material/wood/walnut

/material/wood/yew
	name = MATERIAL_YEW
	icon_colour = WOOD_COLOR_YELLOW
//	adjective_name = MATERIAL_YEW
	stack_type = /obj/item/stack/material/wood/yew

/material/wood/bamboo
	name = MATERIAL_BAMBOO
	icon_colour = WOOD_COLOR_PALE2
	stack_type = /obj/item/stack/material/wood/bamboo
