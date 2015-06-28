# ------------------------
# WPM ENV.
# ------------------------

wpm_env() {

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
	export WPM_PASSWORD="`openssl rand 12 -hex`"
	export AUTH_KEY="`openssl rand 48 -base64`"
	export SECURE_AUTH_KEY="`openssl rand 48 -base64`"
	export LOGGED_IN_KEY="`openssl rand 48 -base64`"
	export NONCE_KEY="`openssl rand 48 -base64`"
	export AUTH_SALT="`openssl rand 48 -base64`"
	export SECURE_AUTH_SALT="`openssl rand 48 -base64`"
	export LOGGED_IN_SALT="`openssl rand 48 -base64`"
	export NONCE_SALT="`openssl rand 48 -base64`"
	export HOME="/home/wordpress"
	export VISUAL="nano"

# 	export WPM_PASS_SHA="`echo -ne "$WPM_PASSWORD" | sha1sum | awk '{print $1}'`"
# 	echo -e "$user:`openssl passwd -crypt $WPM_PASSWORD`\n" > $home/.htpasswd

	# environment dump
	echo "" > /etc/.env && env | grep = >> /etc/.env
	
	# php dotenv
	for var in `cat /etc/.env`; do echo $var >> $wpm/.env; done	
	
	echo -e "set \$MYSQL_HOST $DB_HOST;" >  $home/.adminer
	echo -e "set \$MYSQL_NAME $DB_NAME;" >> $home/.adminer
	echo -e "set \$MYSQL_USER $DB_USER;" >> $home/.adminer
	
	cat /wpm/etc/supervisord.conf \
	| sed -e "s/example.com/$HOSTNAME/g" \
	| sed -e "s/WPM_PASSWORD/{SHA}$WPM_PASS_SHA/g" \
	> /etc/supervisord.conf && chmod 644 /etc/supervisord.conf

	echo -e "$(date +%Y-%m-%d\ %T) Environment setup completed" >> $home/log/wpm-install.log
}
