# ------------------------
# WPM LOGIN
# ------------------------

wpm_login() {

	wpm_header "Logged in as $user"
	su -l $user;
}

# ------------------------
# WPM ROOT
# ------------------------

wpm_root() {

	wpm_header "Logged in as root"
	/bin/sh;
}
