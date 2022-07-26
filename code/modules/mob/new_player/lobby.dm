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
				.container_nav {
					position: absolute;
					width: auto;
					min-width: 100vmin;
					min-height: 50vmin;
					padding-left: 10vmin;
					padding-top: 60vmin;
					box-sizing: border-box;
					top: 50%;
					left:50%;
					transform: translate(-50%, -50%);
					z-index: 1;
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
					height: 4vmin;
					letter-spacing: 1px;
					text-shadow: 2px 2px 0px #000000;
				}
				.menu_a:hover {
					color: #aaffff;
					/*border-left: 3px solid #00ffff;*/
					text-shadow: 0 0 6px #00ffff;
					/* font-weight: bolder; */
					padding-left: 3px;
					/* transition: 0.25s linear border-left, 0.1s linear color, 0.25s linear font-weight; */
				}
			</style>
		</head>
		<body>
	"}

	. += {"<img src="titlescreen.gif" class="lobby_image background" alt="">"}
	. += "<img src='menu_cyberui.png' class='lobby_image' alt=''>"
	. += {"
		<div class="container_nav">
		<a class="menu_a" href='?src=\ref[src];lobby_setup=1'>CHARACTERS</a>
	"}
	if(ticker.current_state <= GAME_STATE_SETTING_UP)
		. += {"<a id="ready" class="menu_a" href='?src=\ref[src];lobby_ready=1'>READY [ready ? " <font color='#00ff00'>☑</font>" : "<font color='#ff0000'>☒</font>"]</a>"}
	else
		. += {"<a id = "enter" class="menu_a" href='?src=\ref[src];lobby_join=1'>ENTER MANHATTAN</a>"}

	. += "</div>"

	. += {"
	<script language="JavaScript">
		var ready = [ready];
		var mark = document.getElementById("ready");
		var marks = new Array("<font color='#ff0000'>☒</font>", "<font color='#00ff00'>☑</font>");
		function imgsrc(setReady)
		{
			if(!isNaN(setReady)) ready = setReady;
			if(mark)
			{
				ready = setReady;
				mark.innerHTML = "READY " + marks\[ready];
			}
		}
	</script>
	"}
	. += "</body></html>"