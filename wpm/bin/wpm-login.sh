# ------------------------
# WPM LOGIN
# ------------------------

wpm_login() {

	wpm_header "Login as $user"
	su -l $user;
}

# ------------------------
# WPM ROOT
# ------------------------

wpm_root() {

	wpm_header "Login as root"
	/bin/sh;
}
