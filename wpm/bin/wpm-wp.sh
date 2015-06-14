# ------------------------
# WORDPRESS SETUP
# ------------------------

wpm_wordpress() {

	wpm_header "WordPress Install"

	su -l $user -c "git clone https://github.com/roots/bedrock.git /var/wpm"
	su -l $user -c "cd www && composer install"
	su -l $user -c "ln -s /var/wpm/web ~/"
	
}
