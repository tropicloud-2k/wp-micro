wpm_wp_setup() {

	wpm_header "WordPress Setup"
	
	# ------------------------
	# NGINX
	# ------------------------

	if [[  $WP_SSL == 'true'  ]];
	then cat /wpm/etc/nginx/wpssl.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/wpm/wordpress.conf
	else cat /wpm/etc/nginx/wp.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/wpm/wordpress.conf
	fi
	
	# ------------------------
	# PHP-FPM
	# ------------------------
	
	if [[  $(free -m | grep 'Mem' | awk '{print $2}') -gt 1800  ]];
	then cat /wpm/etc/php/php-fpm.conf > /etc/wpm/php-fpm.conf
	else cat /wpm/etc/php/php-fpm-min.conf > /etc/wpm/php-fpm.conf
	fi
	
	# ------------------------
	# WORDPRESS
	# ------------------------
	
	su -l $user -c "cd $wpm && git clone $WP_REPO ."
	su -l $user -c "cd $wpm && composer install"
	su -l $user -c "ln -s $web ~/"
	
	echo -e "Configuring environment"
	
	wpm_wp_install > /dev/null 2>&1
	wpm_ssl $HOSTNAME
	wpm_back_serv

}
