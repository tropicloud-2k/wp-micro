# ------------------------
# WPM ENV.
# ------------------------

wpm_env() {
	
	cat > /var/wpm/.env <<END
WP_REPO=$WP_REPO
WP_ENV=$WP_ENV
WP_SSL=$WP_SSL

WP_HOME=$WP_HOME
WP_SITEURL=$WP_HOME/wp

DB_HOST=127.0.0.1
DB_NAME=$user
DB_USER=$user
DB_PASSWORD=`cat /etc/.header_mustache`

AUTH_KEY="`openssl rand 48 -base64`"
SECURE_AUTH_KEY="`openssl rand 48 -base64`"
LOGGED_IN_KEY="`openssl rand 48 -base64`"
NONCE_KEY="`openssl rand 48 -base64`"
AUTH_SALT="`openssl rand 48 -base64`"
SECURE_AUTH_SALT="`openssl rand 48 -base64`"
LOGGED_IN_SALT="`openssl rand 48 -base64`"
NONCE_SALT="`openssl rand 48 -base64`"
END

	if [[  -n $MEMCACHE_PORT  ]]; then
		su -l $user -c "cd /var/wpm/web && wp plugin install wp-ffpc --activate"
		echo -e "\nMEMCACHE_SERVER=`echo $MEMCACHE_PORT | cut -d/ -f3`" >> /var/wpm/.env
	fi
	
	chown $user:nginx /var/wpm/.env
	
}
