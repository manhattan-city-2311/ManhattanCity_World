#define PHONE_NUMBERS_DB "data/phone_numbers.txt"
#define PHONE_NUMBERS_DB_BACKUP "data/phone_numbers_backup.txt"
var/list/existing_phone_numbers = null
/proc/load_phone_numbers()
	if(fexists(PHONE_NUMBERS_DB))
		existing_phone_numbers = splittext(file2text(PHONE_NUMBERS_DB), "\n")
		existing_phone_numbers.Remove("\n")
		existing_phone_numbers.Remove("")
		existing_phone_numbers.Remove(null)
	else
		existing_phone_numbers = list()

/proc/upload_phone_numbers()
	var/backup = file2text(PHONE_NUMBERS_DB)
	if(fexists(PHONE_NUMBERS_DB_BACKUP))
		fdel(PHONE_NUMBERS_DB_BACKUP)
	text2file(backup, PHONE_NUMBERS_DB_BACKUP)
	if(fexists(PHONE_NUMBERS_DB))
		fdel(PHONE_NUMBERS_DB)
	text2file(jointext(existing_phone_numbers, "\n"), PHONE_NUMBERS_DB)

/hook/save_world/proc/save_phone_numbers()
	upload_phone_numbers()

	return TRUE

/datum/exonet_protocol/phone/make_address(var/string)
	var/na
	while(is_address_exist(na) || !na)
		na = ""
		for(var/i in 1 to 3)
			for(var/x in 1 to 3)
				na += num2text(rand(x == 1 ? 1 : 0, 9))
			if(i != 3)
				na += "-"
	address = na
	all_exonet_connections |= src
	existing_phone_numbers |= address

/datum/exonet_protocol/phone/is_address_exist(target_address)
	if(!existing_phone_numbers)
		load_phone_numbers()
	if(existing_phone_numbers)
		if(address in existing_phone_numbers)
			return
		else
			return ..() && TRUE
	else
		return ..()
