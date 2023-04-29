//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32
#define HEAT_DAMAGE_LEVEL_1 5 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 10 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 20 //Amount of damage applied when your body temperature passes the 1000K point

#define COLD_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 3 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

#define RADIATION_SPEED_COEFFICIENT 0.1

/mob/living/carbon/human
	var/oxygen_alert = 0
	var/phoron_alert = 0
	var/co2_alert = 0
	var/fire_alert = 0
	var/pressure_alert = 0
	var/temperature_alert = 0
	var/in_stasis = 0
	var/heartbeat = 0


/mob/living/carbon/human/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	if (transforming)
		return

	//Apparently, the person who wrote this code designed it so that
	//blinded get reset each cycle and then get activated later in the
	//code. Very ugly. I dont care. Moving this stuff here so its easy
	//to find it.
	blinded = 0
	fire_alert = 0

	//TODO: seperate this out
	// update the current life tick, can be used to e.g. only do something every 4 ticks
	++life_tick

	// This is not an ideal place for this but it will do for now.
	if(wearing_rig && wearing_rig.offline)
		wearing_rig = null

	..()

	if(life_tick % 30==15)
		hud_updateflag = 1022

	voice = GetVoice()

	var/stasis = inStasisNow()
	if(getStasis() > 2)
		Sleeping(20)

		if(!client)
			species.handle_npc(src)

	else if(stat == DEAD && !stasis)
		handle_defib_timer()

	if(!handle_some_updates())
		return											//We go ahead and process them 5 times for HUD images and other stuff though.

	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	pulse = handle_pulse()

	if(life_tick % 4 == 0)
		if(virus2.len > 0 && prob(10))
			for(var/mob/living/carbon/M in view(1,src))
				src.spread_disease_to(M)

/mob/living/carbon/human/proc/handle_some_updates()
	if(life_tick % 5 && timeofdeath && (timeofdeath < 5 || world.time - timeofdeath > 6000))	//We are long dead, or we're junk mobs spawned like the clowns on the clown shuttle
		return 0
	return 1

/mob/living/carbon/human/handle_disabilities()
	..()

	if(stat != CONSCIOUS) //Let's not worry about tourettes if you're not conscious.
		return

	if (disabilities & EPILEPSY)
		if ((prob(1) && paralysis < 1))
			to_chat(src, "<font color='red'>You have a seizure!</font>")
			for(var/mob/O in viewers(src, null))
				if(O == src)
					continue
				O.show_message(text("<span class='danger'>[src] starts having a seizure!</span>"), 1)
			Paralyse(10)
			make_jittery(1000)
	if (disabilities & COUGHING)
		if ((prob(5) && paralysis <= 1))
			drop_item()
			spawn( 0 )
				emote("cough")
				return
	if (disabilities & TOURETTES)
		if ((prob(10) && paralysis <= 1))
			Stun(10)
			spawn( 0 )
				switch(rand(1, 3))
					if(1)
						emote("twitch")
					if(2 to 3)
						say("[prob(50) ? ";" : ""][pick("ГОВНО", "МОЧА", "БЛЯТЬ", "СУКА", "ХУЕСОС", "МАМУ ЕБАЛ", "СИСЬКИ")]")
				make_jittery(100)
				return
	if (disabilities & NERVOUS)
		if (prob(10))
			stuttering = max(10, stuttering)

	var/rn = rand(0, 200)
	if(getBrainLoss() >= 5)
		if(0 <= rn && rn <= 3)
			custom_pain("Your head feels numb and painful.", 10)
	if(getBrainLoss() >= 15)
		if(4 <= rn && rn <= 6) if(eye_blurry <= 0)
			to_chat(src, "<span class='warning'>It becomes hard to see for some reason.</span>")
			eye_blurry = 10
	if(getBrainLoss() >= 35)
		if(7 <= rn && rn <= 9) if(get_active_hand())
			to_chat(src, "<span class='danger'>Your hand won't respond properly, you drop what you're holding!</span>")
			drop_item()
	if(getBrainLoss() >= 45)
		if(10 <= rn && rn <= 12)
			if(prob(50))
				to_chat(src, "<span class='danger'>You suddenly black out!</span>")
				Paralyse(10)
			else if(!lying)
				to_chat(src, "<span class='danger'>Your legs won't respond properly, you fall down!</span>")
				Weaken(10)



/mob/living/carbon/human/handle_mutations_and_radiation()
	if(inStasisNow())
		return

	if(getFireLoss())
		if((COLD_RESISTANCE in mutations) || (prob(1)))
			heal_organ_damage(0,1)

	// DNA2 - Gene processing.
	// The HULK stuff that was here is now in the hulk gene.
	if(!isSynthetic())
		for(var/datum/dna/gene/gene in dna_genes)
			if(!gene.block)
				continue
			if(gene.is_active(src))
				gene.OnMobLife(src)

	radiation = clamp(radiation,0,250)

	if(!radiation)
		if(species.appearance_flags & RADIATION_GLOWS)
			set_light(0)
	else
		if(species.appearance_flags & RADIATION_GLOWS)
			set_light(max(1,min(5,radiation/15)), max(1,min(10,radiation/25)), species.get_flesh_colour(src))
		// END DOGSHIT SNOWFLAKE

		var/obj/item/organ/internal/diona/nutrients/rad_organ = locate() in internal_organs_by_name
		if(rad_organ && !rad_organ.is_broken())
			var/rads = radiation/25
			radiation -= rads
			nutrition += rads
			adjustBruteLoss(-(rads))
			adjustFireLoss(-(rads))
			adjustOxyLoss(-(rads))
			adjustToxLoss(-(rads))
			updatehealth()
			return

		var/obj/item/organ/internal/brain/slime/core = locate() in internal_organs_by_name
		if(core)
			return

		var/damage = 0
		radiation -= 1 * RADIATION_SPEED_COEFFICIENT
		if(prob(25))
			damage = 1

		if (radiation > 50)
			damage = 1
			radiation -= 1 * RADIATION_SPEED_COEFFICIENT
			if(!isSynthetic())
				if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT))
					radiation -= 5 * RADIATION_SPEED_COEFFICIENT
					to_chat(src, "<span class='warning'>You feel weak.</span>")
					Weaken(3)
					if(!lying)
						emote("collapse")
				if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT) && species.get_bodytype() == SPECIES_HUMAN) //apes go bald
					if((h_style != "Bald" || f_style != "Shaved" ))
						to_chat(src, "<span class='warning'>Your hair falls out.</span>")
						h_style = "Bald"
						f_style = "Shaved"
						update_hair()

		if (radiation > 75)
			damage = 3
			radiation -= 1 * RADIATION_SPEED_COEFFICIENT
			if(!isSynthetic())
				if(prob(5))
					take_overall_damage(0, 5 * RADIATION_SPEED_COEFFICIENT, used_weapon = "Radiation Burns")
				if(prob(1))
					to_chat(src, "<span class='warning'>You feel strange!</span>")
					adjustCloneLoss(5 * RADIATION_SPEED_COEFFICIENT)
					emote("airgasp")

		if (radiation > 150)
			damage = 6
			radiation -= 4 * RADIATION_SPEED_COEFFICIENT

		if(damage)
			damage *= species.radiation_mod
			adjustToxLoss(damage * RADIATION_SPEED_COEFFICIENT)
			updatehealth()

