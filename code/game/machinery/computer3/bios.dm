/*
	Okay so my last effort to have a central BIOS function was interesting
	but completely unmaintainable, I have scrapped it.

	The parts that were actually useful will be put here in functions instead.
	If we want a central bios function we can add one that just indexes them.
	That should at least allow sensible debugging.
*/

/obj/machinery/computer3

	/*
		interactable(user): performs all standard sanity checks
		Call in topic() and interact().
	*/
/obj/machinery/computer3/proc/interactable(var/mob/user)
	if( !src || !user || stat || user.stat || user.lying || user.blinded )
		return 0
	if(!program)
		return 0
	if(!isturf(loc) || !isturf(user.loc)) // todo handheld maybe
		return 0
	if(user.restrained())
		to_chat(user, "<span class='warning'>You need a free hand!</span>")
		return 0

	if(issilicon(user) &&!program.ai_allowed )
		to_chat(user, "<span class='warning'>You are forbidden from accessing this program.</span>")
		return 0
	if(!ishuman(user) && program.human_controls)
		to_chat(user, "<span class='warning'>Your body can't work the controls!</span>")
		return 0


	if(!in_range(src,user) && (!program.human_controls || !istype(user.get_active_hand(),/obj/item/tk_grab)))
		// telekinesis check
		to_chat(user, "<span class='warning'>It's too complicated to work at a distance!</span>")
		return 0

	add_fingerprint(user)
	user.set_machine(src)
	return 1

	/*
		Deduplicates an item list and gives you range and direction.
		This is used for networking so you can determine which of several
		identically named objects you're referring to.
	*/
/obj/machinery/computer3/proc/format_atomlist(var/list/atoms)
	var/list/output = list()
	for(var/atom/A in atoms)
		var/title = "[A] (Range [get_dist(A,src)] meters, [dir2text(get_dir(src,A))])"
		output[title] = A
	return output

	/*
		This is used by the camera monitoring program to see if you're still in range
	*/
/obj/machinery/computer3/check_eye(var/mob/user as mob)
	if(!interactable(user) || user.machine != src)
		if(user.machine == src)
			user.unset_machine()
		return -1

	var/datum/file/program/security/S = program
	if( !istype(S) || !S.current || !S.current.status || !camnet )
		if( user.machine == src )
			user.unset_machine()
		return -1

	user.reset_view(S.current, 0)
	return 0

	/*
		List all files, including removable disks and data cards
		(I don't know why but I don't want to rip data cards out.
		It just seems... interesting?)
	*/
/obj/machinery/computer3/proc/list_files(var/typekey = null)
	var/list/files = list()
	if(hdd)
		files += hdd.files
	if(floppy && floppy.inserted)
		files += floppy.inserted.files
	if(cardslot && istype(cardslot.reader,/obj/item/weapon/card/data))
		files += cardslot.reader:files
	if(!ispath(typekey))
		return files

	var/i = 1
	while(i<=files.len)
		if(istype(files[i],typekey))
			i++
			continue
		files.Cut(i,i+1)
	return files

	/*
		Crash the computer with an error.
		Todo: redo
	*/
/obj/machinery/computer3/proc/Crash(var/errorcode = PROG_CRASH)
	if(!src)
		return null

	switch(errorcode)
		if(PROG_CRASH)
			if(usr)
				to_chat(usr, "<span class='warning'>The program crashed!</span>")
				to_target(usr, browse(null,"\ref[src]"))
				Reset()

		if(MISSING_PERIPHERAL)
			Reset()
			if(usr)
				to_target(usr, browse("<h2>ERROR: Missing or disabled component</h2><b>A hardware failure has occured.  Please insert or replace the missing or damaged component and restart the computer.</b>","window=\ref[src]"))

		if(BUSTED_ASS_COMPUTER)
			Reset()
			os.error = BUSTED_ASS_COMPUTER
			if(usr)
				to_target(usr, browse("<h2>ERROR: Missing or disabled component</h2><b>A hardware failure has occured.  Please insert or replace the missing or damaged component and restart the computer.</b>","window=\ref[src]"))

		if(MISSING_PROGRAM)
			Reset()
			if(usr)
				to_target(usr, browse("<h2>ERROR: No associated program</h2><b>This file requires a specific program to open, which cannot be located.  Please install the related program and try again.</b>","window=\ref[src]"))

		if(FILE_DRM)
			Reset()
			if(usr)
				to_target(usr, browse("<h2>ERROR: File operation prohibited</h2><b>Copy protection exception: missing authorization token.</b>","window=\ref[src]"))

		if(NETWORK_FAILURE)
			Reset()
			if(usr)
				to_target(usr, browse("<h2>ERROR: Networking exception: Unable to connect to remote host.</h2>","window=\ref[src]"))

		else
			if(usr)
				to_chat(usr, "<span class='warning'>The program crashed!</span>")
				to_target(usr, browse(null,"\ref[src]"))
				testing("computer/Crash() - unknown error code [errorcode]")
				Reset()
	return null

	#define ANY_DRIVE 0
	#define PREFER_FLOPPY 1
	#define PREFER_CARD 2
	#define PREFER_HDD 4


	// required_location: only put on preferred devices
/obj/machinery/computer3/proc/writefile(var/datum/file/F, var/where = ANY_DRIVE, var/required_location = 0)
	if(where != ANY_DRIVE)
		if((where&PREFER_FLOPPY) && floppy && floppy.addfile(F))
			return 1
		if((where&PREFER_CARD) && istype(cardslot, /obj/item/part/computer/cardslot/dual))
			var/obj/item/part/computer/cardslot/dual/D = cardslot
			if(D.addfile(F))
				return 1
		if((where&PREFER_HDD) && hdd && hdd.addfile(F))
			return 1

		if(required_location)
			return 0

	if(floppy && floppy.addfile(F))
		return 1
	if(istype(cardslot, /obj/item/part/computer/cardslot/dual))
		var/obj/item/part/computer/cardslot/dual/D = cardslot
		if(D.addfile(F))
			return 1
	if(hdd && hdd.addfile(F))
		return 1
	return 0
