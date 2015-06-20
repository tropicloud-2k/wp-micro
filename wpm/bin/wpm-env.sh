# ------------------------
# WPM ENV.
# ------------------------

wpm_env() {
	
	if [[  $WP_SSL == 'true'  ]];
	then export WP_HOME="https://${HOSTNAME}"
	else export WP_HOME="http://${HOSTNAME}"
	fi
	
	if [[  -n $MEMCACHE_PORT  ]]; then export WP_MEMCACHE=`echo $MEMCACHE_PORT | cut -d/ -f3`; fi
	if [[  -n $REDIS_PORT  ]]; then export WP_REDIS=`echo $REDIS_PORT | cut -d/ -f3`; fi	

	export DB_HOST="127.0.0.1"
	export DB_NAME="$user"
	export DB_USER="$user"
	export WP_SITEURL="${WP_HOME}/wp"
	
	echo "" > /etc/.env && env | grep = >> /etc/.env

	for var in `cat /etc/.env`; do 
		echo -e "$var" >> /var/wpm/.env
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
