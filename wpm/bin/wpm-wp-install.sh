# ------------------------
# WORDPRESS SETUP
# ------------------------

get_wp_domain() {
	echo -ne "\033[0;34m  Domain Name: \n\n"
	echo -ne "\033[1;37m  http://"
	read WP_DOMAIN && echo ""
}

get_wp_mail() {
	echo -ne "\033[0;34m  WP Email: \033[1;37m"
	read WP_MAIL && echo ""
}

get_wp_user() {
	echo -ne "\033[0;34m  WP User: \033[1;37m"
	read WP_USER && echo ""
}

get_wp_pass() {
	echo -ne "\033[0;34m  WP Pass: \033[1;37m"
	read WP_PASS && echo ""
}

get_wp_ssl() {
	echo -ne "\033[0;34m  Enable SSL? [y/n]: \033[1;37m";
	read WP_SSL
}

wpm_wp_install() {

	wpm_header "WordPress Install"

	if [[  -z $HOSTNAME  ]]; then get_wp_domain; fi
	if [[  -z $WP_USER  ]]; then get_wp_user; fi
	if [[  -z $WP_PASS  ]]; then get_wp_pass; fi
	if [[  -z $WP_MAIL  ]]; then get_wp_mail; fi
	if [[  -z $WP_SSL  ]]; then get_wp_ssl; fi
	
	su -l $user -c "cd /var/wpm && git clone https://github.com/roots/bedrock.git ."
	su -l $user -c "cd /var/wpm && composer install && ln -s /var/wpm/web ~/"
	
}
