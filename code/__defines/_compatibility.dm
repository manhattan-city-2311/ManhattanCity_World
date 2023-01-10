#if DM_VERSION < 515
#define CALL_EXT call
#define ceil(number) (-round(-(number)))
#define fract(number) ((number) - trunc(number))
#define isnan(number) (isnum(number) && ((number) != (number)))
#define isinf(number) ((number) == 1#INF || (number) == -1#INF)

/proc/floor(number)
	return round(number)

/proc/trunc(number)
	if (number < 0)
		return ceil(number)
	return round(number)

/proc/trimtext(text)
	var/static/regex/pattern = regex(@"^\s*(.*?)\s*$", "g")
	return replacetext_char(text, pattern, "$1")

/proc/ftime()
	throw EXCEPTION("ftime not available below 515")

/proc/get_steps_to()
	throw EXCEPTION("get_steps_to not available below 515")
	
/client/proc/RenderIcon(atom)
	throw EXCEPTION("client::RenderIcon() is not available below 515")

/proc/ispointer()
	throw EXCEPTION("ispointer not available below 515")

/proc/nameof(thing)
	throw EXCEPTION("nameof not available below 515")

/proc/noise_hash()
	throw EXCEPTION("noise_hash not available below 515")

/proc/refcount(datum)
	throw EXCEPTION("refcount not available below 515")
#define PROC_REF(X) (.proc/##X)
#define TYPE_PROC_REF(TYPE, X) (##TYPE.proc/##X)
#define GLOBAL_PROC_REF(X) (.proc/##X)
#define NAMEOF_STATIC(datum, X) (#X || ##datum.##X)
#else
#define PROC_REF(X) (nameof(.proc/##X))
#define TYPE_PROC_REF(TYPE, X) (nameof(##TYPE.proc/##X))
#define GLOBAL_PROC_REF(X) (/proc/##X)
#define NAMEOF_STATIC(datum, X) (#X || type::##X)
#define CALL_EXT call_ext
#endif
