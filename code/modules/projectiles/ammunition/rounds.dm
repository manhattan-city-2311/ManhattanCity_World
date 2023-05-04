/************************************************************************/
/*
#    An explaination of the naming format for guns and ammo:
#
#    a = Ammo, as in individual rounds of ammunition.
#    b = Box, intended to have ammo taken out one at a time by hand.
#    c = Clips, intended to reload magazines or guns quickly.
#    m = Magazine, intended to hold rounds of ammo.
#    s = Speedloaders, intended to reload guns quickly.
#
#    Use this format, followed by the caliber. For example, a shotgun's caliber
#    variable is "12g" as a result. Ergo, a shotgun round's path would have "a12g",
#    or a magazine with shotgun shells would be "m12g" instead. To avoid confusion
#    for developers and in-game admins spawning these items, stick to this format.
#    Likewise, when creating new rounds, the caliber variable should match whatever
#    the name says.
#
#    This comment is copied in magazines.dm as well.
*/
/************************************************************************/

/*
 * .357
 */

/obj/item/ammo_casing/a357
	desc = "A .357 bullet casing."
	caliber = ".357"
	projectile_type = /obj/item/projectile/bullet/fmj/p357
/obj/item/ammo_casing/a357/ap
	projectile_type = /obj/item/projectile/bullet/ap/p357
	desc = "A .357 armor-piercing bullet casing."
/obj/item/ammo_casing/a357/hp
	projectile_type = /obj/item/projectile/bullet/hp/p357
	desc = "A .357  hollow point bullet casing."
/obj/item/ammo_casing/a357/rubber
	projectile_type = /obj/item/projectile/bullet/rubber/p357
	icon_state = "r-casing"
	desc = "A .357 rubber bullet casing."

/*
 * .38
 */

/obj/item/ammo_casing/a38
	desc = "A .38 bullet casing."
	caliber = ".38"
	projectile_type = /obj/item/projectile/bullet/fmj/p38

/obj/item/ammo_casing/a38/rubber
	desc = "A .38 rubber bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/rubber/p38

/obj/item/ammo_casing/a38/practice
	desc = "A .38 practice bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/pistol/practice

/obj/item/ammo_casing/a38/emp
	name = ".38 haywire round"
	desc = "A .38 bullet casing fitted with a single-use ion pulse generator."
	icon_state = "empcasing"
	projectile_type = /obj/item/projectile/ion/small
	matter = list(DEFAULT_WALL_MATERIAL = 130, "uranium" = 100)

/*
 * .44
 */

/obj/item/ammo_casing/a44
	desc = "A .44 bullet casing."
	caliber = ".44"
	projectile_type = /obj/item/projectile/bullet/fmj/p44
/obj/item/ammo_casing/a44/ap
	desc = "A .44 armor-piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/ap/p44
/obj/item/ammo_casing/a44/hp
	desc = "A .44 hollow-point bullet casing."
	projectile_type = /obj/item/projectile/bullet/hp/p44

/obj/item/ammo_casing/a44/rubber
	icon_state = "r-casing"
	desc = "A .44 rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/rubber/p44

/*
 * .75 (aka Gyrojet Rockets, aka admin abuse)
 */

/obj/item/ammo_casing/a75
	desc = "A .75 gyrojet rocket sheathe."
	caliber = ".75"
	projectile_type = /obj/item/projectile/bullet/gyro

/*
 * 5.7mm
 */

/obj/item/ammo_casing/a5mm
	desc = "A 5.7mm bullet casing."
	caliber = "5mm"
	projectile_type = /obj/item/projectile/bullet/fmj/p57

/obj/item/ammo_casing/a5mm/ap
	desc = "A 5.7mm armor-piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/ap/p57

/*
 * 9mm
 */

/obj/item/ammo_casing/a9mm
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/fmj/s9x19

/obj/item/ammo_casing/a9mm/ap
	desc = "A 9mm armor-piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/ap/s9x19

