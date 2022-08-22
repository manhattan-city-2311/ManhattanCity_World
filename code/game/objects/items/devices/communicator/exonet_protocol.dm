/datum/exonet_protocol/phone/make_address(var/string)
	// . = ..()
	var/na = "-"
	while(na == find_address(na))
		var/head = list()
		head += rand(1, 9)
		for(var/i in 1 to 2)
			head += rand(0,9)
		var/body = list()
		head += rand(1, 9)
		for(var/i in 1 to 8)
			body += rand(0,9)
		na = jointext(head, "") + "-" + jointext(body, "")
	address = na
	all_exonet_connections |= src


