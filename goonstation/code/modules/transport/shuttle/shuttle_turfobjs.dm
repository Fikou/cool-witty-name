/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=--=-=-=-SHUTTLE TURFS & OBJS, DUH!-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */


////////////////////////////////////////////////////////////////TURFS
/turf/simulated/shuttle
	name = "shuttle wall"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0

	attackby()
	attack_hand()
	hitby()
	reagent_act()
	bullet_act()
	ex_act()
	blob_act()
	meteorhit()
	damage_heat()
	damage_corrosive()
	damage_piercing()
	damage_slashing()
	damage_blunt()


/turf/simulated/shuttle/wall
	name = "shuttle wall"
	icon_state = "wall"
	var/icon_style = "wall"
	opacity = 1
	density = 1
	blocks_air = 1
	pathable = 0

	New()
		..()
		SPAWN_DBG(60) // patch up some ugly corners in derelict mode
			if (derelict_mode)
				if (src.icon_state == "[src.icon_style]_space")
					src.icon_state = "[src.icon_style]_void"

		return

/turf/simulated/shuttle/wall/escape
	opacity = 0

/turf/simulated/shuttle/wall/corner
	icon_state = "wall_space"
	opacity = 0

/turf/simulated/shuttle/wall/destroyable // for the moveable shuttles, so you can sabotage the research shuttle or whatever
	var/health = 60

	proc/checkthatshit()
		if(src.health <= 0)
			qdel(src)

/turf/space/shuttle_transit
	icon_state = "tplaceholder"

	New()
		..()
		if (icon_state == "tplaceholder") icon_state = "near_blank"

/turf/simulated/shuttle/wall/cockpit
	icon = 'icons/effects/160x160.dmi'
	icon_state = "shuttlecock"
	layer = EFFECTS_LAYER_BASE
	pixel_x = -64
	pixel_y = -64
	opacity = 0

/turf/simulated/shuttle/wall/cockpit/window
	name = "shuttle wall"
	icon_state = "wall1"
	icon = 'icons/turf/shuttle.dmi'
	opacity = 0
	pixel_x = 0
	pixel_y = 0

/turf/simulated/floor/shuttle
	name = "shuttle floor"
	icon_state = "floor"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0

	attackby()
	attack_hand()
	hitby()
	reagent_act()
	bullet_act()
	ex_act()
	blob_act()
	meteorhit()
	damage_heat()
	damage_corrosive()
	damage_piercing()
	damage_slashing()
	damage_blunt()


/turf/unsimulated/wall/auto/shuttle
	icon = 'icons/turf/walls_shuttle.dmi'
	light_mod = "wall-"
	connect_overlay = 1
	connects_to = list(/turf/unsimulated/wall/auto/shuttle, /turf/simulated/wall/false_wall, /obj/machinery/door, /obj/window)
	connects_with_overlay = list(/turf/simulated/wall/false_wall/reinforced, /obj/machinery/door, /obj/window)
/*
	update_neighbors()
		..()
		for (var/obj/window/auto/O in orange(1,src))
			O.update_icon()
*/
	/////////////////////////////////////////////////////////////////OBJECTS

/obj/indestructible/
	anchored = 2

	attackby()
	attack_hand()
	hitby()
	reagent_act()
	bullet_act()
	ex_act()
	blob_act()
	meteorhit()
	damage_heat()
	damage_corrosive()
	damage_piercing()
	damage_slashing()
	damage_blunt()

/obj/indestructible/invisible_block // an invisible thing to stop people walking where they 'aint meant to.
	density = 1
	mouse_opacity = 0

	examine()
		return


/obj/indestructible/invisible_block/opaque
	opacity = 1

	examine()
		return

/obj/indestructible/shuttle_corner
	name = "shuttle wall"
	desc = "A shuttle wall. This appears to be a corner."
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall_space"
	density = 1
	opacity = 0
	layer = EFFECTS_LAYER_BASE - 1