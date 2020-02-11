//hi this does stuff

//What zlevels do we worldgen on?
#define ZL_1 1
#define ZL_5 5

/var/global/list/worldgenCandidates = list() //Turfs add themselves to this

/proc/initialize_worldgen()
	for(var/turf/U in worldgenCandidates)
		if (U.z & (ZL_1 | ZL_5)) //Is this an allowed Z?
			U.generate_worldgen() //Yes!
		LAGCHECK(LAG_REALTIME)

#undef ZL_1
#undef ZL_5