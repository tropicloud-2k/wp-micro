# ------------------------
# WORDPRESS PLUGINS
# ------------------------

wp_ffpc() {

	su -l $user -c "cd $web && wp plugin install wp-ffpc --activate"

	sed -i "s/127.0.0.1:11211/$WP_MEMCACHE/g" $web/app/plugins/wp-ffpc/wp-ffpc.php
	sed -i "s/'memcached'/'memcache'/g" $web/app/plugins/wp-ffpc/wp-ffpc.php
	sed -i "s/'pingback_header'.*/'pingback_header' => true,/g" $web/app/plugins/wp-ffpc/wp-ffpc.php
	sed -i "s/'response_header'.*/'response_header' => true,/g" $web/app/plugins/wp-ffpc/wp-ffpc.php
	sed -i "s/'generate_time'.*/'generate_time' => true,/g" $web/app/plugins/wp-ffpc/wp-ffpc.php

	echo "define('WP_CACHE', true);" >> $wpm/config/environments/production.php
}

wp_redis() {

	su -l $user -c "cd $web && wp plugin install redis-cache --activate"
	
	echo "define('WP_REDIS_HOST', getenv('REDIS_PORT_6379_TCP_ADDR'));" >> $wpm/config/environments/production.php
	echo "define('WP_REDIS_PORT', getenv('REDIS_PORT_6379_TCP_PORT'));" >> $wpm/config/environments/production.php
}
