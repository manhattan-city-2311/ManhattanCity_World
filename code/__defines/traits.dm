/// Quirk names defines. To ease keeping track.
// positive quirks.
#define QUIRK_ADRENALINE "Адреналиновая Перегрузка"
#define QUIRK_ATHLETE "Атлет"
#define QUIRK_NIGHTVISION "Кошачьи глаза"
#define QUIRK_REGENERATION_FAST "Быстрая регенерация"
#define QUIRK_BUFF "Накачанный"
#define QUIRK_MULTITASKING "Многозадачность"
#define QUIRK_STRONG_MIND "Психологическая Устойчивость"
#define QUIRK_ALCOHOL_TOLERANCE "Трезвенник"
#define QUIRK_FREERUNNING "Ловкий"
#define QUIRK_LIGHT_STEP "Аккуратная Ходьба"
#define QUIRK_FAST_EQUIP "Улучшенная Координация"

// neutral quirks.
#define QUIRK_HIGH_PAIN_THRESHOLD "Высокий Болевой Порог"
#define QUIRK_LOW_PAIN_THRESHOLD "Низкий Болевой Порог"
#define QUIRK_DALTONISM "Дальтонизм"

// negative quirks.
#define QUIRK_ASTHTMATIC "Астматик"
#define QUIRK_HEARTPROBLEM "Сердечник"
#define QUIRK_HEARTFAILURE "Инвалид-Сердечник"
#define QUIRK_TRANSPLANT "Не свой орган"
#define QUIRK_BLIND "Слепота"
#define QUIRK_COUGHING "Кашель"
#define QUIRK_DEAF "Глухота"
#define QUIRK_SEIZURES "Эпилепсия"
#define QUIRK_FATNESS "Полнота"
#define QUIRK_TOURETTE "Синдром Туретта"
#define QUIRK_NEARSIGHTED "Близорукость"
#define QUIRK_NERVOUS "Нервозность"
#define QUIRK_STRESS_EATER "Компульсивное Переедание"
#define QUIRK_MUTE "Немота"
#define QUIRK_LIGHT_DRINKER "Алкоголик"
#define QUIRK_SMOKING "Курящий"
#define QUIRK_NYCTOPHOBIA "Никтофобия"
#define QUIRK_GENETIC_DEGRADATION "Генетическое Повреждение"

// idk why this exists on TG
#define GENERIC_TRAIT "generic"
// common trait sources
#define ROUNDSTART_TRAIT   "roundstart" //cannot be removed without admin intervention
#define QUALITY_TRAIT      "quality"
#define TWOHANDED_TRAIT    "twohanded"
#define RELIGION_TRAIT     "religion"

#define SIGNAL_ADDTRAIT(trait_ref) "addtrait [trait_ref]"
#define SIGNAL_REMOVETRAIT(trait_ref) "removetrait [trait_ref]"

// trait accessor defines
#define ADD_TRAIT(target, trait, source) \
	do { \
		var/list/_L; \
		if (!target.status_traits) { \
			target.status_traits = list(); \
			_L = target.status_traits; \
			_L[trait] = list(source); \
			SEND_SIGNAL(target, SIGNAL_ADDTRAIT(trait), trait); \
		} else { \
			_L = target.status_traits; \
			if (_L[trait]) { \
				_L[trait] |= list(source); \
			} else { \
				_L[trait] = list(source); \
				SEND_SIGNAL(target, SIGNAL_ADDTRAIT(trait), trait); \
			} \
		} \
	} while (0)
#define REMOVE_TRAIT(target, trait, sources) \
	do { \
		var/list/_L = target.status_traits; \
		var/list/_S; \
		if (sources && !islist(sources)) { \
			_S = list(sources); \
		} else { \
			_S = sources\
		}; \
		if (_L && _L[trait]) { \
			for (var/_T in _L[trait]) { \
				if ((!_S && (_T != ROUNDSTART_TRAIT)) || (_T in _S)) { \
					_L[trait] -= _T \
				} \
			};\
			if (!length(_L[trait])) { \
				_L -= trait; \
				SEND_SIGNAL(target, SIGNAL_REMOVETRAIT(trait), trait); \
			}; \
			if (!length(_L)) { \
				target.status_traits = null \
			}; \
		} \
	} while (0)
#define REMOVE_TRAIT_NOT_FROM(target, trait, sources) \
	do { \
		var/list/_traits_list = target.status_traits; \
		var/list/_sources_list; \
		if (sources && !islist(sources)) { \
			_sources_list = list(sources); \
		} else { \
			_sources_list = sources\
		}; \
		if (_traits_list && _traits_list[trait]) { \
			for (var/_trait_source in _traits_list[trait]) { \
				if (!(_trait_source in _sources_list)) { \
					_traits_list[trait] -= _trait_source \
				} \
			};\
			if (!length(_traits_list[trait])) { \
				_traits_list -= trait; \
				SEND_SIGNAL(target, SIGNAL_REMOVETRAIT(trait), trait); \
			}; \
			if (!length(_traits_list)) { \
				target.status_traits = null \
			}; \
		} \
	} while (0)
