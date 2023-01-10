
#define isdatum(D)		istype(D, /datum)
#define isweakref(A)	istype(A, /weakref)

//#define islist(D)		istype(D, /list)

//---------------
#define isatom(D)		istype(D, /atom)

//---------------
//#define isobj(D)		istype(D, /obj)		//Built in
#define isitem(D)		istype(D, /obj/item)

#define isairlock(A)	istype(A, /obj/machinery/door/airlock)

#define isorgan(A)		istype(A, /obj/item/organ/external)

#define iscomponent(C) istype(C, /obj/item/vehicle_part)
#define iscash(B) istype(B, /obj/item/weapon/spacecash)
#define isdebit(C) istype(C, /obj/item/weapon/card/debit)
#define isopenspace(A)	istype(A, /turf/simulated/open)
