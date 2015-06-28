# ------------------------
# WPM ENV.
# ------------------------

wpm_env() {

	# hide "The mysql extension is deprecated and will be removed in the future: use mysqli or PDO"
	sed -i "s/define('WP_DEBUG'.*/define('WP_DEBUG', false);/g" $WPS_WWW/config/environments/development.php

	if [[  ! -z $WPS_MEMCACHED_PORT  ]]; then export WPS_MEMCACHED=`echo $WPS_MEMCACHED_PORT | cut -d/ -f3`; fi		
	if [[  ! -z $WPS_REDIS_PORT  ]]; then export WPS_REDIS=`echo $WPS_REDIS_PORT | cut -d/ -f3`; fi
	if [[  ! -z $MYSQL_PORT  ]]; then export WPS_MYSQL=`echo $MYSQL_PORT | cut -d/ -f3`; fi
	
	if [[  $WP_SSL == 'true'  ]];
	then export WP_HOME="https://${HOSTNAME}"
	else export WP_HOME="http://${HOSTNAME}"
	fi
	
	export WP_SITEURL="${WP_HOME}/wp"
	export WPS_PASS="`openssl rand 12 -hex`"
# 	export WPS_SHA1="`echo -ne "$WPS_PASS" | sha1sum | awk '{print $1}'`"
	export AUTH_KEY="`openssl rand 48 -base64`"
	export SECURE_AUTH_KEY="`openssl rand 48 -base64`"
	export LOGGED_IN_KEY="`openssl rand 48 -base64`"
	export NONCE_KEY="`openssl rand 48 -base64`"
	export AUTH_SALT="`openssl rand 48 -base64`"
	export SECURE_AUTH_SALT="`openssl rand 48 -base64`"
	export LOGGED_IN_SALT="`openssl rand 48 -base64`"
	export NONCE_SALT="`openssl rand 48 -base64`"
	export HOME="/home/$HOSTNAME"
	export VISUAL="nano"

	# environment dump
	echo "" > /etc/.env && env | grep = >> /etc/.env
	
	# php dotenv
	for var in `cat /etc/.env`; do echo $var >> $WPS_WWW/.env; done	
	
	echo -e "set \$MYSQL_HOST $DB_HOST;" >  $WPS_HOME/.adminer
	echo -e "set \$MYSQL_NAME $DB_NAME;" >> $WPS_HOME/.adminer
	echo -e "set \$MYSQL_USER $DB_USER;" >> $WPS_HOME/.adminer
	
	cat /wpm/etc/supervisord.conf \
	| sed -e "s/example.com/$HOSTNAME/g" \
	| sed -e "s/WPS_PASS/$WPS_PASS/g" \
	> /etc/supervisord.conf && chmod 644 /etc/supervisord.conf

	echo -e "$WPS_USER:`openssl passwd -crypt $WPS_PASS`" > $WPS_HOME/.htpasswd
	echo -e "$(date +%Y-%m-%d\ %T) Environment setup completed" >> $WPS_HOME/log/wpm-install.log
}
