# ------------------------
# WORDPRESS INSTALL
# ------------------------

wpm_wp_url() {
	echo -ne "\033[0;34m  WP Domain: \033[1;37m"
	read HOSTNAME && echo "\033[0m"
}

wpm_wp_title() {
	echo -ne "\033[1;37m  WP Title: \033[1;37m"
	read WP_TITLE && echo "\033[0m"
}


wpm_wp_user() {
	echo -ne "\033[0;34m  WP User: \033[1;37m"
	read WP_USER && echo "\033[0m"
}

wpm_wp_mail() {
	echo -ne "\033[0;34m  WP Email: \033[1;37m"
	read WP_MAIL && echo "\033[0m"
}

wpm_wp_pass() {
	echo -ne "\033[0;34m  WP Pass: \033[1;37m"
	read WP_PASS && echo "\033[0m"
}

wpm_wp_ssl() {
	echo -ne "\033[0;34m  Enable SSL? [y/n]: \033[1;37m";
	read SSL && echo "\033[0m"
	
	if [[  $SSL == 'y'  ]];
	then WP_SSL='true'
	else WP_SSL='false'
	fi
}

wpm_wp_install() {

	wpm_header "WordPress Install"
	
	if [[  -z $HOSTNAME  ]]; then wpm_wp_url; fi
	if [[  -z $WP_TITLE  ]]; then wpm_wp_title; fi
	if [[  -z $WP_USER  ]];  then wpm_wp_user; fi
	if [[  -z $WP_MAIL  ]];  then wpm_wp_mail; fi
	if [[  -z $WP_PASS  ]];  then wpm_wp_pass; fi
	if [[  -z $WP_SSL  ]];   then wpm_wp_ssl; fi

	# ------------------------
	# NGINX
	# ------------------------
	
	if [[  $WP_SSL == 'true'  ]];
	then WP_URL="https://${HOSTNAME}" && cat /wpm/etc/nginx/wpssl.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/wpm/nginx.conf && wpm_ssl $HOSTNAME
	else WP_URL="http://${HOSTNAME}" && cat /wpm/etc/nginx/wp.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/wpm/nginx.conf
	fi

	# ------------------------
	# PHP-FPM
	# ------------------------
	
	if [[  $(free -m | grep 'Mem' | awk '{print $2}') -gt 1800  ]];
	then cat /wpm/etc/php/php-fpm.conf > /etc/php/php-fpm.conf
	else cat /wpm/etc/php/php-fpm-min.conf > /etc/php/php-fpm.conf
	fi
	
	# ------------------------
	# WORDPRESS
	# ------------------------
	
	su -l $user -c "cd /var/wpm && git clone https://github.com/roots/bedrock.git ."
	su -l $user -c "cd /var/wpm && composer install && ln -s /var/wpm/web ~/"
	su -l $user -c "cd /var/wpm && wp core install \
--url=${WP_URL} \
--title=${WP_TITLE} \
--admin_name=${WP_USER} \
--admin_email=${WP_MAIL} \
--admin_password=${WP_PASS}"

}
