/obj/item/modular_computer
	var/ModularComputerTheme/CurrentTheme = "Default"
	var/static/Themes = list(
		new /ModularComputerTheme("Default"),
		new /ModularComputerTheme("The Grid", f = "ModularGrid.css"),
		new /ModularComputerTheme("Netrunner", f = "ModularNetrunner.css"),
	)

/obj/item/modular_computer/initialize()
	. = ..()
	if(istext(CurrentTheme))
		CurrentTheme = GetThemeByName(src, CurrentTheme)

/proc/GetThemeByName(obj/item/modular_computer/source, serchingName)
	for(var/ModularComputerTheme/i in source.Themes)
		if(i.Name == serchingName)
			return i
	// if(name in source.Themes)
	// 	return source.Themes[name]

/ModularComputerTheme
	var/Name = "unknown"
	var/Text = ""
	// Examples:
	// <link rel='stylesheet' type='text/css' href='[NanoUIFilename]'>
	// <style>body{background-image: url(uiBackground-Syndicate.png)}</style>
/ModularComputerTheme/New(_Name, _Text = null, f = null)
	. = ..()
	Name = _Name
	if(f)
		Text = "<link rel='stylesheet' type='text/css' href='[f]'>"
		return
	if(_Text != null)
		Text = _Text
		return
