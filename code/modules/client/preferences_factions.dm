var/global/list/seen_citizenships = list()
var/global/list/seen_systems = list()
var/global/list/seen_factions = list()
var/global/list/seen_antag_factions = list()
var/global/list/seen_religions = list()

//Commenting this out for now until I work the lists it into the event generator/journalist/chaplain.
/proc/UpdateFactionList(mob/living/carbon/human/M)
	/*if(M && M.client && M.client.prefs)
		seen_citizenships |= M.client.prefs.citizenship
		seen_systems      |= M.client.prefs.home_system
		seen_factions     |= M.client.prefs.faction
		seen_religions    |= M.client.prefs.religion*/
	return

var/global/list/citizenship_choices = list(
	"Mars",
	"Earth",
	"Luna",
	"Venus",
	"Ceres",
	"Pluto",
	"Tau Ceti",
	"Helios",
	"Terra",
	"Lorriman",
	"Cinu",
	"Yuklid",
	"Lordania",
	"Kingston",
	"Gaia",
	"Magnitka"
	)

var/global/list/home_system_choices = list(
	"Mars",
	"Earth",
	"Luna",
	"Venus",
	"Ceres",
	"Pluto",
	"Tau Ceti",
	"Helios",
	"Terra",
	"Lorriman",
	"Cinu",
	"Yuklid",
	"Lordania",
	"Kingston",
	"Gaia",
	"Magnitka"
	)

var/global/list/faction_choices = list(
	"Sol Central Government",
	"SCG Fleet",
	"SCG Army",
	"The Expeditionary Corps Organisation",
	"The Independent Colonial Confederation of Gilgamesh",
	"The Expeditionary Corps",
	"The Sol Federal",
	"The NanoTrasen Corporation",
	"Xynergy",
	"Hephaestus Industries",
	"The Free Trade Union",
	"Proxima Centauri Risk Control",
	"Strategic Assault and Asset Retention Enterprises",
	"Deimos Advanced Information Systems",
	"Other"
	)

var/global/list/antag_faction_choices = list(	//Should be populated after brainstorming. Leaving as blank in case brainstorming does not occur.
	"Worker's Union",
	"Blue Moon Cartel",
	"Trust Fund",
	"Quercus Coalition",
	"House of Joshua",
	"Sol Union"
	)

var/global/list/antag_visiblity_choices = list(
	"Hidden",
	"Shared",
	"Known"
	)

var/global/list/religion_choices = list(
	"Unitarianism",
	"Hinduism",
	"Buddhist",
	"Islam",
	"Christianity",
	"Agnosticism",
	"Deism"
	)