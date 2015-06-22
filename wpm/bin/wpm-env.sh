# ------------------------
# WPM ENV.
# ------------------------

wpm_environment() {

	if [[  $WP_SSL == 'true'  ]];
	then export WP_HOME="https://${HOSTNAME}"
	else export WP_HOME="http://${HOSTNAME}"
	fi
	
	export WP_SITEURL=${WP_HOME}/wp
	export DB_HOST=127.0.0.1
	export DB_NAME=$user
	export DB_USER=$user
	
	if [[  ! -z $MEMCACHED_PORT  ]];
	then export MEMCACHED_WPM=`echo $MEMCACHED_PORT | cut -d/ -f3`
	fi		

	if [[  ! -z $REDIS_PORT  ]]; 
	then export REDIS_WPM=`echo $REDIS_PORT | cut -d/ -f3`
	fi
	
	echo "" > /etc/.env && env | grep = >> /etc/.env
	for var in `cat /etc/.env`; do echo $var >> $wpm/.env; done
	
	cat >> $wpm/.env <<END
AUTH_KEY="`openssl rand 48 -base64`"
SECURE_AUTH_KEY="`openssl rand 48 -base64`"
LOGGED_IN_KEY="`openssl rand 48 -base64`"
NONCE_KEY="`openssl rand 48 -base64`"
AUTH_SALT="`openssl rand 48 -base64`"
SECURE_AUTH_SALT="`openssl rand 48 -base64`"
LOGGED_IN_SALT="`openssl rand 48 -base64`"
NONCE_SALT="`openssl rand 48 -base64`"
END

	# hide "The mysql extension is deprecated and will be removed in the future: use mysqli or PDO"
	sed -i "s/define('WP_DEBUG'.*/define('WP_DEBUG', false);/g" $wpm/config/environments/development.php

	cat ~/.profile > ${home}/.profile
	chown $user:nginx $wpm/.env
}
