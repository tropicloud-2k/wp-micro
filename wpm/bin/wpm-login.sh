# ------------------------
# NP LOGIN
# ------------------------

wpm_login() {

	wpm_header "Login as $user"
	su -l $user;
}

# ------------------------
# NP ROOT
# ------------------------

wpm_root() {

	wpm_header "Login as root"
	/bin/sh;
}
