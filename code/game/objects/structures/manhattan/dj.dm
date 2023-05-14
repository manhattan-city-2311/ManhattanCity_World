/obj/structure/manhattan/dj
    name = "dj station"
    icon = 'icons/obj/dj.dmi'
    icon_state = "dj"
    anchored = TRUE

/obj/structure/manhattan/dj/update_icon()
    overlays.Cut()
    
    overlays += emissive_appearance(icon, "dj-emissive")
    
/obj/structure/manhattan/dj/initialize()
    update_icon()