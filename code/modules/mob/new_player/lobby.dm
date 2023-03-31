/mob/new_player/proc/get_lobby_html()
	. = {"
	<html>
		<head>
			<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			<style type='text/css'>
				@font-face {
					font-family: "Fixedsys";
					src: url("FixedsysExcelsior3.01Regular.ttf");
				}
				body, html {
					margin: 0;
					overflow: hidden;
					text-align: center;
					background-color: black;
					-ms-user-select: none;
				}
				img {
					display: inline-block;
					width: auto;
					height: 100%;
					-ms-interpolation-mode: nearest-neighbor
				}
				.lobby_image
				{
					position: absolute;
					width: auto;
					height: 100vmin;
					min-width: 100vmin;
					min-height: 100vmin;
					top: 50%;
					left:50%;
					transform: translate(-50%, -50%);
					z-index: 0;
				}
				.lobby_decor
				{
					z-index: 1;
				}
				.container_nav {
					position: absolute;
					width: auto;
					min-width: 100vmin;
					min-height: 50vmin;
					margin-left: 10vmin;
					margin-top: 50.75vmin	;
					box-sizing: border-box;
					top: 50%;
					left: 50%;
					transform: translate(-50%, -50%);
					z-index: 3;
				}
				.menu_a {
					display: inline-block;
					font-family: "Fixedsys";
					font-weight: lighter;
					text-decoration: none;
					width: 40%;
					text-align: left;
					color:white;
					margin-right: 100%;
					margin-top: 8px;
					padding-left: 6px;
					font-size: 4vmin;
					line-height: 4vmin;
					height: 3.5vmin;
					letter-spacing: 1px;
					text-shadow: 2px 2px 0px #000000;
				}
				.menu_a:hover {
					color: #aaffff;
					/*border-left: 3px solid #00ffff;*/
					text-shadow: 0 0 6px #00ffff;
					/* font-weight: bolder; */
					/* padding-left: 3px;*/
					/* transition: 0.25s linear border-left, 0.1s linear color, 0.25s linear font-weight; */
				}
				.data_output
				{
					z-index: 3;
					font-family: "Fixedsys";
					color: #ff93d7;
					position: absolute;
					letter-spacing: 1px;
					font-size: 2.5vmin;
					margin: 0;
				}
				.admin
				{
					color: #ffaaaa;
					text-shadow: 0 0 10px #ff0000;
					width: 15vmin;
				}
				.admin:hover
				{
					text-shadow: none;
				}

				.container_nav .data_output
				{
					top: 30%;
				}
				#time
				{
					top: 135.7%;
					left: 83.7%;
					transform: scale(0.8,1);
					transform-origin: left;
				}
				#charactername
				{
					top: 72%;
					left: 7.8%;
					transform: scale(0.8,1);
					transform-origin: left;
				}
			</style>
		</head>
		<body>
	"}

	. += {"<img src="titlescreen.gif" class="lobby_image background" alt="">"}
	. += "<img src='menu_cyberui.png' class='lobby_image lobby_decor' alt=''>"
	. += "<div class='container_nav' style='margin-top: 2vmin; margin-left: 0vmin;'>"
	. += {"<span class = "data_output" id = "time">[stationdate2text()]</span>
	<span class = "data_output" id = "charactername">"}
	if(client?.prefs?.real_name)
		. += client.prefs.real_name
	else
		. += "Unknown"
	. += {"</span></div>"}
	. += {"
		<div class="container_nav">
		<a class="menu_a" href='?src=\ref[src];lobby_setup=1'>CHARACTERS</a>
	"}
	if(ticker.current_state <= GAME_STATE_SETTING_UP || !client?.prefs?.persistence_z)
		. += {"<a id="ready" class="menu_a" href='?src=\ref[src];lobby_ready=1'>READY [ready ? " <font color='#00ff00'>☑</font>" : "<font color='#ff0000'>☒</font>"]</a>"}
	else
		. += {"<a id = "enter" class="menu_a" href='?src=\ref[src];lobby_join=1'>RETURN TO MANHATTAN</a>"}

	. += "</div>"
	if(config.observers_allowed || (client.holder && client.holder.rights & R_ADMIN))
		. += {"
		<div class='container_nav' style='margin-top: 63vmin;'>
			<a class='menu_a admin' href='?src=\ref[src];observe=1'>
				OBSERVE
			</a>
		</div>"}
	. += {"
	<script language="JavaScript">
		var ready = [ready];
		var mark = document.getElementById("ready");
		var charname = document.getElementById("charactername");
		var marks = new Array("<font color='#ff0000'>☒</font>", "<font color='#00ff00'>☑</font>");
		function imgsrc(setReady)
		{
			if(mark)
			{
				ready = setReady;
				mark.innerHTML = "READY " + marks\[ready];
			}
		}
		function change_cname(name)
		{
			if(charname)
				charname.innerHTML = name;
		}
	</script>
	"}
	. += "</body></html>"
