# ------------------------
# WORDPRESS SETUP
# ------------------------

wpm_wp_version(){

	WP_VER=`cat $wpm/composer.json | grep 'johnpbloch/wordpress' | cut -d: -f2`
	
	if [[  ! -z $WP_VERSION  ]];
	then sed -i "s/$WP_VER/\"$WP_VERSION\"/g" $wpm/composer.json && su -l $USER -c "cd $wpm && composer update"
	fi
}

wpm_wp_setup() {

	# ------------------------
	# NGINX
	# ------------------------

	cat /wpm/etc/init.d/nginx.ini > $HOME/init.d/nginx.ini
	cat /wpm/etc/nginx/nginx.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/nginx/nginx.conf
	
	if [[  $WP_SSL == 'true'  ]];
	then cat /wpm/etc/nginx/wpssl.conf | sed -e "s/example.com/$HOSTNAME/g" > $HOME/conf.d/wordpress.conf && wpm_ssl
	else cat /wpm/etc/nginx/wp.conf | sed -e "s/example.com/$HOSTNAME/g" > $HOME/conf.d/wordpress.conf
	fi
	
	# ------------------------
	# PHP-FPM
	# ------------------------
	
	cat /wpm/etc/init.d/php-fpm.ini > $HOME/init.d/php-fpm.ini

	if [[  $(free -m | grep 'Mem' | awk '{print $2}') -gt 1800  ]];
	then cat /wpm/etc/php/php-fpm.conf | sed -e "s/example.com/$HOSTNAME/g" > $HOME/conf.d/php-fpm.conf
	else cat /wpm/etc/php/php-fpm-min.conf | sed -e "s/example.com/$HOSTNAME/g" > $HOME/conf.d/php-fpm.conf
	fi
	
	# ------------------------
	# WORDPRESS
	# ------------------------
	
	export USER="$HOSTNAME"
	export HOME="/home/$HOSTNAME"
	
	wpm_header "WordPress Setup"
	
	adduser -D -G nginx -s /bin/sh -h $HOME $USER
	
	mkdir -p $HOME/conf.d
	mkdir -p $HOME/init.d
	mkdir -p $HOME/log/nginx
	mkdir -p $HOME/log/php
	mkdir -p $HOME/ssl
	
	cat /wpm/etc/.profile > /root/.profile
	cat /wpm/etc/.profile > $HOME/.profile
	cat /wpm/etc/smtp/msmtprc > /etc/msmtprc
		
	su -l $USER -c "git clone $WP_REPO wpm" && wpm_wp_version
	su -l $USER -c "cd $wpm && composer install"

	wpm_wp_install > $HOME/log/wpm-wordpress.log 2>&1 & 			
	wpm_wp_status() { cat $HOME/log/wpm-install.log | grep -q "WordPress setup completed"; }
		
	echo -ne "Installing WordPress..."
	while ! wpm_wp_status true; do echo -n '.' && sleep 1; done
	echo -ne " done.\n"
	
	if [[  `cat $HOME/log/wpm-wordpress.log | grep -q "Plugin 'wp-ffpc' activated"` true  ]]; then echo "Plugin 'wp-ffpc' activated."; fi
	if [[  `cat $HOME/log/wpm-wordpress.log | grep -q "Plugin 'redis-cache' activated"` true  ]]; then echo "Plugin 'redis-cache' activated."; fi	
	if [[  `cat $HOME/log/wpm-wordpress.log | grep -q "WordPress installed successfully"` true  ]]; then echo "WordPress installed successfully."; fi
}
