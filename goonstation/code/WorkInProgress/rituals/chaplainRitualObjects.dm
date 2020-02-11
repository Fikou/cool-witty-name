//File for objects chaplain rituals use.

/proc/ritualEffect(var/aloc, var/istate = "magic", var/duration = 50, var/large = 0, var/rPlane = 0)
	if(!large)
		var/obj/chaplainStuff/ritualeffect/M = unpool(/obj/chaplainStuff/ritualeffect)
		M.show(aloc, istate, duration, rPlane)
	else
		var/obj/chaplainStuff/ritualeffectbig/M = unpool(/obj/chaplainStuff/ritualeffectbig)
		M.show(aloc, istate, duration, rPlane)

/obj/item/storage/box/ritual
	name = "EZ-Magic kit"
	spawn_contents = list(/obj/item/sacdagger,/obj/item/thaumometer,/obj/item/spiritshard/cheatyten,/obj/item/spiritshard/cheatyfive,/obj/item/ritualChalk/randomColor,/obj/item/ritualChalk/randomColor,/obj/item/ritualskull)

/obj/chaplainStuff/tentacle
	density = 0
	opacity = 0
	anchored = 1
	layer = EFFECTS_LAYER_4
	name = ""
	icon = 'icons/misc/chaplainRitual.dmi'
	icon_state = "ten1"
	alpha = 0

	New(var/loc,var/d)
		dir = d
		src.set_loc(loc)
		icon_state = pick("ten1","ten2","ten3")
		animate(src, alpha=255, time=10)
		SPAWN_DBG(30)
			animate(src, alpha=0, time=10)
		SPAWN_DBG(40)
			src.set_loc(null)
			qdel(src)
		..(loc)

/obj/chaplainStuff/ritualeffect
	density = 0
	opacity = 0
	anchored = 1
	name = ""
	icon = 'icons/misc/chaplainRitual.dmi'
	icon_state = "empty"
	layer = EFFECTS_LAYER_4

	unpooled(var/t)
		filters = null
		color = "#FFFFFF"
		..(t)

	proc/show(var/loc, var/istate = "magic", var/duration = 50, var/rPlane = 0)
		src.plane = rPlane
		src.set_loc(loc)
		flick(istate, src)
		SPAWN_DBG(duration)
			src.set_loc(null)
			pool(src)

/obj/chaplainStuff/ritualeffectbig
	density = 0
	opacity = 0
	anchored = 1
	pixel_x = -64
	pixel_y = -64
	name = ""
	icon = 'icons/effects/160x160.dmi'
	icon_state = "empty"

	unpooled(var/t)
		filters = null
		color = "#FFFFFF"
		..(t)

	proc/show(var/loc, var/istate = "ritualeffect", var/duration = 200, var/rPlane = 0)
		src.plane = rPlane
		src.set_loc(loc)
		flick(istate, src)
		SPAWN_DBG(duration)
			src.set_loc(null)
			pool(src)

/obj/chaplainStuff/darkness/evil
	New(var/loc, var/duration = 100)
		SPAWN_DBG(20) process()
		..(loc,duration)

	proc/process()
		if(prob(30))
			var/direction = pick(NORTH,EAST,SOUTH,WEST)
			var/turf/T = get_step(src, direction)
			new/obj/chaplainStuff/tentacle(T,direction)
		for(var/mob/M in src.loc)
			M.TakeDamage("All", 5, 5, 5, DAMAGE_BLUNT)
		SPAWN_DBG(20) process()

/obj/chaplainStuff/darkness
	density = 0
	opacity = 1
	anchored = 1
	layer = NOLIGHT_EFFECTS_LAYER_4

	icon = 'icons/misc/chaplainRitual.dmi'
	icon_state = "black"

	New(var/loc, var/duration = 100)
		src.set_loc(loc)
		filters = null
		filters += filter(type="blur", size=6)
		SPAWN_DBG(duration)
			src.set_loc(null)
			qdel(src)
		..(loc)

