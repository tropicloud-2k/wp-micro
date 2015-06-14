# ------------------------
# WPM ENV.
# ------------------------

wpm_env() {

	# ------------------------
	# NGINX
	# ------------------------
	
	if [[  $WP_SSL == 'true'  ]];
	then SCHEME="https" && cat /wpm/etc/nginx/wpssl.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/wpm/nginx.conf && wpm_ssl $HOSTNAME
	else SCHEME="http" && cat /wpm/etc/nginx/wp.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/wpm/nginx.conf
	fi

	# ------------------------
	# PHP-FPM
	# ------------------------
	
	if [[  $(free -m | grep 'Mem' | awk '{print $2}') -gt 1800  ]];
	then cat /wpm/etc/php/php-fpm.conf > /etc/wpm/php-fpm.conf
	else cat /wpm/etc/php/php-fpm-min.conf > /etc/wpm/php-fpm.conf
	fi
	
	wpm_dotenv() {
		cat > /var/wpm/.env <<END
DB_NAME=$wpm_db_name
DB_USER=$wpm_db_user
DB_PASSWORD=`cat /etc/.header_mustache`
DB_HOST=127.0.0.1

WP_ENV=$WP_ENV
WP_HOME=$SCHEME://$HOSTNAME
WP_SITEURL=$SCHEME://$HOSTNAME/wp
END
	}

	su -l $user -c wpm_dotenv
	
}
