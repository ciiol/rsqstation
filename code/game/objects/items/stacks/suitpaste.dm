/obj/item/stack/suitpaste
	name = "suitpaste"
	singular_name = "nanite swarm"
	desc = "A tube of paste containing swarms of nanites. Very effective in constructing space suit from ordinary clothing."
	icon = 'icons/obj/suitpaste.dmi'
	icon_state = "tube"
	origin_tech = "materials=5;engineering=3;biotech=3"
	amount = 5


/obj/item/stack/suitpaste/proc/transform(obj/item/clothing/suit/I, mob/user)
	var/turf/T = get_turf(user)
	user.visible_message("<span class='notice'>\The [user] applies the some [src.name] at [I].</span>",\
	                     "<span class='notice'>You apply the some [src.name] at [I].</span>")
	if(istype(I, /obj/item/clothing/suit/space))
		return
	else if (istype(I, /obj/item/clothing/suit/storage/labcoat/science))
		combine(new/obj/item/clothing/suit/space/anomaly(T), I)
		new/obj/item/clothing/head/helmet/space/anomaly(T)
		I.Del()

	else if (istype(I, /obj/item/clothing/suit/storage/labcoat))
		combine(new/obj/item/clothing/suit/space/rig/medical(T), I)
		new/obj/item/clothing/head/helmet/space/rig/medical(T)
		I.Del()

	else if (istype(I, /obj/item/clothing/suit/storage/hazardvest))
		combine(new/obj/item/clothing/suit/space/rig(T), I)
		new/obj/item/clothing/head/helmet/space/rig(T)
		I.Del()

	else if (istype(I, /obj/item/clothing/suit/storage/hazardvest))
		combine(new/obj/item/clothing/suit/space/rig(T), I)
		new/obj/item/clothing/head/helmet/space/rig(T)
		I.Del()

	else if (istype(I, /obj/item/clothing/suit/fire))
		combine(new/obj/item/clothing/suit/space/rig/atmos(T), I)
		new/obj/item/clothing/head/helmet/space/rig/atmos(T)
		I.Del()

	else if (istype(I, /obj/item/clothing/suit/bomb_suit))
		var/obj/item/clothing/H = new/obj/item/clothing/head/bomb_hood
		combine(new/obj/item/clothing/suit/space(T), I)
		combine(new/obj/item/clothing/head/helmet/space(T), H)
		I.Del()
		H.Del()

	else if (istype(I, /obj/item/clothing/suit/armor/captain))
		var/obj/item/clothing/OH = new/obj/item/clothing/head/helmet/cap
		var/obj/item/clothing/S = combine(new/obj/item/clothing/suit/space(T), I)
		var/obj/item/clothing/H = combine(new/obj/item/clothing/head/helmet/space(T), OH)
		I.Del()
		OH.Del()
		S.icon_state = "ert_commander"
		H.icon_state = "ert_commander"
		S.item_state = "suit-command"
		H.item_state = "helm-command"

	else if (istype(I, /obj/item/clothing/suit/captunic))
		var/obj/item/clothing/S = combine(new/obj/item/clothing/suit/space(T), I)
		var/obj/item/clothing/H = new/obj/item/clothing/head/helmet/space(T)
		I.Del()
		S.icon_state = "ert_commander"
		H.icon_state = "ert_commander"
		S.item_state = "suit-command"
		H.item_state = "helm-command"

	else if (istype(I, /obj/item/clothing/suit/armor))
		combine(new/obj/item/clothing/suit/space/rig/security(T), I)
		new/obj/item/clothing/head/helmet/space/rig/security(T)
		I.Del()

	else
		combine(new/obj/item/clothing/suit/space(T), I)
		new/obj/item/clothing/head/helmet/space(T)
		I.Del()

	user.regenerate_icons()
	use(1)


/obj/item/stack/suitpaste/proc/combine(obj/item/clothing/S, obj/item/clothing/I)
	for(var/atype in S.armor)
		S.armor[atype]=max(I.armor[atype], S.armor[atype])
	S.heat_protection |= I.heat_protection
	S.cold_protection |= I.cold_protection
	S.max_heat_protection_temperature = max(S.max_heat_protection_temperature, I.max_heat_protection_temperature)
	S.desc = I.desc
	return S