/obj/item/sacdagger
	name = "Sacrifical dagger"
	desc = "Used to trigger sacrifical sigils without triggering the entire ritual."
	icon = 'icons/misc/chaplainRitual.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "sacdagger0"
	flags = FPRINT | ONBELT | TABLEPASS | USEDELAY | EXTRADELAY
	throwforce = 1
	force = 5
	w_class = 1.0
	hit_type = DAMAGE_CUT

	setupProperties()
		setProperty("vorpal", 8)
		return ..()

	pixelaction(atom/target, params, mob/user, reach)
		if(istype(target, /obj/screen)) return
		var/turf/T = get_turf(target)
		var/used = 0
		//var/prevLen = T.contents.len
		for(var/atom/A in T)
			if(A.ritualComponent && A.ritualComponent.hasFlags(RITUAL_FLAG_CONSUME))
				A.ritualComponent.flag_consume()
				used = 1
		if(used)// && T.contents.len != prevLen)
			ritualEffect(T, "sac")
		return

/obj/item/ritualskull
	name = "Odd-looking skull"
	desc = "It thrums with evil power."
	icon = 'icons/misc/chaplainRitual.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "oddskull"
	flags = FPRINT| TABLEPASS | USEDELAY | EXTRADELAY
	throwforce = 0
	w_class = 1.0

	New()
		ritualComponent = new/datum/ritualComponent/corruptus(src)
		ritualComponent.autoActive = 1
		..()

/obj/item/spiritshard
	name = "Spirit shard"
	desc = "Condensed magical energy."
	icon = 'icons/misc/chaplainRitual.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "spiritshard0"
	flags = FPRINT | ONBELT | TABLEPASS | USEDELAY | EXTRADELAY
	throwforce = 0
	w_class = 1.0
	var/storedPower = 0
	var/storedStrength = 0
	var/corrupted = 0

	cheatycorrupt
		New(var/loc)
			var/datum/ritualVars/V = newRitualVars(75, 75)
			V.corrupted = 1
			return ..(loc,V)

	cheatyfifty
		New(var/loc)
			return ..(loc,newRitualVars(50, 50))

	cheatyten
		New(var/loc)
			return ..(loc,newRitualVars(10, 10))

	cheatyfive
		New(var/loc)
			return ..(loc,newRitualVars(5, 5))

	cheatyone
		New(var/loc)
			return ..(loc,newRitualVars(1, 1))

	proc/setVars(var/datum/ritualVars/V)
		storedPower = V.energy
		storedStrength = V.strength

		if(V.corrupted)
			corrupted = 1
			switch(storedPower+storedStrength)
				if(1 to 4)
					icon_state = "spiritshardC0"
					name = "Fractured Soul shard"
				if(5 to 10)
					icon_state = "spiritshardC1"
					name = "Ghastly soul shard"
				if(1 to INFINITY)
					icon_state = "spiritshardC2"
					name = "Wailing soul shard"
		else
			switch(storedPower+storedStrength)
				if(1 to 4)
					icon_state = "spiritshard0"
					name = "Dull [lowertext(initial(name))]"
				if(5 to 10)
					icon_state = "spiritshard1"
					name = "Glowing [initial(name)]"
				if(11 to INFINITY)
					icon_state = "spiritshard2"
					name = "Vibrant [lowertext(initial(name))]"

		desc = "Condensed magical energy. It contains [storedPower] power and [storedStrength] strength."
		return

	New(var/loc, var/datum/ritualVars/V)
		set_loc(loc)
		setVars(V)
		return

