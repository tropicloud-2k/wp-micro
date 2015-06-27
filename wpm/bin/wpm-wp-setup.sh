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

	cat /wpm/etc/nginx/nginx.conf > $home/conf.d/nginx.conf
	cat /wpm/etc/init.d/nginx.ini > $home/init.d/nginx.ini
	
	if [[  $WP_SSL == 'true'  ]];
	then cat /wpm/etc/nginx/wpssl.conf | sed -e "s/example.com/$HOSTNAME/g" > $home/conf.d/wp.conf && wpm_ssl
	else cat /wpm/etc/nginx/wp.conf | sed -e "s/example.com/$HOSTNAME/g" > $home/conf.d/wp.conf
	fi
	
	# ------------------------
	# PHP-FPM
	# ------------------------
	
	cat /wpm/etc/init.d/php-fpm.ini > $home/init.d/php-fpm.ini

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
	su -l $user -c "cd $web && mkdir adminer && curl -sL http://www.adminer.org/latest-mysql-en.php > adminer/index.php"
	su -l $user -c "touch .adminer"

	wpm_wp_install > $home/log/wpm-wp-install.log 2>&1 & 			
	wpm_wp_status() { cat $home/log/wpm-install.log | grep -q "WordPress setup completed"; }
		
	echo -ne "Installing WordPress..."
	while ! wpm_wp_status true; do echo -n '.' && sleep 1; done
	echo -ne " done.\n"
	
	echo -ne "Changing file permissions..."
	while ! wpm_chmod true; do echo -n '.' && sleep 1; done
	echo -ne " done.\n"
	
	if [[  `cat $home/log/wpm-wp-install.log | grep -q "Plugin 'wp-ffpc' activated"` true  ]]; then echo "Plugin 'wp-ffpc' activated."; fi
	if [[  `cat $home/log/wpm-wp-install.log | grep -q "Plugin 'redis-cache' activated"` true  ]]; then echo "Plugin 'redis-cache' activated."; fi	
	if [[  `cat $home/log/wpm-wp-install.log | grep -q "WordPress installed successfully"` true  ]]; then echo "WordPress installed successfully."; fi
}
