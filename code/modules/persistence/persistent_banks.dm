var/global/list/datum/money_account/persistent_money_accounts

/proc/load_persistent_account(account_number)
	if(!account_number)
		return

	var/datum/money_account/A = new

	if(!A.load(account_number))
		return

	LAZYADD(global.persistent_money_accounts, A)
	GLOB.all_money_accounts |= A

	return A

/datum/money_account/proc/save()
	var/full_path = "data/persistent/money_accounts/[md5("[account_number]")].sav"

	var/savefile/S = new(full_path)
	if(!S)
		return

	sanitize_values()

	S.cd = "/"

	to_save(S, owner_name)
	to_save(S, account_number)
	to_save(S, remote_access_pin)
	to_save(S, expenses)
	to_save(S, suspended)
	to_save(S, max_transaction_logs)
	to_save(S, transaction_log)
	to_save(S, security_level)
	to_save(S, money)

/datum/money_account/proc/load(acc_num)
	var/full_path = "data/persistent/money_accounts/[md5("[acc_num]")].sav"

	if(!fexists(full_path))
		return FALSE

	var/savefile/S = new(full_path)
	if(!S)
		return FALSE

	S.cd = "/"

	from_save(S, owner_name)
	from_save(S, account_number)
	from_save(S, remote_access_pin)
	from_save(S, expenses)
	from_save(S, suspended)
	from_save(S, max_transaction_logs)
	from_save(S, transaction_log)
	from_save(S, security_level)
	from_save(S, money)

	return TRUE

/datum/money_account/proc/make_persistent()
	var/full_path = "data/persistent/money_accounts/[md5("[account_number]")].sav"

	if(!fexists(full_path))
		LAZYADD(global.persistent_money_accounts, src)
	var/savefile/S = new(full_path)

	return S

/proc/del_persistent_account(account_number)
	var/full_path = "data/persistent/money_accounts/[md5("[account_number]")].sav"
	if(!fexists(full_path))
		return

	fdel(full_path)
