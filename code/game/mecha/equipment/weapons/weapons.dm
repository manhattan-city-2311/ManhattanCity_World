/obj/item/mecha_parts/mecha_equipment/weapon
	name = "mecha weapon"
	range = RANGED
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3)
	var/projectile //Type of projectile fired.
	var/projectiles = 1 //Amount of projectiles loaded.
	var/projectiles_per_shot = 1 //Amount of projectiles fired per single shot.
	var/deviation = 0 //Inaccuracy of shots.
	var/fire_cooldown = 0 //Duration of sleep between firing projectiles in single shot.
	var/fire_sound //Sound played while firing.
	var/fire_volume = 50 //How loud it is played.
	var/auto_rearm = 0 //Does the weapon reload itself after each shot?
	required_type = list(/obj/mecha/combat, /obj/mecha/working/hoverpod/combatpod)

/obj/item/mecha_parts/mecha_equipment/weapon/action_checks(atom/target)
	if(projectiles <= 0)
		return 0
	return ..()

/obj/item/mecha_parts/mecha_equipment/weapon/action(atom/target)
	if(!action_checks(target))
		return
	var/turf/curloc = chassis.loc
	var/turf/targloc = get_turf(target)
	if(!curloc || !targloc)
		return
	chassis.use_power(energy_drain)
	chassis.visible_message("<span class='warning'>[chassis] fires [src]!</span>")
	occupant_message("<span class='warning'>You fire [src]!</span>")
	log_message("Fired from [src], targeting [target].")
	for(var/i = 1 to min(projectiles, projectiles_per_shot))
		var/turf/aimloc = targloc
		if(deviation)
			aimloc = locate(targloc.x+GaussRandRound(deviation,1),targloc.y+GaussRandRound(deviation,1),targloc.z)
		if(!aimloc || aimloc == curloc)
			break
		playsound(chassis, fire_sound, fire_volume, 1)
		projectiles--
		var/P = new projectile(curloc)
		Fire(P, target)
		if(fire_cooldown)
			sleep(fire_cooldown)
	if(auto_rearm)
		projectiles = projectiles_per_shot
	set_ready_state(0)
	do_after_cooldown()
	return

/obj/item/mecha_parts/mecha_equipment/weapon/proc/Fire(atom/A, atom/target)
	var/obj/item/projectile/P = A
	P.launch(target)

/obj/item/mecha_parts/mecha_equipment/weapon/energy
	name = "general energy weapon"
	auto_rearm = 1

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	equip_cooldown = 8
	name = "\improper CH-PS \"Immolator\" laser"
	icon_state = "mecha_laser"
	energy_drain = 30
	projectile = /obj/item/projectile/beam
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser
	equip_cooldown = 30
	name = "jury-rigged welder-laser"
	desc = "While not regulation, this inefficient weapon can be attached to working exo-suits in desperate, or malicious, times."
	icon_state = "mecha_laser"
	energy_drain = 80
	projectile = /obj/item/projectile/beam
	fire_sound = 'sound/weapons/Laser.ogg'
	required_type = list(/obj/mecha/combat, /obj/mecha/working)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy
	equip_cooldown = 15
	name = "\improper CH-LC \"Solaris\" laser cannon"
	icon_state = "mecha_laser"
	energy_drain = 60
	projectile = /obj/item/projectile/beam/heavylaser
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/ion
	equip_cooldown = 40
	name = "mkIV ion heavy cannon"
	icon_state = "mecha_ion"
	energy_drain = 120
	projectile = /obj/item/projectile/ion
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/pulse
	equip_cooldown = 30
	name = "eZ-13 mk2 heavy pulse rifle"
	icon_state = "mecha_pulse"
	energy_drain = 120
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 6, TECH_POWER = 4)
	projectile = /obj/item/projectile/beam/pulse/heavy
	fire_sound = 'sound/weapons/gauss_shoot.ogg'

/obj/item/projectile/beam/pulse/heavy
	name = "heavy pulse laser"
	icon_state = "pulse1_bl"
	var/life = 20

/obj/item/projectile/beam/pulse/heavy/Bump(atom/A, forced=0)
	A.bullet_act(src, def_zone)
	src.life -= 10
	if(life <= 0)
		qdel(src)
		return

/obj/item/mecha_parts/mecha_equipment/weapon/energy/taser
	name = "\improper PBT \"Pacifier\" mounted taser"
	icon_state = "mecha_taser"
	energy_drain = 20
	equip_cooldown = 8
	projectile = /obj/item/projectile/beam/stun
	fire_sound = 'sound/weapons/Taser.ogg'


/obj/item/mecha_parts/mecha_equipment/weapon/honker
	name = "sound emission device"
	icon_state = "mecha_honker"
	energy_drain = 300
	equip_cooldown = 150
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 4, TECH_ILLEGAL = 1)

/obj/item/mecha_parts/mecha_equipment/honker/action(target)
	if(!chassis)
		return 0
	if(energy_drain && chassis.get_charge() < energy_drain)
		return 0
	if(!equip_ready)
		return 0

	playsound(chassis, 'sound/effects/bang.ogg', 30, 1, 30)
	chassis.occupant_message("<span class='warning'>You emit a high-pitched noise from the mech.</span>")
	for(var/mob/living/carbon/M in ohearers(6, chassis))
		if(istype(M, /mob/living/carbon/human))
			var/ear_safety = 0
			ear_safety = M.get_ear_protection()
			if(ear_safety > 0)
				return
		to_chat(M, "<span class='warning'>Your ears feel like they're bleeding!</span>")
		playsound(M, 'sound/effects/bang.ogg', 70, 1, 30)
		M.sleeping = 0
		M.ear_deaf += 30
		M.ear_damage += rand(5, 20)
		M.Weaken(3)
		M.Stun(5)
	chassis.use_power(energy_drain)
	log_message("Used a sound emission device.")
	do_after_cooldown()
	return

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic
	name = "general ballisic weapon"
	var/projectile_energy_cost

	get_equip_info()
		return "[..()]\[[src.projectiles]\][(src.projectiles < initial(src.projectiles))?" - <a href='?src=\ref[src];rearm=1'>Rearm</a>":null]"

	proc/rearm()
		if(projectiles < initial(projectiles))
			var/projectiles_to_add = initial(projectiles) - projectiles
			while(chassis.get_charge() >= projectile_energy_cost && projectiles_to_add)
				projectiles++
				projectiles_to_add--
				chassis.use_power(projectile_energy_cost)
		send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
		log_message("Rearmed [src.name].")
		return

	Topic(href, href_list)
		..()
		if (href_list["rearm"])
			src.rearm()
		return


/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
	name = "\improper LBX AC 10 \"Scattershot\""
	icon_state = "mecha_scatter"
	equip_cooldown = 20
	projectile = /obj/item/projectile/bullet/pistol/medium
	fire_sound = 'sound/weapons/Gunshot.ogg'
	fire_volume = 80
	projectiles = 40
	projectiles_per_shot = 4
	deviation = 0.7
	projectile_energy_cost = 25

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	name = "\improper Ultra AC 2"
	icon_state = "mecha_uac2"
	equip_cooldown = 10
	projectile = /obj/item/projectile/bullet/pistol/medium
	fire_sound = 'sound/weapons/machinegun.ogg'
	projectiles = 300
	projectiles_per_shot = 3
	deviation = 0.3
	projectile_energy_cost = 20
	fire_cooldown = 2

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack
	var/missile_speed = 2
	var/missile_range = 30

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/Fire(atom/movable/AM, atom/target, turf/aimloc)
	AM.throw_at(target,missile_range, missile_speed, chassis)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare
	name = "\improper BNI Flare Launcher"
	icon_state = "mecha_flaregun"
	projectile = /obj/item/device/flashlight/flare
	fire_sound = 'sound/weapons/tablehit1.ogg'
	auto_rearm = 1
	fire_cooldown = 20
	projectiles_per_shot = 1
	projectile_energy_cost = 20
	missile_speed = 1
	missile_range = 15
	required_type = /obj/mecha  //Why restrict it to just mining or combat mechs?

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare/Fire(atom/movable/AM, atom/target, turf/aimloc)
	var/obj/item/device/flashlight/flare/fired = AM
	fired.ignite()
	..()

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	name = "\improper SRM-8 missile rack"
	icon_state = "mecha_missilerack"
	projectile = /obj/item/missile
	fire_sound = 'sound/weapons/rpg.ogg'
	projectiles = 8
	projectile_energy_cost = 1000
	equip_cooldown = 60

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive/Fire(atom/movable/AM, atom/target)
	var/obj/item/missile/M = AM
	M.primed = 1
	..()

