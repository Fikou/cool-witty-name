//!! MAKE SURE YOU CHECK FOR APPLYAOE AND DO NOT APPLY AOE IF IT IS 1.
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!^ ^^^ ^^^^

/datum/ritualComponent
	aer
		id = "aer"
		name = "Aer"
		icon_symbol = "aer"
		desc = "The sigil of air."
		ritualFlags = RITUAL_FLAG_CREATE | RITUAL_FLAG_MODIFY

		flag_modify(var/datum/ritualVars/V, var/atom/A, var/applyaoe=1)
			ritualEffect(get_turf(A), "air")
			var/list/targetsplusaoe = list()

			if(V.aoe && applyaoe)
				for(var/atom/X in view(V.aoe, A))
					if(X.type == A.type)
						targetsplusaoe += A
			else
				targetsplusaoe += A

			for(var/T in targetsplusaoe)
				if(ismob(T))
					SPAWN_DBG(0)
						var/mob/M = T
						M.losebreath = max(M.losebreath-round(V.strength), 0)
						if(hasvar(M, "oxyloss"))
							M:oxyloss = max(M:oxyloss-round(V.strength*1.5), 0)
						M.emote("cough")
				else if(isobj(T))
					SPAWN_DBG(0)
						T:setProperty("stamcost", min(round(V.strength/6),1))
						SPAWN_DBG(max(200*V.strength, 30))
							if(T)
								T:setProperty("stamcost", 0)
						animate_float(T)
				else if(isturf(T))
					SPAWN_DBG(0) flag_create(V, T, 0)
			return A

		flag_create(var/datum/ritualVars/V, var/atom/loc, var/applyaoe=1)
			if(V.aoe <= 0 || !applyaoe)
				ritualEffect(get_turf(loc), "air")
				var/datum/gas_mixture/GM = loc.return_air()
				var/amount = (max(1.5*V.strength, 1)) * CELL_VOLUME //FUCK IF I KNOW WHAT GOES HERE FUCK
				if (istype(GM))
					GM.oxygen += amount
					loc.assume_air(GM)
			else
				for(var/turf/T in view(V.aoe, loc))
					ritualEffect(get_turf(T), "air")
					var/datum/gas_mixture/GM = T.return_air()
					var/amount = (max(1.055*V.strength, 1)) * CELL_VOLUME //FUCK IF I KNOW WHAT GOES HERE FUCK. Also weaker version for AOE.
					if (istype(GM))
						GM.oxygen += amount
						T.assume_air(GM)
			return list()

	terra
		id = "terra"
		name = "Terra"
		icon_symbol = "terra"
		desc = "The sigil of earth."
		ritualFlags = RITUAL_FLAG_CREATE | RITUAL_FLAG_MODIFY

		flag_modify(var/datum/ritualVars/V, var/atom/A, var/applyaoe=1)
			ritualEffect(get_turf(A), "earth")
			if(ismob(A))
				SPAWN_DBG(0)
					A.changeStatus("stonerit", 120*V.strength)
			else if(isobj(A))
				SPAWN_DBG(0)
					A.setMaterial(getMaterial("rock"))
					A.changeStatus("stonerit", 120*V.strength)
			else if(isturf(A))
				SPAWN_DBG(0) A.setMaterial(getMaterial("rock"))
			return A

		flag_create(var/datum/ritualVars/V, var/atom/loc, var/applyaoe=1)
			var/list/created = list()
			if(V.aoe <= 0 || !applyaoe)
				var/spawnType = /obj/item/raw_material/rock
				ritualEffect(get_turf(loc), "earth")
				switch(V.strength)
					if(1 to 3)
						spawnType = pick(/obj/item/raw_material/rock,/obj/item/raw_material/char,/obj/item/raw_material/mauxite, /obj/item/raw_material/molitz)
					if(4 to 7)
						spawnType = pick(/obj/item/raw_material/pharosium,/obj/item/raw_material/plasmastone,/obj/item/raw_material/cerenkite)
					if(8 to 14)
						spawnType = pick(/obj/item/raw_material/gemstone,/obj/item/raw_material/uqill,/obj/item/raw_material/erebite,/obj/item/raw_material/syreline,/obj/item/raw_material/cobryl)
					if(15 to 29)
						spawnType = pick(/obj/item/raw_material/miracle,/obj/item/raw_material/martian,/obj/item/raw_material/eldritch,/obj/item/raw_material/telecrystal)
					if(30 to INFINITY)
						spawnType = pick(/obj/item/raw_material/starstone)

				for(var/i=0, i<rand(5,15)+round(V.strength/10), i++)
					var/obj/item/I = unpool(spawnType)
					I.set_loc(loc)
					created.Add(I)
			else
				for(var/turf/T in view(V.aoe, loc))
					var/spawnType = /turf/simulated/wall/asteroid
					switch(V.strength)
						if(1 to 6)
							spawnType = /turf/simulated/wall/asteroid/dark
						if(7 to INFINITY)
							spawnType = /turf/simulated/wall/asteroid/geode
					created.Add(new spawnType(T))

			return created

	aqua
		id = "aqua"
		name = "Aqua"
		icon_symbol = "aqua"
		desc = "The sigil of water."
		ritualFlags = RITUAL_FLAG_CREATE | RITUAL_FLAG_MODIFY

		flag_modify(var/datum/ritualVars/V, var/atom/A, var/applyaoe=1)
			ritualEffect(get_turf(A), "water")
			if(ismob(A))
				SPAWN_DBG(0) A.delStatus("burning")
			else if(isobj(A))
				SPAWN_DBG(0) A.temperature_expose(null, TCMB, CELL_VOLUME)
			else if(isturf(A))
				SPAWN_DBG(0) flag_create(V, A)
			return A

		flag_create(var/datum/ritualVars/V, var/atom/loc, var/applyaoe=1)
			if(V.aoe <= 0 || !applyaoe)
				ritualEffect(get_turf(loc), "water")
				var/amount = 50 + (round(V.strength**1.5) * 100)
				var/datum/reagents/R = new /datum/reagents(amount)
				R.add_reagent("water", amount)
				var/turf/T = get_turf(loc)
				if (istype(T))
					R.reaction(T,TOUCH)
					R.clear_reagents()
			else
				for(var/turf/T in view(V.aoe, loc))
					ritualEffect(get_turf(T), "water")
					var/amount = 50 + (round(V.strength**1.055) * 100)
					var/datum/reagents/R = new /datum/reagents(amount)
					R.add_reagent("water", amount)
					var/turf/TU = get_turf(T)
					if (istype(TU))
						R.reaction(TU,TOUCH)
						R.clear_reagents()
			return list()

	ignis
		id = "ignis"
		name = "Ignis"
		icon_symbol = "ignis"
		desc = "The sigil of fire."
		ritualFlags = RITUAL_FLAG_CREATE | RITUAL_FLAG_MODIFY

		flag_modify(var/datum/ritualVars/V, var/atom/A, var/applyaoe=1)
			ritualEffect(get_turf(A), "fire")
			if(V.corrupted > 0)
				A.changeStatus("burning", 120*V.strength, BURNING_LV3)
			else
				if(ismob(A))
					SPAWN_DBG(0) A.changeStatus("firerit", 120*V.strength)
				else if(isobj(A))
					SPAWN_DBG(0)
						A.changeStatus("firerit", 120*V.strength)
						A.temperature_expose(null, PLASMA_MINIMUM_BURN_TEMPERATURE+500, CELL_VOLUME)
				else if(isturf(A))
					SPAWN_DBG(0) A:hotspot_expose(PLASMA_MINIMUM_BURN_TEMPERATURE+200, CELL_VOLUME)
			return A

		flag_create(var/datum/ritualVars/V, var/atom/loc, var/applyaoe=1)
			if(V.aoe <= 0 || !applyaoe)
				ritualEffect(get_turf(loc), "fire")
				SPAWN_DBG(0) fireflash(loc, 1, 1)
			else
				ritualEffect(get_turf(loc), "fire")
				SPAWN_DBG(0) fireflash(loc, V.aoe, 1)
			return list()

	obscurum
		id = "obscurum"
		name = "Obscurum"
		icon_symbol = "obscurum"
		desc = "The sigil of darkness."
		ritualFlags = RITUAL_FLAG_CREATE | RITUAL_FLAG_MODIFY

		flag_modify(var/datum/ritualVars/V, var/atom/A, var/applyaoe=1)
			if(ismob(A))
				SPAWN_DBG(0) A.changeStatus("cloaked", max(200*V.strength, 30))
			else if(isobj(A))
				SPAWN_DBG(0) A.changeStatus("cloaked", max(200*V.strength, 30))
			else if(isturf(A))
				SPAWN_DBG(0) animate_fade_to_color_fill(A,"#111111",30)
				SPAWN_DBG(max(100*V.strength, 30))
					if(A)
						animate_fade_to_color_fill(A,"#FFFFFF",30)
			return A

		flag_create(var/datum/ritualVars/V, var/atom/loc, var/applyaoe=1)
			var/list/created = list()
			if(V.aoe <= 0 || !applyaoe)
				if(V.corrupted > 0)
					created.Add(new/obj/chaplainStuff/darkness/evil(loc,max(200*V.strength, 30)))
				else
					created.Add(new/obj/chaplainStuff/darkness(loc,max(200*V.strength, 30)))
			else
				for(var/turf/T in view(V.aoe, loc))
					if(V.corrupted > 0)
						created.Add(new/obj/chaplainStuff/darkness/evil(T,max(150*V.strength, 30)))
					else
						created.Add(new/obj/chaplainStuff/darkness(T,max(150*V.strength, 30)))
			return created

	motus
		id = "motus"
		name = "Motus"
		icon_symbol = "motus"
		desc = "The sigil of movement."
		ritualFlags = RITUAL_FLAG_MODIFY

		flag_modify(var/datum/ritualVars/V, var/atom/A, var/applyaoe=1)
			if(isobj(A))
				SPAWN_DBG(0) A:throw_at(pick(oview(10,A)-oview(2,A)), 20, 2)
			else if (ismob(A))
				SPAWN_DBG(0)
					if(V.corrupted > 0)
						A.changeStatus("slowed", max(200*V.strength, 30))
					else
						A.changeStatus("hastened", max(200*V.strength, 30))
			else if (isturf(A))
				A:wet += 2
				SPAWN_DBG(max(20*V.strength, 20))
					if(A) A:wet -= 2
			return A

	apis
		id = "apis"
		name = "Apis"
		icon_symbol = "apis"
		desc = "The sigil of BEES."
		ritualFlags = RITUAL_FLAG_CREATE | RITUAL_FLAG_MODIFY

		flag_modify(var/datum/ritualVars/V, var/atom/A, var/applyaoe=1)
			if(ismob(A))
				SPAWN_DBG(0)
					for(var/obj/item/I in A)
						I.setMaterial(getMaterial("beewool"))
					if(istype(A,/mob/living/carbon/human))
						A:update_clothing()
			else if(isobj(A))
				SPAWN_DBG(0) A.setMaterial(getMaterial("beewool"))
			else if(isturf(A))
				SPAWN_DBG(0) A.setMaterial(getMaterial("beewool"))
			return A

		flag_create(var/datum/ritualVars/V, var/atom/loc, var/applyaoe=1)
			var/list/created = list()
			if(V.aoe <= 0 || !applyaoe)
				var/spawnType = /obj/critter/domestic_bee_larva
				if(V.corrupted > 0)
					switch(V.strength)
						if(1 to 9)
							spawnType = /obj/critter/domestic_bee/zombee
						if(10 to INFINITY)
							spawnType = /obj/critter/domestic_bee/zombee/lich
				else
					switch(V.strength)
						if(1 to 2)
							spawnType = /obj/critter/domestic_bee_larva
						if(3 to 5)
							spawnType = /obj/critter/domestic_bee/small
						if(6 to 8)
							spawnType = /obj/critter/domestic_bee
						if(9 to INFINITY)
							spawnType = /obj/critter/domestic_bee/fancy
					created.Add(new spawnType(loc))
			else
				var/spawnType = /obj/critter/domestic_bee/small
				for(var/turf/T in view(V.aoe, loc))
					created.Add(new spawnType(loc))
			return created

	sanguis
		id = "sanguis"
		name = "Sanguis"
		icon_symbol = "sanguis"
		desc = "The sigil of blood. Consumes blood on itself to provide power. Use sacrifical dagger on blood on this sigil to store power."
		ritualFlags = RITUAL_FLAG_ENERGY | RITUAL_FLAG_CONSUME
		var/maxPower = 5
		var/storedPower = 0

		flag_consume()
			var/list/destroy = list()
			var/power = 0

			if(owner)
				var/turf/T = get_turf(owner)
				for(var/obj/O in T)
					if(istype(O,/obj/decal/cleanable/blood))
						var/obj/decal/cleanable/blood/B = O
						power += 1
						destroy += B

					if(istype(O,/obj/fluid))
						var/obj/fluid/B = O
						if (B.group.master_reagent_name == "blood")
							power += 1

				if(destroy.len)
					for(var/obj/fluid/B in destroy)
						destroy -= B
						B.removed(0)
					for(var/obj/O in destroy)
						pool(O)
				storedPower += min(power,maxPower)
				return

		flag_power(var/datum/ritualVars/V, var/consume=1)
			V.energy += storedPower
			if(consume) storedPower = 0
			return V

	exalto
		id = "exalto"
		name = "Exalto"
		icon_symbol = "exalto"
		desc = "The sigil of power. Provides 1 strength if it's the only one of it's kind."
		ritualFlags = RITUAL_FLAG_STRENGTH

		flag_strength(var/datum/ritualVars/V, var/consume=1)
			if(ownerAnchor)
				var/list/powerComps = ownerAnchor.getFlagged(RITUAL_FLAG_STRENGTH, list(src))
				for(var/datum/ritualComponent/C in powerComps)
					if(C.id == "exalto") return V
				V.strength += 1
				return V
			return V

	sanctus
		id = "sanctus"
		name = "Sanctus"
		icon_symbol = "sanctus"
		desc = "Holy sigil. Lowers the corruption level of the ritual."
		ritualFlags = RITUAL_FLAG_MODIFY | RITUAL_FLAG_HOLY
		selectable = 0

		flag_corruption(var/datum/ritualVars/V)
			V.corrupted -= 1
			return V

		flag_modify(var/datum/ritualVars/V, var/atom/A, var/applyaoe=1)
			if(isobj(A))
				if(istype(A, /obj/item/ritualChalk))
					var/obj/item/ritualChalk/C = A
					if(!C.blessed)
						C.cursed = 0
						C.blessed = 1
						C.filters = filter(type="drop_shadow", x=0, y=0, offset=0, size=5, border=3, color="#f2e8a7")
						C.addButton(new src.type())
						C.remove_prefixes(2)
						C.name_prefix("sanctified")
						C.UpdateName()
			return A

	corruptus
		id = "corruptus"
		name = "Corruptus"
		icon_symbol = "corruptus"
		desc = "The sigil of corruption. Corrupts rituals, reversing or changing effects."
		ritualFlags = RITUAL_FLAG_MODIFY | RITUAL_FLAG_UNHOLY
		selectable = 0

		flag_corruption(var/datum/ritualVars/V)
			V.corrupted += 1
			return V

		flag_modify(var/datum/ritualVars/V, var/atom/A, var/applyaoe=1)
			if(isobj(A))
				if(istype(A, /obj/item/ritualChalk))
					var/obj/item/ritualChalk/C = A
					if(!C.cursed)
						C.cursed = 1
						C.blessed = 0
						C.filters = filter(type="drop_shadow", x=0, y=0, offset=0, size=5, border=3, color="#b023fc")
						C.addButton(new src.type())
						C.remove_prefixes(2)
						C.name_prefix("cursed")
						C.UpdateName()
			return A

	sacrificum
		id = "sacrificum"
		name = "Sacrificum"
		icon_symbol = "sacrificum"
		desc = "The sigil of sacrifice. Provides power/strength for money, people, limbs or spirit shards sacrificed. Use sacrifical dagger on things on this sigil to store power."
		ritualFlags = RITUAL_FLAG_ENERGY | RITUAL_FLAG_STRENGTH | RITUAL_FLAG_CONSUME
		var/maxPower = 10
		var/maxObjects = 3
		var/storedPower = 0
		var/storedStrength = 0
		var/corrupted = 0

		flag_consume()
			var/list/destroy = list()
			var/power = 0
			var/strength = 0
			var/count = 0

			if(owner)
				var/turf/T = get_turf(owner)
				for(var/mob/M in T)
					if(++count > maxObjects) break
					if(!M.lying && !M.resting && !M.stat) continue
					if(M.client)
						power += 12 //Things without clients give much less.
						strength += 12
						if(prob(50))
							corrupted = max(corrupted, 1)
					else
						power += 3
						strength += 3
						if(prob(5))
							corrupted = max(corrupted, 1)
					destroy += M

				for(var/obj/O in T)
					if(istype(O,/obj/item/spacecash))
						if(++count > maxObjects) break
						power += round(O:amount / 2000) //Money is power. Specifically energy for magic rituals. Not strength.
						destroy += O

					if(istype(O,/obj/item/parts/human_parts))
						if(++count > maxObjects) break
						power += 1
						strength += 1
						destroy += O

					if(istype(O,/obj/item/spiritshard))
						if(++count > maxObjects) break
						var/obj/item/spiritshard/S = O
						strength += S.storedStrength
						power += S.storedPower
						destroy += O
						if(S.corrupted)
							corrupted += 1

				if(destroy.len)
					for(var/mob/M in destroy)
						M.vaporize(0, 1)
					for(var/obj/O in destroy)
						for(var/mob/M in O)
							M.set_loc(O.loc)
						qdel(O)

					storedPower += power
					storedStrength += strength
			return

		flag_power(var/datum/ritualVars/V, var/consume=1)
			V.energy += storedPower
			if(consume)
				storedPower = 0
				if(corrupted > 0)
					V.corrupted += corrupted
			return V

		flag_strength(var/datum/ritualVars/V, var/consume=1)
			V.strength += storedStrength
			if(consume) storedStrength = 0
			return V

	spatium
		id = "spatium"
		name = "Spatium"
		icon_symbol = "spatium"
		desc = "The sigil of space. Can be used to increase the area of effect of rituals based on ritual strength at the cost of 5 energy."
		ritualFlags = RITUAL_FLAG_RANGE | RITUAL_FLAG_ENERGY

		flag_strength(var/datum/ritualVars/V)
			V.energy -= 5
			return V

		flag_range(var/datum/ritualVars/V)
			var/range = 1
			if(ownerAnchor && ownerAnchor.owner)
				range = max(round(V.strength / 4),1)
			V.aoe += range
			return V

	extendo
		id = "extendo"
		name = "Extendo"
		icon_symbol = "extendo"
		desc = "The sigil of reach. Can be used to increase the targeting range of rituals for 2 energy."
		ritualFlags = RITUAL_FLAG_RANGE | RITUAL_FLAG_ENERGY

		flag_strength(var/datum/ritualVars/V)
			V.energy -= 2
			return V

		flag_range(var/datum/ritualVars/V)
			var/range = 1
			if(ownerAnchor && ownerAnchor.owner)
				range = max(round(V.strength / 2),1)
			V.range = range
			return V

	persisto
		id = "persisto"
		name = "Persisto"
		icon_symbol = "persisto"
		desc = "The sigil of persistence. Prevents sigils from disappearing but costs 3 energy."
		ritualFlags = RITUAL_FLAG_PERSIST | RITUAL_FLAG_ENERGY

		flag_power(var/datum/ritualVars/V)
			V.energy -= 3
			return V

	hominem
		id = "hominem"
		name = "Hominem"
		icon_symbol = "hominem"
		desc = "The sigil of humans. Can be used to target nearby humans. If blood or bodyparts are placed on top, the owner will be targeted, if within range. Targeting a specific person costs 5 additional energy."
		ritualFlags = RITUAL_FLAG_CREATE | RITUAL_FLAG_SELECT | RITUAL_FLAG_ENERGY

		flag_power(var/datum/ritualVars/V)
			V.energy -= 1
			return V

		flag_create(var/datum/ritualVars/V, var/atom/loc, var/applyaoe=1)
			var/list/created = list()
			for(var/turf/T in view(V.aoe, loc))
				if(V.aoe <= 0 || !applyaoe)
					if(V.corrupted > 0)
						created.Add(new/obj/critter/zombie(T))
					else
						created.Add(new/mob/living/carbon/human/normal(T))
				else
					created.Add(new/turf/simulated/martian/floor(T))
			return created

		flag_select(var/datum/ritualVars/V)
			var/targetMax = max(round(V.strength / 5),1)
			var/list/targets = list()
			var/count = 0

			var/turf/T = get_turf(owner)
			var/mob/specificTarget = null

			for(var/obj/O in T)
				if(istype(O,/obj/decal/cleanable/blood))
					var/obj/decal/cleanable/blood/B = O
					for(var/mob/living/carbon/human/H in mobs)
						if(B.blood_DNA == H.bioHolder.Uid)
							specificTarget = H
							break

				if(istype(O,/obj/fluid))
					var/obj/fluid/B = O
					if (B.group.master_reagent_name == "blood")
						for(var/mob/living/carbon/human/H in mobs)
							if(B.blood_DNA == H.bioHolder.Uid)
								specificTarget = H
								break

				if(istype(O,/obj/item/parts/human_parts))
					var/obj/item/parts/human_parts/P = O
					if(P.original_holder)
						specificTarget = P.original_holder

			if(specificTarget)
				V.energy -= 5
				V.targets = list(specificTarget)
			else
				for(var/mob/M in view(RITUAL_BASE_RANGE+V.range, owner))
					if(ishuman(M))
						targets += M
						count++
						if(count >= targetMax) break
				V.targets = targets
			return V

	objectum
		id = "objectum"
		name = "Objectum"
		icon_symbol = "objectum"
		desc = "The sigil of objects. Can be used to target objects on the sigil or nearby objects if additional range is added."
		ritualFlags = RITUAL_FLAG_SELECT | RITUAL_FLAG_ENERGY

		flag_power(var/datum/ritualVars/V)
			V.energy -= 1
			return V

		flag_select(var/datum/ritualVars/V)
			var/targetMax = max(round(V.strength / 5),1)
			var/list/targets = list()
			var/count = 0
			for(var/obj/M in view(0+V.range, owner))
				if(isobj(M))
					if(istype(M, /obj/overlay)) continue
					if(istype(M, /obj/decal)) continue
					if(istype(M, /obj/effects)) continue
					if(M.invisibility) continue
					targets += M
					count++
					if(count >= targetMax) break

			V.targets = targets
			return V

	conditum
		id = "conditum"
		name = "Conditum"
		icon_symbol = "conditum"
		desc = "When used as the core of a ritual, this will store all excess power and strength in a spirit shard."
		ritualFlags = RITUAL_FLAG_CORE | RITUAL_FLAG_ENERGY | RITUAL_FLAG_STRENGTH

		//Costs one of each to counter the baseline 1/1 we have.
		flag_power(var/datum/ritualVars/V, var/consume=1)
			V.energy -= 1
			return V

		flag_strength(var/datum/ritualVars/V, var/consume=1)
			V.strength -= 1
			return V

		flag_core(var/datum/ritualVars/V)
			if(owner)
				if(V.energy || V.strength)
					new/obj/item/spiritshard(get_turf(owner),V)
			return 1

	sano
		id = "sano"
		name = "Sano"
		icon_symbol = "sano"
		desc = "The sigil of healing."
		ritualFlags = RITUAL_FLAG_CORE | RITUAL_FLAG_MODIFY

		flag_modify(var/datum/ritualVars/V, var/atom/A, var/applyaoe=1)
			if (ismob(A) && V.corrupted <= 0)
				SPAWN_DBG(0) A.changeStatus("ritual_hot", max(200*V.strength, 30))
			else if (ismob(A) && V.corrupted > 0)
				SPAWN_DBG(0) A.changeStatus("ritual_dot", max(200*V.strength, 30))
			return A

		flag_core(var/datum/ritualVars/V)
			if(ownerAnchor)
				if(V.aoe <= 0)
					if(V.targets.len <= 0) V.targets.Add(get_turf(ownerAnchor.owner))
					for(var/atom/A in V.targets)
						for(var/mob/M in view(V.aoe, A))
							ritualEffect(get_turf(M), "heal")
							if(ismob(M))
								var/mob/tMob = M
								if(V.corrupted > 0)
									tMob.TakeDamage("All", round(V.strength/3)+V.strength, round(V.strength/3)+V.strength, round(V.strength/3)+V.strength, DAMAGE_BLUNT)
								else
									tMob.HealDamage("All", round(V.strength/3)+V.strength, round(V.strength/3)+V.strength, round(V.strength/3)+V.strength)
			return 1

	mutatio
		id = "mutatio"
		name = "Mutatio"
		icon_symbol = "mutatio"
		desc = "The sigil of change."
		ritualFlags = RITUAL_FLAG_CORE

		flag_core(var/datum/ritualVars/V)
			if(ownerAnchor)
				if(V.targets.len <= 0) V.targets.Add(get_turf(ownerAnchor.owner))
				var/list/modify = ownerAnchor.getFlagged(RITUAL_FLAG_MODIFY)
				for(var/atom/M in V.targets)
					for(var/datum/ritualComponent/C in modify)
						C.flag_modify(V, M, 1)
			return 1

	evoco
		id = "evoco"
		name = "Evoco"
		icon_symbol = "evoco"
		desc = "The sigil of summoning."
		ritualFlags = RITUAL_FLAG_CORE | RITUAL_FLAG_ENERGY

		flag_power(var/datum/ritualVars/V)
			V.energy -= 1
			return V

		flag_core(var/datum/ritualVars/V)
			if(ownerAnchor)
				if(V.targets.len <= 0) V.targets.Add(get_turf(ownerAnchor.owner))
				var/list/spawnedThings = list()
				var/datum/ritualComponent/creator = getClosestFlagged(RITUAL_FLAG_CREATE, V.used)
				if(creator)
					for(var/atom/M in V.targets)
						spawnedThings.Add(creator.flag_create(V,M))
				else
					for(var/atom/M in V.targets)
						spawnedThings.Add(make_cleanable(/obj/decal/cleanable/generic,M))

				var/list/modcreate = ownerAnchor.getFlagged(RITUAL_FLAG_MODIFY, (list(src, creator) + V.used))
				for(var/atom/movable/M in spawnedThings)
					for(var/datum/ritualComponent/C in modcreate)
						C.flag_modify(V, M, 0)
						V.strength = max(1,V.strength-1)
			return 1

