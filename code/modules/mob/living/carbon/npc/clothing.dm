#define NPCS_UNISEX_OUTFITS /decl/hierarchy/outfit/job/assistant, \
/decl/hierarchy/outfit/job/assistant/visitor, \
/decl/hierarchy/outfit/job/assistant/socialite, \
/decl/hierarchy/outfit/job/assistant/resident, \
/decl/hierarchy/outfit/job/business/formal, \
/decl/hierarchy/outfit/job/business/casual

var/global/list/npcs_male_outfits = list(
	NPCS_UNISEX_OUTFITS,
	/decl/hierarchy/outfit/job/assistant
)

var/global/list/npcs_female_outfits = list(
	NPCS_UNISEX_OUTFITS,
	/decl/hierarchy/outfit/job/assistant
)


/mob/living/carbon/human/npc
	var/decl/hierarchy/outfit/outfit

/mob/living/carbon/human/npc/proc/equip_outfit()
	if(ispath(outfit))
		outfit = new outfit()
		outfit.equip(src)
		return

	var/list/outfits = outfit || (gender == MALE ? global.npcs_male_outfits : global.npcs_female_outfits)

	var/decl/hierarchy/outfit/O = pick(outfits)
	O = new O()
	O.equip(src)

#undef NPCS_UNISEX_OUTFITS
