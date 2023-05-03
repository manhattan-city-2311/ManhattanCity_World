#define CLAMP01(x) clamp(x, 0, 1)

#define span(class, text) ("<span class='[class]'>[text]</span>")

#define get_turf(A) get_step(A,0)

#define get_x(A) (get_step(A, 0)?.x || 0)

#define get_y(A) (get_step(A, 0)?.y || 0)

#define get_z(A) (get_step(A, 0)?.z || 0)

#define isAI(A) istype(A, /mob/living/silicon/ai)

#define isalien(A) istype(A, /mob/living/carbon/alien)

#define isanimal(A) istype(A, /mob/living/simple_mob)

#define isbrain(A) istype(A, /mob/living/carbon/brain)

#define iscarbon(A) istype(A, /mob/living/carbon)

#define iscorgi(A) istype(A, /mob/living/simple_mob/animal/passive/dog/corgi)

#define isEye(A) istype(A, /mob/observer/eye)

#define ishuman(A) istype(A, /mob/living/carbon/human)

#define isliving(A) istype(A, /mob/living)

#define ismouse(A) istype(A, /mob/living/simple_mob/animal/passive/mouse)

#define isnewplayer(A) istype(A, /mob/new_player)

#define isobserver(A) istype(A, /mob/observer/dead)

#define ispAI(A) istype(A, /mob/living/silicon/pai)

#define isrobot(A) istype(A, /mob/living/silicon/robot)

#define issilicon(A) istype(A, /mob/living/silicon)

#define isvoice(A) istype(A, /mob/living/voice)

#define isslime(A) istype(A, /mob/living/simple_mob/slime)

#define isunderwear(A) istype(A, /obj/item/underwear)

#define isbot(A) istype(A, /mob/living/bot)

#define isxeno(A) istype(A, /mob/living/simple_mob/animal/space/alien)

#define ismaterial(A) istype(A, /material)

#define sequential_id(key) uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, key)

#define random_id(key,min_id,max_id) uniqueness_repository.Generate(/datum/uniqueness_generator/id_random, key, min_id, max_id)

#define MAP_IMAGE_PATH "nano/images/[using_map.path]/"

#define map_image_file_name(z_level) "[using_map.path]-[z_level].png"

#define RANDOM_BLOOD_TYPE pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

#define isclient(A) istype(A, /client)

/// General I/O helpers
#define to_target(target, payload)            target << (payload)
#define from_target(target, receiver)         target >> (receiver)

/// Common use
#define legacy_chat(target, message)          to_target(target, message)
#define to_world(message)                     to_chat(world, message)
#define to_world_log(message)                 to_target(world.log, message)
#define sound_to(target, sound)               to_target(target, sound)
#define image_to(target, image)               to_target(target, image)
#define show_browser(target, content, title)  to_target(target, browse(content, title))
#define close_browser(target, title)          to_target(target, browse(null, title))
#define send_rsc(target, content, title)      to_target(target, browse_rsc(content, title))
#define send_link(target, url)                to_target(target, link(url))
#define send_output(target, msg, control)     to_target(target, output(msg, control))
#define to_file(handle, value)                to_target(handle, value)
#define to_save(savefile, var)		      to_target(savefile[#var], var)
#define from_save(savefile, var)	      from_target(savefile[#var], var)
// TODO - Baystation has this log to crazy places. For now lets just world.log, but maybe look into it later.
#define log_world(message) world.log << message
#define from_file(file_entry, target_var) file_entry >> target_var

// From TG, might be useful to have.
// Didn't port SEND_TEXT() since to_chat() appears to serve the same purpose.
#define DIRECT_OUTPUT(A, B) A << B
#define SEND_IMAGE(target, image) DIRECT_OUTPUT(target, image)
#define SEND_SOUND(target, sound) DIRECT_OUTPUT(target, sound)

#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define CanInteractWith(user, target, state) (target.CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define QDEL_LIST(x) if(x) { for(var/y in x) { qdel(y) }}
#define QDEL_NULL_LIST(x) QDEL_LIST(x) ; x = null

#define QDEL_NULL(x) if(x) { qdel(x) ; x = null }

#define DEBUG_ARGS(x) log_debug("[__FILE__] - [__LINE__] [x]") ; for(var/arg in args) { log_debug("\t[log_info_line(arg)]") }
#define DEBUG_LIST(x) log_debug("[__FILE__] - [__LINE__] [#x]") ; for(var/arg in (x)) { log_debug("\t[log_info_line(arg)] = [log_info_line(x[arg]) || "null"]") }
#define DEBUG_VAR(x) log_debug("[__FILE__] - [__LINE__] [#x] = [log_info_line(x) || "null"]")

#define show_image(target, image) target << image

#define SPAN(class, X) "<span class='" + ##class + "'>" + ##X + "</span>"

#define SPAN_PLEASURE(X) "<span class='pleasure'>[X]</span>"
#define SPAN_INFO(X) SPAN("info", X)
#define SPAN_SUBTLE(X) SPAN("subtle", X)
#define SPAN_NOTICE(X) SPAN("notice", X)
#define SPAN_WARNING(X) SPAN("warning", X)
#define SPAN_DANGER(X) SPAN("danger", X)
#define SPAN_OCCULT(X) SPAN("cult", X)

#define SPAN_STYLE(style, X) "<span style='" + style + "'>" + ##X + "</span>"

#define SPAN_SMALL(X) SPAN_STYLE("font-size:small", X)
#define SPAN_LARGE(X) SPAN_STYLE("font-size:large", X)
#define SPAN_XXLARGE(X) SPAN_STYLE("font-size:xx-large", X)

#define isvehicle(X) istype(X, /obj/manhattan/vehicle)

#define ishormone(G, T) (G == #T)

#define LAZYACCESS0(L, I) (L ? (isnum(I) ? (I > 0 && I <= L.len ? L[I] : 0) : L[I]) : 0)

proc/n_repeat(string, amount)
	if(istext(string) && isnum(amount))
		var/i
		var/newstring = ""
		if(length(newstring)*amount >=1000)
			return
		for(i=0, i<=amount, i++)
			if(i>=1000)
				break
			newstring = newstring + string

		return newstring

#define VIEW_SIZE_X 19
#define VIEW_SIZE_Y 15
#define VIEW_SIZE_MEAN 17
#define VIEW_RADIUS 7
#define VIEW_SIZE "19x15"
