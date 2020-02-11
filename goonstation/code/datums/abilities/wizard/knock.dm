/datum/targetable/spell/knock
	name = "Knock"
	desc = "Opens nearby doors."
	icon_state = "knock"
	targeted = 0
	cooldown = 100
	requires_robes = 1
	restricted_area_check = 1

	cast()
		if(!holder)
			return
		holder.owner.say("AULIE OXIN FIERA")
		var/mob/living/carbon/human/O = holder.owner
		if(O && istype(O.wear_suit, /obj/item/clothing/suit/wizrobe/necro) && istype(O.head, /obj/item/clothing/head/wizard/necro))
			playsound(holder.owner.loc, "sound/voice/wizard/KnockGrim.ogg", 50, 0, -1)
		else if(holder.owner.gender == "female")
			playsound(holder.owner.loc, "sound/voice/wizard/KnockFem.ogg", 50, 0, -1)
		else
			playsound(holder.owner.loc, "sound/voice/wizard/KnockLoud.ogg", 50, 0, -1)

		var/SPrange = 1
		if (holder.owner.wizard_spellpower())
			SPrange = 5
		else
			boutput(holder.owner, "<span style=\"color:red\">Your spell only works at point blank without a staff to focus it!</span>")
		for(var/obj/machinery/door/G in oview(SPrange, holder.owner))
			SPAWN_DBG(1)
				G.open()
		for(var/obj/storage/F in oview(SPrange, holder.owner))
			if (F.locked)
				F.locked = 0
			SPAWN_DBG(1)
				F.open()
		for(var/mob/living/silicon/robot/E in oview(SPrange, holder.owner))
			SPAWN_DBG(1)
				E.spellopen()
		for(var/obj/machinery/bot/B in oview(SPrange, holder.owner))
			B.locked = 0
			B.req_access = null
