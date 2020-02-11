var/global/admin_sound_channel = 1014 //Ranges from 1014 to 1024

/client/proc/play_sound_real(S as sound, var/vol as num, var/freq as num)
	if (!config.allow_admin_sounds)
		alert("Admin sounds disabled")
		return

	var/admin_key = admin_key(src)

	var/sound/uploaded_sound = new()
	uploaded_sound.file = S
	uploaded_sound.wait = 0
	uploaded_sound.volume = max(min(vol, 100), 0)
	uploaded_sound.repeat = 0
	uploaded_sound.priority = 254
	uploaded_sound.channel = admin_sound_channel
	uploaded_sound.frequency = freq

	if (uploaded_sound.volume == 0 || !uploaded_sound.volume)
		return

	logTheThing("admin", src, null, "played sound [S]")
	logTheThing("diary", src, null, "played sound [S]", "admin")
	message_admins("[key_name(src)] played sound [S]")
	SPAWN_DBG(0)
		for (var/client/C in clients)
			C << uploaded_sound
			//DEBUG_MESSAGE("Playing sound for [C] on channel [uploaded_sound.channel]")
			if (src.djmode || src.non_admin_dj)
				boutput(C, "<span class=\"medal\"><b>[admin_key] played:</b></span> <span style=\"color:blue\">[S]</span>")
		move_admin_sound_channel()

/client/proc/play_music_real(S as sound, var/freq as num)
	if (!config.allow_admin_sounds)
		alert("Admin sounds disabled")
		return 0

	var/sound/music_sound = new()
	music_sound.file = S
	music_sound.wait = 0
	music_sound.repeat = 0
	music_sound.priority = 254
	music_sound.channel = admin_sound_channel //having this set to 999 removed layering music functionality -ZeWaka
	if(!freq)
		music_sound.frequency = 1
	else
		music_sound.frequency = freq

	SPAWN_DBG(0)
		var/admin_key = admin_key(src)
		for (var/client/C in clients)
			LAGCHECK(LAG_LOW)
			var/client_vol = C.preferences.admin_music_volume

			if (src.djmode || src.non_admin_dj)
				boutput(C, "<span class=\"medal\"><b>[admin_key] played (your volume: [client_vol ? "[client_vol]" : "muted"]):</b></span> <span style=\"color:blue\">[S]</span>")

			if (client_vol == 0 || !client_vol)
				continue

			music_sound.volume = 100 * (client_vol / 100)  //If this is defined above, the volume gets exponentially lower for each loop.
			C << music_sound
			//DEBUG_MESSAGE("Playing sound for [C] on channel [music_sound.channel] with volume [music_sound.volume]")
		move_admin_sound_channel()
	logTheThing("admin", src, null, "started loading music [S]")
	logTheThing("diary", src, null, "started loading music [S]", "admin")
	message_admins("[key_name(src)] started loading music [S]")
	return 1

/client/proc/play_music_radio(soundPath)
	var/sound/music_sound = getSound(soundPath)
	music_sound.wait = 0
	music_sound.repeat = 0
	music_sound.priority = 254
	music_sound.channel = 1013 // This probably works?

	SPAWN_DBG(0)
		for (var/client/C in clients)
			LAGCHECK(LAG_LOW)
			C.verbs += /client/verb/stop_the_radio
			var/client_vol = C.preferences.radio_music_volume

			if (client_vol == 0 || !client_vol)
				continue

			music_sound.volume = 100
			music_sound.volume *= (client_vol / 100)
			C << music_sound
			//DEBUG_MESSAGE("Playing sound for [C] on channel [music_sound.channel] with volume [client_vol]")

	logTheThing("admin", src, null, "started loading music [soundPath]")
	logTheThing("diary", src, null, "started loading music [soundPath]", "admin")
	message_admins("[key_name(src)] started loading music [soundPath]")
	return 1

