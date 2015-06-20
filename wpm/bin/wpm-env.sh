# ------------------------
# WPM ENV.
# ------------------------

wpm_env() {
	
	export DB_HOST="127.0.0.1"
	export DB_NAME="$user"
	export DB_USER="$user"
	export DB_PASSWORD=`cat /etc/.header_mustache`

	echo "" > /etc/environment && env | grep = >> /etc/environment

	for var in `cat /etc/environment`; do 
		echo -e "$key=$val" >> /var/wpm/.env
	done
	
	cat >> /var/wpm/.env <<END

# WP SALT
AUTH_KEY="`openssl rand 48 -base64`"
SECURE_AUTH_KEY="`openssl rand 48 -base64`"
LOGGED_IN_KEY="`openssl rand 48 -base64`"
NONCE_KEY="`openssl rand 48 -base64`"
AUTH_SALT="`openssl rand 48 -base64`"
SECURE_AUTH_SALT="`openssl rand 48 -base64`"
LOGGED_IN_SALT="`openssl rand 48 -base64`"
NONCE_SALT="`openssl rand 48 -base64`"
END
	
	chown $user:nginx /var/wpm/.env
	
}
