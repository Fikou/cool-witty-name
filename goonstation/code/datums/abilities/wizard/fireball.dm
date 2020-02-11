/datum/projectile/fireball
	name = "a fireball"
	icon_state = "fireball"
	icon = 'icons/obj/wizard.dmi'
	shot_sound = 'sound/effects/mag_fireballlaunch.ogg'

	on_hit(atom/hit, direction, var/obj/projectile/projectile)
		var/turf/T = get_turf(hit)
		if (projectile.mob_shooter && projectile.mob_shooter:wizard_spellpower())
			explosion(projectile, T, -1, -1, 2, 2)
		else if(projectile.mob_shooter)
			if(prob(50))
				explosion(projectile, T, -1, -1, 1, 1)
			boutput(projectile.mob_shooter, "<span style='color:blue'>Your spell is weakened without a staff to channel it.</span>")
		fireflash(T, 1, 1)

/datum/targetable/spell/fireball
	name = "Fireball"
	desc = "Launches an explosive fireball at the target."
	icon_state = "fireball"
	targeted = 1
	target_anything = 1
	cooldown = 350
	requires_robes = 1
	offensive = 1
	sticky = 1

	var/datum/projectile/fireball/fb_proj = new

	cast(atom/target)
		holder.owner.say("MHOL HOTTOV")
		var/mob/living/carbon/human/O = holder.owner
		if(O && istype(O.wear_suit, /obj/item/clothing/suit/wizrobe/necro) && istype(O.head, /obj/item/clothing/head/wizard/necro))
			playsound(holder.owner.loc, "sound/voice/wizard/FireballGrim.ogg", 50, 0, -1)
		else if(holder.owner.gender == "female")
			playsound(holder.owner.loc, "sound/voice/wizard/FireballFem.ogg", 50, 0, -1)
		else
			playsound(holder.owner.loc, "sound/voice/wizard/FireballLoud.ogg", 50, 0, -1)


		var/obj/projectile/P = initialize_projectile_ST( holder.owner, fb_proj, target )
		if (P)
			P.mob_shooter = holder.owner
			P.launch()