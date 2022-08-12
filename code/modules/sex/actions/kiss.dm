/datum/erp_action/kiss_body
	name = "Поцелуи тела"
	sbp = SBP_ORAL
	needs_access = SBP_NIPPLES // a bit tricky.
	category = ERP_ACTION_CATEGORY_FOREPLAY

/datum/erp_action/kiss_body/get_messages(mob/living/carbon/human/user1, mob/living/carbon/human/user2, number)
	return list(
		"@1 нежно касается губами ключицы @2.",
		"@1 целует ложбинку чуть ниже шеи @2.",
		"@1 целует а затем лижет левый сосок @2.",
		"@1 обхватывает губами правый сосок @2.",
		"@1 оставляет на животе @2 дорожку поцелуев от груди и вниз",
		"@1 мягко касается губами у пупка @2.",
		"@1 влажно целует чуть выше паха @2.",
		"@1 оставляет влажное прикосновение губ на внутренней части бедра @2."
	)

/datum/erp_action/kiss_cheek
	name = "Поцелуй в щеку"
	sbp = SBP_ORAL
	needs_access = SBP_FACE

/datum/erp_action/kiss_cheek/get_messages(user1, user2)
	return list("@1 движется к @2 и оставляет на [pronounce_helper(user2, "его", "её")] щеке влажный поцелуй.")

/datum/erp_action/kiss_cheek/gentle
	name = "Нежный поцелуй в щеку"
	action_type = ERP_ACTION_GENTLE

/datum/erp_action/kiss_cheek/gentle/get_messages()
	return list("@1 мягко прикасается губами к щеке @2, вызывая у @2 рой муражек по шее.")

/datum/erp_action/kiss_cheek/rough
	name = "Грубый поцелуй в щеку"
	action_type = ERP_ACTION_ROUGH
	base_pleasure = list(0, 0.8)

/datum/erp_action/kiss_cheek/rough/get_messages(user1, user2)
	return list(
		"@1 резко наклоняется вперёд, вторгаясь в личное пространство @2 и клюёт [pronounce_helper(user2, "его", "её")] в щеку, тут же отстраняясь."
	)

/datum/erp_action/kiss_neck
	name = "Поцелуй в шею"
	sbp = SBP_ORAL
	needs_access = SBP_FACE

/datum/erp_action/kiss_neck/get_messages()
	return list(
		"@1 наклоняется к @2, чуть правее чем можно было бы предположить, и утыкается губами в шею @2, оставляя на коже влажный след."
	)

/datum/erp_action/kiss_neck/gentle
	name = "Нежный поцелуй в шею"
	action_type = ERP_ACTION_GENTLE

/datum/erp_action/kiss_neck/gentle/get_messages()
	return list(
		"@1 наклоняется к @2, но не к губам, а чуть левее, и утыкается своим носом в сгиб шеи @2, медленно вдыхает, и через пару секунд оставляет на коже @2 мягкий, невесомый поцелуй."
	)

/datum/erp_action/kiss_neck/rough
	name = "Грубый поцелуй в шею"
	action_type = ERP_ACTION_ROUGH
	base_pleasure = list(0, 1.2)

/datum/erp_action/kiss_neck/rough/get_messages()
	return list(
		"@1 резко наклоняется, ухватив @2 за талию, и зарывается лицом в сгиб шеи @2, чуть прикусывая и посасывая кожу."
	)

// TODO:
/datum/erp_action/kiss
	name = "Поцелуй в губы"
	sbp = SBP_ORAL
	needs_access = SBP_ORAL

