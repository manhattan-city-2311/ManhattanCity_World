/*
////////////////////////////
/  =--------------------=  /
/  == Hair Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

/datum/sprite_accessory/hair
	icon = 'icons/mob/Human_face_m.dmi'	  // default icon for all hairs
	var/icon_add = 'icons/mob/human_face.dmi'
	var/hair_type = HAIR_SHORT // Default is short

/datum/sprite_accessory/hair/bald
	name = "Bald"
	icon_state = "bald"
	species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI,SPECIES_VOX)

/datum/sprite_accessory/hair/short
	name = "Short Hair"	  // try to capatilize the names please~
	icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you

/datum/sprite_accessory/hair/twintail
	name = "Twintail"
	icon_state = "hair_twintail"

/datum/sprite_accessory/hair/short2
	name = "Short Hair 2"
	icon_state = "hair_shorthair3"

/datum/sprite_accessory/hair/cut
	name = "Cut Hair"
	icon_state = "hair_c"

/datum/sprite_accessory/hair/flair
	name = "Flaired Hair"
	icon_state = "hair_flair"

/datum/sprite_accessory/hair/long
	name = "Shoulder-length Hair"
	icon_state = "hair_b"

/datum/sprite_accessory/hair/longer
	name = "Long Hair"
	icon_state = "hair_vlong"

/datum/sprite_accessory/hair/longest
	name = "Very Long Hair"
	icon_state = "hair_longest"

/datum/sprite_accessory/hair/longfringe
	name = "Long Fringe"
	icon_state = "hair_longfringe"

/datum/sprite_accessory/hair/longestalt
	name = "Longer Fringe"
	icon_state = "hair_vlongfringe"

/datum/sprite_accessory/hair/halfbang
	name = "Half-banged Hair"
	icon_state = "hair_halfbang"

/datum/sprite_accessory/hair/halfbangalt
	name = "Half-banged Hair Alt"
	icon_state = "hair_halfbang_alt"

/datum/sprite_accessory/hair/ponytail1
	name = "Ponytail 1"
	icon_state = "hair_ponytail"

/datum/sprite_accessory/hair/ponytail2
	name = "Ponytail 2"
	icon_state = "hair_pa"

/datum/sprite_accessory/hair/ponytail3
	name = "Ponytail 3"
	icon_state = "hair_ponytail3"

/datum/sprite_accessory/hair/ponytail4
	name = "Ponytail 4"
	icon_state = "hair_ponytail4"

/datum/sprite_accessory/hair/ponytail5
	name = "Ponytail 5"
	icon_state = "hair_ponytail5"

/datum/sprite_accessory/hair/ponytail6
	name = "Ponytail 6"
	icon_state = "hair_ponytail6"

/datum/sprite_accessory/hair/sideponytail
	name = "Side Ponytail"
	icon_state = "hair_stail"

/datum/sprite_accessory/hair/parted
	name = "Parted"
	icon_state = "hair_parted"

/datum/sprite_accessory/hair/pompadour
	name = "Pompadour"
	icon_state = "hair_pompadour"

/datum/sprite_accessory/hair/sleeze
	name = "Sleeze"
	icon_state = "hair_sleeze"

/datum/sprite_accessory/hair/quiff
	name = "Quiff"
	icon_state = "hair_quiff"

/datum/sprite_accessory/hair/bedhead
	name = "Bedhead"
	icon_state = "hair_bedhead"

/datum/sprite_accessory/hair/bedhead2
	name = "Bedhead 2"
	icon_state = "hair_bedheadv2"

/datum/sprite_accessory/hair/bedhead3
	name = "Bedhead 3"
	icon_state = "hair_bedheadv3"

/datum/sprite_accessory/hair/beehive
	name = "Beehive"
	icon_state = "hair_beehive"

/datum/sprite_accessory/hair/beehive2
	name = "Beehive 2"
	icon_state = "hair_beehive2"

/datum/sprite_accessory/hair/bobcurl
	name = "Bobcurl"
	icon_state = "hair_bobcurl"
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/hair/bob
	name = "Bob"
	icon_state = "hair_bobcut"
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/hair/bobcutalt
	name = "Chin Length Bob"
	icon_state = "hair_bobcutalt"
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/hair/baum
	name = "Baum"
	icon_state = "hair_baum"

/datum/sprite_accessory/hair/bowl
	name = "Bowl"
	icon_state = "hair_bowlcut"
	gender = MALE

/datum/sprite_accessory/hair/buzz
	name = "Buzzcut"
	icon_state = "hair_buzzcut"
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/hair/crew
	name = "Crewcut"
	icon_state = "hair_crewcut"

/datum/sprite_accessory/hair/combover
	name = "Combover"
	icon_state = "hair_combover"

/datum/sprite_accessory/hair/father
	name = "Father"
	icon_state = "hair_father"

/datum/sprite_accessory/hair/reversemohawk
	name = "Reverse Mohawk"
	icon_state = "hair_reversemohawk"

/datum/sprite_accessory/hair/devillock
	name = "Devil Lock"
	icon_state = "hair_devilock"

/datum/sprite_accessory/hair/dreadlocks
	name = "Dreadlocks"
	icon_state = "hair_dreads"

/datum/sprite_accessory/hair/curls
	name = "Curls"
	icon_state = "hair_curls"

/datum/sprite_accessory/hair/afro
	name = "Afro"
	icon_state = "hair_afro"

/datum/sprite_accessory/hair/afro2
	name = "Afro 2"
	icon_state = "hair_afro2"

/datum/sprite_accessory/hair/afro_large
	name = "Big Afro"
	icon_state = "hair_bigafro"

/datum/sprite_accessory/hair/rows
	name = "Rows"
	icon_state = "hair_rows1"

/datum/sprite_accessory/hair/rows2
	name = "Rows 2"
	icon_state = "hair_rows2"

/datum/sprite_accessory/hair/sargeant
	name = "Flat Top"
	icon_state = "hair_sargeant"

/datum/sprite_accessory/hair/emo
	name = "Emo"
	icon_state = "hair_emo"

/datum/sprite_accessory/hair/emo2
	name = "Emo Alt"
	icon_state = "hair_emo2"

/datum/sprite_accessory/hair/longemo
	name = "Long Emo"
	icon_state = "hair_emolong"

/datum/sprite_accessory/hair/shorteye
	name = "Overeye Short"
	icon_state = "hair_shortovereye"

/datum/sprite_accessory/hair/longovereye
	name = "Overeye Long"
	icon_state = "hair_longovereye"

/datum/sprite_accessory/hair/flow
	name = "Flow Hair"
	icon_state = "hair_f"

/datum/sprite_accessory/hair/feather
	name = "Feather"
	icon_state = "hair_feather"

/datum/sprite_accessory/hair/hitop
	name = "Hitop"
	icon_state = "hair_hitop"

/datum/sprite_accessory/hair/mohawk
	name = "Mohawk"
	icon_state = "hair_d"
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/hair/jensen
	name = "Adam Jensen Hair"
	icon_state = "hair_jensen"

/datum/sprite_accessory/hair/gelled
	name = "Gelled Back"
	icon_state = "hair_gelled"

/datum/sprite_accessory/hair/gentle
	name = "Gentle"
	icon_state = "hair_gentle"

/datum/sprite_accessory/hair/spiky
	name = "Spiky"
	icon_state = "hair_spikey"
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/hair/kusangi
	name = "Kusanagi Hair"
	icon_state = "hair_kusanagi"

/datum/sprite_accessory/hair/kagami
	name = "Pigtails"
	icon_state = "hair_kagami"

/datum/sprite_accessory/hair/himecut
	name = "Hime Cut"
	icon_state = "hair_himecut"

/datum/sprite_accessory/hair/shorthime
	name = "Short Hime Cut"
	icon_state = "hair_shorthime"

/datum/sprite_accessory/hair/grandebraid
	name = "Grande Braid"
	icon_state = "hair_grande"

/datum/sprite_accessory/hair/mbraid
	name = "Medium Braid"
	icon_state = "hair_shortbraid"

/datum/sprite_accessory/hair/braid2
	name = "Long Braid"
	icon_state = "hair_hbraid"

/datum/sprite_accessory/hair/odango
	name = "Odango"
	icon_state = "hair_odango"

/datum/sprite_accessory/hair/ombre
	name = "Ombre"
	icon_state = "hair_ombre"

/datum/sprite_accessory/hair/updo
	name = "Updo"
	icon_state = "hair_updo"

/datum/sprite_accessory/hair/skinhead
	name = "Skinhead"
	icon_state = "hair_skinhead"

/datum/sprite_accessory/hair/balding
	name = "Balding Hair"
	icon_state = "hair_e"

/datum/sprite_accessory/hair/familyman
	name = "The Family Man"
	icon_state = "hair_thefamilyman"

/datum/sprite_accessory/hair/mahdrills
	name = "Drillruru"
	icon_state = "hair_drillruru"

/datum/sprite_accessory/hair/fringetail
	name = "Fringetail"
	icon_state = "hair_fringetail"

/datum/sprite_accessory/hair/dandypomp
	name = "Dandy Pompadour"
	icon_state = "hair_dandypompadour"

/datum/sprite_accessory/hair/poofy
	name = "Poofy"
	icon_state = "hair_poofy"

/datum/sprite_accessory/hair/crono
	name = "Chrono"
	icon_state = "hair_toriyama"

/datum/sprite_accessory/hair/vegeta
	name = "Vegeta"
	icon_state = "hair_toriyama2"

/datum/sprite_accessory/hair/cia
	name = "CIA"
	icon_state = "hair_cia"

/datum/sprite_accessory/hair/mulder
	name = "Mulder"
	icon_state = "hair_mulder"

/datum/sprite_accessory/hair/scully
	name = "Scully"
	icon_state = "hair_scully"

/datum/sprite_accessory/hair/nitori
	name = "Nitori"
	icon_state = "hair_nitori"

/datum/sprite_accessory/hair/joestar
	name = "Joestar"
	icon_state = "hair_joestar"

/datum/sprite_accessory/hair/volaju
	name = "Volaju"
	icon_state = "hair_volaju"

/datum/sprite_accessory/hair/longeralt2
	name = "Long Hair Alt 2"
	icon_state = "hair_longeralt2"

/datum/sprite_accessory/hair/shortbangs
	name = "Short Bangs"
	icon_state = "hair_shortbangs"

/datum/sprite_accessory/hair/shavedbun
	name = "Shaved Bun"
	icon_state = "hair_shavedbun"

/datum/sprite_accessory/hair/halfshaved
	name = "Half-Shaved"
	icon_state = "hair_halfshaved"

/datum/sprite_accessory/hair/halfshavedemo
	name = "Half-Shaved Emo"
	icon_state = "hair_halfshavedemo"

/datum/sprite_accessory/hair/longsideemo
	name = "Long Side Emo"
	icon_state = "hair_longsideemo"

/datum/sprite_accessory/hair/bun
	name = "Low Bun"
	icon_state = "hair_bun"

/datum/sprite_accessory/hair/bun2
	name = "High Bun"
	icon_state = "hair_bun2"

/datum/sprite_accessory/hair/doublebun
	name = "Double-Bun"
	icon_state = "hair_doublebun"

/datum/sprite_accessory/hair/lowfade
	name = "Low Fade"
	icon_state = "hair_lowfade"

/datum/sprite_accessory/hair/medfade
	name = "Medium Fade"
	icon_state = "hair_medfade"

/datum/sprite_accessory/hair/highfade
	name = "High Fade"
	icon_state = "hair_highfade"

/datum/sprite_accessory/hair/baldfade
	name = "Balding Fade"
	icon_state = "hair_baldfade"

/datum/sprite_accessory/hair/nofade
	name = "Regulation Cut"
	icon_state = "hair_nofade"

/datum/sprite_accessory/hair/trimflat
	name = "Trimmed Flat Top"
	icon_state = "hair_trimflat"

/datum/sprite_accessory/hair/shaved
	name = "Shaved"
	icon_state = "hair_shaved"

/datum/sprite_accessory/hair/trimmed
	name = "Trimmed"
	icon_state = "hair_trimmed"

/datum/sprite_accessory/hair/tightbun
	name = "Tight Bun"
	icon_state = "hair_tightbun"

/datum/sprite_accessory/hair/coffeehouse
	name = "Coffee House Cut"
	icon_state = "hair_coffeehouse"

/datum/sprite_accessory/hair/undercut
	name = "Undercut"
	icon_state = "hair_undercut"

/datum/sprite_accessory/hair/partfade
	name = "Parted Fade"
	icon_state = "hair_shavedpart"

/datum/sprite_accessory/hair/hightight
	name = "High and Tight"
	icon_state = "hair_hightight"

/datum/sprite_accessory/hair/rowbun
	name = "Row Bun"
	icon_state = "hair_rowbun"

/datum/sprite_accessory/hair/rowdualbraid
	name = "Row Dual Braid"
	icon_state = "hair_rowdualtail"

/datum/sprite_accessory/hair/rowbraid
	name = "Row Braid"
	icon_state = "hair_rowbraid"

/datum/sprite_accessory/hair/regulationmohawk
	name = "Regulation Mohawk"
	icon_state = "hair_shavedmohawk"

/datum/sprite_accessory/hair/topknot
	name = "Topknot"
	icon_state = "hair_topknot"

/datum/sprite_accessory/hair/ronin
	name = "Ronin"
	icon_state = "hair_ronin"

/datum/sprite_accessory/hair/bowlcut2
	name = "Bowl2"
	icon_state = "hair_bowlcut2"

/datum/sprite_accessory/hair/thinning
	name = "Thinning"
	icon_state = "hair_thinning"

/datum/sprite_accessory/hair/thinningfront
	name = "Thinning Front"
	icon_state = "hair_thinningfront"

/datum/sprite_accessory/hair/thinningback
	name = "Thinning Back"
	icon_state = "hair_thinningrear"

/datum/sprite_accessory/hair/manbun
	name = "Manbun"
	icon_state = "hair_manbun"

/datum/sprite_accessory/hair/leftsidecut
	name = "Left Sidecut"
	icon_state = "hair_leftside"

/datum/sprite_accessory/hair/rightsidecut
	name = "Right Sidecut"
	icon_state = "hair_rightside"

/datum/sprite_accessory/hair/slick
	name = "Slick"
	icon_state = "hair_slick"

/datum/sprite_accessory/hair/messyhair
	name = "Messy"
	icon_state = "hair_messyhair"

/datum/sprite_accessory/hair/averagejoe
	name = "Average Joe"
	icon_state = "hair_averagejoe"

/datum/sprite_accessory/hair/sideswept
	name = "Sideswept Hair"
	icon_state = "hair_sideswept"

/datum/sprite_accessory/hair/mohawkshaved
	name = "Shaved Mohawk"
	icon_state = "hair_mohawkshaved"

/datum/sprite_accessory/hair/mohawkshaved2
	name = "Tight Shaved Mohawk"
	icon_state = "hair_mohawkshaved2"

/datum/sprite_accessory/hair/mohawkshavednaomi
	name = "Naomi Mohawk"
	icon_state = "hair_mohawkshavednaomi"

/datum/sprite_accessory/hair/amazon
	name = "Amazon"
	icon_state = "hair_amazon"

/datum/sprite_accessory/hair/straightlong
	name = "Straight Long"
	icon_state = "hair_straightlong"

/datum/sprite_accessory/hair/marysue
	name = "Mary Sue"
	icon_state = "hair_marysue"

/datum/sprite_accessory/hair/messyhair2
	name = "Messy Hair 2"
	icon_state = "hair_messyhair2"

/datum/sprite_accessory/hair/buzzcut2
	name = "Buzzcut 2"
	icon_state = "hair_buzzcut2"

/datum/sprite_accessory/hair/sideundercut
	name = "Side Undercut"
	icon_state = "hair_sideundercut"

/datum/sprite_accessory/hair/bighawk
	name = "Big Mohawk"
	icon_state = "hair_bighawk"

/datum/sprite_accessory/hair/donutbun
	name = "Donut Bun"
	icon_state = "hair_donutbun"

/datum/sprite_accessory/hair/gentle2
	name = "Gentle 2"
	icon_state = "hair_gentle2"

/datum/sprite_accessory/hair/gentle2long
	name = "Gentle 2 Long"
	icon_state = "hair_gentle2long"

/datum/sprite_accessory/hair/trimrsidecut
	name = "Trimmed Right Sidecut"
	icon_state = "hair_rightside_trim"

/datum/sprite_accessory/hair/belenkotied
	name = "Belenkotied"
	icon_state = "hair_belenkotied"

/datum/sprite_accessory/hair/bobshoulder
	name = "Shoulder Bob"
	icon_state = "hair_bob_shoulder"

/datum/sprite_accessory/hair/bobshoulder2
	name = "Shoulder Bob 2"
	icon_state = "hair_bob_shoulder2"

/datum/sprite_accessory/hair/bobcurl2
	name = "Bobcurl 2"
	icon_state = "hair_bobcurl2"

/datum/sprite_accessory/hair/bunovereye
	name = "Overeye Bun"
	icon_state = "hair_bun_overeye"

/datum/sprite_accessory/hair/shortbun
	name = "Short Bun"
	icon_state = "hair_bun_short"

/datum/sprite_accessory/hair/bigbun
	name = "Big Bun"
	icon_state = "hair_bunbig"

/datum/sprite_accessory/hair/emofringe
	name = "Emo Fringe"
	icon_state = "hair_emofringe"

/datum/sprite_accessory/hair/hipstery
	name = "Hipstery"
	icon_state = "hair_hipstery"

/datum/sprite_accessory/hair/himecutalt
	name = "Himecut Alt"
	icon_state = "hair_himecut_alt"

/datum/sprite_accessory/hair/himecutlong
	name = "Himecut Long"
	icon_state = "hair_himecut_long_ponytail"

/datum/sprite_accessory/hair/himecutponytail
	name = "Himecut Ponytail"
	icon_state = "hair_himecut_ponytail"

/datum/sprite_accessory/hair/himecutponyup
	name = "Himecut Ponytail Up"
	icon_state = "hair_himecut_ponytail_up"

/datum/sprite_accessory/hair/himecutshort
	name = "Himecut Short"
	icon_state = "hair_himecut_short"

/datum/sprite_accessory/hair/modern
	name = "Modern"
	icon_state = "hair_modern"

/datum/sprite_accessory/hair/mohawkshaved3
	name = "Low and Long Mohawk"
	icon_state = "hair_mohawk_shavedlong"

/datum/sprite_accessory/hair/regmohawk2
	name = "Regulation Mohawk 2"
	icon_state = "hair_mohawk_shavedback"

/datum/sprite_accessory/hair/mohawkshaved4
	name = "Low Mohawk"
	icon_state = "hair_mohawk_shavedbacklong"

/datum/sprite_accessory/hair/newyou
	name = "New You"
	icon_state = "hair_newyou"

/datum/sprite_accessory/hair/oneshoulder
	name = "One Shoulder"
	icon_state = "hair_oneshoulder"

/datum/sprite_accessory/hair/overeye2
	name = "Overeye"
	icon_state = "hair_overeye_veryshort"

/datum/sprite_accessory/hair/overeye3
	name = "Overeye 2"
	icon_state = "hair_overeye_veryshort_alt"

/datum/sprite_accessory/hair/oxton
	name = "Oxton"
	icon_state = "hair_oxton"

/datum/sprite_accessory/hair/ponytail7
	name = "Ponytail 7"
	icon_state = "hair_ponytail7"

/datum/sprite_accessory/hair/ponytailtied
	name = "Ponytail Tied"
	icon_state = "hair_ponytail_tied"

/datum/sprite_accessory/hair/ponytaildinky1
	name = "Ponytail Dinky"
	icon_state = "hair_ponytail_dinky1"

/datum/sprite_accessory/hair/ponytaildinky2
	name = "Ponytail Dinky 2"
	icon_state = "hair_ponytail_dinky2"

/datum/sprite_accessory/hair/ponytaildinky3
	name = "Ponytail Dinky 3"
	icon_state = "hair_ponytail_dinky3"

/datum/sprite_accessory/hair/tressshoulder
	name = "Tress Shoulder"
	icon_state = "hair_tressshoulder"

/datum/sprite_accessory/hair/undercut2
	name = "Undercut 2"
	icon_state = "hair_undercut3"

/datum/sprite_accessory/hair/baldingboddicker
	name = "Balding Boddicker"
	icon_state = "hair_balding_boddicker"

/datum/sprite_accessory/hair/librarianbun
	name = "Librarian Bun"
	icon_state = "hair_bun_librarian"

/datum/sprite_accessory/hair/bunquad
	name = "Bun Quad"
	icon_state = "hair_bun_quad"

/datum/sprite_accessory/hair/bununiter
	name = "Bun Uniter"
	icon_state = "hair_bun_uniter"

/datum/sprite_accessory/hair/business
	name = "Business"
	icon_state = "hair_business"

/datum/sprite_accessory/hair/business2
	name = "Business 2"
	icon_state = "hair_business2"

/datum/sprite_accessory/hair/business3
	name = "Business 3"
	icon_state = "hair_business3"

/datum/sprite_accessory/hair/fadeg
	name = "Fade Grown"
	icon_state = "hair_fade_grown"

/datum/sprite_accessory/hair/partedshort
	name = "Short Parted"
	icon_state = "hair_parted_short"

/datum/sprite_accessory/hair/pigtails
	name = "Simple Pigtails"
	icon_state = "hair_pigtails_simple"

/datum/sprite_accessory/hair/ponytailside
	name = "Side Ponytail 2"
	icon_state = "hair_ponytail_side7"

/datum/sprite_accessory/hair/shortspiked
	name = "Short Spiked"
	icon_state = "hair_short_spiked"

/datum/sprite_accessory/hair/sweptshort
	name = "Swept Short"
	icon_state = "hair_swept_short"

/datum/sprite_accessory/hair/sweptback
	name = "Swept Back"
	icon_state = "hair_swept_back"

/datum/sprite_accessory/hair/wavyshoulder
	name = "Shoulder-length Wavy"
	icon_state = "hair_wavyshoulder_down"

/datum/sprite_accessory/hair/wavyup
	name = "Ponytail Wavy"
	icon_state = "hair_wavyshoulder_up"

/datum/sprite_accessory/hair/wheeler
	name = "Wheeler"
	icon_state = "hair_wheeler"

/datum/sprite_accessory/hair/mullethawk
	name = "Mullet-Hawk"
	icon_state = "hair_mullethawk"
	gender = MALE

/datum/sprite_accessory/hair/leon
	name = "Leon"
	icon_state = "hair_leon"
	gender = MALE

/datum/sprite_accessory/hair/wong
	name = "Wong"
	icon_state = "hair_wong"
	gender = FEMALE

/* [MANHATTAN] */
/datum/sprite_accessory/hair/katara
	name = "Long Hair (Katara)"
	icon_state = "hair_katara"
	hair_type = HAIR_LONG
