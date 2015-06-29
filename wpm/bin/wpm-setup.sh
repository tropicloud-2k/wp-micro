
wps_setup() {

# NGINX
# ---------------------------------------------------------------------------------

	cat /wps/etc/init.d/nginx.ini | sed -e "s/example.com/$HOSTNAME/g" > $home/init.d/nginx.ini
	cat /wps/etc/nginx/nginx.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/nginx/nginx.conf
	
	if [[  $WP_SSL == 'true'  ]];
	then cat /wps/etc/nginx/wpssl.conf | sed -e "s/example.com/$HOSTNAME/g" > $home/conf.d/nginx.conf && wps_ssl
	else cat /wps/etc/nginx/wp.conf | sed -e "s/example.com/$HOSTNAME/g" > $home/conf.d/nginx.conf
	fi
	

# PHP
# ---------------------------------------------------------------------------------
	
	cat /wps/etc/init.d/php-fpm.ini | sed -e "s/example.com/$HOSTNAME/g" > $home/init.d/php-fpm.ini

	if [[  $(free -m | grep 'Mem' | awk '{print $2}') -gt 1800  ]];
	then cat /wps/etc/php/php-fpm.conf | sed -e "s/example.com/$HOSTNAME/g" > $home/conf.d/php-fpm.conf
	else cat /wps/etc/php/php-fpm-min.conf | sed -e "s/example.com/$HOSTNAME/g" > $home/conf.d/php-fpm.conf
	fi


# MYSQL
# ---------------------------------------------------------------------------------
	
	if [[  -z $MYSQL_PORT  ]]; then wps_mysql_setup; else wps_mysql_link; fi
	
	
# MSMTP
# ---------------------------------------------------------------------------------

	cat /wps/etc/smtp/msmtprc | sed -e "s/example.com/$HOSTNAME/g" > /etc/msmtprc
	echo "sendmail_path = /usr/bin/msmtp -t" > /etc/php/conf.d/sendmail.ini
	touch /var/log/msmtp.log
	chmod 777 /var/log/msmtp.log


# SUPERVISOR
# ---------------------------------------------------------------------------------
	
	cat /wps/etc/supervisord.conf \
	| sed -e "s/example.com/$HOSTNAME/g" \
	| sed -e "s/WPM_ENV_HTTP_PASS/{SHA}$WPM_ENV_HTTP_SHA1/g" \
	> /etc/supervisord.conf && chmod 644 /etc/supervisord.conf


# WORDPRESS
# ---------------------------------------------------------------------------------
	
	wps_header "WordPress Setup"
	
	su -l $user -c "git clone $WP_REPO wps" && wps_version
	su -l $user -c "cd $www && composer install"

	wps_wp_install > $home/log/wps-wordpress.log 2>&1 & 			
	wps_wp_status() { cat $home/log/wps-install.log | grep -q "WordPress setup completed"; }
		
	echo -ne "Installing WordPress..."
	while ! wps_wp_status true; do echo -n '.'; sleep 1; done; echo -ne " done.\n"
	
	s="" && q=`cat $home/log/wps-wordpress.log | grep -q "$s"`	
	s="Plugin 'wp-ffpc' activated"; if [[  $q true  ]]; then echo $s; fi
	s="Plugin 'redis-cache' activated"; if [[  $q true  ]]; then echo $s; fi
	s="WordPress installed successfully"; if [[  $q true  ]]; then echo $s; fi
}
