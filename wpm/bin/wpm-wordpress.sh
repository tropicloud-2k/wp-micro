# ------------------------
# WORDPRESS SETUP
# ------------------------

wpm_wordpress() {

	su -l $user -c "git clone https://github.com/roots/bedrock.git www"
	su -l $user -c "composer install"
	
}	
