# ------------------------
# WORDPRESS SETUP
# ------------------------

wpm_wordpress() {

	wpm_header "WordPress Install"

	su -l $user -c "cd /var/wpm && git clone https://github.com/roots/bedrock.git ."
	su -l $user -c "cd /var/wpm && composer install && ln -s /var/wpm/web ~/"
	
}
