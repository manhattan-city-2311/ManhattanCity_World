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
		vessel.add_reagent("blood", client.prefs.blood_level)
	else
		vessel.add_reagent("blood", species.blood_volume)
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
		blood_splatter(tar, src, (ddir > 0), spray_dir = ddir)
		return amt
	return 0

#define BLOOD_SPRAY_DISTANCE 3
/mob/living/carbon/human/proc/blood_squirt(amt, turf/sprayloc)
	if(amt <= 0 || !istype(sprayloc))
		return
	var/spraydir = pick(GLOB.alldirs)
	amt = ceil(amt/BLOOD_SPRAY_DISTANCE)
	var/bled = 0
	spawn(0)
		for(var/i in 1 to BLOOD_SPRAY_DISTANCE)
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
			if(hit_mob)
				break
			sleep(1)
	return bled
#undef BLOOD_SPRAY_DISTANCE

/mob/living/carbon/human/proc/remove_blood(amt)
	if(!should_have_organ(O_HEART) || !amt)
		return 0
	return vessel.remove_reagent(CI_BLOOD, amt * (mob_size / MOB_MEDIUM))

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to the container, preserving all data in it.
/mob/living/carbon/proc/take_blood(obj/item/weapon/reagent_containers/container, var/amount)
	var/datum/reagent/blood/B = get_blood(container.reagents)
	if(!B)
		B = new /datum/reagent/blood
		B.sync_to(src)
		container.reagents.add_reagent(CI_BLOOD, amount, B.data)
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
		if(reagent?.id == CI_BLOOD)
			var/datum/reagent/blood/blood = reagent
			blood.sync_to(src)
			return

//For humans, blood does not appear from blue, it comes from vessels.
/mob/living/carbon/human/take_blood(obj/item/weapon/reagent_containers/container, var/amount)
	if(!should_have_organ(O_HEART))
		reagents.trans_to_obj(container, amount)
		return 1

	if(vessel.get_reagent_amount(CI_BLOOD) < amount)
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
		return

	if(blood_incompatible(injected.data["blood_type"], injected.data["species"]))
		reagents.add_reagent("toxin", amount * 0.0625)
	vessel.add_reagent("blood", amount, injected.data)
	vessel.update_total()
	..()

/mob/living/carbon/human/proc/inject_saline(var/datum/reagent/saline/injected, var/amount)
	vessel.add_reagent("blood", amount, injected.data)
	vessel.update_total()

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
	var/blood_volume_raw = vessel.get_reagent_amount(CI_BLOOD)
	. = max(0, min(amount, species.blood_volume - blood_volume_raw))
	if(.)
		var/datum/reagent/blood/B = get_blood(vessel)
		if(istype(B))
			B.volume += amount
			vessel.update_total()

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
	return vessel.total_volume ? vessel.total_volume / vessel.maximum_volume : 0

/mob/living/carbon/human/proc/calc_heart_rate_coeff(hr)
	if(!hr)
		return 0 // hrp should be POSITIVE_INFINITY when hr = 0, but will be zero.
	. = ((60.0 / hr) * 0.109 + 0.159)
	. *= 3.73134328358209 // 1 = hrpd(where hr = 60) => 3.73...

// Recalcs cmed parameters due to HR change, use before true changing
/mob/living/carbon/human/proc/handle_heart_rate_change(newhr)
	mcv = get_cardiac_output() * newhr
	update_cm(newhr)

