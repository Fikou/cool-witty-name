//MOB HIMSELF

/obj/dialogueobj/ntrepresentative
	name = "NT Representative"
	icon = 'icons/misc/factionreps.dmi'
	icon_state = "ntcommander"
	density = 1
	anchored = 2
	var/datum/dialogueMaster/dialogue = null

	New()
		dialogue = new/datum/dialogueMaster/nt_faction(src)
		..()

	attack_hand(mob/user as mob)
		if(get_dist(usr, src) > 1 || usr.z != src.z) return
		dialogue.showDialogue(user)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		return attack_hand(user)

/datum/dialogueMaster/nt_faction
	dialogueName = "NT Representative"
	start = /datum/dialogueNode/nt_start
	visibleDialogue = 0
	maxDistance = 1

/datum/dialogueNode
	nt_start
		nodeImage = "ntportrait.png"
		linkText = "..." //Because we use the first node as a "go back" link as well.
		links = list(/datum/dialogueNode/nt_who,/datum/dialogueNode/nt_reputation,/datum/dialogueNode/nt_rewards,/datum/dialogueNode/nt_standing,/datum/dialogueNode/nt_item)
		var/lastComplaint = 0

		getNodeText(var/client/C)
			var/rep = C.reputations.get_reputation_level("nt")
			switch(rep)
				if(0)
					return "Hello [C.mob.name]."
				if(-3 to -1)
					return "And what do you want?"
				if(-6 to -4)
					return "What do you want, you darn traitor?"
				if(1 to 3)
					return "Good to see you [C.mob.name]!"
				if(4 to 6)
					return "Hope you're having an excellent day [C.mob.name]!"
			return ""

	nt_who
		nodeImage = "ntportrait.png"
		linkText = "Who are you?"
		nodeText = "I am Commander Wardson. I've been sent here to investigate the NSS Polaris incident. Do you by any chance have information regarding that?"
		links = list()

	nt_reputation
		nodeImage = "ntportrait.png"
		linkText = "How can I improve my standing with you?"
		nodeText = "I would encourage you to dispose of any threats to the station you might find. Especially those darn syndicate members and their blasted drones. Bring me back proof and I will reward you accordingly."
		links = list()

	nt_standing
		nodeImage = "ntportrait.png"
		linkText = "What is my current standing with you?"
		links = list()

		getNodeText(var/client/C)
			var/rep = C.reputations.get_reputation_string("nt")
			return "Your current standing with Nanotrasen is [rep]."

	nt_rewards
		nodeImage = "ntportrait.png"
		linkText = "Let me see the available rewards, please."
		nodeText = "Alright, here's what I have to offer for your current standing with Nanotrasen.."
		links = list(/datum/dialogueNode/nt_reward_a)

	nt_reward_a
		nodeImage = "ntrep_sad.png"
		linkText = "Blank Nanotrasen ID"
		nodeText = "Sure thing, here you go."
		links = list()

		canShow(var/client/C)
			var/rep = C.reputations.get_reputation_level("nt")
			if(master.getFlag(C, "card_reward") == "taken" || rep < 1 ) return 0
			else return 1

		onActivate(var/client/C)
			master.setFlag(C, "card_reward", "taken")
			C.mob.put_in_hand_or_drop(new/obj/item/card/id/blank_polaris, C.mob.hand)
			return

	nt_item
		nodeImage = "ntportrait.png"
		linkText = "I actually have something that you might find interesting.."
		links = list(/datum/dialogueNode/nt_itemtake)

		canShow(var/client/C)
			if(istype(C.mob.equipped(), /obj/item/factionrep/ntboard)) return 1
			if(istype(C.mob.equipped(), /obj/item/blackbox)) return 1
			else return 0

		getNodeText(var/client/C)
			return "Excellent work,[C.mob.name]! You'll do Nanotrasen proud. Now hand it over and I will make sure you will be rewarded accordingly."


	nt_itemtake
		nodeImage = "ntportrait.png"
		linkText = "Alright, here you go."
		nodeText = ""
		links = list()

		getNodeText(var/client/C)
			return "Í will make sure that Nanotrasen will remember your name, [C.mob.name]."

		canShow(var/client/C)
			if(istype(C.mob.equipped(), /obj/item/factionrep/ntboard)) return 1
			if(istype(C.mob.equipped(), /obj/item/blackbox)) return 1
			else return 0

		onActivate(var/client/C)
			qdel(C.mob.equipped())
			C.reputations.set_reputation(id = "nt",amt = 500,absolute = 0)
			boutput(C.mob, "<span style=\"color:green\">Your standing with Nanotrasen has increased by 50!</span>")
			return



/obj/item/factionrep/ntboard
	name = "syndicate circuit board"
	desc = "Rather complex circuit board, ripped straight from syndicate drone's internal mechanicsm."
	icon = 'icons/misc/factionrewards.dmi'
	icon_state = "droneboard2"