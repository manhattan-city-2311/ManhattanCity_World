/datum/organ_disease
	var/name
	var/strength = 20
	var/max_strength = 40
	var/dstrength = 1
	var/gone_level = 0

/datum/organ_disease/proc/update()
	return

/datum/organ_disease/proc/can_gone()
	return strength <= gone_level

/datum/organ_disease/proc/can_be_apply(var/obj/item/organ/internal/I)
	return TRUE

/datum/organ_disease/infarct
	dstrength = 0.05

/datum/organ_disease/infarct/update()
	strength = clamp(strength + dstrength, 0, max_strength)

/datum/arrythmia
	var/id
	var/name
	var/co_mod = 1
	var/severity = 0 // 0 for uncommon arrythmias
	var/ischemia_mod = 0
	var/weakening_type = null
	var/strengthening_type = null

	var/appear_time
	var/mutate_period = 1.5 MINUTE

/datum/arrythmia/New()
	appear_time = world.time

/datum/arrythmia/proc/get_hr_mod(var/obj/item/organ/internal/heart/H)
	return 0

/datum/arrythmia/proc/is_over_period()
	return world.time > (appear_time + mutate_period)

/datum/arrythmia/proc/can_weaken(var/obj/item/organ/internal/heart/H)
	return weakening_type && (H.get_arrythmic() <= (severity - 1))

/datum/arrythmia/proc/can_strengthen(var/obj/item/organ/internal/heart/H)
	return strengthening_type && (H.get_arrythmic() >= (severity))

/datum/arrythmia/proc/can_appear(var/obj/item/organ/internal/heart/H)
	return TRUE

/obj/item/organ/internal/heart/proc/get_arrythmic()
	. = LAZYACCESS0(owner.chem_effects, CE_ARRYTHMIC) - LAZYACCESS0(owner.chem_effects, CE_ANTIARRYTHMIC)
	. += (damage / max_damage) / 0.25
	. += (owner.mpressure > BLOOD_PRESSURE_HCRITICAL) || (owner.mpressure < BLOOD_PRESSURE_LCRITICAL)
	. += owner.gvr > 280
	. += owner.mcv > 20000
	. += (owner.mcv < 3000) * 2
	. += (owner.mcv < 1000) * 3
	. += (pulse > 250)
	. = max(0, .)

/obj/item/organ/internal/heart/proc/make_arrythmia(T, allocated = null)

	var/datum/arrythmia/A = allocated || (new T)
	if(A.severity >= ARRYTHMIA_SEVERITY_OVERWRITING)
		arrythmias.Cut()
	else if(get_ow_arrythmia())
		return
	arrythmias[A.id] = A

/obj/item/organ/internal/heart/proc/remove_arrythmia(id)
	arrythmias -= id

/obj/item/organ/internal/heart/proc/make_common_arrythmia(severity)
	for(var/T in subtypesof(/datum/arrythmia))
		var/datum/arrythmia/A = new T
		if(A.severity <= severity && !(A.id in arrythmias) && A.can_appear(src))
			make_arrythmia(, allocated = A)
			return

/obj/item/organ/internal/heart/proc/make_specific_arrythmia(severity)
	for(var/T in subtypesof(/datum/arrythmia))
		var/datum/arrythmia/A = new T
		if(A.severity == severity && !(A.id in arrythmias) && A.can_appear(src))
			make_arrythmia(, allocated = A)
			return
/obj/item/organ/internal/heart/proc/total_common_arrythmias_count()
	. = 0
	for(var/T in arrythmias)
		var/datum/arrythmia/A = arrythmias[T]
		if(A.severity >= 1 && A.severity < ARRYTHMIA_SEVERITY_OVERWRITING)
			++.

/obj/item/organ/internal/heart/proc/get_arrythmia_score()
	. = 0
	for(var/T in arrythmias)
		var/datum/arrythmia/A = arrythmias[T]
		. += A.severity

/obj/item/organ/internal/heart/proc/get_ow_arrythmia()
	if(arrythmias.len)
		var/datum/arrythmia/A = arrythmias[arrythmias[1]]
		if(A.severity >= ARRYTHMIA_SEVERITY_OVERWRITING)
			return A
	return null

/datum/arrythmia/proc/mutate(var/obj/item/organ/internal/heart/H, T)
	H.remove_arrythmia(id)
	if(!T)
		return

	if(islist(T))
		var/target = pick(T)
		if(target)
			H.make_arrythmia(target)
	else
		H.make_arrythmia(T)

