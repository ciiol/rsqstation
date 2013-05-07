//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31


/obj/machinery/computer/security
	name = "Security Cameras"
	desc = "Used to access the various cameras on the station."
	icon_state = "cameras"
	circuit = "/obj/item/weapon/circuitboard/security"
	var/mob/aiEye/eyeobj = null
	var/last_pic = 1.0
	var/list/network = list("SS13")
	var/mapping = 0//For the overview file, interesting bit of code.

	New()
		eyeobj = new/mob/aiEye
		eyeobj.loc = loc
		..()

	attack_ai(var/mob/user as mob)
		return attack_hand(user)


	attack_paw(var/mob/user as mob)
		return attack_hand(user)


	check_eye(var/mob/user as mob)
		if ((get_dist(user, src) > 1 || !( user.canmove ) || user.blinded) && (!istype(user, /mob/living/silicon)))
			user.unset_machine()
			return null
		user.sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
		return 1


	attack_hand(var/mob/user as mob)
		if (src.z > 6)
			user << "\red <b>Unable to establish a connection</b>: \black You're too far away from the station!"
			return
		if(stat & (NOPOWER|BROKEN))	return

		if(!isAI(user))
			user.set_machine(src)

		if ((get_dist(user, src) > 1 || user.machine != src || user.blinded || !( user.canmove )) && (!istype(user, /mob/living/silicon/ai)))
			return 0
		else
			cameranet.visibility(eyeobj)
			user.client.eye = eyeobj
			eyeobj.ai = user
			use_power(50)

/client/proc/SCameraMove(n, direct, var/mob/aiEye/eyeobj)
	// Simpified version of AIMove
	var/initial = 20
	for(var/i = 0; i < initial; i += 20)
		var/turf/step = get_turf(get_step(eyeobj, direct))
		if(step)
			eyeobj.loc = step
			cameranet.visibility(eyeobj)

/obj/machinery/computer/security/telescreen
	name = "Telescreen"
	desc = "Used for watching an empty arena."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "telescreen"
	network = list("thunder")
	density = 0
	circuit = null

/obj/machinery/computer/security/telescreen/update_icon()
	icon_state = initial(icon_state)
	if(stat & BROKEN)
		icon_state += "b"
	return

/obj/machinery/computer/security/telescreen/entertainment
	name = "entertainment monitor"
	desc = "Damn, they better have /tg/thechannel on these things."
	icon = 'icons/obj/status_display.dmi'
	icon_state = "entertainment"
	network = list("thunder")
	density = 0
	circuit = null


/obj/machinery/computer/security/wooden_tv
	name = "Security Cameras"
	desc = "An old TV hooked into the stations camera network."
	icon_state = "security_det"


/obj/machinery/computer/security/mining
	name = "Outpost Cameras"
	desc = "Used to access the various cameras on the outpost."
	icon_state = "miningcameras"
	network = list("MINE")
	circuit = "/obj/item/weapon/circuitboard/mining"
