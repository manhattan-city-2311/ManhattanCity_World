/*
//	Least descriptive filename?
//	This is where all of the things that aren't really loot should go.
//	Barricades, mines, etc.
*/

/obj/random/junk //Broken items, or stuff that could be picked up
	name = "random junk"
	desc = "This is some random junk."
	icon = 'icons/obj/trash.dmi'
	icon_state = "trashbag3"

/obj/random/junk/item_to_spawn()
	return get_random_junk_type()

/obj/random/trash //Mostly remains and cleanable decals. Stuff a janitor could clean up
	name = "random trash"
	desc = "This is some random trash."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenglow"

/obj/random/trash/item_to_spawn()
	return pick(/obj/effect/decal/remains/lizard,
				/obj/effect/decal/cleanable/blood/gibs/robot,
				/obj/effect/decal/cleanable/blood/oil,
				/obj/effect/decal/cleanable/blood/oil/streak,
				/obj/effect/decal/cleanable/spiderling_remains,
				/obj/effect/decal/remains/mouse,
				/obj/effect/decal/cleanable/vomit,
				/obj/effect/decal/cleanable/blood/splatter,
				/obj/effect/decal/cleanable/ash,
				/obj/effect/decal/cleanable/generic,
				/obj/effect/decal/cleanable/flour,
				/obj/effect/decal/cleanable/dirt,
				/obj/effect/decal/remains/robot)

/obj/random/obstruction //Large objects to block things off in maintenance
	name = "random obstruction"
	desc = "This is a random obstruction."
	icon = 'icons/obj/cult.dmi'
	icon_state = "cultgirder"

/obj/random/obstruction/item_to_spawn()
	return pick(/obj/structure/barricade,
				/obj/structure/girder,
				/obj/structure/girder/displaced,
				/obj/structure/girder/reinforced,
				/obj/structure/grille,
				/obj/structure/grille/broken,
				/obj/structure/foamedmetal,
				/obj/structure/inflatable,
				/obj/structure/inflatable/door)

/obj/random/landmine
	name = "Random Land Mine"
	desc = "This is a random land mine."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "uglymine"
	spawn_nothing_percentage = 25

/obj/random/landmine/item_to_spawn()
	return pick(prob(30);/obj/effect/mine,
				prob(25);/obj/effect/mine/frag,
				prob(25);/obj/effect/mine/emp,
				prob(10);/obj/effect/mine/stun,
				prob(10);/obj/effect/mine/incendiary,)

/obj/random_multi/single_item/captains_spare_id
	name = "Multi Point - Captain's Spare"
	id = "Captain's spare id"
	item_path = /obj/item/weapon/card/id/gold/captain/spare

/obj/random_multi/single_item/sfr_headset
	name = "Multi Point - headset"
	id = "SFR headset"
	item_path = /obj/random/sfr

// This is in here because it's spawned by the SFR Headset randomizer
/obj/random/sfr
	name = "random SFR headset"
	desc = "This is a headset spawn."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

/obj/random/sfr/item_to_spawn()
	return pick(prob(25);/obj/item/device/radio/headset/heads/captain/sfr,
				prob(25);/obj/item/device/radio/headset/headset_cargo/alt,
				prob(25);/obj/item/device/radio/headset/headset_com/alt,
				prob(25);/obj/item/device/radio/headset)

// Mining Goodies
/obj/random/multiple/minevault
	name = "random vault loot"
	desc = "Loot for mine vaults."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