/obj/item/ammo_casing/a9mm/flash
	desc = "A 9mm flash shell casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_casing/a9mm/rubber
	desc = "A 9mm rubber bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/rubber/s9x19

/obj/item/ammo_casing/a9mm/practice
	desc = "A 9mm practice bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/pistol/practice

/*
 * .45
 */

/obj/item/ammo_casing/a45
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/fmj/p45

/obj/item/ammo_casing/a45/ap
	desc = "A .45 Armor-Piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/ap/p45

/obj/item/ammo_casing/a45/practice
	desc = "A .45 practice bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/pistol/practice

/obj/item/ammo_casing/a45/rubber
	desc = "A .45 rubber bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/rubber/p45

/obj/item/ammo_casing/a45/flash
	desc = "A .45 flash shell casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_casing/a45/emp
	name = ".45 haywire round"
	desc = "A .45 bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/item/projectile/ion/small
	icon_state = "empcasing"
	matter = list(DEFAULT_WALL_MATERIAL = 130, "uranium" = 100)

/obj/item/ammo_casing/a45/hp
	desc = "A .45 hollow-point bullet casing."
	projectile_type = /obj/item/projectile/bullet/hp/p45


/*
 * 10mm
 */

/obj/item/ammo_casing/a10mm
	desc = "A 10mm bullet casing."
	caliber = "10mm"
	projectile_type = /obj/item/projectile/bullet/pistol/medium

/obj/item/ammo_casing/a10mm/emp
	name = "10mm haywire round"
	desc = "A 10mm bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/item/projectile/ion/small
	icon_state = "empcasing"
	matter = list(DEFAULT_WALL_MATERIAL = 130, "uranium" = 100)

/*
 * 12g (aka shotgun ammo)
 */

/obj/item/ammo_casing/a12g
	name = "shotgun slug"
	desc = "A 12 gauge slug."
	icon_state = "slshell"
	caliber = "12g"
	projectile_type = /obj/item/projectile/bullet/shotgun
	matter = list(DEFAULT_WALL_MATERIAL = 360)

/obj/item/ammo_casing/a12g/pellet
	name = "shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun
	matter = list(DEFAULT_WALL_MATERIAL = 360)

/obj/item/ammo_casing/a12g/blank
	name = "shotgun shell"
	desc = "A blank shell."
	icon_state = "blshell"
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(DEFAULT_WALL_MATERIAL = 90)

/obj/item/ammo_casing/a12g/practice
	name = "shotgun shell"
	desc = "A practice shell."
	icon_state = "pshell"
	projectile_type = /obj/item/projectile/bullet/shotgun/practice
	matter = list("metal" = 90)

/obj/item/ammo_casing/a12g/beanbag
	name = "beanbag shell"
	desc = "A beanbag shell."
	icon_state = "bshell"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag
	matter = list(DEFAULT_WALL_MATERIAL = 180)

//Can stun in one hit if aimed at the head, but
//is blocked by clothing that stops tasers and is vulnerable to EMP
/obj/item/ammo_casing/a12g/stunshell
	name = "stun shell"
	desc = "A 12 gauge taser cartridge."
	icon_state = "stunshell"
	projectile_type = /obj/item/projectile/energy/electrode/stunshot
	matter = list(DEFAULT_WALL_MATERIAL = 360, "glass" = 720)

/obj/item/ammo_casing/a12g/stunshell/emp_act(severity)
	if(prob(100/severity)) BB = null
	update_icon()

//Does not stun, only blinds, but has area of effect.
/obj/item/ammo_casing/a12g/flash
	name = "flash shell"
	desc = "A chemical shell used to signal distress or provide illumination."
	icon_state = "fshell"
	projectile_type = /obj/item/projectile/energy/flash/flare
	matter = list(DEFAULT_WALL_MATERIAL = 90, "glass" = 90)

/obj/item/ammo_casing/a12g/emp
	name = "ion shell"
	desc = "An advanced shotgun round that creates a small EMP when it strikes a target."
	icon_state = "empshell"
	projectile_type = /obj/item/projectile/ion
