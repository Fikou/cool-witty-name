/datum/targetable/spell/mutate
	name = "Empower"
	desc = "Temporarily superpowers your body and mind."
	icon_state = "mutate"
	targeted = 0
	cooldown = 400
	requires_robes = 1
	offensive = 1

	cast()
		if(!holder)
			return
		holder.owner.say("BIRUZ BENNAR")
		var/mob/living/carbon/human/O = holder.owner
		if(O && istype(O.wear_suit, /obj/item/clothing/suit/wizrobe/necro) && istype(O.head, /obj/item/clothing/head/wizard/necro))
			playsound(holder.owner.loc, "sound/voice/wizard/MutateGrim.ogg", 50, 0, -1)
		else if(holder.owner.gender == "female")
			playsound(holder.owner.loc, "sound/voice/wizard/MutateFem.ogg", 50, 0, -1)
		else
			playsound(holder.owner.loc, "sound/voice/wizard/MutateLoud.ogg", 50, 0, -1)
		boutput(holder.owner, "<span style=\"color:blue\">Your mind and muscles are magically empowered!</span>")
		holder.owner.visible_message("<span style=\"color:red\">[holder.owner] glows with a POWERFUL aura!</span>")

		if (!holder.owner.bioHolder.HasEffect("hulk"))
			holder.owner.bioHolder.AddEffect("hulk", 0, 0, 1)
		if (!holder.owner.bioHolder.HasEffect("telekinesis") && holder.owner.wizard_spellpower())
			holder.owner.bioHolder.AddEffect("telekinesis", 0, 0, 1)
		var/SPtime = 150
		if (holder.owner.wizard_spellpower())
			SPtime = 300
		else
			boutput(holder.owner, "<span style=\"color:red\">Your spell doesn't last as long without a staff to focus it!</span>")
		SPAWN_DBG (SPtime)
			if (holder.owner.bioHolder.HasEffect("telekinesis"))
				holder.owner.bioHolder.RemoveEffect("telekinesis")
			if (holder.owner.bioHolder.HasEffect("hulk"))
				holder.owner.bioHolder.RemoveEffect("hulk")
