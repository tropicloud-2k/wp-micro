# ------------------------
# WORDPRESS SETUP
# ------------------------

wpm_wordpress_setup() {

	su -l $user -c "git clone https://github.com/roots/bedrock.git ."
	su -l $user -c "composer install"

}	
