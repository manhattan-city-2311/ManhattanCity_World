/****************************************************
				BLOOD SYSTEM
****************************************************/

/mob/living/carbon/human/var/datum/reagents/vessel // Container for blood and BLOOD ONLY. Do not transfer other chems here.
/mob/living/carbon/human/var/var/pale = 0          // Should affect how mob sprite is drawn, but currently doesn't.

//Initializes blood vessels
/mob/living/carbon/human/proc/make_blood()

	if(vessel)
		return

	vessel = new/datum/reagents(species.blood_volume, src)

	if(!should_have_organ(O_HEART)) //We want the var for safety but we can do without the actual blood.
		return
	if(client && client.prefs.blood_level)
		vessel.add_reagent("blood",client.prefs.blood_level)
	else
		vessel.add_reagent("blood",species.blood_volume)
	fixblood()

//Resets blood data
/mob/living/carbon/human/proc/fixblood()
	for(var/datum/reagent/blood/B in vessel.reagent_list)
		if(B.type == /datum/reagent/blood)
			B.data = list(
				"donor" = weakref(src),
				"species" = species.name,
				"blood_DNA" = dna.unique_enzymes,
				"blood_colour" = species.get_blood_colour(src),
				"blood_type" = dna.b_type,
				"trace_chem" = null,
				"virus2" = list(),
				"antibodies" = list()
			)
			B.color = B.data["blood_colour"]

//Makes a blood drop, leaking amt units of blood from the mob
/mob/living/carbon/human/proc/drip(var/amt, var/tar = src, var/ddir)
	if(remove_blood(amt))
		if(bloodstr.total_volume)
			var/chem_share = amt / (bloodstr.total_volume + vessel.total_volume)
			bloodstr.remove_any(chem_share * bloodstr.total_volume)
		blood_splatter(tar, src, (ddir && ddir>0), spray_dir = ddir)
		return amt
	return 0

#define BLOOD_SPRAY_DISTANCE 2
/mob/living/carbon/human/proc/blood_squirt(var/amt, var/turf/sprayloc)
	if(amt <= 0 || !istype(sprayloc))
		return
	var/spraydir = pick(GLOB.alldirs)
	amt = ceil(amt/BLOOD_SPRAY_DISTANCE)
	var/bled = 0
	spawn(0)
		for(var/i = 1 to BLOOD_SPRAY_DISTANCE)
			sprayloc = get_step(sprayloc, spraydir)
			if(!istype(sprayloc) || sprayloc.density)
				break
			var/hit_mob
			for(var/thing in sprayloc)
				var/atom/A = thing
				if(!A.simulated)
					continue

				if(ishuman(A))
					var/mob/living/carbon/human/H = A
					if(!H.lying)
						H.bloody_body(src)
						H.bloody_hands(src)
						var/blinding = FALSE
						if(ran_zone() == BP_HEAD)
							blinding = TRUE
							for(var/obj/item/I in list(H.head, H.glasses, H.wear_mask))
								if(I && (I.body_parts_covered & EYES))
									blinding = FALSE
									break
						if(blinding)
							H.eye_blurry = max(H.eye_blurry, 10)
							H.eye_blind = max(H.eye_blind, 5)
							to_chat(H, "<span class='danger'>You are blinded by a spray of blood!</span>")
						else
							to_chat(H, "<span class='danger'>You are hit by a spray of blood!</span>")
						hit_mob = TRUE

				if(hit_mob || !A.CanPass(src, sprayloc))
					break

			drip(amt, sprayloc, spraydir)
			bled += amt
			if(hit_mob) break
			sleep(1)
	return bled
#undef BLOOD_SPRAY_DISTANCE

/mob/living/carbon/human/proc/remove_blood(var/amt)
	if(!should_have_organ(O_HEART)) //TODO: Make drips come from the reagents instead.
		return 0
	if(!amt)
		return 0
	return vessel.remove_reagent("blood", amt * (src.mob_size/MOB_MEDIUM))

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to the container, preserving all data in it.
/mob/living/carbon/proc/take_blood(obj/item/weapon/reagent_containers/container, var/amount)
	var/datum/reagent/blood/B = get_blood(container.reagents)
	if(!B)
		B = new /datum/reagent/blood
		B.sync_to(src)
		container.reagents.add_reagent("blood", amount, B.data)
	else
		B.sync_to(src)
		B.volume += amount
	return 1