//	projectile_type = /obj/item/projectile/bullet/shotgun/ion
	matter = list(DEFAULT_WALL_MATERIAL = 360, "uranium" = 240)


/obj/item/ammo_casing/g12x70/slug
	name = "12x70 slug shell"
	icon_state = "slshell"
	projectile_type = /obj/item/projectile/bullet/gauge/g12x70

/obj/item/ammo_casing/g12x70/pellet
	name = "12x70 buckshot shell"
	icon_state = "gshell"
	projectile_type = /obj/item/projectile/bullet/pellet/g12x70

/obj/item/ammo_casing/g20x73/slug
	name = "20x73 slug shell"
	icon_state = "slshell"
	projectile_type = /obj/item/projectile/bullet/gauge/g20x73

/obj/item/ammo_casing/g20x73/pellet
	name = "20x73 buckshot shell"
	icon_state = "gshell"
	projectile_type = /obj/item/projectile/bullet/pellet/g20x73

/*
 * 7.62mm
 */

/obj/item/ammo_casing/a762
	desc = "A 7.62x51mm bullet casing."
	caliber = "7.62mm"
	icon_state = "rifle-casing"
	projectile_type = /obj/item/projectile/bullet/fmj/s7p62x51

/obj/item/ammo_casing/a762/ap
	desc = "A 7.62x51mm armor-piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/ap/s7p62x51

/obj/item/ammo_casing/a762p
	desc = "A 7.62x51mm practice bullet casing."
	caliber = "7.62mm"
	icon_state = "rifle-casing" // Need to make an icon for these
	projectile_type = /obj/item/projectile/bullet/rifle/practice

/obj/item/ammo_casing/a762/blank
	desc = "A blank 7.62x51mm bullet casing."
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(DEFAULT_WALL_MATERIAL = 90)

/obj/item/ammo_casing/a762/hp
	desc = "A 7.62x51mm hollow-point bullet casing."
	projectile_type = /obj/item/projectile/bullet/hp/s7p62x51

/*
/obj/item/ammo_casing/a762/hunter
	desc = "A 7.62x51mm hunting bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/a762/hunter
*/

/*
 * 14.5mm (anti-materiel rifle round)
 */

/obj/item/ammo_casing/a145
	desc = "A 14.5mm shell."
	icon_state = "lcasing"
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a145
	matter = list(DEFAULT_WALL_MATERIAL = 1250)

/*
 * 5.45mm
 */

/obj/item/ammo_casing/a545
	desc = "A 5.45mm bullet casing."
	caliber = "5.45mm"
	icon_state = "rifle-casing"
	projectile_type = /obj/item/projectile/bullet/fmj/s5p45x39

/obj/item/ammo_casing/a545/ap
	desc = "A 5.45mm armor-piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/ap/s5p45x39

/obj/item/ammo_casing/a545p
	desc = "A 5.45mm practice bullet casing."
	caliber = "5.45mm"
	icon_state = "rifle-casing" // Need to make an icon for these
	projectile_type = /obj/item/projectile/bullet/rifle/practice

/obj/item/ammo_casing/a545/blank
	desc = "A blank 5.45mm bullet casing."
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(DEFAULT_WALL_MATERIAL = 90)

/obj/item/ammo_casing/a545/hp
	desc = "A 5.45mm hollow-point bullet casing."
	projectile_type = /obj/item/projectile/bullet/hp/s5p45x39

/*
/obj/item/ammo_casing/a545/hunter
	desc = "A 5.45mm hunting bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/a545/hunter
*/

/*
 * Misc
 */

/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell"
	projectile_type = /obj/item/missile
	caliber = "rocket"

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	caliber = "caps"
	icon_state = "r-casing"
	color = "#FF0000"
	projectile_type = /obj/item/projectile/bullet/pistol/cap

/obj/item/ammo_casing/spent // For simple hostile mobs only, so they don't cough up usable bullets when firing. This is for literally nothing else.
	icon_state = "s-casing-spent"
	BB = null
	projectile_type = null