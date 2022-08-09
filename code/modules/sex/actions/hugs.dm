/datum/erp_action/hug
	name = "Обнять"
	allowed_poses = list(list(POS_STANDING, POS_STANDING))

/datum/erp_action/hug/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	var/messages = list(
		list("@1 тянется всем телом, но достает только до уровня груди @2, куда и утыкается лицом, обвив руки вокруг [pronounce_helper(user2, "его", "её")] талии."),
		list("@1 крепко обнимает @2, прижавшись к [pronounce_helper(user2, "нему", "ней")] всем телом."),
		list("@1 тянется всем телом, но достает только до уровня груди @2, куда и утыкается лицом, обвив руки вокруг [pronounce_helper(user2, "его", "её")] талии.")
	)

	return height_picker(user1, user2, messages)

/datum/erp_action/hug/sitting
	allowed_poses = list(list(POS_SITTING, POS_SITTING))

/datum/erp_action/hug/sitting/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	return list(
		"@1 пододвигается ближе к @2 и кладет свою руку [pronounce_helper(user2, "ему", "ей")] на плечо, прижимая ",
		"@1 зевает, и якобы невзначай кладет свою руку на плечо @2."
	)

/datum/erp_action/hug/lying
	allowed_poses = list(list(POS_LYING, POS_LYING))

/datum/erp_action/hug/lying/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2)
	return list(
		"@1 подползает чуть поближе к @2 и обвивает [pronounce_helper(user2, "его", "её")] рукой вокруг талии.",
		"@1 тянется вбок и заключает [pronounce_helper(user2, "лежащего", "лежащую")] рядом @2 в объятия."
	)