/datum/reagent/blood/proc/sync_to(var/mob/living/carbon/C)
	data["donor"] = weakref(C)
	if (!data["virus2"])
		data["virus2"] = list()
	data["virus2"] |= virus_copylist(C.virus2)
	data["antibodies"] = C.antibodies
	data["blood_DNA"] = C.dna.unique_enzymes
	data["blood_type"] = C.dna.b_type
	data["species"] = C.species.name
	var/list/temp_chem = list()
	for(var/datum/reagent/R in C.reagents.reagent_list)
		temp_chem[R.id] = R.volume
	data["trace_chem"] = list2params(temp_chem)
	data["dose_chem"] = list2params(C.chem_doses)
	data["blood_colour"] = C.species.get_blood_colour(C)
	color = data["blood_colour"]

/mob/living/carbon/human/proc/sync_vessel()
	for(var/R in vessel.reagent_list)
		var/datum/reagent/reagent = R
		if(reagent && reagent.id == "blood")
			var/datum/reagent/blood/blood = reagent
			blood.sync_to(src)
			return

//For humans, blood does not appear from blue, it comes from vessels.
/mob/living/carbon/human/take_blood(obj/item/weapon/reagent_containers/container, var/amount)
	if(!should_have_organ(O_HEART))
		reagents.trans_to_obj(container, amount)
		return 1

	if(vessel.get_reagent_amount("blood") < amount)
		return null

	sync_vessel()
	vessel.trans_to_holder(container.reagents,amount)
	return 1

//Transfers blood from container ot vessels
/mob/living/carbon/proc/inject_blood(var/datum/reagent/blood/injected, var/amount)
	if (!injected || !istype(injected))
		return
	var/list/sniffles = virus_copylist(injected.data["virus2"])
	for(var/ID in sniffles)
		var/datum/disease2/disease/sniffle = sniffles[ID]
		infect_virus2(src,sniffle,1)
	if (injected.data["antibodies"] && prob(5))
		antibodies |= injected.data["antibodies"]
	var/list/chems = list()
	chems = params2list(injected.data["trace_chem"])
	for(var/C in chems)
		src.reagents.add_reagent(C, (text2num(chems[C]) / species.blood_volume) * amount)//adds trace chemicals to owner's blood
	reagents.update_total()

//Transfers blood from reagents to vessel, respecting blood types compatability.
/mob/living/carbon/human/inject_blood(var/datum/reagent/blood/injected, var/amount)

	if(!should_have_organ(O_HEART))
		reagents.add_reagent("blood", amount, injected.data)
		reagents.update_total()
		return

	if(blood_incompatible(injected.data["blood_type"], injected.data["species"]))
		reagents.add_reagent("toxin", amount * 0.5)
		reagents.update_total()
	else
		vessel.add_reagent("blood", amount, injected.data)
		vessel.update_total()
	..()

//Gets human's own blood.
/mob/living/carbon/proc/get_blood(datum/reagents/container)
	var/datum/reagent/blood/res = locate() in container.reagent_list //Grab some blood
	if(res) // Make sure there's some blood at all
		if(weakref && res.data["donor"] != weakref) //If it's not theirs, then we look for theirs
			for(var/datum/reagent/blood/D in container.reagent_list)
				if(weakref && D.data["donor"] != weakref)
					return D
	return res

/mob/living/carbon/human/proc/blood_incompatible(blood_type, blood_species)
	if(blood_species && species.name)
		if(blood_species != species.name)
			return 1

	var/donor_antigen = copytext_char(blood_type, 1, length(blood_type))
	var/receiver_antigen = copytext_char(dna.b_type, 1, length(dna.b_type))
	var/donor_rh = (findtext_char(blood_type, "+") > 0)
	var/receiver_rh = (findtext_char(dna.b_type, "+") > 0)

	if(donor_rh && !receiver_rh) return 1
	switch(receiver_antigen)
		if("A")
			if(donor_antigen != "A" && donor_antigen != "O") return 1
		if("B")
			if(donor_antigen != "B" && donor_antigen != "O") return 1
		if("O")
			if(donor_antigen != "O") return 1
		//AB is a universal receiver.
	return 0

/mob/living/carbon/human/proc/regenerate_blood(amount)
	var/blood_volume_raw = vessel.get_reagent_amount("blood")
	amount = max(0,min(amount, species.blood_volume - blood_volume_raw))
	if(amount)
		var/datum/reagent/blood/B = get_blood(vessel)
		if(istype(B))
			B.volume += amount
			vessel.update_total()
	return amount

