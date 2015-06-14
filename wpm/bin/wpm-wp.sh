# ------------------------
# WORDPRESS SETUP
# ------------------------

wpm_wordpress() {

	wpm_header "WordPress Install"

	su -l $user -c "git clone https://github.com/roots/bedrock.git www"
	su -l $user -c "cd www && composer install"
	
}
