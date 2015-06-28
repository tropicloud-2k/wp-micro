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
	
	wpm_header "WP Setup"
	
	adduser -D -G nginx -s /bin/sh -h $WPS_HOME $WPS_USER
	
	mkdir -p $WPS_HOME/conf.d
	mkdir -p $WPS_HOME/init.d
	mkdir -p $WPS_HOME/log/nginx
	mkdir -p $WPS_HOME/log/php
	mkdir -p $WPS_HOME/ssl
	
	cat /wpm/etc/.profile > $WPS_HOME/.profile
	cat /wpm/etc/.profile > /root/.profile
		
	su -l $WPS_USER -c "git clone $WP_REPO $WPS_WWW" && wpm_wp_version
	su -l $WPS_USER -c "cd $WPS_WWW && composer install"

	# ------------------------
	# NGINX
	# ------------------------

	cat /wpm/etc/init.d/nginx.ini > $WPS_HOME/init.d/nginx.ini
	cat /wpm/etc/nginx/nginx.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/nginx/nginx.conf
	
	if [[  $WP_SSL == 'true'  ]];
	then cat /wpm/etc/nginx/wpssl.conf | sed -e "s/example.com/$HOSTNAME/g" > $WPS_HOME/conf.d/nginx.conf && wpm_ssl
	else cat /wpm/etc/nginx/wp.conf | sed -e "s/example.com/$HOSTNAME/g" > $WPS_HOME/conf.d/nginx.conf
	fi
	
	# ------------------------
	# PHP-FPM
	# ------------------------
	
	cat /wpm/etc/init.d/php-fpm.ini | sed -e "s/example.com/$HOSTNAME/g" > $WPS_HOME/init.d/php-fpm.ini

	if [[  $(free -m | grep 'Mem' | awk '{print $2}') -gt 1800  ]];
	then cat /wpm/etc/php/php-fpm.conf | sed -e "s/example.com/$HOSTNAME/g" > $WPS_HOME/conf.d/php-fpm.conf
	else cat /wpm/etc/php/php-fpm-min.conf | sed -e "s/example.com/$HOSTNAME/g" > $WPS_HOME/conf.d/php-fpm.conf
	fi
	
	# ------------------------
	# MYSQL
	# ------------------------
	
	if [[  -z $MYSQL_PORT  ]];
	then wpm_mysql_setup
	else wpm_mysql_link
	fi
	
	# ------------------------
	# MSMTP
	# ------------------------

	cat /wpm/etc/smtp/msmtprc | sed -e "s/example.com/$HOSTNAME/g" > /etc/msmtprc
	echo "sendmail_path = /usr/bin/msmtp -t" > /etc/php/conf.d/sendmail.ini
	touch /var/log/msmtp.log && chmod 777 /var/log/msmtp.log

	# ------------------------
	# WP INSTALL
	# ------------------------
	
	wpm_header "WP Install"
	wpm_wp_install
}
