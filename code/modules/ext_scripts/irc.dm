/proc/send2irc(channel, msg)
	if (config.use_irc_bot)
		if (config.use_node_bot)
			shell("node bridge.js -h \"[config.irc_bot_host]\" -p \"[config.irc_bot_port]\" -c \"[channel]\" -m \"[escape_shell_arg(msg)]\"")
		else
			if (config.irc_bot_host)
				if(config.irc_bot_export)
					spawn(-1) // spawn here prevents hanging in the case that the bot isn't reachable
						world.Export("http://[config.irc_bot_host]:45678?[list2params(list(pwd=config.comms_password, chan=channel, mesg=msg))]")
				else
					if(config.use_lib_nudge)
						var/nudge_lib
						if(world.system_type == MS_WINDOWS)
							nudge_lib = "lib\\nudge.dll"
						else
							nudge_lib = "lib/nudge.so"

						spawn(0)
							call(nudge_lib, "nudge")("[config.comms_password]","[config.irc_bot_host]","[channel]","[escape_shell_arg(msg)]")
					else
						spawn(0)
							ext_python("ircbot_message.py", "[config.comms_password] [config.irc_bot_host] [channel] [escape_shell_arg(msg)]")
	return

/proc/send2mainirc(msg)
	if(config.main_irc)
		send2irc(config.main_irc, msg)
	return

/proc/send2adminirc(msg)
	if(config.admin_irc)
		send2irc(config.admin_irc, msg)
	return

/proc/get_world_url()
	. = "byond://"
	if(config.serverurl)
		. += config.serverurl
	else if(config.server)
		. += config.server
	else
		. += "[world.address]:[world.port]"


/hook/startup/proc/ircNotify()
	send2mainirc("Server starting up on byond://[config.serverurl ? config.serverurl : (config.server ? config.server : "[world.address]:[world.port]")]")
	return 1