/obj/item/thaumometer
	name = "Thaumometer"
	desc = "Used to analyze the power and strength of rituals. Will only show the currently stored power/strength of the ritual."
	icon = 'icons/misc/chaplainRitual.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "thaumometer"
	flags = FPRINT | ONBELT | TABLEPASS | USEDELAY | EXTRADELAY
	throwforce = 0
	w_class = 1.0

	pixelaction(atom/target, params, mob/user, reach)
		if(istype(target, /obj/screen)) return
		var/turf/T = get_turf(target)
		for(var/atom/A in T)
			if(A.ritualComponent)
				var/datum/ritualComponent/anchor/anchor = null
				if(istype(A.ritualComponent, /datum/ritualComponent/anchor))
					anchor = A.ritualComponent
				else if(A.ritualComponent.ownerAnchor)
					anchor = A.ritualComponent.ownerAnchor
				if(anchor)
					var/datum/ritualVars/V = newRitualVars()
					for(var/datum/ritualComponent/C in anchor.getFlagged(RITUAL_FLAG_ENERGY))
						V = C.flag_power(V,0)
					for(var/datum/ritualComponent/C in anchor.getFlagged(RITUAL_FLAG_STRENGTH))
						V = C.flag_strength(V,0)
					boutput(user, "<span style=\"color:red\"><b>Ritual power:[V.energy] , Ritual strength:[V.strength]</b></span>")
				else
					boutput(user, "<span style=\"color:red\"><b>No ritual anchor found.</b></span>")
		return

/obj/item/ritualChalk
	name = "Ritual chalk"
	desc = "Ritual chalk used to draw symbols for rituals."
	icon = 'icons/obj/writing.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "ritualchalk"
	flags = FPRINT | ONBELT | TABLEPASS | USEDELAY | EXTRADELAY
	throwforce = 0
	w_class = 1.0
	color = "#931010"
	var/cursed = 0
	var/blessed = 0

	randomColor
		New()
			randomColor()
			..()

	var/list/buttons = list()
	var/turf/target = null

	proc/setColor(var/datum/color/C)
		color = C.to_rgb()
		name = "[capitalize(get_nearest_color(C))] [lowertext(initial(name))]"
		return

	proc/randomColor()
		var/datum/color/C = new()
		C.r = rand(0,255)
		C.g = rand(0,255)
		C.b = rand(0,255)
		C.a = 255
		setColor(C)
		return

	proc/addButton(var/datum/ritualComponent/C)
		var/obj/screen/chalkButton/B = new/obj/screen/chalkButton(src, C, src, src.color)
		return B

	pixelaction(atom/target, params, mob/living/user, reach)
		if (!target || !isturf(target) || !user || !reach || get_dist(target, user) > 1)
			return 0

		if(!buttons.len)
			for(var/datum/ritualComponent/C in globalRitualComponents)
				if(C.selectable)
					buttons += addButton(C)

		var/starting_x = (target.x - user.x)
		var/starting_y = (target.y - user.y)

		var/off_y = starting_y
		var/off_x = -(RITUAL_BUTTON_SCALE*RITUAL_BUTTONS_PER_SIDE) + starting_x

		removeButtons(user)

		for(var/obj/screen/chalkButton/C in buttons)
			C.screen_loc = "CENTER[off_x < 0 ? "[off_x]":"+[off_x]"],CENTER[off_y < 0 ? "[off_y]":"+[off_y]"]"
			var/mob/living/carbon/human/H = user
			if(istype(H)) H.hud.add_screen(C)
			var/mob/living/critter/R = user
			if(istype(R)) R.hud.add_screen(C)

			if(off_x >= (RITUAL_BUTTON_SCALE*RITUAL_BUTTONS_PER_SIDE) + starting_x)
				off_x = -(RITUAL_BUTTON_SCALE*RITUAL_BUTTONS_PER_SIDE) + starting_x
				off_y -= RITUAL_BUTTON_SCALE
			else
				off_x += RITUAL_BUTTON_SCALE

		//set move callback (dismiss buttons when we move)
		if (islist(user.move_laying))
			user.move_laying += src
		else
			if (user.move_laying)
				user.move_laying = list(user.move_laying, src)
			else
				user.move_laying = list(src)

		src.target = target
		return 1

	proc/placeSymbol(var/datum/ritualComponent/C)
		if(locate(/obj/decal/cleanable/ritualSigil) in target)
			var/obj/decal/cleanable/ritualSigil/S = (locate(/obj/decal/cleanable/ritualSigil) in target)
			boutput(usr, "<span style=\"color:red\"><b>You replace the [S] ...")
			del(S)
		if(target && get_dist(target, src) <= 1)
			var/obj/decal/cleanable/ritualSigil/R = new/obj/decal/cleanable/ritualSigil(target, C.type)
			R.color = src.color
			playsound(get_turf(target), pick('sound/effects/chalk1.ogg','sound/effects/chalk2.ogg','sound/effects/chalk3.ogg'), 100, 1)
		return


	move_callback(var/mob/M, var/turf/source, var/turf/target)
		removeButtons(M)

	proc/removeButtons(var/mob/living/user)
		for(var/obj/screen/chalkButton/C in user.client.screen)
			var/mob/living/carbon/human/H = user
			if(istype(H)) H.hud.remove_screen(C)
			var/mob/living/critter/R = user
			if(istype(R)) R.hud.remove_screen(C)

		if (islist(user.move_laying))
			user.move_laying -= src
		else
			user.move_laying = null

		return

