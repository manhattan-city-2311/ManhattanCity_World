var/list/organ_cache = list()

/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	germ_level = 0
	w_class = ITEMSIZE_TINY
	var/min_bruised_damage

	// Strings.
	var/organ_tag = "organ"           // Unique identifier.
	var/parent_organ = BP_TORSO      // Organ holding this object.
	var/dead_icon = "dead"

	// Status tracking.
	var/status = 0                    // Various status flags (such as robotic)
	var/vital                         // Lose a vital limb, die immediately.
	var/robotic = 0

	// Reference data.
	var/mob/living/carbon/human/owner // Current mob owning the organ.
	var/datum/dna/dna                 // Original DNA.
	var/datum/species/species         // Original species.

	// Damage vars.
	var/damage = 0                    // Current damage to the organ
	var/min_broken_damage = 30     	  // Damage before becoming broken
	var/max_damage                    // Damage cap
	var/rejecting                     // Is this organ already being rejected?
	var/preserved
	var/death_time

/obj/item/organ/internal/proc/is_bruised()
	return damage >= min_bruised_damage

/obj/item/organ/Destroy()

	owner = null
	dna = null
	species = null

	return ..()

/obj/item/organ/proc/update_health()
	return

/obj/item/organ/proc/is_broken()
	return (damage >= min_broken_damage || (status & ORGAN_CUT_AWAY) || (status & ORGAN_BROKEN))

/obj/item/organ/New(var/mob/living/carbon/human/holder, var/internal)
	..(holder)

	if(max_damage)
		min_broken_damage = floor(max_damage / 2)
	else
		max_damage = min_broken_damage * 2

	if(istype(holder))
		owner = holder
		w_class = max(w_class + mob_size_difference(holder.mob_size, MOB_MEDIUM), 1) //smaller mobs have smaller organs.

		if(holder.dna)
			dna = holder.dna.Clone()
			species = all_species[dna.species]
		else
			species = all_species[SPECIES_HUMAN]
			log_debug("[src] spawned in [holder] without a proper DNA.")
	var/obj/item/organ/external/E = holder.get_organ(parent_organ)
	if(E && internal)
		if(E.internal_organs == null)
			E.internal_organs = list()
		E.internal_organs |= src

	if(dna)
		if(!blood_DNA)
			blood_DNA = list()
		blood_DNA[dna.unique_enzymes] = dna.b_type
	
	if(internal)
		holder.internal_organs |= src

	create_reagents(5 * (w_class-1)**2)
	//reagents.add_reagent(/datum/reagent/nutriment/protein, reagents.maximum_volume)

	update_icon()

/obj/item/organ/proc/set_dna(var/datum/dna/new_dna)
	if(new_dna)
		dna = new_dna.Clone()
		if(!blood_DNA)
			blood_DNA = list()
		blood_DNA.Cut()
		blood_DNA[dna.unique_enzymes] = dna.b_type
		species = all_species[new_dna.species]

/obj/item/organ/proc/die()
	damage = max_damage
	status |= ORGAN_DEAD
	STOP_PROCESSING(SSobj, src)
	death_time = world.time
	if(owner && vital)
		owner.death()

