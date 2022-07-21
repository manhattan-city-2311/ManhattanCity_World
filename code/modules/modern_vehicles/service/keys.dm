/obj/item/car_key
    name = "car key"
    desc = "A key for some kind of car."
    var/serial_number
    var/obj/manhattan/vehicle/vehicle = null

/obj/item/car_key/initialize()
    for(var/obj/manhattan/vehicle/new_vehicle in range(3, src))
        vehicle = new_vehicle
        break
    serial_number = vehicle.serial_number
    desc += " This one seems to belong to [vehicle]. It's serial number is [serial_number]"