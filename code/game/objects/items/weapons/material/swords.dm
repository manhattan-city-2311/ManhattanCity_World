/obj/item/weapon/material/sword
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	slot_flags = SLOT_BELT
	force_divisor = 0.7 // 42 when wielded with hardnes 60 (steel)
	thrown_force_divisor = 0.5 // 10 when thrown with weight 20 (steel)
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'

	tax_type = WEAPONS_TAX
	contraband_type = CONTRABAND_KNIFELARGE


/obj/item/weapon/material/sword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

	if(default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/weapon/material/sword/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	viewers(user) << "<span class='danger'>[user] is falling on the [src.name]! It looks like [TU.he] [TU.is] trying to commit suicide.</span>"
	return(BRUTELOSS)

/obj/item/weapon/material/sword/katana
	name = "katana"
	desc = "Woefully underpowered in D20. This one looks pretty sharp."
	icon_state = "katana"
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/weapon/material/sword/katana/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	visible_message(SPAN("danger", "[user] is slitting [TU.his] stomach open with \the [src.name]! It looks like [TU.hes] trying to commit seppuku."), SPAN("danger", "You slit your stomach open with \the [src.name]!"), SPAN("danger", "You hear the sound of flesh tearing open.")) // gory, but it gets the point across
	return(BRUTELOSS)

/obj/item/weapon/material/sword/murasama
	name = "murasama"
	desc = "A high-frequency blade, it seems that you can cut anything with it. There will be bloodshed."
	icon_state = "murasama"
	slot_flags = SLOT_BELT
	applies_material_colour = 0
	default_material = "uranium"
	material = "uranium"
	embed_chance = 0
	force_divisor = 0.6
	reach = 2
	unbreakable = 1
	unacidable = 1
	armor_penetration = 50

/obj/item/weapon/material/sword/murasama/advisor
	name = "Best Advisor"
	desc = "The best adviser, will help in all matters that cannot be resolved peacefully."
