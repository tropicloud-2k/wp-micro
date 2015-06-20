# ------------------------
# WPM ENV.
# ------------------------

wpm_env() {
	
	if [[  $WP_SSL == 'true'  ]];
	then export WP_HOME="https://${HOSTNAME}"
	     export WP_SITEURL="https://${HOSTNAME}/wp"
	else export WP_HOME="http://${HOSTNAME}"
	     export WP_SITEURL="http://${HOSTNAME}/wp"
	fi

	export DB_HOST="127.0.0.1"
	export DB_NAME="$user"
	export DB_USER="$user"
	export DB_PASSWORD=`cat /etc/.header_mustache`

	for var in `cat /etc/.env`; do 
		key=`echo $var | cut -d= -f1`
		val=`echo $var | cut -d= -f2`
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
