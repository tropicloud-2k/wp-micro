# ------------------------
# WORDPRESS SETUP
# ------------------------

wpm_wp_setup() {

	# ------------------------
	# NGINX
	# ------------------------

	if [[  $WP_SSL == 'true'  ]];
	then cat /wpm/etc/nginx/wpssl.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/wpm/wordpress.conf && wpm_ssl
	else cat /wpm/etc/nginx/wp.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/wpm/wordpress.conf
	fi
	
	# ------------------------
	# PHP-FPM
	# ------------------------
	
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
	# WORDPRESS
	# ------------------------
	
	wpm_header "WordPress Setup"

	su -l $user -c "cd $wpm && git clone $WP_REPO ."
	su -l $user -c "cd $wpm && composer install"
	su -l $user -c "ln -s $web ~/"
	
 	wpm_wp_install > /var/log/wpm-wp-install.log 2>&1 & 			
 	wpm_wp_status() { cat /var/log/wpm-install.log | grep -q "WordPress setup completed"; }
 	
 	echo -ne "Installing WordPress..."
 	while ! wpm_wp_status true; do echo -n '.' && sleep 1; done
 	echo -ne " done.\nLog file: /var/log/wpm-wp-install.log\n"
 	
 	if [[  `cat /var/log/wpm-wp-install.log | grep -q "WordPress installed successfully"` true  ]]; then echo "WordPress installed successfully."; fi
 	if [[  `cat /var/log/wpm-wp-install.log | grep -q "Plugin 'wp-ffpc' activated"` true  ]]; then echo "Plugin 'wp-ffpc' activated."; fi
 	if [[  `cat /var/log/wpm-wp-install.log | grep -q "Plugin 'redis-cache' activated"` true  ]]; then echo "Plugin 'redis-cache' activated."; fi
}