/mob/living/carbon/human/proc/update_cm(hr = get_heart_rate())
	var/blood_volume = sqrt(get_blood_volume())
	var/cardiac_output_mod = get_cardiac_output_mod()
	if(cardiac_output_mod && blood_volume && mcv < 100)
		mcv = 1000 * cardiac_output_mod * blood_volume // MCV should'nt be zero if any circulation present
	if(!blood_volume && (mpressure + mcv))
		spressure = mpressure = dpressure = mcv = 0

	var/coeff = calc_heart_rate_coeff(hr)

	var/ngvr = 218.50746268 + LAZYACCESS0(chem_effects, CE_PRESSURE)
	ngvr += spressure * (0.0008 * spressure - 0.8833) + 94 // elasticity of vascular resistance model

	ngvr = LERP(gvr, ngvr, 0.5)

	if(mcv)
		update_blood_pressure(hr, mcv, coeff)
	else if(mpressure)
		spressure = mpressure = dpressure = 0

	// update mcv
	var/mpressure2 = (mpressure + dpressure) * 0.5
	var/nmcv = ((mpressure2 * 7999.2) / gvr * coeff * cardiac_output_mod + mcv_add) * blood_volume
	mcv = clamp(nmcv, 0, MAX_MCV)
	mcv_add = 0

	var/n_perfusion = mcv ? CLAMP01((mcv / (NORMAL_MCV * k)) * (get_blood_saturation() / 0.97)) : 0

	perfusion = round(LERP(perfusion, n_perfusion, 0.2), 0.01)

	oxy = min(get_max_blood_oxygen_delta(), oxy)

/mob/living/carbon/human/proc/update_blood_pressure(hr, mcv, coeff, force = 0.5)
	var/hr53 = hr * coeff * 53.0
	dpressure = max(0, LERP(dpressure, (gvr * (2180 + hr53))/((17820 - hr53)), force))

	var/mcv50divhr27 = (50 * mcv) / ((27 * hr) || 1000)
	spressure = clamp(LERP(spressure, mcv50divhr27 + 2.0 * dpressure - (7646.0 * k)/49.585, force), 0, MAX_PRESSURE)
	dpressure = min(dpressure, spressure - rand(5, 15))

	mpressure = dpressure + (spressure - dpressure) / 3.0

/mob/living/carbon/human/proc/get_heart_rate()
	var/obj/item/organ/internal/heart/heart = internal_organs_by_name[O_HEART]
	return round(heart?.pulse)

/mob/living/carbon/human/proc/get_cardiac_output_mod()
	var/obj/item/organ/internal/heart/heart = internal_organs_by_name[O_HEART]
	if(!heart || !get_heart_rate())
		return 0
	return heart.cardiac_output

/mob/living/carbon/human/proc/get_cardiac_output()
	return get_heart_rate() && (max(mcv - mcv_add, 0) / get_heart_rate())

/mob/living/carbon/human/proc/get_blood_saturation()
	return clamp(1 - (get_deprivation() / 100), 0, 0.99)

// in minute
/mob/living/carbon/human/proc/get_max_blood_oxygen_delta()
	return mcv * 0.2 // 100 ml of blood can consume ~20 ml oxygen

/mob/living/carbon/human/get_deprivation()
	if(oxy && mcv)
		return max(0, 100 - round(oxy / (OXYGEN_LEVEL_NORMAL) * 100))
	return 0

// in minute
/mob/living/carbon/human/proc/get_max_blood_co2_delta()
	return mcv ? ((80 * NORMAL_MCV) / mcv) : 0

/mob/living/carbon/human/var/avail_oxygen = 0
/mob/living/carbon/human/var/avail_oxygen_last_tick = 0

/mob/living/carbon/human/proc/make_oxygen(amount, force = FALSE)
	if(!force)
		oxy += get_max_blood_oxygen_delta() - min(avail_oxygen + amount, get_max_blood_oxygen_delta())
	else
		oxy += amount
	avail_oxygen += amount

/mob/living/carbon/human/proc/remove_co2(amount)
	co2 = max(0, co2 - amount)

// metabolism place
/mob/living/carbon/human/proc/consume_oxygen(amount, efficiency = 1)
	var/max_delta = get_max_blood_oxygen_delta() / 300
	amount = min(amount, max_delta)
	if((oxy_last_tick_demand + amount) > max_delta)
		var/diff = oxy_last_tick_demand + amount - max_delta
		co2 += (diff / efficiency) * 2

	if(amount <= 0)
		return

	co2 += amount / efficiency
	oxy -= amount
	oxy_demand += amount

// 0-1
/mob/living/carbon/human/proc/get_blood_perfusion()
	return perfusion