/obj/random/multiple/minevault/item_to_spawn()
	return pick(
			prob(5);list(
				/obj/item/clothing/mask/smokable/pipe,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/rum,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,
				/obj/item/weapon/reagent_containers/food/snacks/grown/cannabisdeus,
				/obj/item/weapon/flame/lighter/zippo,
				/obj/structure/closet/crate/hydroponics
			),
			prob(5);list(
				/obj/item/weapon/pickaxe/drill,
				/obj/item/clothing/suit/space/void/mining,
				/obj/item/clothing/head/helmet/space/void/mining,
				/obj/structure/closet/crate/engineering
			),
			prob(5);list(
				/obj/item/weapon/pickaxe/drill,
				/obj/item/clothing/suit/space/void/mining/alt,
				/obj/item/clothing/head/helmet/space/void/mining/alt,
				/obj/structure/closet/crate/engineering
			),
			prob(5);list(
				/obj/item/weapon/reagent_containers/glass/beaker/bluespace,
				/obj/item/weapon/reagent_containers/glass/beaker/bluespace,
				/obj/item/weapon/reagent_containers/glass/beaker/bluespace,
				/obj/structure/closet/crate/science
			),
			prob(5);list(
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/structure/closet/crate/engineering
			),
			prob(5);list(
				/obj/item/weapon/pickaxe/drill,
				/obj/item/clothing/glasses/material,
				/obj/structure/ore_box,
				/obj/structure/closet/crate
			),
			prob(5);list(
				/obj/item/weapon/reagent_containers/glass/beaker/noreact,
				/obj/item/weapon/reagent_containers/glass/beaker/noreact,
				/obj/item/weapon/reagent_containers/glass/beaker/noreact,
				/obj/structure/closet/crate/science
			),
			prob(5);list(
//				/obj/item/weapon/storage/secure/briefcase/money,
				/obj/structure/closet/crate/freezer/rations
			),
			prob(5);list(
				/obj/item/clothing/accessory/tie/horrible,
				/obj/item/clothing/accessory/tie/horrible,
				/obj/item/clothing/accessory/tie/horrible,
				/obj/item/clothing/accessory/tie/horrible,
				/obj/item/clothing/accessory/tie/horrible,
				/obj/item/clothing/accessory/tie/horrible,
				/obj/structure/closet/crate
			),
			prob(5);list(
				/obj/item/weapon/melee/baton,
				/obj/item/weapon/melee/baton,
				/obj/item/weapon/melee/baton,
				/obj/item/weapon/melee/baton,
				/obj/structure/closet/crate
			),
			prob(5);list(
				/obj/item/clothing/under/shorts/red,
				/obj/item/clothing/under/shorts/blue,
				/obj/structure/closet/crate
			),
			prob(2);list(
				/obj/item/weapon/melee/baton/cattleprod,
				/obj/item/weapon/melee/baton/cattleprod,
				/obj/item/weapon/cell/high,
				/obj/item/weapon/cell/high,
				/obj/structure/closet/crate
			),
			prob(2);list(
				/obj/item/latexballon,
				/obj/item/latexballon,
				/obj/structure/closet/crate
			),
			prob(2);list(
				/obj/item/toy/syndicateballoon,
				/obj/item/toy/syndicateballoon,
				/obj/structure/closet/crate
			),
			prob(2);list(
				/obj/item/weapon/rig/industrial/equipped,
				/obj/item/weapon/storage/bag/ore,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/clothing/head/cakehat,
				/obj/item/clothing/head/cakehat,
				/obj/item/clothing/head/cakehat,
				/obj/item/clothing/head/cakehat,
				/obj/structure/closet/crate
			),
			prob(2);list(
				/obj/random/coin,
				/obj/random/coin,
				/obj/random/coin,
				/obj/random/coin,
				/obj/random/coin,
				/obj/structure/closet/crate/plastic
			),
			prob(2);list(
				/obj/random/multiple/voidsuit,
				/obj/random/multiple/voidsuit,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/clothing/suit/space/syndicate/black/red,
				/obj/item/clothing/head/helmet/space/syndicate/black/red,
				/obj/item/clothing/suit/space/syndicate/black/red,
				/obj/item/clothing/head/helmet/space/syndicate/black/red,
				/obj/item/weapon/gun/projectile/automatic/mini_uzi,
				/obj/item/weapon/gun/projectile/automatic/mini_uzi,
				/obj/item/ammo_magazine/m45uzi,
				/obj/item/ammo_magazine/m45uzi,
				/obj/item/ammo_magazine/m45uzi/empty,
				/obj/item/ammo_magazine/m45uzi/empty,
				/obj/structure/closet/crate/plastic
			),
			prob(2);list(
				/obj/item/clothing/suit/ianshirt,
				/obj/item/clothing/suit/ianshirt,
				/obj/item/weapon/bedsheet/ian,
				/obj/structure/closet/crate/plastic
			),
			prob(2);list(
				/obj/item/clothing/suit/armor/vest,
				/obj/item/clothing/suit/armor/vest,
				/obj/item/weapon/gun/projectile/garand,
				/obj/item/weapon/gun/projectile/garand,
				/obj/item/ammo_magazine/m762garand,
				/obj/item/ammo_magazine/m762garand,
				/obj/structure/closet/crate/plastic
			),
			prob(2);list(
				/obj/mecha/working/ripley/mining
			),
			prob(2);list(
				/obj/mecha/working/hoverpod/combatpod
			),
			prob(2);list(
				/obj/item/weapon/pickaxe/silver,
				/obj/item/weapon/storage/bag/ore,
				/obj/item/clothing/glasses/material,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/weapon/pickaxe/drill,
				/obj/item/weapon/storage/bag/ore,
				/obj/item/clothing/glasses/material,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/weapon/pickaxe/jackhammer,
				/obj/item/weapon/storage/bag/ore,
				/obj/item/clothing/glasses/material,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/weapon/pickaxe/diamond,
				/obj/item/weapon/storage/bag/ore,
				/obj/item/clothing/glasses/material,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/weapon/pickaxe/diamonddrill,
				/obj/item/weapon/storage/bag/ore,
				/obj/item/clothing/glasses/material,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/weapon/pickaxe/gold,
				/obj/item/weapon/storage/bag/ore,
				/obj/item/clothing/glasses/material,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/weapon/pickaxe/plasmacutter,
				/obj/item/weapon/storage/bag/ore,
				/obj/item/clothing/glasses/material,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/weapon/material/sword/katana,
				/obj/item/weapon/material/sword/katana,
				/obj/structure/closet/crate
			),
			prob(2);list(
				/obj/item/weapon/material/sword,
				/obj/item/weapon/material/sword,
				/obj/structure/closet/crate
			),
			prob(1);list(
				/obj/item/clothing/mask/balaclava,
				/obj/item/weapon/material/star,
				/obj/item/weapon/material/star,
				/obj/item/weapon/material/star,
				/obj/item/weapon/material/star,
				/obj/structure/closet/crate
			),
			prob(1);list(
				/obj/item/weed_extract,
				/obj/item/xenos_claw,
				/obj/structure/closet/crate/science
			),
			prob(1);list(
				/obj/item/clothing/head/bearpelt,
				/obj/item/clothing/under/soviet,
				/obj/item/clothing/under/soviet,
				/obj/item/weapon/gun/projectile/shotgun/pump/rifle/ceremonial,
				/obj/item/weapon/gun/projectile/shotgun/pump/rifle/ceremonial,
				/obj/structure/closet/crate
			),
			prob(1);list(
				/obj/item/weapon/gun/projectile/revolver/detective,
				/obj/item/weapon/gun/projectile/contender,
				/obj/item/weapon/gun/projectile/p92x,
				/obj/item/weapon/gun/projectile/derringer,
				/obj/structure/closet/crate
			),
			prob(1);list(
				/obj/item/weapon/vampiric,
				/obj/item/weapon/vampiric,
				/obj/structure/closet/crate/science
			),
			prob(1);list(
				/obj/item/weapon/archaeological_find
			),
			prob(1);list(
				/obj/item/weapon/melee/energy/sword,
				/obj/item/weapon/melee/energy/sword,
				/obj/item/weapon/melee/energy/sword,
				/obj/item/weapon/shield/energy,
				/obj/item/weapon/shield/energy,
				/obj/structure/closet/crate/science
			),
			prob(1);list(
				/obj/item/weapon/storage/backpack/clown,
				/obj/item/clothing/under/rank/clown,
				/obj/item/clothing/shoes/clown_shoes,
				/obj/item/device/pda/clown,
				/obj/item/clothing/mask/gas/clown_hat,
				/obj/item/weapon/bikehorn,
				/obj/item/toy/waterflower,
				/obj/item/weapon/pen/crayon/rainbow,
				/obj/structure/closet/crate
			),
			prob(1);list(
				/obj/item/clothing/under/mime,
				/obj/item/clothing/shoes/black,
				/obj/item/device/pda/mime,
				/obj/item/clothing/gloves/white,
				/obj/item/clothing/mask/gas/mime,
				/obj/item/clothing/head/beret,
				/obj/item/clothing/suit/suspenders,
				/obj/item/weapon/pen/crayon/mime,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing,
				/obj/structure/closet/crate
			),
			prob(1);list(
				/obj/item/weapon/storage/belt/champion,
				/obj/item/clothing/mask/luchador,
				/obj/item/clothing/mask/luchador/rudos,
				/obj/item/clothing/mask/luchador/tecnicos,
				/obj/structure/closet/crate
			)
		)