#define REMOVE_TRAITS_NOT_IN(target, sources) \
	do { \
		var/list/_L = target.status_traits; \
		var/list/_S = sources; \
		if (_L) { \
			for (var/_T in _L) { \
				_L[_T] &= _S;\
				if (!length(_L[_T])) { \
					_L -= _T; \
					SEND_SIGNAL(target, SIGNAL_REMOVETRAIT(_T), _T); \
					}; \
				};\
			if (!length(_L)) { \
				target.status_traits = null\
			};\
		}\
	} while (0)

#define REMOVE_TRAITS_IN(target, sources) \
	do { \
		var/list/_L = target.status_traits; \
		var/list/_S = sources; \
		if (sources && !islist(sources)) { \
			_S = list(sources); \
		} else { \
			_S = sources\
		}; \
		if (_L) { \
			for (var/_T in _L) { \
				_L[_T] -= _S;\
				if (!length(_L[_T])) { \
					_L -= _T; \
					SEND_SIGNAL(target, SIGNAL_REMOVETRAIT(_T)); \
					}; \
				};\
			if (!length(_L)) { \
				target.status_traits = null\
			};\
		}\
	} while (0)

#define HAS_TRAIT(target, trait) (target.status_traits ? (target.status_traits[trait] ? TRUE : FALSE) : FALSE)
#define HAS_TRAIT_FROM(target, trait, source) (target.status_traits ? (target.status_traits[trait] ? (source in target.status_traits[trait]) : FALSE) : FALSE)
#define HAS_TRAIT_FROM_ONLY(target, trait, source) (\
	target.status_traits ?\
		(target.status_traits[trait] ?\
			((source in target.status_traits[trait]) && (length(target.status_traits) == 1))\
			: FALSE)\
		: FALSE)
#define HAS_TRAIT_NOT_FROM(target, trait, source) (target.status_traits ? (target.status_traits[trait] ? (length(target.status_traits[trait] - source) > 0) : FALSE)

#define TRAIT_ALCOHOL_TOLERANCE   "alcohol_tolerance"
#define TRAIT_BLIND               "blind"
#define TRAIT_COUGH               "cough"
#define TRAIT_DEAF                "deaf"
#define TRAIT_EPILEPSY            "epilepsy"
#define TRAIT_FAT                 "fatness"
#define TRAIT_HIGH_PAIN_THRESHOLD "high_pain_threshold"
#define TRAIT_LIGHT_DRINKER       "light_drinker"
#define TRAIT_LOW_PAIN_THRESHOLD  "low_pain_threshold"
#define TRAIT_TOURETTE            "tourette"
#define TRAIT_NEARSIGHT           "nearsighted"
#define TRAIT_NERVOUS             "nervous"
#define TRAIT_STRESS_EATER        "stresseater"
#define TRAIT_MULTITASKING        "multitasking"
#define TRAIT_NATURECHILD         "child_of_nature"
#define TRAIT_MUTE                "mute"
#define TRAIT_STRONGMIND          "strong_mind"
#define TRAIT_AV                  "artifical_ventilation"
#define TRAIT_CPB                 "cardiopulmonary_bypass"
#define TRAIT_LIGHT_STEP          "light_step"
#define TRAIT_FREERUNNING         "freerunning"
#define TRAIT_AGEUSIA             "ageusia"
#define TRAIT_DALTONISM           "daltonism"
#define TRAIT_COOLED              "external_cooling_device"
#define TRAIT_NO_RUN              "no_run"
#define TRAIT_FAST_EQUIP          "fast_equip"
#define TRAIT_NO_CLONE            "no_clone"
#define TRAIT_VACCINATED          "vaccinated"
#define TRAIT_DWARF               "dwarf"
#define TRAIT_NO_SOUL             "no_soul"
#define TRAIT_SEE_GHOSTS          "see_ghosts"
#define TRAIT_SYRINGE_FEAR        "syringe_fear"
#define TRAIT_WET_HANDS           "wet_hands"
#define TRAIT_GREASY_FINGERS      "greasy_fingers"
#define TRAIT_ANATOMIST           "anatomist"
#define TRAIT_SOULSTONE_IMMUNE    "soulstone_immune"


// self explanatory
#define BEAUTY_ELEMENT_TRAIT "beauty_element"
#define MOOD_COMPONENT_TRAIT "mood_component"
#define SPAWN_AREA_TRAIT "spawn_area_trait"
// medical stuff I guess
#define OBESITY_TRAIT      "obesity"
#define LIFE_ASSIST_MACHINES_TRAIT            "life_assist_machines"
#define FEAR_TRAIT         "fear"