/datum/sprite_accessory/marking
	icon = 'icons/mob/human_races/markings.dmi'
	do_colouration = 1 //Almost all of them have it, COLOR_ADD

	//Empty list is unrestricted. Should only restrict the ones that make NO SENSE on other species,
	//like Tajaran inner-ear coloring overlay stuff.
	species_allowed = list()

	var/body_parts = list() //A list of bodyparts this covers, in organ_tag defines
	//Reminder: BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD

	taj_paw_socks
		name = "Socks Coloration (Taj)"
		icon_state = "taj_pawsocks"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
		species_allowed = list(SPECIES_TAJ)

	una_paw_socks
		name = "Socks Coloration (Una)"
		icon_state = "una_pawsocks"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
		species_allowed = list(SPECIES_UNATHI)

	paw_socks
		name = "Socks Coloration (Generic)"
		icon_state = "pawsocks"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
		species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

	paw_socks_belly
		name = "Socks,Belly Coloration (Generic)"
		icon_state = "pawsocksbelly"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
		species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

	belly_hands_feet
		name = "Hands,Feet,Belly Color (Minor)"
		icon_state = "bellyhandsfeetsmall"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
		species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

	hands_feet_belly_full
		name = "Hands,Feet,Belly Color (Major)"
		icon_state = "bellyhandsfeet"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
		species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

	hands_feet_belly_full_female
		name = "Hands,Feet,Belly Color (Major, Female)"
		icon_state = "bellyhandsfeet_female"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
		species_allowed = list(SPECIES_TAJ)

	patches
		name = "Color Patches"
		icon_state = "patches"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)
		species_allowed = list(SPECIES_TAJ)

	patchesface
		name = "Color Patches (Face)"
		icon_state = "patchesface"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TAJ)

	tiger_stripes
		name = "Tiger Stripes"
		icon_state = "tiger"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_GROIN)
		species_allowed = list(SPECIES_TAJ) //There's a tattoo for non-cats

	//Taj specific stuff
	taj_belly
		name = "Belly Fur (Taj)"
		icon_state = "taj_belly"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_TAJ)

	taj_bellyfull
		name = "Belly Fur Wide (Taj)"
		icon_state = "taj_bellyfull"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_TAJ)

	taj_earsout
		name = "Outer Ear (Taj)"
		icon_state = "taj_earsout"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TAJ)

	taj_earsin
		name = "Inner Ear (Taj)"
		icon_state = "taj_earsin"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TAJ)

	taj_nose
		name = "Nose Color (Taj)"
		icon_state = "taj_nose"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TAJ)

	taj_crest
		name = "Chest Fur Crest (Taj)"
		icon_state = "taj_crest"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_TAJ)

	taj_muzzle
		name = "Muzzle Color (Taj)"
		icon_state = "taj_muzzle"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TAJ)

	taj_face
		name = "Cheeks Color (Taj)"
		icon_state = "taj_face"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TAJ)

	taj_all
		name = "All Taj Head (Taj)"
		icon_state = "taj_all"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TAJ)

	//Una specific stuff
	una_face
		name = "Face Color (Una)"
		icon_state = "una_face"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_UNATHI)

	una_facelow
		name = "Face Color Low (Una)"
		icon_state = "una_facelow"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_UNATHI)

	una_scutes
		name = "Scutes (Una)"
		icon_state = "una_scutes"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_UNATHI)

// Human Body Markings //

	aug_backports
		name = "Augment (Backports, Back)"
		icon_state = "aug_backports"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

		diode
			name = "Augment (Backports Diode, Back)"
			icon_state = "aug_backportsdiode"

	aug_backportswide
		name = "Augment (Backports Wide, Back)"
		icon_state = "aug_backportswide"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

		diode
			name = "Augment (Backports Wide Diode, Back)"
			icon_state = "aug_backportswidediode"

	aug_headcase
		name = "Augment (Headcase, Head)"
		icon_state = "aug_headcase"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	aug_headcase_light
		name = "Augment (Headcase Light, Head)"
		icon_state = "aug_headcaselight"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