/proc/play_music_remote(data)
	if (!config.allow_admin_sounds)
		alert("Admin sounds disabled")
		return 0

	var/client/adminC
	for (var/client/C in clients)
		if (C.key == data["key"])
			adminC = C

	SPAWN_DBG(0)
		for (var/client/C in clients)
			LAGCHECK(LAG_LOW)
			C.verbs += /client/verb/stop_the_music
			var/vol = C.preferences.admin_music_volume

			var/ismuted
			if (vol == 0 || !vol) ismuted = 1

			if (adminC && (adminC.djmode || adminC.non_admin_dj))
				var/show_other_key = 0
				if (adminC.stealth || adminC.alt_key)
					show_other_key = 1
				boutput(C, "<span class=\"medal\"><b>[show_other_key ? adminC.fakekey : adminC.key] played (your volume: [ ismuted ? "muted" : vol ]):</b></span> <span style=\"color:blue\">[data["title"]] ([data["duration"]])</span>")

			if (ismuted) //bullshit BYOND 0 is not null fuck you
				continue

			C.chatOutput.playMusic(data["file"], vol)

	if (adminC)
		logTheThing("admin", adminC, null, "loaded remote music: [data["file"]] ([data["filesize"]])")
		logTheThing("diary", adminC, null, "loaded remote music: [data["file"]] ([data["filesize"]])", "admin")
		message_admins("[key_name(adminC)] loaded remote music: [data["title"]] ([data["duration"]] / [data["filesize"]])")
	else
		logTheThing("admin", data["key"], null, "loaded remote music: [data["file"]] ([data["filesize"]])")
		logTheThing("diary", data["key"], null, "loaded remote music: [data["file"]] ([data["filesize"]])", "admin")
		message_admins("[key_name(data["key"])] loaded remote music: [data["title"]] ([data["duration"]] / [data["filesize"]])")
	return 1

/mob/verb/adminmusicvolume()
	set name = "Alter Music Volume"
	set desc = "Alert admin music volume, default is 50"
	set hidden = 1

	if (!usr.client) //How could this even happen?
		return

	var/vol = input("Goes from 0-100. Default is 50", "Admin Music Volume", usr.client.preferences.admin_music_volume) as num
	vol = max(0,min(vol,100))
	usr.client.preferences.admin_music_volume = vol
	boutput(usr, "<span style=\"color:blue\">You have changed Admin Music Volume to [vol]. Note that this setting will not save unless you manually do so in Character Preferences.</style>")

/mob/verb/radiomusicvolume()
	set name = "Alter Radio Volume"
	set desc = "Alert radio music volume, default is 50"
	set hidden = 1

	if (!usr.client)
		return

	var/vol = input("Goes from 0-100. Default is 50", "Radio Music Volume", usr.client.preferences.radio_music_volume) as num
	vol = max(0,min(vol,100))
	usr.client.preferences.radio_music_volume = vol
	boutput(usr, "<span style=\"color:blue\">You have changed Radio Music Volume to [vol]. Note that this setting will not save unless you manually do so in Character Preferences.</style>")

// for giving non-admins the ability to play music
/client/proc/non_admin_dj(S as sound)
	set category = "Special Verbs"
	set name = "Play Music"

	if (src.play_music_real(S))
		boutput(src, "<span style=\"color:blue\">Loading music [S]...</span>")

/client/verb/stop_the_music()
	set category = "Commands"
	set name = "Stop the Music!"
	set desc = "Is there music playing? Do you hate it? Press this to make it stop!"
	set popup_menu = 0
	set hidden = 1

	ehjax.send(src, "browseroutput", "stopaudio") //For client-side audio

	var/mute_channel = 1014
	var/sound/stopsound = sound(null,wait = 0,channel=mute_channel)
	for (var/i = 1 to 10)
		//DEBUG_MESSAGE("Muting sound channel [stopsound.channel] for [src]")
		stopsound.channel = mute_channel
		src << 	stopsound
		mute_channel ++
	//DEBUG_MESSAGE("Muting sound channel [stopsound.channel] for [src]")

/client/verb/stop_the_radio()
	set category = "Commands"
	set name = "Stop the Radio!"
	set desc = "Is the radio playing shitty songs? Do you hate it? Press this to make it stop!"
	set popup_menu = 0
	set hidden = 1

	ehjax.send(src, "browseroutput", "stopaudio") //For client-side audio

	src.verbs -= /client/verb/stop_the_radio
	var/mute_channel = 1013
	var/sound/stopsound = sound(null,wait = 0,channel=mute_channel)
	//DEBUG_MESSAGE("Muting sound channel [stopsound.channel] for [src]")
	stopsound.channel = mute_channel
	src << 	stopsound
	//DEBUG_MESSAGE("Muting sound channel [stopsound.channel] for [src]")
	SPAWN_DBG(50)
		src.verbs += /client/verb/stop_the_radio

