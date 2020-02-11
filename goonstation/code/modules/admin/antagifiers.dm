// Antagonifiers
/obj/traitorifier
	//var/allowAntagStacking = 0 // If set to 1, permits people to use multiple traitorifier types TODO: Figure out how to make this work intelligently
	name = "An Offer You Couldn't Refuse"
	desc = "In this economy you'd be stupid to turn this down."
	anchored = 1
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda-s"
	var/attachedObjective = "For the free market!"
	var/uses = -1 // -1 for infinite uses

	attack_hand(mob/M as mob)
		if (issilicon(M))
			boutput(M, "Silly robot.")
			return
		/*
		if (!allowAntagStacking && checktraitor(M))
			boutput(M, "Don't be greedy.")
			return
		*/
		if (M && M.mind && !M.mind.special_role)
			makeAntag(M)
			var/datum/objective/newObj = new /datum/objective(attachedObjective)
			newObj.owner = M.mind
			newObj.set_up()
			M.mind.objectives += newObj
			uses--
			if (uses == 0)
				qdel(src)

	proc/makeAntag(mob/M as mob)
		M.show_text("<h2><font color=red><B>You have defected and become a traitor!</B></font></h2>", "red")
		M.mind.special_role = "traitor"
		M.verbs += /client/proc/gearspawn_traitor
		SHOW_TRAITOR_RADIO_TIPS(M)

/obj/traitorifier/wizard
	name = "Eldritch Altar"
	desc = "Phenomenal cosmic power and groovy facial hair."
	attachedObjective = "You're a wizard, you don't need reasons."
	icon = 'icons/misc/halloween.dmi'
	icon_state = "tombstone"

	makeAntag(mob/M as mob)
		M.mind.special_role = "wizard"
		M.show_text("<h2><font color=red><B>You have been seduced by magic and become a wizard!</B></font></h2>", "red")
		SHOW_ADMINWIZARD_TIPS(M)
		M.verbs += /client/proc/gearspawn_wizard

/obj/traitorifier/changeling
	name = "Fleshy Protuberance"
	desc = "Join ussssssss"
	attachedObjective = "EAT"
	icon = 'icons/misc/meatland.dmi'
	icon_state = "ganglion0"

	makeAntag(mob/M as mob)
		M.mind.special_role = "changeling"
		M.show_text("<h2><font color=red><B>You have mutated into a changeling!</B></font></h2>", "red")
		M.make_changeling()

/obj/traitorifier/vampire
	name = "Fang-Marked Coffin"
	desc = "The children of the night make such beautiful music."
	attachedObjective = "Convert an army of minions, wear a cloak, say 'bluh' a lot."
	icon = 'icons/obj/large_storage.dmi'
	icon_state = "coffin"
	color = "#FF0000"

	makeAntag(mob/M as mob)
		M.mind.special_role = "vampire"
		M.show_text("<h2><font color=red><B>You have joined the ranks of the undead and are now a vampire!</B></font></h2>", "red")
		M.make_vampire()

/obj/traitorifier/wrestler
	name = "VERY Haunted Championship Belt"
	desc = "You feel more awesome just looking at this thing."
	attachedObjective = "Climb to the top of the mountain!"
	icon = 'icons/obj/belts.dmi'
	icon_state = "machobelt"

	makeAntag(mob/M as mob)
		M.mind.special_role = "wrestler"
		M.show_text("<h2><font color=red><B>You feel an urgent need to wrestle!</B></font></h2>", "red")
		M.make_wrestler(1)

/obj/traitorifier/hunter
	name = "Ferocious Alien Skull"
	desc = "Fancy a game?"
	attachedObjective = "Blood, blood, blood!"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "skullP"
	color = "#FF0000"

	makeAntag(mob/M as mob)
		M.mind.special_role = "hunter"
		M.mind.assigned_role = "Hunter"
		M.show_text("<h2><font color=red><B>You have become a hunter!</B></font></h2>", "red")
		M.make_hunter()

/obj/traitorifier/werewolf
	name = "Shadowy Dog Thing"
	desc = "Awooo?"
	attachedObjective = "Awoooooooooo"
	icon = 'icons/misc/critter.dmi'
	icon_state = "george"
	color = "#000000"

	makeAntag(mob/M as mob)
		M.mind.special_role = "werewolf"
		M.show_text("<h2><font color=red><B>You have become a werewolf!</B></font></h2>", "red")
		M.make_werewolf()

/obj/traitorifier/omnitraitor
	name = "Ugly Amalgamation"
	desc = "For the person who wants everything."
	attachedObjective = "Try not to kill yourself with your own power."
	icon = 'icons/effects/fire.dmi'
	icon_state = "1old"

	makeAntag(mob/M as mob)
		M.mind.special_role = "omnitraitor"
		M.verbs += /client/proc/gearspawn_traitor
		M.verbs += /client/proc/gearspawn_wizard
		M.make_changeling()
		M.make_vampire()
		M.make_werewolf()
		M.make_wrestler(1)
		M.make_grinch()
		M.show_text("<h2><font color=red><B>You have become an omnitraitor!</B></font></h2>", "red")
		SHOW_TRAITOR_OMNI_TIPS(M)

/obj/traitorifier/wraith
	name = "Spooky Pool"
	desc = "The void calls."
	icon = 'icons/effects/3dimension.dmi'
	icon_state = "fissure"
	attachedObjective = "Make them suffer."

	makeAntag(mob/M as mob)
		M.make_wraith()

/obj/traitorifier/blob
	name = "Viscous Puddle"
	desc = "This does not look refreshing."
	icon = 'icons/mob/blob.dmi'
	icon_state = "nucleus"
	color = "#44FF44"
	attachedObjective = "GET FAT"

	makeAntag(mob/M as mob)
		M.make_blob()