/* This one simply refuses to appear in the list. I don't know why. I've just spent 5 hours trying EVERYTHING to fix this ONE marking. I give up.
If you're reading this and have any clue on how to fix this. Please. Be my guest. I can't do this anymore. I can't feel my hands. - Flag */
	aug_headport
		name = "Augment (Headport, Head)"
		icon_state = "aug_headport"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

		diode //This one works though. I don't know why. I DON'T KNOW WHYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY. - Flag
		name = "Augment (Headport Diode, Head)"
		icon_state = "aug_headplugdiode"

	aug_lowerjaw
		name = "Augment (Lower Jaw, Head)"
		icon_state = "aug_lowerjaw"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	aug_scalpports
		name = "Augment (Scalp Ports)"
		icon_state = "aug_scalpports"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

		vertex_left
			name = "Augment (Scalp Port, Vertex Left)"
			icon_state = "aug_vertexport_l"

		vertex_right
			name = "Augment (Scalp Port, Vertex Right)"
			icon_state = "aug_vertexport_r"

		occipital_left
			name = "Augment (Scalp Port, Occipital Left)"
			icon_state = "aug_occipitalport_l"

		occipital_right
			name = "Augment (Scalp Port, Occipital Right)"
			icon_state = "aug_occipitalport_r"

	aug_scalpportsdiode
		name = "Augment (Scalp Ports Diode)"
		icon_state = "aug_scalpportsdiode"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

		vertex_left
			name = "Augment (Scalp Port Diode, Vertex Left)"
			icon_state = "aug_vertexportdiode_l"

		vertex_right
			name = "Augment (Scalp Port Diode, Vertex Right)"
			icon_state = "aug_vertexportdiode_r"

		occipital_left
			name = "Augment (Scalp Port Diode, Occipital Left)"
			icon_state = "aug_occipitalportdiode_l"

		occipital_right
			name = "Augment (Scalp Port Diode, Occipital Right)"
			icon_state = "aug_occipitalportdiode_r"

	aug_backside_left
		name = "Augment (Backside Left, Head)"
		icon_state = "aug_backside_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

		side_diode
			name = "Augment (Backside Left Diode, Head)"
			icon_state = "aug_sidediode_l"

	aug_backside_right
		name = "Augment (Backside Right, Head)"
		icon_state = "aug_backside_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

		side_diode
			name = "Augment (Backside Right Diode, Head)"
			icon_state = "aug_sidediode_r"

	aug_side_deunan_left
		name = "Augment (Deunan, Side Left)"
		icon_state = "aug_sidedeunan_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	aug_side_deunan_right
		name = "Augment (Deunan, Side Right)"
		icon_state = "aug_sidedeunan_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	aug_side_kuze_left
		name = "Augment (Kuze, Side Left)"
		icon_state = "aug_sidekuze_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

		side_diode
			name = "Augment (Kuze Diode, Side Left)"
			icon_state = "aug_sidekuzediode_l"

	aug_side_kuze_right
		name = "Augment (Kuze, Side Right)"
		icon_state = "aug_sidekuze_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

		side_diode
			name = "Augment (Kuze Diode, Side Right)"
			icon_state = "aug_sidekuzediode_r"

	aug_side_kinzie_left
		name = "Augment (Kinzie, Side Left)"
		icon_state = "aug_sidekinzie_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	aug_side_kinzie_right
		name = "Augment (Kinzie, Side Right)"
		icon_state = "aug_sidekinzie_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	aug_side_shelly_left
		name = "Augment (Shelly, Side Left)"
		icon_state = "aug_sideshelly_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	aug_side_shelly_right
		name = "Augment (Shelly, Side Right)"
		icon_state = "aug_sideshelly_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	aug_chestports
		name = "Augment (Chest Ports)"
		icon_state = "aug_chestports"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	aug_abdomenports
		name = "Augment (Abdomen Ports)"
		icon_state = "aug_abdomenports"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	backstripe
		name = "Back Stripe"
		icon_state = "backstripe"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

		spinemarks
			name = "Back Stripe Marks"
			icon_state = "backstripemarks"

	bands
		name = "Color Bands (All)"
		icon_state = "bands"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)

		chest
			name = "Color Bands (Torso)"
			body_parts = list(BP_TORSO)

		groin
			name = "Color Bands (Groin)"
			body_parts = list(BP_GROIN)

		left_arm
			name = "Color Bands (Left Arm)"
			body_parts = list(BP_L_ARM)

		right_arm
			name = "Color Bands (Right Arm)"
			body_parts = list(BP_R_ARM)

		left_hand
			name = "Color Bands (Left Hand)"
			body_parts = list(BP_L_HAND)

		right_hand
			name = "Color Bands (Right Hand)"
			body_parts = list(BP_R_HAND)

		left_leg
			name = "Color Bands (Left Leg)"
			body_parts = list(BP_L_LEG)

		right_leg
			name = "Color Bands (Right Leg)"
			body_parts = list(BP_R_LEG)

		left_foot
			name = "Color Bands (Left Foot)"
			body_parts = list(BP_L_FOOT)
			species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara", "Unathi")

		left_foot_human
			name = "Color Bands (Left Foot)"
			icon_state = "bandshuman"
			body_parts = list(BP_L_FOOT)
			species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

		right_foot
			name = "Color Bands (Right Foot)"
			body_parts = list(BP_R_FOOT)
			species_allowed = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara", "Unathi")

		right_foot_human
			name = "Color Bands (Right Foot)"
			icon_state = "bandshuman"
			body_parts = list(BP_R_FOOT)
			species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	bandsface_human
		name = "Color Bands (Face)"
		icon_state = "bandshumanface"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	bindi
		name = "Bindi"
		icon_state = "bindi"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	blush
		name = "Blush"
		icon_state= "blush"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	bridge
		name = "Bridge"
		icon_state = "bridge"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	brow_left
		name = "Brow Left"
		icon_state = "brow_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	brow_right
		name = "Brow Right"
		icon_state = "brow_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	cheekspot_left
		name = "Cheek Spot (Left Cheek)"
		icon_state = "cheekspot_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	cheekspot_right
		name = "Cheek Spot (Right Cheek)"
		icon_state = "cheekspot_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	cheshire_left
		name = "Cheshire (Left Cheek)"
		icon_state = "cheshire_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	cheshire_right
		name = "Cheshire (Right Cheek)"
		icon_state = "cheshire_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	crow_left
		name = "Crow Mark (Left Eye)"
		icon_state = "crow_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	crow_right
		name = "Crow Mark (Right Eye)"
		icon_state = "crow_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	ear_left
		name = "Ear Cover (Left)"
		icon_state = "ear_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	ear_right
		name = "Ear Cover (Right)"
		icon_state = "ear_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	eyestripe
		name = "Eye Stripe"
		icon_state = "eyestripe"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	eyecorner_left
		name = "Eye Corner Left"
		icon_state = "eyecorner_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	eyecorner_right
		name = "Eye Corner Right"
		icon_state = "eyecorner_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	eyelash_left
		name = "Eyelash Left"
		icon_state = "eyelash_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	eyelash_right
		name = "Eyelash Right"
		icon_state = "eyelash_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	fullfacepaint
		name = "Full Face Paint"
		icon_state = "fullface"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	lips
		name = "Lips"
		icon_state = "lips"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	lipcorner_left
		name = "Lip Corner Left"
		icon_state = "lipcorner_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	lipcorner_right
		name = "Lip Corner Right"
		icon_state = "lipcorner_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	lowercheek_left
		name = "Lower Cheek Left"
		icon_state = "lowercheek_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	lowercheek_left
		name = "Lower Cheek Right"
		icon_state = "lowercheek_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	neck
		name = "Neck Cover"
		icon_state = "neck"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	neckthick
		name = "Neck Cover (Thick)"
		icon_state = "neckthick"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	nosestripe
		name = "Nose Stripe"
		icon_state = "nosestripe"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	nosetape
		name = "Nose Tape"
		icon_state = "nosetape"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	scratch_abdomen_left
		name = "Scratch, Abdomen Left"
		icon_state = "scratch_abdomen_l"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	scratch_abdomen_right
		name = "Scratch, Abdomen Right"
		icon_state = "scratch_abdomen_r"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	scratch_abdomen_small_left
		name = "Scratch, Abdomen Small Left"
		icon_state = "scratch_abdomensmall_l"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	scratch_abdomen_small_right
		name = "Scratch, Abdomen Small Right"
		icon_state = "scratch_abdomensmall_r"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	scratch_back
		name = "Scratch, Back"
		icon_state = "scratch_back"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	scratch_chest_left
		name = "Scratch, Chest (Left)"
		icon_state = "scratch_chest_l"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	scratch_chest_right
		name = "Scratch, Chest (Right)"
		icon_state = "scratch_chest_r"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	skull_paint
		name = "Skull Paint"
		icon_state = "skull"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_belly
		name = "Tattoo (Belly)"
		icon_state = "tat_belly"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_campbell_leftarm
		name = "Tattoo (Campbell, Left Arm)"
		icon_state = "tat_campbell"
		body_parts = list(BP_L_ARM)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_campbell_rightarm
		name = "Tattoo (Campbell, Right Arm)"
		icon_state = "tat_campbell"
		body_parts= list(BP_R_ARM)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_campbell_leftleg
		name = "Tattoo (Campbell, Left Leg)"
		icon_state = "tat_campbell"
		body_parts= list(BP_L_LEG)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_campbell_rightleg
		name = "Tattoo (Campbell, Right Leg)"
		icon_state = "tat_campbell"
		body_parts= list(BP_R_LEG)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_forrest_left
		name = "Tattoo (Forrest, Left Eye)"
		icon_state = "tat_forrest_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_forrest_right
		name = "Tattoo (Forrest, Right Eye)"
		icon_state = "tat_forrest_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_hive
		name = "Tattoo (Hive, Back)"
		icon_state = "tat_hive"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_heart
		name = "Tattoo (Heart, Chest)"
		icon_state = "tat_heart"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_heart_back
		name = "Tattoo (Heart, Lower Back)"
		icon_state = "tat_heartback"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_hunter_left
		name = "Tattoo (Hunter, Left Eye)"
		icon_state = "tat_hunter_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_hunter_right
		name = "Tattoo (Hunter, Right Eye)"
		icon_state = "tat_hunter_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_jaeger_left
		name = "Tattoo (Jaeger, Left Eye)"
		icon_state = "tat_jaeger_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_jaeger_right
		name = "Tattoo (Jaeger, Right Eye)"
		icon_state = "tat_jaeger_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_kater_left
		name = "Tattoo (Kater, Left Eye)"
		icon_state = "tat_kater_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_kater_right
		name = "Tattoo (Kater, Right Eye)"
		icon_state = "tat_kater_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_lujan_left
		name = "Tattoo (Lujan, Left Eye)"
		icon_state = "tat_lujan_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_lujan_right
		name = "Tattoo (Lujan, Right Eye)"
		icon_state = "tat_lujan_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_montana_left
		name = "Tattoo (Montana, Left Face)"
		icon_state = "tat_montana_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_montana_right
		name = "Tattoo (Montana, Right Face)"
		icon_state = "tat_montana_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_natasha_left
		name = "Tattoo (Natasha, Left Eye)"
		icon_state = "tat_natasha_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_natasha_right
		name = "Tattoo (Natasha, Right Eye)"
		icon_state = "tat_natasha_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_nightling
		name = "Tattoo (Nightling, Back)"
		icon_state = "tat_nightling"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_pawsocks
		name = "Tattoo (Pawsocks, All)"
		icon_state = "pawsocks"
		body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

		chest
			name = "Tattoo (Pawsocks, Torso)"
			body_parts = list(BP_TORSO)

		groin
			name = "Tattoo (Pawsocks, Groin)"
			body_parts = list(BP_GROIN)

		left_arm
			name = "Tattoo (Pawsocks, Left Arm)"
			body_parts = list(BP_L_ARM)

		right_arm
			name = "Tattoo (Pawsocks, Right Arm)"
			body_parts = list(BP_R_ARM)

		left_hand
			name = "Tattoo (Pawsocks, Left Hand)"
			body_parts = list(BP_L_HAND)

		right_hand
			name = "Tattoo (Pawsocks, Right Hand)"
			body_parts = list(BP_R_HAND)

		left_leg
			name = "Tattoo (Pawsocks, Left Leg)"
			body_parts = list(BP_L_LEG)

		right_leg
			name = "Tattoo (Pawsocks, Right Leg)"
			body_parts = list(BP_R_LEG)

		left_foot
			name = "Tattoo (Pawsocks, Left Foot)"
			body_parts = list(BP_L_FOOT)

		right_foot
			name = "Tattoo (Pawsocks, Right Foot)"
			body_parts = list(BP_R_FOOT)

	tat_silverburgh_left
		name = "Tattoo (Silverburgh, Left Leg)"
		icon_state = "tat_silverburgh"
		body_parts = list(BP_L_LEG)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_silverburgh_right
		name = "Tattoo (Silverburgh, Right Leg)"
		icon_state = "tat_silverburgh"
		body_parts = list(BP_R_LEG)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_tamoko
		name = "Tattoo (Ta Moko, Face)"
		icon_state = "tat_tamoko"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_tiger
		name = "Tattoo (Tiger Stripes, All)"
		icon_state = "tat_tiger"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

		chest
			name = "Tattoo (Tiger Stripes, Chest)"
			body_parts = list(BP_TORSO)

		groin
			name = "Tattoo (Tiger Stripes, Groin)"
			body_parts = list(BP_GROIN)

		left_arm
			name = "Tattoo (Tiger Stripes, Left Arm)"
			body_parts = list(BP_L_ARM)

		right_arm
			name = "Tattoo (Tiger Stripes, Right Arm)"
			body_parts = list(BP_R_ARM)

		left_hand
			name = "Tattoo (Tiger Stripes, Left Hand)"
			body_parts = list(BP_L_HAND)

		right_hand
			name = "Tattoo (Tiger Stripes, Right Hand)"
			body_parts = list(BP_R_HAND)

		left_leg
			name = "Tattoo (Tiger Stripes, Left Leg)"
			body_parts = list(BP_L_LEG)

		right_leg
			name = "Tattoo (Tiger Stripes, Right Leg)"
			body_parts = list(BP_R_LEG)

		left_foot
			name = "Tattoo (Tiger Stripes, Left Foot)"
			body_parts = list(BP_L_FOOT)

		right_foot
			name = "Tattoo (Tiger Stripes, Right Foot)"
			body_parts = list(BP_R_FOOT)

	tat_toshi_left
		name = "Tattoo (Toshi, Left Eye)"
		icon_state = "tat_toshi_l"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_toshi_right
		name = "Tattoo (Volgin, Right Eye)"
		icon_state = "tat_toshi_r"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tat_wings_back
		name = "Tattoo (Wings, Lower Back)"
		icon_state = "tat_wingsback"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tigerhead
		name = "Tiger Stripes (Head, Minor)"
		icon_state = "tigerhead"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)

	tilaka
		name = "Tilaka"
		icon_state = "tilaka"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_HUMAN_VATBORN_MPL)
