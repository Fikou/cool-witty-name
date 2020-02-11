/*
Afterlife Stuff - Some fun (or unfun) places for the dead to mess about in.
Contents:
Afterlife bar areas
Hell area (send people here if they die in a shameful way)
*/
/area/afterlife


/area/afterlife/bar
	name = "The Afterlife Bar"
	skip_sims = 1
	sims_score = 100
	icon_state = "afterlife_bar"
	requires_power = 0
	teleport_blocked = 1

/area/afterlife/bar/barspawn
	name = "The Afterlife Bar"
	skip_sims = 1
	sims_score = 100
	icon_state = "afterlife_bar_spawn"
	requires_power = 0
	teleport_blocked = 1

/area/afterlife/hell
	name = "hell"
	skip_sims = 1
	sims_score = 0
	icon_state = "afterlife_hell"
	requires_power = 0
	teleport_blocked = 1

/area/afterlife/hell/hellspawn
	name = "hellspawn"
	skip_sims = 1
	sims_score = 0
	icon_state = "afterlife_hell_spawn"
	requires_power = 0
	teleport_blocked = 1

/area/afterlife/arena
	name = "THE ARENA"
	skip_sims = 1
	sims_score = 0
	icon_state = "afterlife_hell"
	requires_power = 0
	teleport_blocked = 1

/area/afterlife/arenaspawn
	name = "THE ARENA SPAWN"
	skip_sims = 1
	sims_score = 0
	icon_state = "afterlife_hell_spawn"
	requires_power = 0
	teleport_blocked = 1

proc/inafterlifebar(var/mob/M as mob in world)
	return istype(get_area(M),/area/afterlife/bar)

proc/inafterlife(var/mob/M as mob in world)
	return istype(get_area(M),/area/afterlife)