/obj/screen/chalkButton
	name = ""
	icon = 'icons/obj/writing.dmi'
	icon_state = ""
	var/datum/ritualComponent/component = null
	var/image/bgImage = null
	var/obj/item/ritualChalk/chalice = null

	New(var/cloc, var/datum/ritualComponent/C, var/obj/item/ritualChalk/ch, var/col)
		chalice = ch
		src.loc = cloc
		component = C
		src.name = C.name
		icon_state = C.icon_symbol
		src.color = col
		bgImage = image('icons/obj/writing.dmi', src, C.bg)
		bgImage.appearance_flags = RESET_COLOR
		src.underlays += bgImage
		src.transform *= RITUAL_BUTTON_SCALE
		src.filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=0, border=2, color="#000000")
		return ..()

	MouseEntered(object,location,control,params)
		src.filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=0, border=2, color="#FFFFFF")

		var/flagStr = ""
		if(component.ritualFlags & RITUAL_FLAG_CORE) flagStr += " Core"
		if(component.ritualFlags & RITUAL_FLAG_CREATE) flagStr += " Smn"
		if(component.ritualFlags & RITUAL_FLAG_MODIFY) flagStr += " Mod"
		if(component.ritualFlags & RITUAL_FLAG_ENERGY) flagStr += " Enr"
		if(component.ritualFlags & RITUAL_FLAG_SELECT) flagStr += " Trg"
		if(component.ritualFlags & RITUAL_FLAG_STRENGTH) flagStr += " Str"
		if(component.ritualFlags & RITUAL_FLAG_CONSUME) flagStr += " Sac"
		if(component.ritualFlags & RITUAL_FLAG_RANGE) flagStr += " Rng"
		flagStr += " "

		if (usr.client.tooltipHolder && (component != null))
			var/turf/T = locate(usr.x-1, usr.y+3, usr.z) //This is so unbelievably fucking stupid. WHY ARE THE PARAMS PASSED INTO THIS NON-EXISTENT ANYWAY. FUCK.
			usr.client.tooltipHolder.showHover(src, list(
				"params" = T.getScreenParams(),
				"title" = component.name + " ([flagStr])",
				"content" = component.desc,
				"theme" = "wraith"
			))
		return

	MouseExited(location,control,params)
		src.filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=0, border=2, color="#000000")
		if (usr.client.tooltipHolder)
			usr.client.tooltipHolder.hideHover()
		return

	clicked(list/params)
		chalice.removeButtons(usr)
		chalice.placeSymbol(component)

/obj/decal/cleanable/ritualSigil
	name = "Sigil"
	desc = "A sigil of some sort."
	can_fluid_absorb = 0
	icon = 'icons/obj/writing.dmi'
	icon_state = "(anchor)"

	New(var/cloc, var/C)
		ritualComponent = new C(src)
		icon_state = ritualComponent.icon_symbol
		src.name = ritualComponent.name
		return ..(loc=cloc, viral_list=null)

	Del()
		if(ritualComponent)
			del(ritualComponent)
		return ..()