/datum/sprite_accessory/hair/wong
	name = "Wong"
	icon_state = "hair_wong"
/datum/sprite_accessory/hair/angel
	name = "Angel"
	icon_state = "hair_angel"
/datum/sprite_accessory/hair/Harley
	name = "Harley"
	icon_state = "hair_harley"
	hair_type = HAIR_LONG
/datum/sprite_accessory/hair/Hipstery
	name = "Hipstery"
	icon_state = "hair_hipstery"
/datum/sprite_accessory/hair/shortcover
	name = "Cover Short"
	icon_state = "hair_shortcover"
/datum/sprite_accessory/hair/longcover
	name = "Cover Long"
	icon_state = "hair_longcover"
/datum/sprite_accessory/hair/waterfall
	name = "Short Cover Waterfall"
	icon_state = "hair_waterfall"
/datum/sprite_accessory/hair/hayasaka_small
	name = "Ponytail Hayasaka Lesser"
	icon_state = "hair_long_braided"
/datum/sprite_accessory/hair/ponytail_hayasaka
	name = "Ponytail Hayasaka"
	icon_state = "hair_ponytail_hayasaka"
/datum/sprite_accessory/hair/longemo_alt
	name = "Long Emo Alt"
	icon_state = "hair_longemo_alt"
/datum/sprite_accessory/hair/long_tail
	name = "Long Tail"
	icon_state = "hair_longtail"