/datum/erp_action/kiss/get_messages(user1, user2)
	var/list/height_dependent_messages = list(
		list("@1 движется вперёд, и подтягивается, с усилием оказываясь напротив @2 и тут же запечатляет поцелуй на [pronounce_helper(user1, "его", "её")] губах, проникая языком внутрь и касаясь зубов @2."),
		list("@1 пересекает оставшееся расстояние между собой и @2, и прикасается к губам @2 своими губами. [pronounce_helper(user1, "Он", "Она")] проводит языком по зубам @2 и только тогда отстраняется."),
		list("@1 наклоняется, даже сгибается к @2, обхватывая [pronounce_helper(user2, "его", "её")] за плечи и касается своими губами губ @2, перебирает пальцами по плечам @2, углубляет поцелуй, проводит своим языком по зубам @2 и только теперь отстраняется, довольно тяжело дыша.")
	)
	return height_picker(user1, user2, height_dependent_messages)

/datum/erp_action/kiss/gentle
	name = "Нежный поцелуй в губы"
	action_type = ERP_ACTION_GENTLE

/datum/erp_action/kiss/gentle/get_messages(user1, user2)
	var/list/height_dependent_messages = list(
		list("@1 поднимается на цыпочки, тянется ближе к @2, и, дотянувшись, соприкасается своими губами с @2, но дальше не движется, потому что не может, или попросту не хочет."),
		list("@1 движется вперёд, и оказавшись прямо напротив @2 продолжает движение, соприкасаясь губами с @2, все же остановившись на том."),
		list("@1 берет @2 за плечи и чуть сжимает их, наклоняется ниже, склоняясь к @2 и оставляет на [pronounce_helper(user1, "его", "её")] губах поцелуй, просто нежное прикосновение.")
	)
	return height_picker(user1, user2, height_dependent_messages)

/datum/erp_action/kiss/passionate
	name = "Страстный поцелуй в губы"
	category = ERP_ACTION_CATEGORY_FOREPLAY
	action_type = ERP_ACTION_PASSIONATE

/datum/erp_action/kiss/passionate/get_messages(user1, user2)
	var/list/height_dependent_messages = list(
		list("@1 дёргается вперёд, к @2, за секунду преодолевая разделяющее их расстояние, склоняется к @2, и завлекает [pronounce_helper(user2, "того", "ту")] в поцелуй, их губы соприкасаются, движутся, и вот уже @1 играет с языком @2, по щеке @2 течет струйка слюны. Это явно просто так не кончится."),
		list("@1 практически мгновенно преодолевает то небольшое расстояние что осталось между [pronounce_helper(user2, "ним", "ней")] и @2, и завлекает [pronounce_helper(user2, "того", "ту")] в глубокий поцелуй, их языки переплетаются, они дышат горячо и отрывисто, это явно не закончится просто так."),
		list("@1 сокращает расстояние между собой и @2, недолго думая поднимается на цыпочки, тянется вверх, и соприкасается губами с @2, вовсе не останавливается на этом, приоткрывает рот, и получает ответ, не менее страстный.")
	)

	return height_picker(user1, user2, height_dependent_messages)

/datum/erp_action/neck_bite
	name = "Укус в шею"
	category = ERP_ACTION_CATEGORY_FOREPLAY
	action_type = ERP_ACTION_ROUGH
	sbp = SBP_ORAL
	base_pleasure = list(0, 0.8)

/datum/erp_action/neck_bite/get_messages(user1, user2)
	var/list/height_dependent_messages = list(
		list("@1 тянется, привстает на цыпочки, пытается дотянутся до шеи @2, но утыкается только в ключицы, оставляя на тех несколько поцелуев, после чего недовольно отстраняется."),
		list("@1 сокращает небольшое расстояние между собой и @2, и утыкается носом в сгиб [pronounce_helper(user2, "его", "её")] шеи, спустя пару секунд нежно прикусывает кожу, вызывая слабый румянец."),
		list("@1 наклоняется, тянется к @2, утыкается носом в сгиб [pronounce_helper(user2, "его", "её")] шеи, вдыхает запах. Через пару секунд влажные губы смыкаются на нежном кусочке кожи на шее @2, а потом и некоторое присутствие зубов, посылающее по спине мурашки.")
	)

	return height_picker(user1, user2, height_dependent_messages)
