#define WHEEL_PRESSURE_MINIMUM 10
#define WHEEL_PRESSURE_OPTIMAL 40
#define WHEEL_PRESSURE_MAXIMUM 50

#define VC_RIGHT_FRONT_WHEEL "rfrontwheel"
#define VC_RIGHT_BACK_WHEEL "rbackwheel"
#define VC_LEFT_FRONT_WHEEL "lfrontwheel"
#define VC_LEFT_BACK_WHEEL "lbackwheel"

/obj/item/vehicle_part/wheel
	name = "car wheel"
	icon_state = "wheel"
	armor = 35
	var/pressure  = WHEEL_PRESSURE_OPTIMAL
	break_sound = 'sound/vehicles/modern/tire_explode.ogg'
	break_message = "<span class = 'danger'>A tire pops!</span>"

/obj/item/vehicle_part/wheel/initialize()
	pressure += rand(-5, 5)

/obj/item/vehicle_part/wheel/proc/handle_pressure(var/strength)
	if(pressure < WHEEL_PRESSURE_MINIMUM)
		return
	var/delta_damage = clamp(strength, 0, pressure)
	pressure -= delta_damage

// N
/obj/item/vehicle_part/wheel/proc/get_traction()
	return ((WHEEL_PRESSURE_MAXIMUM + 5) - pressure)

/obj/item/vehicle_part/wheel/part_process()
	if(vehicle.speed.modulus() > TO_MPS(70))
		handle_damage(1)
	switch(integrity)
		if(75 to 90)
			if(prob(5))
				handle_pressure(1)
		if(1 to 74)
			if(prob(10))
				handle_pressure(2)