/obj/item/organ/Process()

	if(loc != owner)
		owner = null

	//dead already, no need for more processing
	if(status & ORGAN_DEAD)
		return
	//Process infections
	//if ((robotic >= ORGAN_ROBOT) || (owner && owner.species))
	//	germ_level = 0
	//	return

	if(!owner && reagents)
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
		if(B && prob(40))
			reagents.remove_reagent("blood",0.1)
			blood_splatter(src,B,1)
		if(config.organs_decay)
			take_damage(rand(1,3))
		germ_level += rand(2,6)
		if(germ_level >= INFECTION_LEVEL_TWO)
			germ_level += rand(4,8)
		if(germ_level >= INFECTION_LEVEL_THREE)
			germ_level += rand(1,2)

	else if(owner && owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Handle antibiotics and curing infections
		handle_antibiotics()
		handle_rejection()
		handle_germ_effects()

	//check if we've hit max_damage
	if(damage >= max_damage)
		die()

/obj/item/organ/proc/is_preserved()
	if(istype(loc,/obj/item/organ))
		var/obj/item/organ/O = loc
		return O.is_preserved()
	else
		return (istype(loc,/obj/item/device/mmi) || istype(loc,/obj/structure/closet/body_bag/cryobag) || istype(loc,/obj/structure/closet/crate/freezer) || istype(loc,/obj/item/weapon/storage/box/freezer))

/obj/item/organ/examine(mob/user)
	. = ..(user)
	show_decay_status(user)

/obj/item/organ/proc/show_decay_status(mob/user)
	if(status & ORGAN_DEAD)
		to_chat(user, "<span class='notice'>The decay has set into \the [src].</span>")

/obj/item/organ/proc/handle_germ_effects()
	//** Handle the effects of infections
	var/antibiotics = LAZYACCESS0(owner.chem_effects, CE_ANTIBIOTIC)

	if(germ_level > 0 && germ_level < INFECTION_LEVEL_ONE / 2)
		--germ_level

	if(germ_level >= INFECTION_LEVEL_ONE)
		if(owner.bodytemperature - T0C < 45.5)
			owner.bodytemperature += germ_level / 170

	if(germ_level >= INFECTION_LEVEL_TWO)
		var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
		// Spread germs
		if(antibiotics < 5 && parent.germ_level < germ_level && (parent.germ_level < INFECTION_LEVEL_ONE * 2))
			parent.germ_level++

		if (prob(3))	//about once every 30 seconds
			take_damage(germ_level / INFECTION_LEVEL_TWO)
	return germ_level

/obj/item/organ/proc/handle_rejection()
	// Process unsuitable transplants. TODO: consider some kind of
	// immunosuppressant that changes transplant data to make it match.
	if(isrobotic())
		return
	if(dna)
		if(!rejecting)
			if(owner.blood_incompatible(dna.b_type, species))
				rejecting = 1
		else
			++rejecting //Rejection severity increases over time.
			if(rejecting % 10 == 0) //Only fire every ten rejection ticks.
				switch(rejecting)
					if(1 to 50)
						++germ_level
					if(51 to 200)
						germ_level += rand(1,2)
					if(201 to 500)
						germ_level += rand(2,3)
					if(501 to POSITIVE_INFINITY)
						germ_level += rand(3,5)

/obj/item/organ/proc/receive_chem(chemical as obj)
	return 0

/obj/item/organ/proc/remove_rejuv()
	qdel(src)

/obj/item/organ/proc/rejuvenate(var/ignore_prosthetic_prefs)
	damage = 0
	status = 0
	if(!ignore_prosthetic_prefs && owner && owner.client && owner.client.prefs && owner.client.prefs.real_name == owner.real_name)
		var/status = owner.client.prefs.organ_data[organ_tag]
		if(status == "assisted")
			mechassist()
		else if(status == "mechanical")
			robotize()

//Germs
/obj/item/organ/proc/handle_antibiotics()
	var/antibiotics = owner.chem_effects[CE_ANTIBIOTIC]

	if (!germ_level || antibiotics < 5)
		return

	germ_level -= antibiotics / 5
	if(germ_level < INFECTION_LEVEL_ONE)
		germ_level = 0 // cure instantly

//Note: external organs have their own version of this proc
/obj/item/organ/proc/take_damage(amount, var/silent=0)
	damage = between(0, damage + round(amount, 0.1), max_damage)

/obj/item/organ/proc/heal_damage(amount)
	damage = between(0, damage - round(amount, 0.1), max_damage)


/obj/item/organ/proc/robotize() //Being used to make robutt hearts, etc
	robotic = ORGAN_ROBOT
	status = 0

/obj/item/organ/proc/mechassist() //Used to add things like pacemakers, etc
	status = 0
	robotic = ORGAN_ASSISTED
	min_broken_damage += 5

/obj/item/organ/emp_act(severity)
	if(!(robotic >= ORGAN_ROBOT))
		return
	switch (severity)
		if (1)
			take_damage(9)
		if (2)
			take_damage(3)
		if (3)
			take_damage(1)

/**
 *  Remove an organ
 *
 *  drop_organ - if true, organ will be dropped at the loc of its former owner
 */
/obj/item/organ/proc/removed(var/mob/living/user, var/drop_organ=1)

	if(!istype(owner))
		return

	if(drop_organ)
		dropInto(owner.loc)

	START_PROCESSING(SSobj, src)
	rejecting = null
	if(robotic < ORGAN_ROBOT)
		var/datum/reagent/blood/organ_blood = locate(/datum/reagent/blood) in reagents.reagent_list //TODO fix this and all other occurences of locate(/datum/reagent/blood) horror
		if(!organ_blood || !organ_blood.data["blood_DNA"])
			owner.vessel.trans_to(src, 5, 1, 1)

	if(owner && vital)
		if(user)
			log_admin(user, owner, "Removed a vital organ ([src]).", "Had a vital organ ([src]) removed.", "removed a vital organ ([src]) from")
		owner.death()
	owner.internal_organs_by_name -= organ_tag
	owner.internal_organs -= src
	owner.organs_by_name -= src
	owner = null

/obj/item/organ/proc/replaced(var/mob/living/carbon/human/target, var/obj/item/organ/external/affected)
	owner = target
	forceMove(owner) //just in case
	owner.internal_organs_by_name |= src
	owner.organs_by_name |= src
	if(isrobotic())
		set_dna(owner.dna)
	return 1

/obj/item/organ/attack(var/mob/target, var/mob/user)

	if(robotic >= ORGAN_ROBOT || !istype(target) || !istype(user) || (user != target && user.a_intent == I_HELP))
		return ..()

	if(alert("Do you really want to use this organ as food? It will be useless for anything else afterwards.",,"Ew, no.","Bon appetit!") == "Ew, no.")
		to_chat(user, "<span class='notice'>You successfully repress your cannibalistic tendencies.</span>")
		return

	user.drop_from_inventory(src)
	var/obj/item/weapon/reagent_containers/food/snacks/organ/O = new(get_turf(src))
	O.name = name
	O.appearance = src
	reagents.trans_to(O, reagents.total_volume)
	if(fingerprints)
		O.fingerprints = fingerprints.Copy()
	if(fingerprintshidden)
		O.fingerprintshidden = fingerprintshidden.Copy()
	if(fingerprintslast)
		O.fingerprintslast = fingerprintslast
	user.put_in_active_hand(O)
	qdel(src)
	target.attackby(O, user)

/obj/item/organ/proc/can_feel_pain()
	return 1

/obj/item/organ/proc/is_usable()
	return !(status & (ORGAN_CUT_AWAY|ORGAN_MUTATED|ORGAN_DEAD))

/obj/item/organ/proc/can_recover()
	return (!(status & ORGAN_DEAD) || death_time >= world.time - 180)

/obj/item/organ/proc/get_scan_results()
	. = list()
	if(robotic == ORGAN_ASSISTED)
		. += "Assisted"
	else if(robotic == ORGAN_ROBOT)
		. += "Mechanical"
	if(status & ORGAN_CUT_AWAY)
		. += "Severed"
	if(status & ORGAN_MUTATED)
		. += "Genetic Deformation"
	if(status & ORGAN_DEAD)
		if(can_recover())
			. += "Decaying"
		else
			. += "Necrotic"
	switch (germ_level)
		if(INFECTION_LEVEL_ONE to INFECTION_LEVEL_ONE + 50)
			. += "Mild Infection I"
		if(INFECTION_LEVEL_ONE + 50 to INFECTION_LEVEL_ONE + 100)
			. += "Mild Infection II"
		if(INFECTION_LEVEL_ONE + 100 to INFECTION_LEVEL_TWO)
			. += "Mild Infection III"
		if(INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO + 100)
			. += "Acute Infection I"
		if(INFECTION_LEVEL_TWO + 100 to INFECTION_LEVEL_TWO + 200)
			. += "Acute Infection II"
		if(INFECTION_LEVEL_TWO + 200 to INFECTION_LEVEL_THREE)
			. += "Acute Infection III"
		if(INFECTION_LEVEL_THREE to INFECTION_LEVEL_THREE + 100)
			. += "Septic I"
		if(INFECTION_LEVEL_THREE + 100 to INFECTION_LEVEL_THREE + 200)
			. += "Septic II"
		if(INFECTION_LEVEL_THREE + 200 to INFECTION_LEVEL_MAX)
			. += "Septic III"
		if(INFECTION_LEVEL_MAX to POSITIVE_INFINITY)
			. += "Gangrene"
	if(rejecting)
		. += "Genetic Rejection"

/obj/item/organ/proc/isrobotic()
	return robotic >= ORGAN_ROBOT

//used by stethoscope
/obj/item/organ/proc/listen()
	return
