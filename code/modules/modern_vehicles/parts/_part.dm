#define COMPONENT_MESSAGE_MODE_OCCUPANTS        1
#define COMPONENT_MESSAGE_MODE_SURROUNDINGS     2

/obj/item/vehicle_part
    name = "vehicle component"
    desc = "An unknown part for some kind of vehicle."
    var/integrity = 100 //0-100
    var/broken = FALSE
    var/needs_processing = FALSE
    var/obj/manhattan/vehicle/vehicle = null

    var/break_message
    var/break_sound = null

/obj/item/vehicle_part/process()
    if(!needs_processing)
        return
    part_process()

/obj/item/vehicle_part/proc/part_process()
    return

/obj/item/vehicle_part/proc/fail()
    if(broken)
        return
    broken = TRUE
    if(break_message)
        vehicle.visible_message(break_message)
    if(break_sound)
        playsound(vehicle, break_sound, 50, 1, 5)

/obj/item/vehicle_part/proc/handle_damage(var/strength)
    if(broken)
        return

    var/total_damage = strength - armor * 0.5
    var/delta_damage = Clamp(total_damage, 0, integrity)
    if(!delta_damage)
        return
    integrity -= delta_damage
    if(!integrity)
        fail()

/obj/item/vehicle_part/proc/send_message(var/message, var/mode)
    if(mode == COMPONENT_MESSAGE_MODE_SURROUNDINGS)
        vehicle.visible_message(message)

/obj/item/vehicle_part/proc/inspect(var/mob/living/carbon/human/user)
    return

#undef COMPONENT_MESSAGE_MODE_OCCUPANTS
#undef COMPONENT_MESSAGE_MODE_SURROUNDINGS