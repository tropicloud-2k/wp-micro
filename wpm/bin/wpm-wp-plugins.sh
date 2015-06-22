# ------------------------
# WORDPRESS PLUGINS
# ------------------------

wpm_wp_plugins() {

	# Memcached full-page cache
	if [[  ! -z $MEMCACHED_PORT  ]]; then
		su -l $user -c "cd $web && wp plugin install wp-ffpc --activate"
		sed -i "s/127.0.0.1:11211/$MEMCACHED/g" /etc/wpm/nginx.conf		
		cat $web/app/plugins/wp-ffpc/wp-ffpc.php \
		| sed -i "s/127.0.0.1:11211/$MEMCACHED/g" \
		| sed -i "s/'300'/'3600'/g" \
		| sed -i "s/'memcached'/'memcache'/g" \
		| sed -i "s/'pingback_header'.*/'pingback_header' => true,/g" \
		| sed -i "s/'response_header'.*/'response_header' => true,/g" \
		| sed -i "s/'generate_time'.*/'generate_time' => true,/g" \
		> $web/app/plugins/wp-ffpc/wp-ffpc.php
		echo "define('WP_CACHE', true);" >> $wpm/config/environments/production.php
	fi
	
	# Redis object-cache
	if [[  ! -z $REDIS_PORT  ]]; then
		su -l $user -c "cd $web && wp plugin install redis-cache --activate"		
		sed -i "s/127.0.0.1:11211/$REDIS/g" /etc/wpm/nginx.conf
		echo "define('WP_REDIS_HOST', getenv('REDIS_PORT_6379_TCP_ADDR'));" >> $wpm/config/environments/production.php
		echo "define('WP_REDIS_PORT', getenv('REDIS_PORT_6379_TCP_PORT'));" >> $wpm/config/environments/production.php
	fi
}