/obj/item/weapon/key/car
	name = "key"
	desc = "A small steel key, it's intended for a car."
	icon = 'icons/obj/vehicle_keys.dmi'
	icon_state = null
	w_class = ITEMSIZE_TINY
	var/key_data
	slot_flags = SLOT_POCKET

/obj/item/weapon/key/car/initialize()
	. = ..()
	if(!icon_state)
		icon_state = "key[rand(1, 5)]"

/obj/item/weapon/key/car/vars_to_save()
	return ..() + list("key_data")

/obj/item/weapon/key/car/zakatneba 
	icon_state = "keyzakatneba"
	key_data = "zakatneba"

/obj/item/weapon/key/car/police
	icon_state = "keyzakatneba"
