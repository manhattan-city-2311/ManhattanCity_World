var/list/male_outfits
var/list/female_outfits
var/list/unisex_outfits = list(
	/decl/hierarchy/outfit/job/assistant,
	/decl/hierarchy/outfit/job/assistant/visitor,
	/decl/hierarchy/outfit/job/assistant/socialite,
	/decl/hierarchy/outfit/job/assistant/resident,
	/decl/hierarchy/outfit/job/business/formal,
	/decl/hierarchy/outfit/job/business/casual
)

/mob/living/carbon/human/npc
	var/decl/hierarchy/outfit/outfit

/mob/living/carbon/human/npc/proc/random_outfit()
	if(outfit)
		outfit.equip_base(src)
		return

	var/list/outfits = list()
	outfits += unisex_outfits.Copy()
	if(gender == MALE)
		outfits += male_outfits.Copy()
	else
		outfits += female_outfits.Copy()

	var/decl/hierarchy/outfit/O = pick(outfits)
	O.equip_base(src)

