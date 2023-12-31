// Held by /obj/machinery/modular_computer to reduce amount of copy-pasted code.
/obj/item/modular_computer/processor
	name = "processing unit"
	desc = "You shouldn't see this. If you do, report it."
	icon = null
	icon_state = null
	icon_state_unpowered = null
	icon_state_menu = null
	hardware_flag = 0

	var/obj/machinery/modular_computer/machinery_computer = null

/obj/item/modular_computer/processor/on_persistence_load()
	// adds battery modules
	var/B = locate(/obj/item/weapon/computer_hardware/battery_module) in src
	if(B)
		battery_module = B

	// add network cards
	var/N = locate(/obj/item/weapon/computer_hardware/network_card) in src
	if(N)
		network_card = N

	// add hard drives
	var/H = locate(/obj/item/weapon/computer_hardware/hard_drive) in src
	if(H)
		hard_drive = H

	// add printers
	var/P = locate(/obj/item/weapon/computer_hardware/nano_printer) in src
	if(P)
		nano_printer = P


/obj/item/modular_computer/processor/Destroy()
	if(machinery_computer && (machinery_computer.cpu == src))
		machinery_computer.cpu = null
	machinery_computer = null
	return ..()

// Due to how processes work, we'd receive two process calls - one from machinery type and one from our own type.
// Since we want this to be in-sync with machinery (as it's hidden type for machinery-based computers) we'll ignore
// non-relayed process calls.
/obj/item/modular_computer/processor/process(relayed = 0)
	if(relayed)
		..()
	else
		return

// Power interaction is handled by our machinery part, due to machinery having APC connection.
/obj/item/modular_computer/processor/handle_power()
	if(machinery_computer)
		machinery_computer.handle_power()

/obj/item/modular_computer/processor/New(comp)
	if(!comp || !istype(comp, /obj/machinery/modular_computer))
		CRASH("Inapropriate type passed to obj/item/modular_computer/processor/New()! Aborting.")
	// Obtain reference to machinery computer
	machinery_computer = comp
	machinery_computer.cpu = src
	hardware_flag = machinery_computer.hardware_flag
	max_hardware_size = machinery_computer.max_hardware_size
	steel_sheet_cost = machinery_computer.steel_sheet_cost

/obj/item/modular_computer/processor/relay_qdel()
	qdel(machinery_computer)

/obj/item/modular_computer/processor/find_hardware_by_name(N)
	var/obj/item/weapon/computer_hardware/H = machinery_computer.find_hardware_by_name(N)
	if(H)
		return H
	else
		return ..()

/obj/item/modular_computer/processor/update_icon()
	if(machinery_computer)
		return machinery_computer.update_icon()

/obj/item/modular_computer/processor/get_header_data()
	var/list/L = ..()
	if(machinery_computer.tesla_link && machinery_computer.tesla_link.enabled)
		L["PC_apclinkicon"] = "charging.gif"
	return L

// Checks whether the machinery computer doesn't take power from APC network
/obj/item/modular_computer/processor/check_power_override()
	if(!machinery_computer)
		return 0
	if(!machinery_computer.tesla_link || !machinery_computer.tesla_link.enabled)
		return 0
	return TRUE 

// This thing is not meant to be used on it's own, get topic data from our machinery owner.
/obj/item/modular_computer/processor/CanUseTopic(user, state)
	if(!machinery_computer)
		return 0
	return machinery_computer.CanUseTopic(user, state)

/obj/item/modular_computer/processor/shutdown_computer()
	if(!machinery_computer)
		return
	kill_program(1)
	visible_message("\The [machinery_computer] shuts down.")
	enabled = 0
	machinery_computer.update_icon()
	return

// Tesla links only work on machinery types, so we'll override the default try_install_component() proc
/obj/item/modular_computer/processor/try_install_component(mob/living/user, obj/item/weapon/computer_hardware/H, found = 0)
	if(istype(H, /obj/item/weapon/computer_hardware/tesla_link))
		if(machinery_computer.tesla_link)
			to_chat(user, "This computer's tesla link slot is already occupied by \the [machinery_computer.tesla_link].")
			return
		var/obj/item/weapon/computer_hardware/tesla_link/L = H
		L.holder = machinery_computer
		machinery_computer.tesla_link = L
		// Consoles don't usually have internal power source, so we can't disable tesla link in them.
		if(istype(machinery_computer, /obj/machinery/modular_computer/console))
			L.critical = 1
		found = 1
	..(user, H, found)

/obj/item/modular_computer/processor/uninstall_component(mob/living/user, obj/item/weapon/computer_hardware/H, found = 0, critical = 0)
	if(machinery_computer.tesla_link == H)
		machinery_computer.tesla_link = null
		var/obj/item/weapon/computer_hardware/tesla_link/L = H
		L.critical = 0		// That way we can install tesla link from console to laptop and it will be possible to turn it off via config.
		L.holder = null
		found = 1
	..(user, H, found, critical)

/obj/item/modular_computer/processor/get_all_components()
	var/list/all_components = ..()
	if(machinery_computer && machinery_computer.tesla_link)
		all_components.Add(machinery_computer.tesla_link)
	return all_components

// Perform adjacency checks on our machinery counterpart, rather than on ourselves.
/obj/item/modular_computer/processor/Adjacent(atom/neighbor)
	if(!machinery_computer)
		return 0
	return machinery_computer.Adjacent(neighbor)
