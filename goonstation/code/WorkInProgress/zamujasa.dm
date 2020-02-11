/obj/very_important_wire
	name = "very conspicuous cable"
	desc = "Some sort of cabling that runs under the floor. Looks pretty important."
	density = 0
	anchored = 1
	icon = 'icons/obj/power_cond.dmi'
	icon_state = "1-10"
	layer = CABLE_LAYER
	color = "#037ffc"

	attackby(obj/item/W as obj, mob/user as mob)
		if (issnippingtool(W))
			logTheThing("station", user, null, "cut the don't-cut-this wire and got ghosted/disconnected as a result.")
			//boutput(user, "<span style=\"color:red\">You snip the ca</span>")
			user.visible_message("[user] nearly snips the cable with \the [W], but suddenly freezes in place just before it cuts!", "<span style=\"color:red\">You snip the ca</span>")
			var/client/C = user.client
			user.ghostize()
			del(C)
			return

		..()
		return