/datum/sprite_accessory/hair/zone
	name = "Zone"
	icon_state = "hair_zone"
/datum/sprite_accessory/hair/longbangs
	name = "Bangs Long"
	icon_state = "hair_lbangs"
/datum/sprite_accessory/hair/toph
	name = "Toph"
	icon_state = "hair_toph"
/datum/sprite_accessory/hair/shinobu
	name = "shinobu"
	icon_state = "hair_shinobu"
/datum/sprite_accessory/hair/sidetail3
	name = "Pony Side 3"
	icon_state = "hair_sidetail3"
/datum/sprite_accessory/hair/kirrina
	name = "Long Side Part (Selaki)"
	icon_state = "hair_longsidepartstraight"
/datum/sprite_accessory/hair/bedhead_fringe
	name = "Long Fringe Bedhead"
	icon_state = "hair_bluntbangs"
/datum/sprite_accessory/hair/bob_combed
	name = "Bob Combed"
	icon_state = "hair_combedbob"
/datum/sprite_accessory/hair/messybedhead
	name = "Bedhead Messy"
	icon_state = "hair_slightlymessy"
/datum/sprite_accessory/hair/baum
	name = "Short Hair (Baum)"
	icon_state = "hair_baum"
/datum/sprite_accessory/hair/pony80s
	name = "Ponytail 80's"
	icon_state = "hair_80s_ponytail"
