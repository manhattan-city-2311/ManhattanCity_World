// Ported from /vg/.
/proc/escape_shell_arg(var/arg)
	// RCE prevention
	// - Encloses arg in single quotes
	// - Escapes single quotes
	// Also escapes %, ! on windows
	if(world.system_type == MS_WINDOWS)
		arg = replacetext_char(arg, "^", "^^") // Escape char
		arg = replacetext_char(arg, "%", "%%") // %PATH% -> %%PATH%%
		arg = replacetext_char(arg, "!", "^!") // !PATH!, delayed variable expansion on Windows
		arg = replacetext_char(arg, "\"", "^\"")
		arg = "\"[arg]\""
	else
		arg = replacetext_char(arg, "\\", "\\\\'") // Escape char
		arg = replacetext_char(arg, "'", "\\'")    // No breaking out of the single quotes.
		arg = "'[arg]'"
	return arg

/proc/ext_python(var/script, var/args, var/scriptsprefix = 1)
	if(scriptsprefix)
		script = "scripts/" + script

	if(world.system_type == MS_WINDOWS)
		script = replacetext_char(script, "/", "\\")

	var/command = config.python_path + " " + script + " " + args
	return shell(command)