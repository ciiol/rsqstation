

//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as")

/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "\red Speech is currently admin-disabled."
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		src << "<font color='red'>Error: Admin-PM: You cannot send adminhelps (Muted).</font>"
		return
	if(src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	/**src.verbs -= /client/verb/adminhelp

	spawn(1200)
		src.verbs += /client/verb/adminhelp	// 2 minute cool-down for adminhelps
		src.verbs += /client/verb/adminhelp	// 2 minute cool-down for adminhelps//Go to hell
	**/

	//clean the input msg
	if(!msg)	return
	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg)	return
	//Here is cutted part of code by reason of bugs with russian language
	var/ref_mob = "\ref[mob]"

	msg = "\blue <b><font color=red>HELP: </font>[key_name(src, 1)] (<A HREF='?_src_=holder;adminmoreinfo=[ref_mob]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=[ref_mob]'>PP</A>) (<A HREF='?_src_=vars;Vars=[ref_mob]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=[ref_mob]'>SM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=[ref_mob]'>JMP</A>) (<A HREF='?_src_=holder;check_antagonist=1'>CA</A>):</b> [msg]"

	//send this msg to all admins
	var/admin_number_afk = 0
	for(var/client/X in admins)
		if((R_ADMIN|R_MOD) & X.holder.rights)
			if(X.is_afk())
				admin_number_afk++
			if(X.prefs.toggles & SOUND_ADMINHELP)
				X << 'sound/effects/adminhelp.ogg'
			X << msg

	//show it to the person adminhelping too
	src << "<font color='blue'>PM to-<b>Admins</b>: [msg]</font>"

	var/admin_number_present = admins.len - admin_number_afk
	log_admin("HELP: [key_name(src)]: [msg] - heard by [admin_number_present] non-AFK admins.")
	if(admin_number_present <= 0)
		if(!admin_number_afk)
			send2adminirc("ADMINHELP from [key_name(src)]: [msg] - !!No admins online!!")
		else
			send2adminirc("ADMINHELP from [key_name(src)]: [msg] - !!All admins AFK ([admin_number_afk])!!")
	else
		send2adminirc("ADMINHELP from [key_name(src)]: [msg]")
	feedback_add_details("admin_verb","AH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return