/datum/arrythmia/proc/weak(var/obj/item/organ/internal/heart/H)
	mutate(H, weakening_type)

/datum/arrythmia/proc/strengthen(var/obj/item/organ/internal/heart/H)
	mutate(H, strengthening_type)

/datum/arrythmia/aflaunt
	id = ARRYTHMIA_AFLAUNT
	name = "Atrial flaunt"
	co_mod = 0.95
	severity = 2
	ischemia_mod = 0.2
	weakening_type = /datum/arrythmia/afib/rr
	strengthening_type = list(/datum/arrythmia/tachycardia/paroxysmal, 0)

/datum/arrythmia/aflaunt/get_hr_mod()
	return rand(-20, 50)

/datum/arrythmia/afib
	id = ARRYTHMIA_AFIB
	name = "Atrial fibrillation"
	co_mod = 0.95
	severity = 1
	ischemia_mod = 0.15
	weakening_type = null
	strengthening_type = /datum/arrythmia/afib/rr

/datum/arrythmia/afib/get_hr_mod()
	return rand(-20, 20)

/datum/arrythmia/afib/can_weaken(var/obj/item/organ/internal/heart/H)
	return H.get_arrythmic() < 1

/datum/arrythmia/afib/rr
	name = "Atrial fibrillation with rapid heart rate"
	severity = 2
	co_mod = 0.80
	ischemia_mod = 0.2
	weakening_type = /datum/arrythmia/afib
	strengthening_type = /datum/arrythmia/tachycardia

/datum/arrythmia/afib/rr/get_hr_mod()
	return rand(20, 70)

/datum/arrythmia/tachycardia
	id = ARRYTHMIA_TACHYCARDIA
	name = "Tachycardia"
	severity = 2
	co_mod = 0.9
	ischemia_mod = 0.1
	weakening_type = null
	strengthening_type = /datum/arrythmia/tachycardia/paroxysmal

/datum/arrythmia/tachycardia/get_hr_mod()
	return rand(40, 90)

/datum/arrythmia/tachycardia/paroxysmal
	name = "Paroxysmal tachycardia"
	severity = 3
	co_mod = 0.8
	ischemia_mod = 0.2
	weakening_type = /datum/arrythmia/tachycardia
	strengthening_type = null
	mutate_period = 0.5 MINUTE

/datum/arrythmia/tachycardia/paroxysmal/get_hr_mod()
	return rand(90, 140)

/datum/arrythmia/extrasystolic
	id = ARRYTHMIA_EXTRASYSTOLIC
	name = "Extrasystolic"
	severity = 2
	co_mod = 0.87
	ischemia_mod = 0.2
	weakening_type = /datum/arrythmia/afib
	strengthening_type = /datum/arrythmia/tachycardia

/datum/arrythmia/extrasystolic/get_hr_mod()
	return prob(30) * -80

/datum/arrythmia/vfib
	id = ARRYTHMIA_VFIB
	name = "Ventricular fibrillation"

	severity = ARRYTHMIA_SEVERITY_OVERWRITING + 1

	co_mod = 0.1

	weakening_type = list(/datum/arrythmia/vflaunt)
	strengthening_type = /datum/arrythmia/asystole

	mutate_period = 1 MINUTE

/datum/arrythmia/vfib/get_hr_mod()
	return rand(200, 300)

/datum/arrythmia/vflaunt
	id = ARRYTHMIA_VFLAUNT
	name = "Ventricular flaunt"
	co_mod = 0.3
	
	severity = ARRYTHMIA_SEVERITY_OVERWRITING

	weakening_type = null
	strengthening_type = /datum/arrythmia/vfib

	mutate_period = 30 SECONDS

/datum/arrythmia/vflaunt/get_hr_mod()
	return rand(100, 200)

/datum/arrythmia/asystole
	id = ARRYTHMIA_ASYSTOLE
	name = "Asystole"

	severity = ARRYTHMIA_SEVERITY_OVERWRITING + 2

	co_mod = 2
	ischemia_mod = 0.7


	weakening_type = list(/datum/arrythmia/vfib, null)
	strengthening_type = null

/datum/arrythmia/asystole/get_hr_mod(var/obj/item/organ/internal/heart/H)
	return -145 - (H.ischemia / 50) * 40 + LAZYACCESS0(H.owner.chem_effects, CE_ANTIARRYTHMIC) * 10
/datum/arrythmia/asystole/can_weaken(var/obj/item/organ/internal/heart/H)
	return H.pulse > 0