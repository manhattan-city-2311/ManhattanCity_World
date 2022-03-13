#define NEWSFILE "data/news.sav"	//where the memos are saved

/client/
	//var/last_news_hash = null // Stores a hash of the last news window it saw, which gets compared to the current one to see if it is different.

// Returns true if news was updated since last seen.
/client/proc/check_for_new_server_news()
	var/savefile/F = get_server_news()
	if(F)
		if(md5(F["body"]) != prefs.lastnews)
			return TRUE
	return FALSE

/client/proc/modify_server_news()
	set name = "Modify Public News"
	set category = "Server"

	if(!check_rights(0))
		return

	var/savefile/F = new(NEWSFILE)
	if(F)
		var/title = F["title"]
		var/body = html2paper_markup(F["body"])
		var/new_title = sanitize(input(src,"Write a good title for the news update.  Note: HTML is NOT supported.","Write News", title) as null|text, extra = 0)
		if(!new_title)
			return
		var/new_body = sanitize(input(src,"Write the body of the news update here. Note: HTML is NOT supported, however paper markup is supported.  \n\
		Hitting enter will automatically add a line break.  \n\
		Valid markup includes: \[b\], \[i\], \[u\], \[large\], \[h1\], \[h2\], \[h3\]\ \[*\], \[hr\], \[small\], \[list\], \[table\], \[grid\], \
		\[row\], \[cell\], \[logo\], \[sglogo\].","Write News", body) as null|message, extra = 0)

		new_body = paper_markup2html(new_body)

		if(findtext(new_body,"<script",1,0) ) // Is this needed with santize()?
			return
		F["title"] << new_title
		F["body"] << new_body
		F["author"] << key
		F["timestamp"] << time2text(world.realtime, "DDD, MMM DD YYYY")
		message_admins("[key] modified the news to read:<br>[new_title]<br>[new_body]")

/proc/get_server_news()
	var/savefile/F = new(NEWSFILE)
	if(F)
		return F
// This is used when submitting the news input, so the safe markup can get past sanitize.
/proc/paper_markup2html(var/text)
	text = replacetext_char(text, "\n", "<br>")
	text = replacetext_char(text, "\[center\]", "<center>")
	text = replacetext_char(text, "\[/center\]", "</center>")
	text = replacetext_char(text, "\[br\]", "<BR>")
	text = replacetext_char(text, "\[b\]", "<B>")
	text = replacetext_char(text, "\[/b\]", "</B>")
	text = replacetext_char(text, "\[i\]", "<I>")
	text = replacetext_char(text, "\[/i\]", "</I>")
	text = replacetext_char(text, "\[u\]", "<U>")
	text = replacetext_char(text, "\[/u\]", "</U>")
	text = replacetext_char(text, "\[large\]", "<font size=\"4\">")
	text = replacetext_char(text, "\[/large\]", "</font>")
	text = replacetext_char(text, "\[h1\]", "<H1>")
	text = replacetext_char(text, "\[/h1\]", "</H1>")
	text = replacetext_char(text, "\[h2\]", "<H2>")
	text = replacetext_char(text, "\[/h2\]", "</H2>")
	text = replacetext_char(text, "\[h3\]", "<H3>")
	text = replacetext_char(text, "\[/h3\]", "</H3>")

	text = replacetext_char(text, "\[*\]", "<li>")
	text = replacetext_char(text, "\[hr\]", "<HR>")
	text = replacetext_char(text, "\[small\]", "<font size = \"1\">")
	text = replacetext_char(text, "\[/small\]", "</font>")
	text = replacetext_char(text, "\[list\]", "<ul>")
	text = replacetext_char(text, "\[/list\]", "</ul>")
	text = replacetext_char(text, "\[table\]", "<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>")
	text = replacetext_char(text, "\[/table\]", "</td></tr></table>")
	text = replacetext_char(text, "\[grid\]", "<table>")
	text = replacetext_char(text, "\[/grid\]", "</td></tr></table>")
	text = replacetext_char(text, "\[row\]", "</td><tr>")
	text = replacetext_char(text, "\[cell\]", "<td>")
	text = replacetext_char(text, "\[logo\]", "<img src = ntlogo.png>") // Not sure if these would get used but why not
	text = replacetext_char(text, "\[sglogo\]", "<img src = sglogo.png>")
	return text

// This is used when reading text that went through paper_markup2html(), to reverse it so that edits don't need to replace everything once more to avoid sanitization.
/proc/html2paper_markup(var/text)
	text = replacetext_char(text, "<br>", "\[br\]")
	text = replacetext_char(text, "<center>", "\[center\]")
	text = replacetext_char(text, "</center>", "\[/center\]")
	text = replacetext_char(text, "<BR>", "\[br\]")
	text = replacetext_char(text, "<B>", "\[b\]")
	text = replacetext_char(text, "</B>", "\[/b\]")
	text = replacetext_char(text, "<I>", "\[i\]")
	text = replacetext_char(text, "</I>", "\[/i\]")
	text = replacetext_char(text, "<U>", "\[u\]")
	text = replacetext_char(text, "</U>", "\[/u\]")
	text = replacetext_char(text, "<font size=\"4\">", "\[large\]")
	text = replacetext_char(text, "</font>", "\[/large\]")
	text = replacetext_char(text, "<H1>", "\[h1\]")
	text = replacetext_char(text, "</H1>", "\[/h1\]")
	text = replacetext_char(text, "<H2>", "\[h2\]")
	text = replacetext_char(text, "</H2>", "\[/h2\]")
	text = replacetext_char(text, "<H3>", "\[h3\]")
	text = replacetext_char(text, "</H3>", "\[/h3\]")

	text = replacetext_char(text, "<li>", "\[*\]")
	text = replacetext_char(text, "<HR>", "\[hr\]")
	text = replacetext_char(text, "<font size = \"1\">", "\[small\]")
	text = replacetext_char(text, "</font>", "\[/small\]")
	text = replacetext_char(text, "<ul>", "\[list\]")
	text = replacetext_char(text, "</ul>", "\[/list\]")
	text = replacetext_char(text, "<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>", "\[table\]")
	text = replacetext_char(text, "</td></tr></table>", "\[/table\]")
	text = replacetext_char(text, "<table>", "\[grid\]")
	text = replacetext_char(text, "</td></tr></table>", "\[/grid\]")
	text = replacetext_char(text, "</td><tr>", "\[row\]")
	text = replacetext_char(text, "<td>", "\[cell\]")
	text = replacetext_char(text, "<img src = ntlogo.png>", "\[logo\]") // Not sure if these would get used but why not
	text = replacetext_char(text, "<img src = sglogo.png>", "\[sglogo\]")
	return text

#undef NEWSFILE