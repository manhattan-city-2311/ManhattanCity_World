/obj/item/vehicle_module
    name = "vehicle module"
    desc = "You shouldn't see this"
    icon_state = "module"
    var/default_icon_state
    var/busted_icon_state = "destroyed"
    var/smoke_icon_state = "smoke"
    var/obj/manhattan/vehicles/vehicle //Референс на машину
    var/integrity = 100 //Прочность
    var/active = FALSE
    var/failed = FALSE
    var/temperature = 21 //Температура детали в градусах
    var/heat_cap = 0 //Тепловая устойчивость в градусах. 0 - неуязвимость к теплу.

    var/fail_message = "The module fails catastrophically and explodes!"

/obj/item/vehicle_module/New()
    . = ..()
    default_icon_state = icon_state

/obj/item/vehicle_module/heating
    //Генерирует тепло
    var/heat_generation = 50 //Генерация тепла. Джоули в тик.

/obj/item/vehicle_module/cooling
    //Рассеивает тепло
    var/heat_dissipation = 50 //Рассеивание тепла. Джоули в тик.


/obj/item/vehicle_module/proc/tick()
    if(!integrity >= 0)
        if(!failed)
            fail()
        return
    if(temperature > heat_cap)
        integrity -= 1
    var/thermal_effect_cap = heat_cap * 0.5
    if(temperature > thermal_effect_cap) //Косметические эффекты дыма и огня
        icon_state = smoke_icon_state
    else
        icon_state = default_icon_state

/obj/item/vehicle_module/proc/fail()
    src.visible_message("<span class = 'warning'>[fail_message]</span>")
    icon_state = busted_icon_state
    active = FALSE
    failed = TRUE

    