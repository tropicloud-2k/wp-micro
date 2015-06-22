# ------------------------
# WORDPRESS SETUP
# ------------------------

wpm_wp_setup() {

	wpm_ssl $HOSTNAME
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
	
	wpm_wp_install > /var/log/install.log 2>&1 &
	
	wpm_wp_status=$(cat /etc/wpm_wp_status)

	echo -ne "Initializing WordPress..."
	while [[  $wpm_wp_status != 'installed' || $wpm_wp_status != 'initialized'  ]]; do
		echo -n '.' && sleep 1
	done && echo -ne "done\n"

	if [[  $? == 0  ]]; 
	then echo -e "WordPress installed successfully"
	fi
}
