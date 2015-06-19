# ------------------------
# WPM ENV.
# ------------------------

wpm_env() {
	
	if [[  -z $WP_ENV  ]]; then WP_ENV="production"; fi
	
	cat > /var/wpm/.env <<END
WP_ENV=$WP_ENV

WP_HOME=$WP_URL
WP_SITEURL=$WP_URL/wp

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

	chown $user:nginx /var/wpm/.env && . /var/wpm/.env
	
}
