# ------------------------
# WORDPRESS PLUGINS
# ------------------------

wpm_wp_plugins() {

	# Memcached full-page cache
	if [[  ! -z $MEMCACHED_PORT  ]]; then
		su -l $WPS_USER -c "cd $web && wp plugin install wp-ffpc --activate"
		sed -i "s/127.0.0.1:11211/$MEMCACHED/g" $WPS_HOME/conf.d/nginx.conf		
		curl -sL https://raw.githubusercontent.com/petermolnar/wp-ffpc/master/wp-ffpc.php \
		| sed "s/127.0.0.1:11211/$MEMCACHED/g" \
		| sed "s/'memcached'/'memcache'/g" \
		| sed "s/'pingback_header'.*/'pingback_header' => true,/g" \
		| sed "s/'response_header'.*/'response_header' => true,/g" \
		| sed "s/'generate_time'.*/'generate_time' => true,/g" \
		> $web/app/plugins/wp-ffpc/wp-ffpc.php
		echo "define('WP_CACHE', true);" >> $WPS_WWW/config/environments/production.php
	fi
	
	# Redis object-cache
	if [[  ! -z $REDIS_PORT  ]]; then
		su -l $WPS_USER -c "cd $web && wp plugin install redis-cache --activate"		
		sed -i "s/127.0.0.1:11211/$REDIS/g" $WPS_HOME/conf.d/nginx.conf
		echo "define('WP_REDIS_HOST', getenv('REDIS_PORT_6379_TCP_ADDR'));" >> $WPS_WWW/config/environments/production.php
		echo "define('WP_REDIS_PORT', getenv('REDIS_PORT_6379_TCP_PORT'));" >> $WPS_WWW/config/environments/production.php
	fi
}
