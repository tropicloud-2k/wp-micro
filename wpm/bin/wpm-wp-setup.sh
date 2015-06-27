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

	if [[  $WP_SSL == 'true'  ]];
	then WP_CONF="/wpm/etc/nginx/wpssl.conf" && wpm_ssl
	else WP_CONF="/wpm/etc/nginx/wp.conf"
	fi
	
	cat /wpm/etc/nginx/nginx.conf > /etc/nginx/nginx.conf
	cat /wpm/etc/init.d/nginx.ini > $home/init.d/nginx.ini
	
	cat $WP_CONF \
	| sed -e "s/DB_HOST/$DB_HOST/g" \
	| sed -e "s/DB_NAME/$DB_NAME/g" \
	| sed -e "s/DB_USER/$DB_USER/g" \
	| sed -e "s/example.com/$HOSTNAME/g" \
	> $home/conf.d/wordpress.conf 
	
	# ------------------------
	# PHP-FPM
	# ------------------------
	
	cat /wpm/etc/init.d/php-fpm.ini > $home/init.d/php-fpm.ini
	cat /wpm/etc/smtp/msmtprc > /etc/msmtprc

	if [[  $(free -m | grep 'Mem' | awk '{print $2}') -gt 1800  ]];
	then cat /wpm/etc/php/php-fpm.conf | sed -e "s/example.com/$HOSTNAME/g" > $home/conf.d/php-fpm.conf
	else cat /wpm/etc/php/php-fpm-min.conf | sed -e "s/example.com/$HOSTNAME/g" > $home/conf.d/php-fpm.conf
	fi
	
	# ------------------------
	# WORDPRESS
	# ------------------------
	
	wpm_header "WordPress Setup"
	
	su -l $user -c "git clone $WP_REPO wpm" && wpm_wp_version
	su -l $user -c "cd $wpm && composer install"

	wpm_wp_install > $home/log/wpm-wordpress.log 2>&1 & 			
	wpm_wp_status() { cat $home/log/wpm-install.log | grep -q "WordPress setup completed"; }
		
	echo -ne "Installing WordPress..."
	while ! wpm_wp_status true; do echo -n '.' && sleep 1; done
	echo -ne " done.\n"
	
	if [[  `cat $home/log/wpm-wordpress.log | grep -q "Plugin 'wp-ffpc' activated"` true  ]]; then echo "Plugin 'wp-ffpc' activated."; fi
	if [[  `cat $home/log/wpm-wordpress.log | grep -q "Plugin 'redis-cache' activated"` true  ]]; then echo "Plugin 'redis-cache' activated."; fi	
	if [[  `cat $home/log/wpm-wordpress.log | grep -q "WordPress installed successfully"` true  ]]; then echo "WordPress installed successfully."; fi
}
