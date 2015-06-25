# ------------------------
# WPM ENV.
# ------------------------

wpm_environment() {

	# hide "The mysql extension is deprecated and will be removed in the future: use mysqli or PDO"
	sed -i "s/define('WP_DEBUG'.*/define('WP_DEBUG', false);/g" $wpm/config/environments/development.php

	if [[  ! -z $MEMCACHED_PORT  ]]; then export MEMCACHED=`echo $MEMCACHED_PORT | cut -d/ -f3`; fi		
	if [[  ! -z $REDIS_PORT  ]]; then export REDIS=`echo $REDIS_PORT | cut -d/ -f3`; fi
	if [[  ! -z $MYSQL_PORT  ]]; then export MYSQL=`echo $MYSQL_PORT | cut -d/ -f3`; fi
	
	if [[  $WP_SSL == 'true'  ]];
	then export WP_HOME="https://${HOSTNAME}"
	else export WP_HOME="http://${HOSTNAME}"
	fi
	
	export WP_SITEURL="${WP_HOME}/wp"
	export WPM_ENV_HTTP_PASS=`openssl rand 12 -base64`
	export WPM_ENV_HTTP_SHA1=`echo "$WPM_ENV_HTTP_PASS" | openssl dgst -sha1`
	export AUTH_KEY="`openssl rand 48 -base64`"
	export SECURE_AUTH_KEY="`openssl rand 48 -base64`"
	export LOGGED_IN_KEY="`openssl rand 48 -base64`"
	export NONCE_KEY="`openssl rand 48 -base64`"
	export AUTH_SALT="`openssl rand 48 -base64`"
	export SECURE_AUTH_SALT="`openssl rand 48 -base64`"
	export LOGGED_IN_SALT="`openssl rand 48 -base64`"
	export NONCE_SALT="`openssl rand 48 -base64`"
	export VISUAL="nano"

	echo "" > /etc/.env && env | grep = >> /etc/.env
	for var in `cat /etc/.env`; do echo $var >> $wpm/.env; done	
	chown $user:nginx $wpm/.env

	echo -e "$(date +%Y-%m-%d\ %T) Environment setup completed" >> /var/log/wpm-install.log
}
