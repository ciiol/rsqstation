/**********************Shuttle Computer**************************/

//copy paste from the mining shuttle

var/arrival_shuttle_tickstomove = 10
var/arrival_shuttle_moving = 0
var/arrival_shuttle_location = 0 // 0 = station 13, 1 = arrival station

proc/move_arrival_shuttle()
	if(arrival_shuttle_moving)	return
	arrival_shuttle_moving = 1
	spawn(arrival_shuttle_tickstomove*10)
		var/area/fromArea
		var/area/toArea
		if (arrival_shuttle_location == 1)
			fromArea = locate(/area/shuttle/arrival/ship)
			toArea = locate(/area/shuttle/arrival/station)
		else
			fromArea = locate(/area/shuttle/arrival/station)
			toArea = locate(/area/shuttle/arrival/ship)


		var/list/dstturfs = list()
		var/throwy = world.maxy

		for(var/turf/T in toArea)
			dstturfs += T
			if(T.y < throwy)
				throwy = T.y

		// hey you, get out of the way!
		for(var/turf/T in dstturfs)
			// find the turf to move things to
			var/turf/D = locate(T.x, throwy - 1, 1)
			//var/turf/E = get_step(D, SOUTH)
			for(var/atom/movable/AM as mob|obj in T)
				AM.Move(D)
				// NOTE: Commenting this out to avoid recreating mass driver glitch
				/*
				spawn(0)
					AM.throw_at(E, 1, 1)
					return
				*/

			if(istype(T, /turf/simulated))
				del(T)

		for(var/mob/living/carbon/bug in toArea) // If someone somehow is still in the shuttle's docking area...
			bug.gib()

		fromArea.move_contents_to(toArea)
		if (arrival_shuttle_location)
			arrival_shuttle_location = 0
			spawn(60)
				if (!arrival_shuttle_moving && arrival_shuttle_location)
					move_arrival_shuttle()
		else
			arrival_shuttle_location = 1
		arrival_shuttle_moving = 0
	return
/obj/machinery/computer/arrival_shuttle
	icon = 'computer.dmi'
	icon_state = "shuttle"
	req_access = list()
	var/hacked = 0
	var/location = 0 //0 = station, 1 = master ship

/obj/machinery/computer/arrival_shuttle/ship
	name = "Arrival Shuttle Ship Console"

/obj/machinery/computer/arrival_shuttle/shuttle
	name = "Arrival Shuttle Console"

/obj/machinery/computer/arrival_shuttle/ship/attack_hand(user as mob)
	src.add_fingerprint(usr)
	var/dat = "<center>arrival shuttle: <b><A href='?src=\ref[src];move=1'>Send</A></b></center><br>"
	user << browse("[dat]", "window=arrivalshuttle;size=200x100")

/obj/machinery/computer/arrival_shuttle/ship/attack_hand(user as mob)
	src.add_fingerprint(usr)
	var/dat
	if (location == 1) // If at ship
		dat = "<center>arrival shuttle: <b><A href='?src=\ref[src];move=1'>Send</A></b></center><br>"
	else
		dat = "<center>Shuttle is waiting commands from the master ship</center><br>"
	user << browse("[dat]", "window=arrivalshuttle;size=200x100")

/obj/machinery/computer/arrival_shuttle/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	src.add_fingerprint(usr)
	if(href_list["move"])
		if (!arrival_shuttle_moving)
			usr << "\blue Shuttle recieved message and will be sent shortly."
			move_arrival_shuttle()
		else
			usr << "\blue Shuttle is already moving."