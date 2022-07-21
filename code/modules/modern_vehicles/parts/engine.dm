#define RPM_IDLE 700
#define RPM_SLOW 2000
#define RPM_MED  3500
#define RPM_FAST 6500

#define VC_ENGINE "engine"

/obj/item/vehicle_part/engine
    name = "car engine"
    icon_state = "engine"
    armor = 50
    id = VC_ENGINE
    var/rpm = 0
    var/torque = 0
    break_sound = 'sound/vehicles/modern/vehicle_running_out_of_gas.ogg'
    var/stop_sound = 'sound/vehicles/modern/vehicle_turned_off.ogg'
    var/start_sound = 'sound/vehicles/modern/vehicle_start.ogg'
    var/failstart_sound = 'sound/vehicles/modern/vehicle_failing_to_start.ogg'
    break_message = "<span class = 'danger'>The car's engine whines like an injured animal and shuts down!</span>"

    var/list/xs = list(0, 1000, 2000, 3000, 4000, 5000, 5500, 6000)
    var/list/ys = list(0, 60,   70,   80,   90,   80,   70,   60)
    var/max_rpm = 6200

/obj/item/vehicle_part/engine/fail()
    ..()
    vehicle.active = FALSE
    needs_processing = FALSE

/obj/item/vehicle_part/engine/proc/start()
    if(prob(integrity))
        needs_processing = TRUE
        playsound(vehicle, start_sound, 150, 1, 5)
        spawn(15)
            playsound(vehicle, 'sound/vehicles/modern/zb_fb_idle.ogg', 30, 1, 5)
            rpm = RPM_IDLE - 1
    else
        playsound(vehicle, failstart_sound, 150, 1, 5)

/obj/item/vehicle_part/engine/proc/stop()
    needs_processing = FALSE
    playsound(vehicle, stop_sound, 150, 1, 5)
    rpm = 0

/obj/item/vehicle_part/engine/part_process()
    switch(rpm)
        if(1 to RPM_IDLE)
            playsound(vehicle, 'sound/vehicles/modern/zb_fb_idle.ogg', 100, 1, 5)
        if(RPM_IDLE to RPM_SLOW)
            playsound(vehicle, 'sound/vehicles/modern/zb_fb_slow.ogg', 100, 1, 5)
        if(RPM_SLOW to RPM_FAST)
            playsound(vehicle, 'sound/vehicles/modern/zb_fb_med.ogg', 100, 1, 5)
        if(RPM_FAST to INFINITY)
            playsound(vehicle, 'sound/vehicles/modern/zb_fb_fast.ogg', 100, 1, 5)