/datum/sprite_accessory/hair/pony80s_alt
	name = "Ponytail 80's Alt"
	icon_state = "hair_80s_ponytail_alt"
/datum/sprite_accessory/hair/odano
	name = "Odando"
	icon_state = "hair_bun_odango"
/datum/sprite_accessory/hair/twincurl
	name = "Twin Curls"
	icon_state = "hair_twincurls2"
/datum/sprite_accessory/hair/amicia
	name = "Amicia"
	icon_state = "hair_amicia"
/datum/sprite_accessory/hair/widelonghair
	name = "Long Hair Wide"
	icon_state = "hair_longwide"
/datum/sprite_accessory/hair/widow
	name = "Ponytail Widowmaker"
	icon_state = "hair_widowmaker"
/datum/sprite_accessory/hair/widowshort
	name = "Ponytail Widowmaker Short"
	icon_state = "hair_widowmaker_short"
/datum/sprite_accessory/hair/widow_alt
	name = "Ponytail Widowmaker Alt"
	icon_state = "hair_widowmaker_alt"
/datum/sprite_accessory/hair/undercut_messy
	name = "Undercut Messy Right"
	icon_state = "hair_messy_rightcut_s"
/datum/sprite_accessory/hair/travolta
	name = "Ponytail Travolta"
	icon_state = "hair_travolta_tied_s"
/* [/MANHATTAN] */