/mob/living/carbon/human/proc/handle_chemical_smoke(var/datum/gas_mixture/environment)
	if(wear_mask && (wear_mask.item_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	if(glasses && (glasses.item_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	if(head && (head.item_flags & BLOCK_GAS_SMOKE_EFFECT))
		return

/mob/living/carbon/human/proc/handle_glucose_level()
	var/level = bloodstr.get_reagent_amount("glucose")

	switch(level)
		if(NEGATIVE_INFINITY to GLUCOSE_LEVEL_LCRITICAL)
			add_chemical_effect(CE_CARDIAC_OUTPUT, 0.1)
		if(GLUCOSE_LEVEL_LCRITICAL to GLUCOSE_LEVEL_L2BAD)
			add_chemical_effect(CE_CARDIAC_OUTPUT, 0.45)
		if(GLUCOSE_LEVEL_LBAD to GLUCOSE_LEVEL_NORMAL_LOW)
			add_chemical_effect(CE_CARDIAC_OUTPUT, 0.7)
		if(GLUCOSE_LEVEL_HBAD to GLUCOSE_LEVEL_H2BAD)
			add_chemical_effect(CE_CARDIAC_OUTPUT, 0.55)
		if(GLUCOSE_LEVEL_H2BAD to GLUCOSE_LEVEL_HCRITICAL)
			add_chemical_effect(CE_CARDIAC_OUTPUT, 0.40)
		if(GLUCOSE_LEVEL_HCRITICAL to GLUCOSE_LEVEL_H2CRITICAL)
			add_chemical_effect(CE_CARDIAC_OUTPUT, 0.10)

/*
/mob/living/carbon/human/proc/adjust_body_temperature(current, loc_temp, boost)
	var/temperature = current
	var/difference = abs(current-loc_temp)	//get difference
	var/increments// = difference/10			//find how many increments apart they are
	if(difference > 50)
		increments = difference/5
	else
		increments = difference/10
	var/change = increments*boost	// Get the amount to change by (x per increment)
	var/temp_change
	if(current < loc_temp)
		temperature = min(loc_temp, temperature+change)
	else if(current > loc_temp)
		temperature = max(loc_temp, temperature-change)
	temp_change = (temperature - current)
	return temp_change
*/

/mob/living/carbon/human/proc/reset_weight()
	if(has_modifier_of_type(/datum/modifier/trait/thin))
		remove_a_modifier_of_type(/datum/modifier/trait/thin)


	if(has_modifier_of_type(/datum/modifier/trait/thinner))
		remove_a_modifier_of_type(/datum/modifier/trait/thinner)


	if(has_modifier_of_type(/datum/modifier/trait/fat))
		remove_a_modifier_of_type(/datum/modifier/trait/fat)


	if(has_modifier_of_type(/datum/modifier/trait/obese))
		remove_a_modifier_of_type(/datum/modifier/trait/obese)

	update_transform()
	return


	//beyond this you're not getting any bigger, but you'll die.

/mob/living/carbon/human/proc/stabilize_body_temperature()
	// We produce heat naturally.
	if (species.passive_temp_gain)
		bodytemperature += species.passive_temp_gain
	if (species.body_temperature == null)
		return //this species doesn't have metabolic thermoregulation

	// FBPs will overheat, prosthetic limbs are fine.
	if(robobody_count)
		bodytemperature += round(robobody_count*1.75)

	var/body_temperature_difference = species.body_temperature - bodytemperature

	if (abs(body_temperature_difference) < 0.5)
		return //fuck this precision

	if (on_fire)
		return //too busy for pesky metabolic regulation

	if(bodytemperature < species.cold_level_1) //260.15 is 310.15 - 50, the temperature where you start to feel effects.
		if(nutrition >= 2) //If we are very, very cold we'll use up quite a bit of nutriment to heat us up.
			nutrition -= 2
		var/recovery_amt = max((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
		//to_world("Cold. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
//				log_debug("Cold. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
		bodytemperature += recovery_amt
	else if(species.cold_level_1 <= bodytemperature && bodytemperature <= species.heat_level_1)
		var/recovery_amt = body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR
		//to_world("Norm. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
//				log_debug("Norm. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
		bodytemperature += recovery_amt
	else if(bodytemperature > species.heat_level_1) //360.15 is 310.15 + 50, the temperature where you start to feel effects.
		//We totally need a sweat system cause it totally makes sense...~
		var/recovery_amt = min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)	//We're dealing with negative numbers
		//to_world("Hot. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
//				log_debug("Hot. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
		bodytemperature += recovery_amt

	//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, UPPER_TORSO, LOWER_TORSO, etc. See setup.dm for the full list)
/mob/living/carbon/human/proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
	. = 0
	//Handle normal clothing
	for(var/obj/item/clothing/C in list(head,wear_suit,w_uniform,shoes,gloves,wear_mask))
		if(C)
			if(C.max_heat_protection_temperature && C.max_heat_protection_temperature >= temperature)
				. |= C.heat_protection

//See proc/get_heat_protection_flags(temperature) for the description of this proc.
/mob/living/carbon/human/proc/get_cold_protection_flags(temperature)
	. = 0
	//Handle normal clothing
	for(var/obj/item/clothing/C in list(head,wear_suit,w_uniform,shoes,gloves,wear_mask))
		if(C)
			if(C.min_cold_protection_temperature && C.min_cold_protection_temperature <= temperature)
				. |= C.cold_protection

/mob/living/carbon/human/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = get_heat_protection_flags(temperature)
	return get_thermal_protection(thermal_protection_flags)

/mob/living/carbon/human/get_cold_protection(temperature)
	if(COLD_RESISTANCE in mutations)
		return 1 //Fully protected from the cold.

	temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	var/thermal_protection_flags = get_cold_protection_flags(temperature)
	return get_thermal_protection(thermal_protection_flags)

/mob/living/carbon/human/proc/get_thermal_protection(var/flags)
	.=0
	if(flags)
		if(flags & HEAD)
			. += THERMAL_PROTECTION_HEAD
		if(flags & UPPER_TORSO)
			. += THERMAL_PROTECTION_UPPER_TORSO
		if(flags & LOWER_TORSO)
			. += THERMAL_PROTECTION_LOWER_TORSO
		if(flags & LEG_LEFT)
			. += THERMAL_PROTECTION_LEG_LEFT
		if(flags & LEG_RIGHT)
			. += THERMAL_PROTECTION_LEG_RIGHT
		if(flags & FOOT_LEFT)
			. += THERMAL_PROTECTION_FOOT_LEFT
		if(flags & FOOT_RIGHT)
			. += THERMAL_PROTECTION_FOOT_RIGHT
		if(flags & ARM_LEFT)
			. += THERMAL_PROTECTION_ARM_LEFT
		if(flags & ARM_RIGHT)
			. += THERMAL_PROTECTION_ARM_RIGHT
		if(flags & HAND_LEFT)
			. += THERMAL_PROTECTION_HAND_LEFT
		if(flags & HAND_RIGHT)
			. += THERMAL_PROTECTION_HAND_RIGHT
	return min(1,.)

/mob/living/carbon/human/handle_chemicals_in_body()

	if(inStasisNow())
		return

	if(reagents)
		chem_effects.Cut()

		if(!isSynthetic())

			if(touching)
				touching.metabolize()
			if(ingested)
				ingested.metabolize()
			if(bloodstr)
				bloodstr.metabolize()

	if(status_flags & GODMODE)
		return 0	//godmode

	if(species.light_dam)
		var/light_amount = 0
		if(isturf(loc))
			var/turf/T = loc
			light_amount = T.get_lumcount() * 10
		if(light_amount > species.light_dam) //if there's enough light, start dying
			take_overall_damage(1,1)
		else //heal in the dark
			heal_overall_damage(1,1)

	// nutrition decrease
	var/nutrition_reduction = species.hunger_factor
	if(nutrition > 0 && stat != DEAD)
		adjust_nutrition(-species.hunger_factor)

		for(var/datum/modifier/mod in modifiers)
			if(!isnull(mod.metabolism_percent))
				nutrition_reduction *= mod.metabolism_percent

		nutrition = max (0, nutrition - nutrition_reduction)

	if(!isSynthetic())
		if(hydration > 0 && stat != DEAD)
			adjust_hydration(-species.thirst_factor)



		if(calories > 0 && stat != DEAD && client) //Calories won't burn when you're SSD or dead.
			adjust_calories(-species.metabolic_rate / 100)

		if (nutrition > 450)
			if(overeatduration < 600) //capped so people don't take forever to unfat
				overeatduration++
		else
			if(overeatduration > 1)
				overeatduration -= 2 //doubled the unfat rate

	// Trace chemicals
	for(var/T in chem_doses)
		if(bloodstr.has_reagent(T) || ingested.has_reagent(T) || touching.has_reagent(T))
			continue
		var/datum/reagent/R = T
		chem_doses[T] -= initial(R.metabolism)*2
		if(chem_doses[T] <= 0)
			chem_doses -= T

	updatehealth()

	return //TODO: DEFERRED

//DO NOT CALL handle_statuses() from this proc, it's called from living/Life() as long as this returns a true value.
/mob/living/carbon/human/handle_regular_status_updates()
	if(!handle_some_updates())
		return 0

	if(status_flags & GODMODE)	return 0

	//SSD check, if a logged player is awake put them back to sleep!
	if(species.get_ssd(src) && !client && !teleop && !npc)
		Sleeping(2)
	if(stat == DEAD)	//DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
		blinded = 1
		silent = 0
		handle_decay()
	else				//ALIVE. LIGHTS ARE ON
		updatehealth()	//TODO

		if((should_have_organ("brain") && !has_brain()))
			death()
			blinded = 1
			silent = 0
			return 1

		//UNCONSCIOUS. NO-ONE IS HOME
		if((get_deprivation() > (species.total_health/2)) || (health <= config.health_threshold_crit))
			Paralyse(3)

		if(hallucination)
			if(hallucination >= 20 && !(species.flags & (NO_POISON|IS_PLANT|NO_HALLUCINATION)) )
				if(prob(3))
					fake_attack(src)
				if(!handling_hal)
					spawn handle_hallucinations() //The not boring kind!
				if(client && prob(5))
					client.dir = pick(2,4,8)
					spawn(rand(20,50))
						client.dir = 1

			hallucination = max(0, hallucination - 2)
		else
			for(var/atom/a in hallucinations)
				qdel(a)

		//Brain damage from Oxyloss
		if(should_have_organ("brain"))
			var/brainOxPercent = 0.015		//Default 1.5% of your current oxyloss is applied as brain damage, 50 oxyloss is 1 brain damage
			if(CE_STABLE in chem_effects)
				brainOxPercent = 0.008		//Halved in effect
			if(oxyloss >= (getMaxHealth() * 0.3) && prob(5))  // If oxyloss exceeds 30% of your max health, you can take brain damage.
				adjustBrainLoss(brainOxPercent * oxyloss)

		if(halloss >= species.total_health)
			to_chat(src, "<span class='notice'>You're in too much pain to keep going...</span>")
			src.visible_message("<B>[src]</B> slumps to the ground, too weak to continue fighting.")
			Paralyse(10)
			setHalLoss(species.total_health - 1)

		if(paralysis || sleeping)
			blinded = 1
			set_stat(UNCONSCIOUS)
			animate_tail_reset()
			adjustHalLoss(-3)

			if(sleeping)
				handle_dreams()
				if (mind)
					//Are they SSD? If so we'll keep them asleep but work off some of that sleep var in case of stoxin or similar.
					if(client || sleeping > 3)
						AdjustSleeping(-1)
				if( prob(2) && health && !hal_crit )
					spawn(0)
						emote("snore")
		//CONSCIOUS
		else
			set_stat(CONSCIOUS)

		//Periodically double-check embedded_flag
		if(embedded_flag && !(life_tick % 10))
			var/list/E
			E = get_visible_implants(0)
			if(!E.len)
				embedded_flag = 0

		//Eyes
		//Check rig first because it's two-check and other checks will override it.
		if(istype(back,/obj/item/weapon/rig))
			var/obj/item/weapon/rig/O = back
			if(O.helmet && O.helmet == head && (O.helmet.body_parts_covered & EYES))
				if((O.offline && O.offline_vision_restriction == 2) || (!O.offline && O.vision_restriction == 2))
					blinded = 1

		// Check everything else.

		//Periodically double-check embedded_flag
		if(embedded_flag && !(life_tick % 10))
			if(!embedded_needs_process())
				embedded_flag = 0
		//Vision
		var/obj/item/organ/vision
		if(species.vision_organ)
			vision = internal_organs_by_name[species.vision_organ]

		if(!species.vision_organ) // Presumably if a species has no vision organs, they see via some other means.
			SetBlinded(0)
			blinded =    0
			eye_blurry = 0
		else if(!vision || vision.is_broken())   // Vision organs cut out or broken? Permablind.
			SetBlinded(1)
			blinded =    1
			eye_blurry = 1
		else //You have the requisite organs
			if(sdisabilities & BLIND) 	// Disabled-blind, doesn't get better on its own
				blinded =    1
			else if(eye_blind)		  	// Blindness, heals slowly over time
				AdjustBlinded(-1)
				blinded =    1
			else if(istype(glasses, /obj/item/clothing/glasses/sunglasses/blindfold))	//resting your eyes with a blindfold heals blurry eyes faster
				eye_blurry = max(eye_blurry-3, 0)
				blinded =    1

			if(eye_blurry)	           // Blurry eyes heal slowly
				eye_blurry = max(eye_blurry-1, 0)

		//Ears
		if(sdisabilities & DEAF)	//disabled-deaf, doesn't get better on its own
			ear_deaf = max(ear_deaf, 1)
		else if(ear_deaf)			//deafness, heals slowly over time
			ear_deaf = max(ear_deaf-1, 0)
		else if(get_ear_protection() >= 2)	//resting your ears with earmuffs heals ear damage faster
			ear_damage = max(ear_damage-0.15, 0)
			ear_deaf = max(ear_deaf, 1)
		else if(ear_damage < 25)	//ear damage heals slowly under this threshold. otherwise you'll need earmuffs
			ear_damage = max(ear_damage-0.05, 0)

		//Resting
		if(resting)
			dizziness = max(0, dizziness - 15)
			jitteriness = max(0, jitteriness - 15)
			adjustHalLoss(-3)
		else
			dizziness = max(0, dizziness - 3)
			jitteriness = max(0, jitteriness - 3)
			adjustHalLoss(-1)

		if (drowsyness)
			drowsyness = max(0, drowsyness - 1)
			eye_blurry = max(2, eye_blurry)
			if (prob(5))
				sleeping += 1
				Paralyse(5)

		// If you're dirty, your gloves will become dirty, too.
		if(gloves && germ_level > gloves.germ_level && prob(10))
			gloves.germ_level += 1

	return 1

/mob/living/carbon/human/proc/set_stat(var/new_stat)
	stat = new_stat
	if(stat)
		update_skin(1)

/mob/living/carbon/human/handle_regular_hud_updates()
	if(hud_updateflag) // update our mob's hud overlays, AKA what others see flaoting above our head
		handle_hud_list()

	// now handle what we see on our screen
	if(!client)
		return 0

	..()

	client.screen.Remove(global_hud.blurry, global_hud.druggy, global_hud.vimpaired, global_hud.darkMask, global_hud.nvg, global_hud.thermal, global_hud.meson, global_hud.science, global_hud.material, global_hud.whitense)

	if(istype(client.eye,/obj/machinery/camera))
		var/obj/machinery/camera/cam = client.eye
		client.screen |= cam.client_huds

	if(stat != DEAD)
		if(stat == UNCONSCIOUS && health <= 0)
			//Critical damage passage overlay
			var/severity = 0
			switch(health)
				if(-20 to -10)			severity = 1
				if(-30 to -20)			severity = 2
				if(-40 to -30)			severity = 3
				if(-50 to -40)			severity = 4
				if(-60 to -50)			severity = 5
				if(-70 to -60)			severity = 6
				if(-80 to -70)			severity = 7
				if(-90 to -80)			severity = 8
				if(-95 to -90)			severity = 9
				if(NEGATIVE_INFINITY to -95)	severity = 10
			overlay_fullscreen("crit", /obj/screen/fullscreen/crit, severity)
		else
			clear_fullscreen("crit")
			//Oxygen damage overlay
			if(oxyloss)
				var/severity = 0
				switch(oxyloss)
					if(10 to 20)		severity = 1
					if(20 to 25)		severity = 2
					if(25 to 30)		severity = 3
					if(30 to 35)		severity = 4
					if(35 to 40)		severity = 5
					if(40 to 45)		severity = 6
					if(45 to POSITIVE_INFINITY)	severity = 7
				overlay_fullscreen("oxy", /obj/screen/fullscreen/oxy, severity)
			else
				clear_fullscreen("oxy")

		//Fire and Brute damage overlay (BSSR)
		var/hurtdamage = src.getShockBruteLoss() + src.getShockFireLoss() + damageoverlaytemp	//Doesn't call the overlay if you can't actually feel it
		damageoverlaytemp = 0 // We do this so we can detect if someone hits us or not.
		if(hurtdamage)
			var/severity = 0
			switch(hurtdamage)
				if(10 to 25)		severity = 1
				if(25 to 40)		severity = 2
				if(40 to 55)		severity = 3
				if(55 to 70)		severity = 4
				if(70 to 85)		severity = 5
				if(85 to POSITIVE_INFINITY)	severity = 6
			overlay_fullscreen("brute", /obj/screen/fullscreen/brute, severity)
		else
			clear_fullscreen("brute")

	if(stat == DEAD)
		set_sight(sight | SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF)
		set_see_in_dark(8)
		if(!druggy)
			set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)
		if(healths)
			healths.icon_state = "health7"	//DEAD healthmeter
		if(client?.view != world.view) // If mob dies while zoomed in with device, unzoom them.
			for(var/obj/item/item in contents)
				if(item.zoom)
					item.zoom()
					break

	else
		set_sight(sight & ~(SEE_TURFS | SEE_MOBS | SEE_OBJS))
		set_see_invisible(see_in_dark > 2 ? SEE_INVISIBLE_LEVEL_ONE : see_invisible_default)

		if(XRAY in mutations)
			set_sight(sight | SEE_TURFS | SEE_MOBS | SEE_OBJS)
			set_see_in_dark(8)
			if(!druggy)
				set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)

		if(!seedarkness)
			set_sight(species.get_vision_flags(src))
			set_see_in_dark(8)
			set_see_invisible(SEE_INVISIBLE_NOLIGHTING)
		else
			set_sight(species.get_vision_flags(src))
			set_see_in_dark(species.darksight)
			set_see_invisible(see_in_dark > 2 ? SEE_INVISIBLE_LEVEL_ONE : see_invisible_default)

		var/glasses_processed = 0
		var/obj/item/weapon/rig/rig = back
		if(istype(rig) && rig.visor)
			if(!rig.helmet || (head && rig.helmet == head))
				if(rig.visor && rig.visor.vision && rig.visor.active && rig.visor.vision.glasses)
					glasses_processed = 1
					process_glasses(rig.visor.vision.glasses)

		if(glasses && !glasses_processed)
			glasses_processed = 1
			process_glasses(glasses)
		if(XRAY in mutations)
			set_sight(sight | SEE_TURFS | SEE_MOBS | SEE_OBJS)
			set_see_in_dark(8)
			if(!druggy)
				set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)

		if(!glasses_processed && (species.get_vision_flags(src) > 0))
			set_sight(sight | species.get_vision_flags(src))
		if(!seer && !glasses_processed && seedarkness)
			set_see_invisible(see_invisible_default)

		if(healths)
			if (chem_effects[CE_PAINKILLER] > 100)
				healths.icon_state = "health_numb"
				healths.overlays = null
			else
				// Generate a by-limb health display.
				var/mutable_appearance/healths_ma = new(healths)
				healths_ma.icon_state = "blank"
				healths_ma.overlays = null
				healths_ma.plane = PLANE_PLAYER_HUD

				var/no_damage = 1
				var/trauma_val = 0 // Used in calculating softcrit/hardcrit indicators.
				if(!(species.flags & NO_PAIN))
					trauma_val = max(shock_stage, halloss) / SHOCK_STAGE_AGONY
				var/limb_trauma_val = trauma_val*0.3
				// Collect and apply the images all at once to avoid appearance churn.
				var/list/health_images = list()
				for(var/obj/item/organ/external/E in organs_by_name)
					if(no_damage && E.get_pain())
						no_damage = 0
					health_images += E.get_damage_hud_image(limb_trauma_val)

				// Apply a fire overlay if we're burning.
				if(on_fire)
					health_images += image('icons/mob/OnFire.dmi',"[get_fire_icon_state()]")

				if(!trauma_val && no_damage)
					health_images += image('icons/mob/screen1_health.dmi',"fullhealth")

				healths_ma.overlays += health_images
				healths.appearance = healths_ma

		if(nutrition_icon)
			switch(bloodstr?.get_reagent_amount(CI_GLUCOSE))
				if(GLUCOSE_LEVEL_NORMAL + 0.2 to POSITIVE_INFINITY)				     nutrition_icon.icon_state = "nutrition0"
				if(GLUCOSE_LEVEL_NORMAL - 0.5 to GLUCOSE_LEVEL_NORMAL + 0.2) nutrition_icon.icon_state = "nutrition1"
				if(GLUCOSE_LEVEL_NORMAL - 2   to GLUCOSE_LEVEL_NORMAL - 0.5) nutrition_icon.icon_state = "nutrition2"
				if(GLUCOSE_LEVEL_LBAD + 2.5   to GLUCOSE_LEVEL_NORMAL - 2)   nutrition_icon.icon_state = "nutrition2"
				if(GLUCOSE_LEVEL_LBAD - 1     to GLUCOSE_LEVEL_LBAD + 2.5)	 nutrition_icon.icon_state = "nutrition4"
				if(NEGATIVE_INFINITY 		  to GLUCOSE_LEVEL_LBAD)		 nutrition_icon.icon_state = "nutrition5"
		if(!isSynthetic())
			if(hydration_icon)
				switch(hydration)
					if(450 to POSITIVE_INFINITY)				hydration_icon.icon_state = "thirst0"
					if(350 to 450)					hydration_icon.icon_state = "thirst1"
					if(250 to 350)					hydration_icon.icon_state = "thirst2"
					if(150 to 250)					hydration_icon.icon_state = "thirst3"
					if(50 to 150)					hydration_icon.icon_state = "thirst4"
					else						hydration_icon.icon_state = "thirst5"
		if(pressure)
			pressure.icon_state = "pressure[pressure_alert]"

//			if(rest)	//Not used with new UI
//				if(resting || lying || sleeping)		rest.icon_state = "rest1"
//				else									rest.icon_state = "rest0"
		if(toxin)
			if(hal_screwyhud == 4 || (phoron_alert && !does_not_breathe))	toxin.icon_state = "tox1"
			else									toxin.icon_state = "tox0"
		if(oxygen)
			if(hal_screwyhud == 3 || (oxygen_alert && !does_not_breathe))	oxygen.icon_state = "oxy1"
			else									oxygen.icon_state = "oxy0"
		if(fire)
			if(fire_alert)							fire.icon_state = "fire[fire_alert]" //fire_alert is either 0 if no alert, 1 for cold and 2 for heat.
			else									fire.icon_state = "fire0"

		if(bodytemp)
			if (!species)
				switch(bodytemperature) //310.055 optimal body temp
					if(370 to POSITIVE_INFINITY)		bodytemp.icon_state = "temp4"
					if(350 to 370)			bodytemp.icon_state = "temp3"
					if(335 to 350)			bodytemp.icon_state = "temp2"
					if(320 to 335)			bodytemp.icon_state = "temp1"
					if(300 to 320)			bodytemp.icon_state = "temp0"
					if(295 to 300)			bodytemp.icon_state = "temp-1"
					if(280 to 295)			bodytemp.icon_state = "temp-2"
					if(260 to 280)			bodytemp.icon_state = "temp-3"
					else					bodytemp.icon_state = "temp-4"
			else
				//TODO: precalculate all of this stuff when the species datum is created
				var/base_temperature = species.body_temperature
				if(base_temperature == null) //some species don't have a set metabolic temperature
					base_temperature = (species.heat_level_1 + species.cold_level_1)/2

				var/temp_step
				if (bodytemperature >= base_temperature)
					temp_step = (species.heat_level_1 - base_temperature)/4

					if (bodytemperature >= species.heat_level_1)
						bodytemp.icon_state = "temp4"
					else if (bodytemperature >= base_temperature + temp_step*3)
						bodytemp.icon_state = "temp3"
					else if (bodytemperature >= base_temperature + temp_step*2)
						bodytemp.icon_state = "temp2"
					else if (bodytemperature >= base_temperature + temp_step*1)
						bodytemp.icon_state = "temp1"
					else
						bodytemp.icon_state = "temp0"

				else if (bodytemperature < base_temperature)
					temp_step = (base_temperature - species.cold_level_1)/4

					if (bodytemperature <= species.cold_level_1)
						bodytemp.icon_state = "temp-4"
					else if (bodytemperature <= base_temperature - temp_step*3)
						bodytemp.icon_state = "temp-3"
					else if (bodytemperature <= base_temperature - temp_step*2)
						bodytemp.icon_state = "temp-2"
					else if (bodytemperature <= base_temperature - temp_step*1)
						bodytemp.icon_state = "temp-1"
					else
						bodytemp.icon_state = "temp0"

		if(blinded)		overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
		else			clear_fullscreens()

		if(disabilities & NEARSIGHTED)	//this looks meh but saves a lot of memory by not requiring to add var/prescription
			if(glasses)					//to every /obj/item
				var/obj/item/clothing/glasses/G = glasses
				if(!G.prescription)
					set_fullscreen(disabilities & NEARSIGHTED, "impaired", /obj/screen/fullscreen/impaired, 1)
			else
				set_fullscreen(disabilities & NEARSIGHTED, "impaired", /obj/screen/fullscreen/impaired, 1)

		set_fullscreen(eye_blurry, "blurry", /obj/screen/fullscreen/blurry)
		set_fullscreen(druggy, "high", /obj/screen/fullscreen/high)

		if(config.welder_vision)
			var/found_welder
			if(species.short_sighted)
				found_welder = 1
			else
				if(istype(glasses, /obj/item/clothing/glasses/welding))
					var/obj/item/clothing/glasses/welding/O = glasses
					if(!O.up)
						found_welder = 1
				if(!found_welder && istype(head, /obj/item/clothing/head/welding))
					var/obj/item/clothing/head/welding/O = head
					if(!O.up)
						found_welder = 1
				if(!found_welder && istype(back, /obj/item/weapon/rig))
					var/obj/item/weapon/rig/O = back
					if(O.helmet && O.helmet == head && (O.helmet.body_parts_covered & EYES))
						if((O.offline && O.offline_vision_restriction == 1) || (!O.offline && O.vision_restriction == 1))
							found_welder = 1
			if(found_welder)
				client.screen |= global_hud.darkMask

		if(machine)
			var/viewflags = machine.check_eye(src)
			machine.apply_visual(src)
			if(viewflags < 0)
				reset_view(null, 0)
			else if(viewflags && !looking_elsewhere)
				set_sight(sight | viewflags)
		else if(eyeobj)
			if(eyeobj.owner != src)

				reset_view(null)
		else
			var/isRemoteObserve = 0
			if((mRemote in mutations) && remoteview_target)
				if(remoteview_target.stat==CONSCIOUS)
					isRemoteObserve = 1
			if(!isRemoteObserve && client && !client.adminobs)
				remoteview_target = null
				reset_view(null, 0)
	return 1

/mob/living/carbon/human/reset_view(atom/A)
	..()
	if(machine_visual && machine_visual != A)
		machine_visual.remove_visual(src)

/mob/living/carbon/human/proc/process_glasses(var/obj/item/clothing/glasses/G)
	if(G && G.active)
		see_in_dark += G.darkness_view
		if(G.overlay)
			client.screen |= G.overlay
		if(G.vision_flags)
			set_sight(sight | G.vision_flags)
		if(istype(G,/obj/item/clothing/glasses/night) && !seer)
			see_invisible = SEE_INVISIBLE_MINIMUM

		if(G.see_invisible >= 0)
			see_invisible = G.see_invisible
		else if(!druggy && !seer)
			see_invisible = see_invisible_default

/mob/living/carbon/human/handle_random_events()
	if(inStasisNow())
		return

	// Puke if toxloss is too high
	if(!stat)
		if (getToxLoss() >= 30 && isSynthetic())
			if(!confused)
				if(prob(5))
					to_chat(src, "<span class='danger'>You lose directional control!</span>")
					Confuse(10)
		if (getToxLoss() >= 45)
			spawn vomit()


	//0.1% chance of playing a scary sound to someone who's in complete darkness
	if(isturf(loc) && rand(1,1000) == 1)
		var/turf/T = loc
		if(T.get_lumcount() <= LIGHTING_SOFT_THRESHOLD)
			playsound_local(src,pick(scarySounds),50, 1, -1)

/mob/living/carbon/human/handle_stomach()
	spawn(0)
		for(var/mob/living/M in stomach_contents)
			if(M.loc != src)
				stomach_contents.Remove(M)
				continue
			if(istype(M, /mob/living/carbon) && stat != 2)
				if(M.stat == 2)
					M.death(1)
					stomach_contents.Remove(M)
					qdel(M)
					continue
				if(prob(30)) // TODO: Fix this, probably stub, this should be handled by cumed
					adjust_nutrition(10)

/mob/living/carbon/human/proc/handle_changeling()
	if(mind && mind.changeling)
		mind.changeling.regenerate()
		if(hud_used)
			ling_chem_display.invisibility = 0
//			ling_chem_display.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#dd66dd'>[round(mind.changeling.chem_charges)]</font></div>"
			switch(mind.changeling.chem_storage)
				if(1 to 50)
					switch(mind.changeling.chem_charges)
						if(0 to 9)
							ling_chem_display.icon_state = "ling_chems0"
						if(10 to 19)
							ling_chem_display.icon_state = "ling_chems10"
						if(20 to 29)
							ling_chem_display.icon_state = "ling_chems20"
						if(30 to 39)
							ling_chem_display.icon_state = "ling_chems30"
						if(40 to 49)
							ling_chem_display.icon_state = "ling_chems40"
						if(50)
							ling_chem_display.icon_state = "ling_chems50"
				if(51 to 80) //This is a crappy way of checking for engorged sacs...
					switch(mind.changeling.chem_charges)
						if(0 to 9)
							ling_chem_display.icon_state = "ling_chems0e"
						if(10 to 19)
							ling_chem_display.icon_state = "ling_chems10e"
						if(20 to 29)
							ling_chem_display.icon_state = "ling_chems20e"
						if(30 to 39)
							ling_chem_display.icon_state = "ling_chems30e"
						if(40 to 49)
							ling_chem_display.icon_state = "ling_chems40e"
						if(50 to 59)
							ling_chem_display.icon_state = "ling_chems50e"
						if(60 to 69)
							ling_chem_display.icon_state = "ling_chems60e"
						if(70 to 79)
							ling_chem_display.icon_state = "ling_chems70e"
						if(80)
							ling_chem_display.icon_state = "ling_chems80e"
	else
		if(mind && hud_used)
			ling_chem_display.invisibility = 101

/mob/living/carbon/human/var/shock_decrease_coeff = 0.1

/mob/living/carbon/human/proc/handle_shock()
	if(status_flags & GODMODE)
		return	//godmode
	if(!can_feel_pain())
		return
	if(stat == DEAD)
		shock_stage = 0
		return

	shock_stage = clamp(shock_stage - shock_decrease_coeff * shock_stage, 0, SHOCK_STAGE_MAX)
	shock_stage = LERP(shock_stage, total_pain, 0.7)

	var/font_size
	var/message
	switch(shock_stage)
		if(SHOCK_STAGE_STUN-10 to SHOCK_STAGE_STUN-2)
			message = pick(SHOCK_PAIN_MESSAGES_SEVERE)

			if(life_tick % SHOCK_STAGE_STUN == 0)
				Weaken(20)

			font_size = 2

		if(SHOCK_STAGE_STUN - 1 to SHOCK_STAGE_STUN + 1)
			if(prob(20))
				custom_pain(SPAN_NOTICE("You feel a sudden relief..."))
				emote("collapse")
				Paralyse(5)
			else
				message = "You cannot resist any more!"
				if((life_tick % SHOCK_EMOTE_PERIOD) == 0)
					emote(pick("cry", "scream", "scream", "cry", "agony"), supress_warning = TRUE)

				if((life_tick % SHOCK_STAGE_STUN) == 0)
					Weaken(5)
			font_size = 3

		if(SHOCK_STAGE_STUN+2 to SHOCK_STAGE_AGONY)
			message = pick(SHOCK_PAIN_MESSAGES_SEVERE)
			if((life_tick % SHOCK_STAGE_STUN) == 0)
				Weaken(20)
			if(prob(4))
				Stun(rand(5, 10))

			font_size = 3

		if(SHOCK_STAGE_AGONY to POSITIVE_INFINITY)
			message = pick(SHOCK_PAIN_MESSAGES_SEVERE)

			if((life_tick % SHOCK_STAGE_STUN) == 0)
				Weaken(20)

			if(prob(4))
				Stun(rand(7, 12))

			if(prob(1))
				emote("collapse")
				Paralyse(5)

			font_size = 3
			if((life_tick % SHOCK_EMOTE_PERIOD) == 0)
				emote("agony", supress_warning = TRUE)

	if(message)
		throttle_message("shock", message, bold = TRUE, font_size = font_size, span = "danger", delay = SHOCK_MESSAGE_PERIOD)




/mob/living/carbon/human/proc/handle_pulse()
	return

/mob/living/carbon/human/proc/handle_nourishment()
	if (nutrition <= 0)
		if (prob(1.5))
			if(!isSynthetic())
				to_chat(src, SPAN("warning", "Your hunger pangs are excruciating as the stomach acid sears in your stomach... you feel weak."))
			else
				to_chat(src, SPAN("warning", "Your internal battery makes a silent beep. It is time to recharge."))

		return

	if (hydration <= 0)
		if (prob(1.5))
			if(!isSynthetic())
				to_chat(src, SPAN("warning", "You feel dizzy and disorientated as your lack of hydration becomes impossible to ignore."))

		return



/mob/living/carbon/human/proc/handle_heartbeat()
	return

/mob/living/carbon/human/proc/handle_hud_list()
	if(!client)
		return
	if (BITTEST(hud_updateflag, HEALTH_HUD))
		var/image/holder = grab_hud(HEALTH_HUD)
		if(stat == DEAD)
			holder.icon_state = "-100" 	// X_X
		else
			holder.icon_state = RoundHealth((health-config.health_threshold_crit)/(getMaxHealth()-config.health_threshold_crit)*100)
		apply_hud(HEALTH_HUD, holder)

	if (BITTEST(hud_updateflag, LIFE_HUD))
		var/image/holder = grab_hud(LIFE_HUD)
		if(isSynthetic())
			holder.icon_state = "hudrobo"
		else if(stat == DEAD)
			holder.icon_state = "huddead"
		else
			holder.icon_state = "hudhealthy"
		apply_hud(LIFE_HUD, holder)

	if (BITTEST(hud_updateflag, STATUS_HUD))
		var/foundVirus = 0
		for (var/ID in virus2)
			if (ID in virusDB)
				foundVirus = 1
				break

		var/image/holder = grab_hud(STATUS_HUD)
		var/image/holder2 = grab_hud(STATUS_HUD_OOC)
		if (isSynthetic())
			holder.icon_state = "hudrobo"
		else if(stat == DEAD)
			holder.icon_state = "huddead"
			holder2.icon_state = "huddead"
		else if(foundVirus)
			holder.icon_state = "hudill"
		else if(has_brain_worms())
			var/mob/living/simple_mob/animal/borer/B = has_brain_worms()
			if(B.controlling)
				holder.icon_state = "hudbrainworm"
			else
				holder.icon_state = "hudhealthy"
			holder2.icon_state = "hudbrainworm"
		else
			holder.icon_state = "hudhealthy"
			if(virus2.len)
				holder2.icon_state = "hudill"
			else
				holder2.icon_state = "hudhealthy"

		apply_hud(STATUS_HUD, holder)
		apply_hud(STATUS_HUD_OOC, holder2)

	if (BITTEST(hud_updateflag, ID_HUD))
		var/image/holder = grab_hud(ID_HUD)
		if(wear_id)
			var/obj/item/weapon/card/id/I = wear_id.GetID()
			if(I)
				holder.icon_state = "hud[ckey(I.GetJobName())]"
			else
				holder.icon_state = "hudunknown"
		else
			holder.icon_state = "hudunknown"

		apply_hud(ID_HUD, holder)

	if (BITTEST(hud_updateflag, WANTED_HUD))
		var/image/holder = grab_hud(WANTED_HUD)
		holder.icon_state = "hudblank"
		var/perpname = name
		if(wear_id)
			var/obj/item/weapon/card/id/I = wear_id.GetID()
			if(I)
				perpname = I.registered_name

		for(var/datum/data/record/E in data_core.general)
			if(E.fields["name"] == perpname)
				for (var/datum/data/record/R in data_core.security)
					if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
						holder.icon_state = "hudwanted"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Incarcerated"))
						holder.icon_state = "hudprisoner"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Parolled"))
						holder.icon_state = "hudparolled"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Released"))
						holder.icon_state = "hudreleased"
						break

		apply_hud(WANTED_HUD, holder)

	if (  BITTEST(hud_updateflag, IMPLOYAL_HUD) \
	   || BITTEST(hud_updateflag,  IMPCHEM_HUD) \
	   || BITTEST(hud_updateflag, IMPTRACK_HUD))

		var/image/holder1 = grab_hud(IMPTRACK_HUD)
		var/image/holder2 = grab_hud(IMPLOYAL_HUD)
		var/image/holder3 = grab_hud(IMPCHEM_HUD)

		holder1.icon_state = "hudblank"
		holder2.icon_state = "hudblank"
		holder3.icon_state = "hudblank"

		for(var/obj/item/weapon/implant/I in src)
			if(I.implanted)
				if(!I.malfunction)
					if(istype(I,/obj/item/weapon/implant/tracking))
						holder1.icon_state = "hud_imp_tracking"
					if(istype(I,/obj/item/weapon/implant/loyalty))
						holder2.icon_state = "hud_imp_loyal"
					if(istype(I,/obj/item/weapon/implant/chem))
						holder3.icon_state = "hud_imp_chem"

		apply_hud(IMPTRACK_HUD, holder1)
		apply_hud(IMPLOYAL_HUD, holder2)
		apply_hud(IMPCHEM_HUD, holder3)

	if (BITTEST(hud_updateflag, SPECIALROLE_HUD))
		var/image/holder = grab_hud(SPECIALROLE_HUD)
		holder.icon_state = "hudblank"
		if(mind && mind.special_role)
			if(hud_icon_reference[mind.special_role])
				holder.icon_state = hud_icon_reference[mind.special_role]
			else
				holder.icon_state = "hudsyndicate"
		apply_hud(SPECIALROLE_HUD, holder)

	hud_updateflag = 0

/mob/living/carbon/human/handle_stunned()
	if(!can_feel_pain())
		stunned = 0
		return 0
	return ..()

/mob/living/carbon/human/handle_fire()
	if(..())
		return

	var/thermal_protection = get_heat_protection(fire_stacks * 1500) // Arbitrary but below firesuit max temp when below 20 stacks.

	if(thermal_protection != 1) // Immune.
		bodytemperature += (BODYTEMP_HEATING_MAX + (fire_stacks * 15)) * (1-thermal_protection)

/mob/living/carbon/human/rejuvenate()
	species.restore_missed_organs(src)

	setup_cm()
	restore_blood()

	total_pain = 0
	shock_stage = 0

	spressure = initial(spressure)
	mpressure = initial(mpressure)
	dpressure = initial(dpressure)

	perfusion = 1

	mcv_add = 0

	for (var/ID in virus2)
		var/datum/disease2/disease/V = virus2[ID]
		V.cure(src)

	losebreath = 0

	co2 = 0
	oxy = OXYGEN_LEVEL_NORMAL //* k

	. = ..()
	
	bloodstr.add_reagent(CI_GLUCOSE, GLUCOSE_LEVEL_NORMAL)


/mob/living/carbon/human/proc/handle_defib_timer()
	if(!should_have_organ(O_BRAIN))
		return // No brain.

	var/obj/item/organ/internal/brain/brain = internal_organs_by_name[O_BRAIN]
	if(!brain)
		return // Still no brain.

/mob/living/carbon/human/proc/handle_decay()
	var/decaytime = world.time - timeofdeath
	var/image/flies = image('icons/effects/effects.dmi', "rotten")//This is a hack, there has got to be a safer way to do this but I don't know it at the moment.

	if(isSynthetic())
		return

	if(decaytime <= 6000) //10 minutes for decaylevel1 -- stinky
		return

	if(decaytime > 6000 && decaytime <= 12000)//20 minutes for decaylevel2 -- bloated and very stinky
		decaylevel = 1
		overlays -= flies
		overlays += flies

	if(decaytime > 12000 && decaytime <= 18000)//30 minutes for decaylevel3 -- rotting and gross
		decaylevel = 2

	if(decaytime > 18000 && decaytime <= 27000)//45 minutes for decaylevel4 -- skeleton
		decaylevel = 3

	if(decaytime > 27000)
		decaylevel = 4
		overlays -= flies
		flies = null
		ChangeToSkeleton()
		return

	for(var/mob/living/carbon/human/H in range(decaylevel, src))
		if(prob(2))
			if(istype(loc,/obj/item/bodybag))
				return
			if(H.wear_mask)
				return
			if(H.stat == DEAD)//This shouldn't even need to be a fucking check.
				return
			to_chat(H, "<spawn class='warning'>You smell something foul...")
			if(prob(75))
				H.vomit()

#undef HUMAN_MAX_OXYLOSS