proc/blood_splatter(var/target,var/datum/reagent/blood/source,var/large,var/spray_dir)

	var/obj/effect/decal/cleanable/blood/B
	var/decal_type = /obj/effect/decal/cleanable/blood/splatter
	var/turf/T = get_turf(target)

	if(istype(source,/mob/living/carbon/human))
		var/mob/living/carbon/human/M = source
		source = M.get_blood(M.vessel)

	// Are we dripping or splattering?
	var/list/drips = list()
	// Only a certain number of drips (or one large splatter) can be on a given turf.
	for(var/obj/effect/decal/cleanable/blood/drip/drop in T)
		drips |= drop.drips
		qdel(drop)
	if(!large && drips.len < 3)
		decal_type = /obj/effect/decal/cleanable/blood/drip

	// Find a blood decal or create a new one.
	B = locate(decal_type) in T
	if(!B)
		B = new decal_type(T)

	var/obj/effect/decal/cleanable/blood/drip/drop = B
	if(istype(drop) && drips && drips.len && !large)
		drop.overlays |= drips
		drop.drips |= drips

	// If there's no data to copy, call it quits here.
	if(!source)
		return B

	// Update appearance.
	if(source.data["blood_colour"])
		B.basecolor = source.data["blood_colour"]
		B.update_icon()
	if(spray_dir)
		B.icon_state = "squirt"
		B.dir = spray_dir

	// Update blood information.
	if(source.data["blood_DNA"])
		B.blood_DNA = list()
		if(source.data["blood_type"])
			B.blood_DNA[source.data["blood_DNA"]] = source.data["blood_type"]
		else
			B.blood_DNA[source.data["blood_DNA"]] = "O+"

	// Update virus information.
	if(source.data["virus2"])
		B.virus2 = virus_copylist(source.data["virus2"])

	B.fluorescent  = 0
	return B

// 0-1
/mob/living/carbon/human/proc/get_blood_volume()
	. = vessel.total_volume / vessel.maximum_volume

/mob/living/carbon/human/process()
	var/hr = get_heart_rate()

	var/hrp 
	if(hr)
		hrp = 60.0 / hr
	else
		hrp = 0
	var/hrpd = hrp * 0.109 + 0.159
	var/coeff = (hrpd * 3.73134328) // 1 = hrpd(where hr = 60) => 3.73...

	if(get_cardiac_output() && get_blood_volume() && mcv < 100)
		mcv = rand(100, 150) // MCV should'nt be zero if any circulation present
// update GVR
	gvr = k*218.50746//max(120, k * dpressure * ((hrp-hrpd)/hrpd))
	gvr += LAZYACCESS0(chem_effects, CE_PRESSURE)
	gvr += spressure * (0.0008 * spressure - 0.8833) + 94 // simulate elasticity of vascular resistance
// update dpressure
	var/hr53 = hr * coeff * 53.0
	dpressure = max(0, LERP(dpressure, (gvr * (2180 + hr53))/(k * (17820 - hr53)), 0.5))
// update spressure

	var/mcv50divhr27
	if(hr)
		mcv50divhr27 = (50 * mcv) / (27 * hr)
	else
		mcv50divhr27 = (50 * mcv) / 10000

	spressure = clamp(LERP(spressure,  mcv50divhr27 + 2.0 * dpressure - (7646.0 * k)/54.0, 0.5), 0, MAX_PRESSURE)
	dpressure = min(dpressure, spressure - rand(5, 15))
// update mpressure
	mpressure = dpressure + (spressure - dpressure) / 3.0
// update MCV
	mcv = LERP(mcv, clamp(((((spressure + dpressure) * 4000) / gvr) * coeff * get_cardiac_output() + mcv_add) * get_blood_volume(), 0, MAX_MCV), 0.5)
	mcv_add = 0
// update perfusion
	var/n_perfusion = CLAMP01((mcv / (NORMAL_MCV * k)) * get_blood_saturation())
	perfusion = LERP(perfusion, n_perfusion, 0.2)

/mob/living/carbon/human/proc/get_heart_rate()
	var/obj/item/organ/internal/heart/heart = internal_organs_by_name[O_HEART]
	return round(heart?.pulse)

/mob/living/carbon/human/proc/get_cardiac_output()
	var/obj/item/organ/internal/heart/heart = internal_organs_by_name[O_HEART]
	if(!heart || !get_heart_rate())
		return 0
	return heart.cardiac_output

/mob/living/carbon/human/proc/get_blood_saturation()
	// TODO: make this by cm standards
	return clamp(1 - (getOxyLoss() / 100) + rand(-0.05, 0.05), 0, 0.99)

// 0-1
/mob/living/carbon/human/proc/get_blood_perfusion()
	return perfusion