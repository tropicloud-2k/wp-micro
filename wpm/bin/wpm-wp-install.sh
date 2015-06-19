# ------------------------
# WORDPRESS INSTALL
# ------------------------

wpm_wp_url() {
	echo -ne "\033[0;34m  WP Domain: \033[1;37m"
	read HOSTNAME && echo -e "\033[0m"
}

wpm_wp_title() {
	echo -ne "\033[0;34m  WP Title: \033[1;37m"
	read WP_TITLE && echo -e "\033[0m"
}


wpm_wp_user() {
	echo -ne "\033[0;34m  WP User: \033[1;37m"
	read WP_USER && echo -e "\033[0m"
}

wpm_wp_mail() {
	echo -ne "\033[0;34m  WP Email: \033[1;37m"
	read WP_MAIL && echo -e "\033[0m"
}

wpm_wp_pass() {
	echo -ne "\033[0;34m  WP Pass: \033[1;37m"
	read WP_PASS && echo -e "\033[0m"
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
	
# 	if [[  -z $HOSTNAME  ]]; then wpm_wp_url; fi
# 	if [[  -z $WP_TITLE  ]]; then wpm_wp_title; fi
# 	if [[  -z $WP_USER  ]];  then wpm_wp_user; fi
# 	if [[  -z $WP_MAIL  ]];  then wpm_wp_mail; fi
# 	if [[  -z $WP_PASS  ]];  then wpm_wp_pass; fi
# 	if [[  -z $WP_SSL  ]];   then wpm_wp_ssl; fi

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
	

	su -l $user -c "cd /var/wpm && git clone $WP_REPO ."
	su -l $user -c "cd /var/wpm && composer install && ln -s /var/wpm/web ~/"

	if [[  ! -f /var/www/web/.env   ]]; then
		
		if [[  -z $WP_ENV  ]]; then WP_ENV="production"; fi
		cat > /var/wpm/.env <<END
DB_NAME=$user
DB_USER=$user
DB_PASSWORD=`cat /etc/.header_mustache`
DB_HOST=127.0.0.1

WP_ENV=$WP_ENV
WP_HOME=$WP_URL
WP_SITEURL=$WP_URL/wp

AUTH_KEY="`openssl rand 48 -base64`"
SECURE_AUTH_KEY="`openssl rand 48 -base64`"
LOGGED_IN_KEY="`openssl rand 48 -base64`"
NONCE_KEY="`openssl rand 48 -base64`"
AUTH_SALT="`openssl rand 48 -base64`"
SECURE_AUTH_SALT="`openssl rand 48 -base64`"
LOGGED_IN_SALT="`openssl rand 48 -base64`"
NONCE_SALT="`openssl rand 48 -base64`"
END
	fi

# 	su -l $user -c "cd /var/wpm && wp core install \
# --url=${WP_URL} \
# --title=${WP_TITLE} \
# --admin_name=${WP_USER} \
# --admin_email=${WP_MAIL} \
# --admin_password=${WP_PASS}"
# 

}
