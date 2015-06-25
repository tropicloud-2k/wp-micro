# ------------------------
# WORDPRESS SETUP
# ------------------------

wpm_wp_version(){

	WP_VER=`cat $wpm/composer.json | grep 'johnpbloch/wordpress' | cut -d: -f2`
	
	if [[  ! -z $WP_VERSION  ]];
	then sed -i "s/$WP_VER/\"$WP_VERSION\"/g" $wpm/composer.json && su -l $user -c "cd $wpm && composer update"
	fi
}

wpm_wp_setup() {

	# ------------------------
	# NGINX
	# ------------------------

	cat /wpm/etc/nginx/nginx.conf > /etc/wpm/nginx.conf
	cat /wpm/etc/run/nginx.ini    > /etc/wpm/run/nginx.ini
	
	if [[  $WP_SSL == 'true'  ]];
	then cat /wpm/etc/nginx/wpssl.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/wpm/wordpress.conf && wpm_ssl
	else cat /wpm/etc/nginx/wp.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/wpm/wordpress.conf
	fi
	
	# ------------------------
	# PHP-FPM
	# ------------------------
	
	cat /wpm/etc/run/php-fpm.ini  > /etc/wpm/run/php-fpm.ini
	
	if [[  $(free -m | grep 'Mem' | awk '{print $2}') -gt 1800  ]];
	then cat /wpm/etc/php/php-fpm.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/wpm/php-fpm.conf
	else cat /wpm/etc/php/php-fpm-min.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/wpm/php-fpm.conf
	fi
	
	# ------------------------
	# MSMTP
	# ------------------------

	cat /wpm/etc/msmtprc | sed -e "s/example.com/$HOSTNAME/g" > /etc/msmtprc
	echo "sendmail_path = /usr/bin/msmtp -t" > /etc/php/conf.d/sendmail.ini
	touch /var/log/msmtp.log && chmod 777 /var/log/msmtp.log
	
	# ------------------------
	# SUPERVISORD
	# ------------------------
	
	cat /wpm/etc/supervisord.conf \
	| sed -e "s/example.com/$HOSTNAME/g" \
	| sed -e "s/WPM_ENV_HTTP_SHA1/$WPM_ENV_HTTP_SHA1" \
	> /etc/supervisord.conf && chmod 644 /etc/supervisord.conf

	# ------------------------
	# WORDPRESS
	# ------------------------
	
	wpm_header "WordPress Setup"
	
	su -l $user -c "cd $wpm && git clone $WP_REPO ." && wpm_wp_version
	su -l $user -c "cd $wpm && composer install"
	su -l $user -c "ln -s $web ~/"
	
 	wpm_wp_install > /var/log/wpm-wp-install.log 2>&1 & 			
 	wpm_wp_status() { cat /var/log/wpm-install.log | grep -q "WordPress setup completed"; }
 	
 	echo -ne "Installing WordPress..."
 	while ! wpm_wp_status true; do echo -n '.' && sleep 1; done
 	echo -ne " done.\n"
 	
 	if [[  `cat /var/log/wpm-wp-install.log | grep -q "WordPress installed successfully"` true  ]]; then echo "WordPress installed successfully."; fi
 	if [[  `cat /var/log/wpm-wp-install.log | grep -q "Plugin 'wp-ffpc' activated"` true  ]]; then echo "Plugin 'wp-ffpc' activated."; fi
 	if [[  `cat /var/log/wpm-wp-install.log | grep -q "Plugin 'redis-cache' activated"` true  ]]; then echo "Plugin 'redis-cache' activated."; fi
}
