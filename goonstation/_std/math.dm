//#define CLAMP(V, MN, MX) max(MN, min(MX, V))
#define CLAMP(V, MN, MX) ((V<MN) ? MN : (V>MX) ? MX : V)

/proc/atan2(x, y)
	if(!x && !y) return 0
	.= y >= 0 ? arccos(x / sqrt(x * x + y * y)) : -arccos(x / sqrt(x * x + y * y))

/proc/angledifference(a1,a2) //difference in degrees between two angles in degrees
	.= ( a2 - a1 + 180 ) % 360 - 180
	if (. < -180)
		.+= 360

/proc/sign(x) //Should get bonus points for being the most compact code in the world!
	return x!=0?x/abs(x):0

/proc/clamp(var/number, var/min, var/max)
	return max(min(number, max), min)