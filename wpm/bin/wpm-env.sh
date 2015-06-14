# ------------------------
# WPM ENV.
# ------------------------

wpm_env() {

	wpm_header "Environment"

	if [[  $WP_SSL == 'true'  ]];
	then SCHEME="https" && cat /wpm/etc/nginx/wpssl.conf | sed -e "s/example.com/$HOSTNAME/g" > $home/etc/nginx.conf && wpm_ssl $HOSTNAME
	else SCHEME="http" && cat /wpm/etc/nginx/wp.conf | sed -e "s/example.com/$HOSTNAME/g" > $home/etc/nginx.conf
	fi

	cat > $home/www/.env <<END
DB_NAME=$user
DB_USER=$user
DB_PASSWORD=`cat /etc/.header_mustache`
DB_HOST=127.0.0.1

WP_ENV=$WP_ENV
WP_HOME=$SCHEME://$HOSTNAME
WP_SITEURL=$SCHEME://$HOSTNAME/wp
END

chown $user:nginx $home/www/.env

}
