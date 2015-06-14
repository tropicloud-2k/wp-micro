# ------------------------
# WPM ENV.
# ------------------------

wpm_env() {

	if [[  -z $SSL  ]];
	then SCHEME="http" && cat /wpm/etc/nginx/wp.conf | sed -e "s/example.com/$HOSTNAME/g" > $home/etc/nginx.conf
	else SCHEME="https" && cat /wpm/etc/nginx/wp-ssl.conf | sed -e "s/example.com/$HOSTNAME/g" > $home/etc/nginx.conf && wpm_ssl $HOSTNAME
	fi
	
	cat > $home/.env <<END
DB_NAME=$user
DB_USER=$user
DB_PASSWORD=`cat /etc/wpm/.wpm_shadow`
DB_HOST=localhost

WP_ENV=production
WP_HOME=$SCHEME://$HOSTNAME
WP_SITEURL=$SCHEME://$HOSTNAME/wp
END
		
}