/client/verb/stop_all_sounds()
	set category = "Commands"
	set name = "Stop Sounds"
	set desc = "Is there some weird sound that won't go away? Try this."
	set popup_menu = 0
	set hidden = 1

	src.verbs -= /client/verb/stop_all_sounds
	var/mute_channel = 0
	var/sound/stopsound = sound(null,wait = 0,channel=mute_channel)
	for (var/i = 1 to 1013)
		//DEBUG_MESSAGE("Muting sound channel [stopsound.channel] for [src]")
		stopsound.channel = mute_channel
		src << 	stopsound
		mute_channel ++
	//DEBUG_MESSAGE("Muting sound channel [stopsound.channel] for [src]")
	SPAWN_DBG(50)
		src.verbs += /client/verb/stop_all_sounds

/proc/move_admin_sound_channel(var/opposite = 0)
	if (opposite)
		if (admin_sound_channel > 1014)
			//DEBUG_MESSAGE("Increasing admin_sound_channel from [admin_sound_channel] to [(admin_sound_channel+1)]")
			admin_sound_channel--
			admin_dj.SetVar("admin_channel", admin_sound_channel)
			//DEBUG_MESSAGE("admin_sound_channel now [admin_sound_channel]")
		else //At 1014, set it bring it up 10.
			//DEBUG_MESSAGE("Resetting admin_sound_channel from [admin_sound_channel]")
			admin_sound_channel = 1024
			admin_dj.SetVar("admin_channel", 1024)
			//DEBUG_MESSAGE("admin_sound_channel now [admin_sound_channel]")
	else
		if (admin_sound_channel < 1024)
			//DEBUG_MESSAGE("Increasing admin_sound_channel from [admin_sound_channel] to [(admin_sound_channel+1)]")
			admin_sound_channel++
			admin_dj.SetVar("admin_channel", admin_sound_channel)
			//DEBUG_MESSAGE("admin_sound_channel now [admin_sound_channel]")
		else //At 1024, set it back down 10.
			//DEBUG_MESSAGE("Resetting admin_sound_channel from [admin_sound_channel]")
			admin_sound_channel = 1014
			admin_dj.SetVar("admin_channel", 1014)
			//DEBUG_MESSAGE("admin_sound_channel now [admin_sound_channel]")

/client/proc/play_youtube_audio()
	if (!config.youtube_audio_key)
		alert("You don't have access to the youtube audio converter")
		return 0

	var/video = input("Input the Youtube video information\nEither the full URL e.g. https://www.youtube.com/watch?v=145RCdUwAxM\nOr just the video ID e.g. 145RCdUwAxM", "Play Youtube Audio") as null|text
	if (!video)
		return

	var/url = "http://yt.goonhub.com/index.php?server=[config.server_id]&key=[src.key]&video=[video]&auth=[config.youtube_audio_key]"
	var/response[] = world.Export(url)
	if (!response)
		boutput(src, "<span class='bold' style=\"color:blue\">Something went wrong with the youtube thing! Yell at Wire.</span>")
		logTheThing("debug", null, null, "<b>Youtube Error</b>: No response from server with video: <b>[video]</b>")
		logTheThing("diary", null, null, "Youtube Error: No response from server with video: [video]", "debug")
		return

	var/key
	var/contentExists = 0
	for (key in response)
		if (key == "CONTENT")
			contentExists = 1

	if (!contentExists)
		boutput(src, "<span class='bold' style=\"color:blue\">Something went wrong with the youtube thing! Yell at Wire.</span>")
		logTheThing("debug", null, null, "<b>Youtube Error</b>: Malformed response from server with video: <b>[video]</b>")
		logTheThing("diary", null, null, "Youtube Error: Malformed response from server with video: [video]", "debug")
		return

	var/data = json_decode(file2text(response["CONTENT"]))
	if (data["error"])
		boutput(src, "<span class='bold' style=\"color:blue\">Error returned from youtube server thing: [data["error"]].</span>")
		return

	boutput(src, "<span class='bold' style=\"color:blue\">Youtube audio loading started. This may take some time to play and a second message will be displayed when it finishes.</span>")