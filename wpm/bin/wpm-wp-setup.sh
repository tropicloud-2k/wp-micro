# ------------------------
# WORDPRESS SETUP
# ------------------------

wpm_wp_version(){

	WP_VER=`cat $WPS_WWW/composer.json | grep 'johnpbloch/wordpress' | cut -d: -f2`
	
	if [[  ! -z $WP_VERSION  ]];
	then sed -i "s/$WP_VER/\"$WP_VERSION\"/g" $WPS_WWW/composer.json && su -l $WPS_USER -c "cd $WPS_WWW && composer update"
	fi
}

wpm_wp_setup() {

	# ------------------------
	# WP SETUP
	# ------------------------
		
	export WPS_USER="${HOSTNAME}"
	export WPS_HOME="/home/${HOSTNAME}"
	export WPS_WWW="/home/${HOSTNAME}/www"
	export WPS_WEB="/home/${HOSTNAME}/www/web"
	
	wpm_header "WordPress Setup"
	
	adduser -D -G nginx -s /bin/sh -h $WPS_HOME $WPS_USER
	
	mkdir -p $WPS_HOME/conf.d
	mkdir -p $WPS_HOME/init.d
	mkdir -p $WPS_HOME/log/nginx
	mkdir -p $WPS_HOME/log/php
	mkdir -p $WPS_HOME/ssl
	
	cat /wpm/etc/.profile > /root/.profile
	cat /wpm/etc/.profile > $WPS_HOME/.profile
	cat /wpm/etc/smtp/msmtprc > /etc/msmtprc
		
	su -l $WPS_USER -c "git clone $WP_REPO $WPS_WWW" && wpm_wp_version
	su -l $WPS_USER -c "cd $WPS_WWW && composer install"

	# ------------------------
	# MYSQL
	# ------------------------
	
	if [[  -z $MYSQL_PORT  ]];
	then wpm_mysql_setup
	else wpm_mysql_link
	fi
	
	# ------------------------
	# NGINX
	# ------------------------

	if [[  $WP_SSL == 'true'  ]];
	then cat /wpm/etc/nginx/wpssl.conf | sed -e "s/example.com/$HOSTNAME/g" > $WPS_HOME/conf.d/wordpress.conf && wpm_ssl
	else cat /wpm/etc/nginx/wp.conf | sed -e "s/example.com/$HOSTNAME/g" > $WPS_HOME/conf.d/wordpress.conf
	fi
	
	cat /wpm/etc/init.d/nginx.ini > $WPS_HOME/init.d/nginx.ini
	cat /wpm/etc/nginx/nginx.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/nginx/nginx.conf
	
	# ------------------------
	# PHP-FPM
	# ------------------------
	
	if [[  $(free -m | grep 'Mem' | awk '{print $2}') -gt 1800  ]];
	then cat /wpm/etc/php/php-fpm.conf | sed -e "s/example.com/$HOSTNAME/g" > $WPS_HOME/conf.d/php-fpm.conf
	else cat /wpm/etc/php/php-fpm-min.conf | sed -e "s/example.com/$HOSTNAME/g" > $WPS_HOME/conf.d/php-fpm.conf
	fi
	
	cat /wpm/etc/init.d/php-fpm.ini > $WPS_HOME/init.d/php-fpm.ini

	# ------------------------
	# WP INSTALL
	# ------------------------
	
	wpm_wp_install > $WPS_HOME/log/wpm-wordpress.log 2>&1 & 			
	wpm_wp_status() { cat $WPS_HOME/log/wpm-install.log | grep -q "WordPress setup completed"; }
		
	echo -ne "Installing WordPress..."
	while ! wpm_wp_status true; do echo -n '.' && sleep 1; done
	echo -ne " done.\n"
	
	if [[  `cat $WPS_HOME/log/wpm-wordpress.log | grep -q "Plugin 'wp-ffpc' activated"` true  ]]; then echo "Plugin 'wp-ffpc' activated."; fi
	if [[  `cat $WPS_HOME/log/wpm-wordpress.log | grep -q "Plugin 'redis-cache' activated"` true  ]]; then echo "Plugin 'redis-cache' activated."; fi	
	if [[  `cat $WPS_HOME/log/wpm-wordpress.log | grep -q "WordPress installed successfully"` true  ]]; then echo "WordPress installed successfully."; fi
}
