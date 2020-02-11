
/client/proc/cmd_admin_playeropt(mob/M as mob in world)
	set name = "Player Options"
	set category = null
	if (src.holder)
		src.holder.playeropt(M)
	return

/datum/admins/proc/playeropt(mob/M)
	if (!ismob(M))
		alert("Unable to auto-refresh the panel. Manual refresh required.")
		return

	if (istype(M, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = M
		if (AI.deployed_to_eyecam)
			M = AI.eyecam

	var/dat = "<title>Options for [M.key] ([M.job])</title>"
	dat += {"<style>
				a {text-decoration:none}
				.optionGroup {padding:5px; margin-bottom:8px; border:1px solid black}
				.optionGroup .title {display:block; color:white; background:black; padding: 2px 5px; margin: -5px -5px 2px -5px}
			</style>"}

	//Antag roles (yes i said antag jeez shut up about it already)
	var/antag
	if (M.mind && M.mind.special_role != null)
		antag += "\[<a href='?src=\ref[src];action=traitor;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'><span style='color:red;text-transform:uppercase'>[M.mind.special_role]</span></a>\]"
		antag += "\[<a href='?src=\ref[src];action=remove_traitor;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'><span style='color:red;text-transform:uppercase'>Remove Traitor</span></a>\]"
	else if (!isobserver(M))
		antag += "\[<a href='?src=\ref[src];action=traitor;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Make Traitor</a>\]"

	dat += "<a href='?src=\ref[src];action=refreshoptions;targetckey=[M.ckey];targetmob=\ref[M];' style='position:absolute;top:5px;right:5px'>R</a>"

	//General info
	dat += "<div style='margin-bottom:8px;padding-right:7px'>"
	if(!istype(M, /mob/new_player))
		dat += {"Options for <b>[M.name]</b> played by <b>[M.key]</b> \[<a href='?src=\ref[src];action=view_logs;type=all_logs_string;presearch=[M.key];origin=adminplayeropts'>LOGS</a>\]
				[M.client ? "" : " <i>(logged out) </i>"]
				[isdead(M) ? "<b><font color=red>(DEAD)</font></b>" : ""]
				<br>Mob Type: <b>[M.type]</b> [antag]"}
	else
		dat += "<b>Hasn't Entered Game</b>"
	dat += "</div>"

	//Common options
	dat += "<div class='optionGroup' style='border-color:#AEC6CF'><b class='title' style='background:#AEC6CF'>Common</b>"
	if (M.client)
		dat += {"<a href='?action=priv_msg&target=[M.ckey];origin=adminplayeropts'>PM</a> |
				<a href='?src=\ref[src];action=subtlemsg;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Subtle PM</a> |
				<a href='?src=\ref[src];action=plainmsg;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Plain Message</a> |
				<a href='?src=\ref[src];action=adminalert;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Alert</a>"}
	if (!istype(M, /mob/new_player))
		//Wire: Hey I wonder if I can put a short syntax condition with a multi-line text result inside a multi-line text string
		//Turns out yes but good lord does it break dream maker syntax highlighting
		//dat += {"[M.client ? " | " : ""][ishuman(M) ? {"<br>Reagents: \[
		dat += {"[isobserver(M) ? "" : {"<br><b>Health</b>: \[
					<a href='?src=\ref[src];action=checkhealth;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Check</a> |
					<a href='?src=\ref[src];action=revive;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Heal</a>
				\] | "}]
				[ishuman(M) ? {"<b>Reagents</b><A href='?src=\ref[src];action=secretsfun;type=reagent_help'>*</a>: \[
					<a href='?src=\ref[src];action=checkreagent;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Check</a> |
					<a href='?src=\ref[src];action=addreagent;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Add</a> |
					<a href='?src=\ref[src];action=removereagent;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Remove</a>
					\] |
					<b>Bioeffect</b><a href='?src=\ref[src];action=secretsfun;type=bioeffect_help'>*</a>: \[
					<a href='?src=\ref[src];action=addbioeffect;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Add</a> |
					<a href='?src=\ref[src];action=removebioeffect;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Remove</a>
					\] | "} : ""]
				[isliving(M) ? "<a href='?src=\ref[src];action=removehandcuff;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Unhandcuff</a> | " : ""]
				<b>Contents</b>: \[
			 		<a href='?src=\ref[src];action=checkcontents;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Check</a> |
			 		<a href='?src=\ref[src];action=dropcontents;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Drop</a>
				\]
				<br><b>Gib</b>: \[
					<a href='?src=\ref[src];action=gib;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Normal</a> |
					<a href='?src=\ref[src];action=partygib;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Party</a> |
					<a href='?src=\ref[src];action=owlgib;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Owl</a> |
					<a href='?src=\ref[src];action=firegib;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Fire</a> |
					<a href='?src=\ref[src];action=elecgib;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Elec</a> |
					<a href='?src=\ref[src];action=sharkgib;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Shark</a> |
					<a href='?src=\ref[src];action=icegib;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Ice</a> |
					<a href='?src=\ref[src];action=goldgib;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Gold</a> |
					<a href='?src=\ref[src];action=spidergib;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Spider</a> |
					<a href='?src=\ref[src];action=cluwnegib;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Cluwne</a> |
					<a href='?src=\ref[src];action=tysongib;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Tyson</a> |
					<a href='?src=\ref[src];action=damn;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>(Un)Damn</a>
				\] |
				<b>Abilities</b>: \[
			 		<a href='?src=\ref[src];action=addabil;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Add</a> |
			 		<a href='?src=\ref[src];action=removeabil;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Remove</a> |
			 		<a href='?src=\ref[src];action=abilholder;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>New Holder</a>
				\]"}
	dat += "</div>"

	//Movement based options
	if(!istype(M, /mob/new_player))
		dat += {"<div class='optionGroup' style='border-color:#77DD77'><b class='title' style='background:#77DD77'>Movement</b>
					<a href='?src=\ref[src];action=jumpto;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Jump To</A> |
					<a href='?src=\ref[src];action=getmob;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Get</a> |
					<a href='?src=\ref[src];action=sendmob;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Send To</a> | "}
		if (!isobserver(M))
			var/area/A = get_area(M)
			if (A && istype(A, /area/prison/cell_block/wards))
				dat += "<a href='?src=\ref[src];action=prison;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Unprison</a> | "
			else
				dat += "<a href='?src=\ref[src];action=prison;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Prison</a> | "
			dat += "<a href='?src=\ref[src];action=shamecube;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Shame Cube</a> | "
		dat += {"	Thunderdome: \[
						<a href='?src=\ref[src];action=tdome;targetckey=[M.ckey];targetmob=\ref[M];type=1;origin=adminplayeropts'>One</a> |
						<a href='?src=\ref[src];action=tdome;targetckey=[M.ckey];targetmob=\ref[M];type=2;origin=adminplayeropts'>Two</a>
					\]
				</div>"}

	//Admin control options
	if (M.client || M.ckey)
		dat += "<div class='optionGroup' style='border-color:#FF6961'><b class='title' style='background:#FF6961'>Control</b>"
		var/adminRow1
		var/adminRow2
		if (M.client)
			adminRow1 += {"<a href='?src=\ref[src];action=showrules;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Show Rules</a> |
					<a href='?src=\ref[src];action=prom_demot;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Promote/Demote</a> |
					<a href='?src=\ref[src];action=forcespeech;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Force to Say</a> |"}
			if (M.client.ismuted())
				adminRow1 += " <a href='?src=\ref[src];action=mute;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Unmute</a>"
			else
				adminRow1 += {" Mute \[<a href='?src=\ref[src];action=mute;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Perm</a> |
					<a href='?src=\ref[src];action=tempmute;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Temp</a>\]"}

			adminRow2 += {"[!M.ckey ? " | " : ""]<a href='?src=\ref[src];action=warn;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Warn</a> |
							<a href='?src=\ref[src];action=boot;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Kick</a>"}
		if (M.ckey)
			adminRow2 += {"[M.client ? " | " : ""] Ban \[<a href='?src=\ref[src];action=addban;targetckey=[M.ckey];origin=adminplayeropts'>Normal</a> |
					<a href='?src=\ref[src];action=sharkban;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Shark</a> \] |
					<a href='?src=\ref[src];action=jobbanpanel;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Jobban</a> |
					<a href='?src=\ref[src];action=notes;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Notes</a> |
					<a href='?src=\ref[src];action=viewcompids;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>CompIDs</a> | "}
			if (oocban_isbanned(M))
				adminRow2 += " <a href='?src=\ref[src];action=banooc;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>OOC - Unban</a>  "
			else
				adminRow2 += " <a href='?src=\ref[src];action=banooc;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>OOC - Ban</a>  "

			adminRow2 += "|  <a href='?src=\ref[src];action=chatbans;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Chat Bans</a> "
			adminRow2 += "|  <a href='?src=\ref[src];action=giveantagtoken;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Antag Tokens</a> "
			adminRow2 += "|  <a href='?src=\ref[src];action=setspacebux;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Spacebux</a> "
			adminRow2 += "|  <a href='?src=\ref[src];action=viewantaghistory;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Antag History</a> "
			adminRow2 += "|  <a href='?src=\ref[src];action=show_player_stats;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Stats</a> "

			adminRow1 += "[M.client ? " | " : ""]<a href='?src=\ref[src];action=respawntarget;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Respawn</a>"
		dat += "[adminRow1]<br>[adminRow2]"
		dat += "</div>"

	//Very special roles
	if(!istype(M, /mob/new_player))
		dat += "<div class='optionGroup' style='border-color:#B57EDC'><b class='title' style='background:#B57EDC'>Special Roles</b>"
		if (iswraith(M))
			dat += "<b>Is Wraith</b> | "
		else
			dat += "<a href='?src=\ref[src];action=makewraith;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Make Wraith</a> | "
		if (isblob(M))
			dat += "<b>Is Blob</b> | "
		else
			dat += "<a href='?src=\ref[src];action=makeblob;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Make Blob</a> | "
		if (istype(M, /mob/living/carbon/human/machoman))
			dat += "<b>Is Macho Man</b> |"
		else
			dat += "<a href='?src=\ref[src];action=makemacho;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Make Macho</a> | "
		if (iswelder(M))
			dat += "<b>Is Welder</b> |"
		else
			dat += "<a href='?src=\ref[src];action=makewelder;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Make Welder</a> | "
		dat += "<a href='?src=\ref[src];action=makecritter;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Make Critter</a> | "
		dat += "<a href='?src=\ref[src];action=makecube;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Make Cube</a> | "
		/*if (istype(M, /mob/living/intangible/intruder))
			dat += "<b>Is Intruder</b>"
		else
			dat += "<a href='?src=\ref[src];action=makeintruder;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Make Intruder (DO NOT USE, BROKEN)</a>"
		*/
		if (isflock(M))
			dat += "<b>Is Flock</b>"
		else
			dat += "<a href='?src=\ref[src];action=makeflock;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Make Flock (WIP)</a>"
		dat += "</div>"

	//Transformation options
	if(!istype(M, /mob/new_player))// && !isobserver(M)) man it's really annoying to not be able to make ghosts into humans, why were they excluded from being humanized in the first place?
		dat += "<div class='optionGroup' style='border-color:#779ECB'><b class='title' style='background:#779ECB'>Transformation</b>"
		dat += "<a href='?src=\ref[src];action=humanize;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Humanize</a> | "
		/* This is not needed  with monkies being a mutantrace.
		if (ismonkey(M))
			dat += "<b>Is a Monkey</b>"
		else */
		if (isAI(M))
			dat += "<b>Is an AI</b>"
		else if (ishuman(M))
			dat += {"<a href='?src=\ref[src];action=transform;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Transform</a> |
					<a href='?src=\ref[src];action=clownify;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Clownify</a> |
					<a href='?src=\ref[src];action=makeai;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Make AI</a> |
					<a href='?src=\ref[src];action=modifylimbs;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Modify Parts</a>
					"}
		else
			dat += "<b>Mob type cannot be transformed</b>"
		if (!isobserver(M)) //moved from SG level stuff
			dat += " | <a href='?src=\ref[src];action=polymorph;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Polymorph</a>"
		dat += "</div>"

	//Coder options
	if( src.level >= LEVEL_SHITGUY )
		dat += {"<div class='optionGroup' style='border-color:#FFB347'><b class='title' style='background:#FFB347'>High Level / Coder</b>
				<a href='?src=\ref[src];action=possessmob;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>[M == usr ? "Release" : "Possess"]</a> |
				Variables: \[
					<a href='?src=\ref[src];action=viewvars;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>View</a> |
					<a href='?src=\ref[src];action=editvars;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Edit</a>
				\] |
				<a href='?src=\ref[src];action=modcolor;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>Modify Icon</a>"}
		if (src.level >= LEVEL_CODER)
			dat += "<br><a href='?src=\ref[src];action=viewsave;targetckey=[M.ckey];targetmob=\ref[M];origin=adminplayeropts'>View Save Data</a>"
			if(M.client)
				if(M.has_medal( "Contributor" ))
					dat += "<br><a href='?src=\ref[src];targetckey=[M.ckey];targetmob=\ref[M];action=revokecontributor;origin=adminplayeropts'>Revoke Contributor Medal</a>"
				else
					dat += "<br><a href='?src=\ref[src];targetckey=[M.ckey];targetmob=\ref[M];action=grantcontributor;origin=adminplayeropts'>Grant Contributor Medal</a>"
		dat += "</div>"

	var/windowHeight
	if (src.level == LEVEL_SHITGUY)
		windowHeight = "390"
	else if (src.level == LEVEL_CODER)
		windowHeight = "611"
	else
		windowHeight = "310"

	usr.Browse(dat, "window=adminplayeropts[M.ckey];size=505x[windowHeight]")