/obj/item/missile
	icon = 'icons/obj/grenade.dmi'
	icon_state = "missile"
	var/primed = null
	throwforce = 15

	throw_impact(atom/hit_atom)
		if(primed)
			explosion(hit_atom, 1, 2, 5, 7)
			qdel(src)
		else
			..()
		return

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang
	name = "\improper SGL-6 grenade launcher"
	icon_state = "mecha_grenadelnchr"
	projectile = /obj/item/weapon/grenade/flashbang
	fire_sound = 'sound/effects/bang.ogg'
	projectiles = 6
	missile_speed = 1.5
	projectile_energy_cost = 800
	equip_cooldown = 60
	var/det_time = 20

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang/Fire(atom/movable/AM, atom/target, turf/aimloc)
	..()
	var/obj/item/weapon/grenade/flashbang/F = AM
	spawn(det_time)
		F.prime()

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang/clusterbang//Because I am a heartless bastard -Sieve
	name = "\improper SOP-6 grenade launcher"
	projectile = /obj/item/weapon/grenade/flashbang/clusterbang

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang/clusterbang/limited/get_equip_info()//Limited version of the clusterbang launcher that can't reload
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[chassis.selected==src?"<b>":"<a href='?src=\ref[chassis];select_equip=\ref[src]'>"][src.name][chassis.selected==src?"</b>":"</a>"]\[[src.projectiles]\]"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang/clusterbang/limited/rearm()
	return//Extra bit of security

//////////////
//Fire-based//
//////////////

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/incendiary
	name = "\improper DR-AC 3"
	desc = "Dual-barrel rotary machinegun that fires small, incendiary rounds. Ages ten and up."
	description_fluff = "A weapon designed by Hephaestus Industries, the DR-AC 3's design was plagued by prototype faults including but not limited to: Spontaneous combustion, spontaneous detonation, and excessive collateral conflagration."
	icon_state = "mecha_drac3"
	equip_cooldown = 20
	projectile = /obj/item/projectile/bullet/incendiary
	fire_sound = 'sound/weapons/machinegun.ogg'
	projectiles = 30
	projectiles_per_shot = 2
	deviation = 0.4
	projectile_energy_cost = 40
	fire_cooldown = 3
	origin_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 5, TECH_PHORON = 2, TECH_ILLEGAL = 1)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer
	equip_cooldown = 30
	name = "\improper CR-3 Mark 8"
	desc = "An imposing device, this weapon hurls balls of fire."
	description_fluff = "A weapon designed by Hephaestus for anti-infantry combat, the CR-3 is capable of outputting a large volume of synthesized fuel. Initially designed by a small company, later purchased by Aether, on Earth as a device made for clearing underbrush and co-operating with firefighting operations. Obviously, Hephaestus has found an 'improved' use for the Aether designs."
	icon_state = "mecha_cremate"

	energy_drain = 30

	projectile = /obj/item/projectile/bullet/incendiary/flamethrower/large
	fire_sound = 'sound/weapons/towelwipe.ogg'

	origin_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 6, TECH_PHORON = 4, TECH_ILLEGAL = 4)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer/rigged
	name = "\improper AA-CR-1 Mark 4"
	description_fluff = "A firefighting tool maintained by Aether Atmospherics, whose initial design originated from a small Earth company. This one seems to have been jury rigged."

	energy_drain = 50
	required_type = list(/obj/mecha/combat, /obj/mecha/working)

	projectile = /obj/item/projectile/bullet/incendiary/flamethrower

	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_PHORON = 3, TECH_ILLEGAL = 2)

//////////////
//Defensive//
//////////////

/obj/item/mecha_parts/mecha_equipment/shocker
	name = "exosuit electrifier"
	desc = "A device to electrify the external portions of a mecha in order to increase its defensive capabilities."
	icon_state = "mecha_coil"
	equip_cooldown = 10
	energy_drain = 100
	range = RANGED
	origin_tech = list(TECH_COMBAT = 3, TECH_POWER = 6)
	var/shock_damage = 15
	var/active

/obj/item/mecha_parts/mecha_equipment/shocker/can_attach(obj/mecha/M as obj)
	if(..())
		if(!M.proc_res["dynattackby"] && !M.proc_res["dynattackhand"] && !M.proc_res["dynattackalien"])
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/shocker/attach(obj/mecha/M as obj)
	..()
	chassis.proc_res["dynattackby"] = src
	return

/obj/item/mecha_parts/mecha_equipment/shocker/proc/dynattackby(obj/item/weapon/W, mob/living/user)
	if(!action_checks(user) || !active)
		return
	user.electrocute_act(shock_damage, src)
	return chassis.dynattackby(W,user)
