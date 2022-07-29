#define ALL_VEHICLE_POSITIONS list("driver","passenger","gunner")

/datum/vehicle_interior
    var/id

    //11 at max
    var/size_x = 0
    var/size_y = 0

    var/list/mob/living/carbon/human/occupants = null
    var/datum/map_template/interior_template = /datum/map_template
    var/turf/middle_turf
    var/obj/effect/vehicle_entrance/entrance = null
    var/obj/structure/vehicledoor/door = null
    var/obj/manhattan/vehicle/large/vehicle = null

/datum/vehicle_interior/New()
    . = ..()
    sleep(1)
    var/datum/map_template/template
    for(var/obj/effect/interior_spawn/spawns in GLOB.vehicle_spawnpoints)
        var/turf/T = spawns.loc
        middle_turf = T
        template = new template
        if(!template.load(T, centered = TRUE))
            log_error("Vehicle interior template failed to load!")
            qdel(src)
        qdel(spawns)
        break
    if(!template)
        log_error("No template for vehicle interior found.")
        return

    id = rand(1, 999999) //Will never match
    if(!vehicle)
        return
    for(var/obj/effect/vehicle_entrance/E in range(5, middle_turf))
        entrance = E
        entrance.id = id
        break
    for(var/obj/structure/vehicledoor/E in range(5, middle_turf))
        door = E
        door.id = id
        door.interior = src
        break
    if(!vehicle)
        return
    GLOB.vehicle_interiors += src

/obj/effect/vehicle_entrance
    var/id

/obj/effect/interior_spawn
    var/free_x = 0
    var/free_y = 0

/obj/effect/interior_spawn/New()
    . = ..()
    GLOB.vehicle_spawnpoints += src



/obj/manhattan/vehicle/large
	var/datum/vehicle_interior/interior = null
	var/size_x = 0
	var/size_y = 0
	var/datum/map_template/interior_template = /datum/map_template

/obj/manhattan/vehicle/large/New()
	interior = new
	interior.vehicle = src
	interior.interior_template = interior_template

/obj/manhattan/vehicle/large/enter_vehicle()
    set name = "Войти в транспорт"
    set category = "Транспорт"
    set src in view(1)

    var/mob/living/user = usr
    if(!istype(user) || !src.Adjacent(user) || user.incapacitated())
        return
    var/player_pos_choice
    var/list/L = ALL_VEHICLE_POSITIONS
    if(L.len == 1)
        player_pos_choice = L[1]
    else
        player_pos_choice = input(user,"Enter which position?","Vehicle Entry Position Select","Cancel") in ALL_VEHICLE_POSITIONS + list("Cancel")

    switch(player_pos_choice)
        if("cancel")
            return
        if("passenger")
            visible_message("<span class = 'notice'>[user] enters the interior of [src].</span>")
            to_chat(user,"<span class = 'info'>You are now in the interior of [src].</span>")
            playsound(src, 'sound/vehicles/modern/vehicle_enter.ogg', 150, 1, 5)
            user.forceMove(interior.entrance.loc)
            occupants += user
            occupants[user] = "passenger"
            contents += user
            return

    enter_as_position(user,player_pos_choice)

/obj/manhattan/vehicle/large/enter_as_position(var/mob/user,var/position = "driver")
    if(block_enter_exit)
        to_chat(user,"<span class = 'notice'>The [src] is locked.</span>")
        return 0
    if(check_position_blocked(position))
        to_chat(user,"<span class = 'notice'>No [position] spaces in [src]</span>")
        return 0
    var/mob/living/h_test = user
    if(!istype(h_test) && position == "driver")
        to_chat(user,"<span class = 'notice'>You don't know how to drive that.</span>") //Let's assume non-living mobs can't drive.
        return
    var/can_enter = check_enter_invalid()
    if(can_enter)
        to_chat(user,"<span class = 'notice'>[can_enter]</span>")
        return 0
    if(user in occupants)
        if(occupants[user] == position)
            to_chat(user,"<span class = 'notice'>You're already a [position] of [src]</span>")
            return 0
        occupants[user] = position
        visible_message("<span class = 'notice'>[user] enters [src] as [position]</span>")
        update_object_sprites()
        return 1

    occupants += user
    occupants[user] = position
    user.loc = contents
    contents += user
    update_object_sprites()
    visible_message("<span class = 'notice'>[user] enters the [position] position of [src].</span>")
    to_chat(user,"<span class = 'info'>You are now in the [position] position of [src].</span>")
    playsound(src, 'sound/vehicles/modern/vehicle_enter.ogg', 150, 1, 5)
    return 1

/obj/manhattan/vehicle/large/exit_vehicle(var/mob/user,var/ignore_incap_check = 0)
    if(!occupants[user])
        to_chat(user,"<span class = 'notice'>You must be inside [src] to exit it.</span>")
        return
    if(user.incapacitated() && !ignore_incap_check)
        to_chat(user,"<span class='warning'>You cannot do that when you are incapacitated!</span>")
        return
    var/loc_moveto = pick_valid_exit_loc()
    if(isnull(loc_moveto))
        to_chat(user,"<span class = 'notice'>There is no valid location to exit at.</span>")
        return
    occupants -= user
    contents -= user
    user.forceMove(loc_moveto)
    playsound(src, 'sound/vehicles/modern/vehicle_enter.ogg', 150, 1, 5)
    update_object_sprites()



/obj/structure/vehiclewall
	name = "vehicle wall"
	breakable = FALSE
	icon = 'icons/vehicles/interior/walls.dmi'
	icon_state = "noborder"
	layer = ABOVE_MOB_LAYER
	density = 1

/obj/structure/vehicledoor
	name = "vehicle door"
	desc = "Don't joke about the back door!"
	icon = 'icons/vehicles/interior/walls.dmi'
	icon_state = "ambulancedoor"
	var/id
	var/datum/vehicle_interior/interior = null
	layer = ABOVE_MOB_LAYER
	density = 1

/obj/structure/vehicledoor/attack_hand(mob/user)
    . = ..()
    interior.vehicle.exit_vehicle(user)