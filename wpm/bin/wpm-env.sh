# ------------------------
# WPM ENV.
# ------------------------

wpm_env() {
	
	cat > /var/wpm/.env <<END
DB_NAME=$user
DB_USER=$user
DB_PASSWORD=`cat /etc/.header_mustache`
DB_HOST=127.0.0.1

WP_ENV=$WP_ENV
WP_HOME=$SCHEME://$HOSTNAME
WP_SITEURL=$SCHEME://$HOSTNAME/wp
END

	chown $user:nginx /var/wpm/.env
	
}
