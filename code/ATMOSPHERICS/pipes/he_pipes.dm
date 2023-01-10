//
// Heat Exchanging Pipes - Behave like simple pipes
//
/obj/machinery/atmospherics/pipe/simple/heat_exchanging
	var/initialize_directions_he
	var/surface = 2	//surface area in m^2
	var/icon_temperature = T20C //stop small changes in temperature causing an icon refresh
//
// Heat Exchange Junction - Interfaces HE pipes to normal pipes
//
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction

