/datum/analysis
	var/name = "UNKNOWN ANALYSIS"
	var/required_reagent = /datum/reagent/blood
	var/required_amount = 15
	var/time = 0
	var/removed_amount = 5

/datum/analysis/proc/form_reagent_list(var/datum/reagent/blood/B)
	. = list()
	var/list/chems = params2list(B.data["trace_chem"])
	for(var/C in chems)
		.[text2path(C)] = text2num(chems[C])

/datum/analysis/proc/format_header(var/datum/reagent/R)
	. = "[name] of [R.name]<br>"
	. += "Time of analysis: [time_stamp()]<br>"
	. += "<hr><br>"

/datum/analysis/proc/format_reagent_level(name, amount, normal_l, normal_h, normal_a = "", ed = "u", desc)
	var/normal = "  ([normal_a][ed]) "
	if(!(normal_l && normal_h))
		if(normal_l)
			normal = "  (>[normal_l][ed]) "
		if(normal_h)
			normal = "  (<[normal_h][ed]) "
	if(normal_l && normal_h)
		normal = "  ([normal_l][ed] - [normal_h][ed]) "

	var/formatted_name = "[name][n_repeat(" ", 10 - length(name))]"
	. = "[formatted_name] [amount][ed][normal] [desc]<br>"

/datum/analysis/proc/format_2(t1, t2, desc)
	var/formatted_t1 = "[t1][n_repeat(" ", 10 - length(t1))]"
	var/formatted_t2 = "[n_repeat(" ", 10 - length(t2))][t2]"
	. = "[formatted_t1] [formatted_t2] [desc]<br>"

/datum/analysis/proc/get_reagent_amount(var/list/RL, T)
	return LAZYACCESS(RL, T) || 0
/datum/analysis/proc/analyze(var/datum/reagent/R)
	if(!R)
		return "Cannot analyze this sample."

/datum/analysis/troponin
	name = "Troponin-T analysis"
	removed_amount = 4

/datum/analysis/troponin/analyze(var/datum/reagent/blood/B)
	. = format_header(B)
	var/list/RL = form_reagent_list(B)
	var/troponin_level = get_reagent_amount(RL, /datum/reagent/hormone/marker/troponin_t)
	. += format_reagent_level("Troponin-T", amount = troponin_level, normal_h = 0)

/datum/analysis/ast_alt
	name = "AST/ALT analysis"
	removed_amount = 5

/datum/analysis/ast_alt/analyze(var/datum/reagent/blood/B)
	. = format_header(B)
	var/list/RL = form_reagent_list(B)
	var/ast_level = get_reagent_amount(RL, /datum/reagent/hormone/marker/ast)
	. += format_reagent_level("AST", amount = ast_level, normal_h = 41)

	var/alt_level = get_reagent_amount(RL, /datum/reagent/hormone/marker/alt)
	. += format_reagent_level("ALT", amount = alt_level, normal_h = 41)

/datum/analysis/liver
	name = "Liver function tests"
	removed_amount = 8

/datum/analysis/liver/analyze(var/datum/reagent/blood/B)
	. = format_header(B)
	var/list/RL = form_reagent_list(B)
	var/ast_level = get_reagent_amount(RL, /datum/reagent/hormone/marker/ast)
	. += format_reagent_level("AST", amount = ast_level, normal_h = 41)

	var/alt_level = get_reagent_amount(RL, /datum/reagent/hormone/marker/alt)
	. += format_reagent_level("ALT", amount = alt_level, normal_h = 41)

	var/bilirubine_level = get_reagent_amount(RL, /datum/reagent/hormone/marker/bilirubine)
	. += format_reagent_level("Bilirubine", amount = bilirubine_level, normal_l = 5, normal_h = 21)

/datum/analysis/biochemical
	name = "Biochemical analysis"
	removed_amount = 12

/datum/analysis/biochemical/analyze(var/datum/reagent/blood/B)
	. = format_header(B)

	var/list/RL = form_reagent_list(B)
	var/glucose_level = get_reagent_amount(RL, /datum/reagent/hormone/glucose)
	. += format_reagent_level("Glucose", amount = glucose_level,
		normal_l = GLUCOSE_LEVEL_LBAD + 0.5, normal_h = GLUCOSE_LEVEL_HBAD - 0.5)
	var/potassium_level = get_reagent_amount(RL, /datum/reagent/hormone/potassium)
	. += format_reagent_level("Potassium", amount = potassium_level,
		normal_h = POTASSIUM_LEVEL_HBAD)

/datum/analysis/blood_type
	name = "Blood type screen"
	removed_amount = 2

/datum/analysis/blood_type/analyze(var/datum/reagent/blood/B)
	. = format_header(B)

	. += format_2("Blood type", B.data["blood_type"])