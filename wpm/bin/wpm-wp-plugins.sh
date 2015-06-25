# ------------------------
# WORDPRESS PLUGINS
# ------------------------

wpm_wp_plugins() {

	cd $web
	
	# Autoptimize
	if [[  $WP_ENV == 'production'  ]]; then
		wp plugin install autoptimize
		wp option update autoptimize_html 'on'
		wp option update autoptimize_html_keepcomments 'on'
		wp option update autoptimize_js 'on'
		wp option update autoptimize_css 'on'
		wp option update autoptimize_css_datauris 'on'
	fi
		
	# Memcached full-page cache
	if [[  ! -z $MEMCACHED_PORT  ]]; then
		wp plugin install wp-ffpc --activate
		sed -i "s/127.0.0.1:11211/$MEMCACHED/g" /etc/wpm/nginx.conf		
		curl https://raw.githubusercontent.com/petermolnar/wp-ffpc/master/wp-ffpc.php \
		| sed "s/127.0.0.1:11211/$MEMCACHED/g" \
		| sed "s/'memcached'/'memcache'/g" \
		| sed "s/'pingback_header'.*/'pingback_header' => true,/g" \
		| sed "s/'response_header'.*/'response_header' => true,/g" \
		| sed "s/'generate_time'.*/'generate_time' => true,/g" \
		> $web/app/plugins/wp-ffpc/wp-ffpc.php
		echo "define('WP_CACHE', true);" >> $wpm/config/environments/production.php
	fi
	
	# Redis object-cache
	if [[  ! -z $REDIS_PORT  ]]; then
		wp plugin install redis-cache --activate
		sed -i "s/127.0.0.1:11211/$REDIS/g" /etc/wpm/nginx.conf
		echo "define('WP_REDIS_HOST', getenv('REDIS_PORT_6379_TCP_ADDR'));" >> $wpm/config/environments/production.php
		echo "define('WP_REDIS_PORT', getenv('REDIS_PORT_6379_TCP_PORT'));" >> $wpm/config/environments/production.php
	fi
}