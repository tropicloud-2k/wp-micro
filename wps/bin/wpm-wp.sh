
# WP INSTALL
# ---------------------------------------------------------------------------------

wps_core_install() {

	wp core install --url=$WP_HOME --title=$WP_TITLE --admin_name=$WP_USER --admin_email=$WP_MAIL --admin_password=$WP_PASS
	wp rewrite structure '/%postname%/'
	wps_wp_plugins
}

wps_wp_install() {

	wps_env
	cd $web
	
	if [[  ! -z "$WP_TITLE" && ! -z "$WP_USER" && ! -z "$WP_MAIL" && ! -z "$WP_PASS"  ]]; then 
		if [[  -z $MYSQL_PORT  ]]; then
			mysqld_safe > /dev/null 2>&1 &
			while [[  ! -e /run/mysqld/mysqld.sock  ]]; do sleep 1; done && wps_core_install			
			mysqladmin -u root shutdown
		else wps_core_install
		fi
	fi
	echo -e "$(date +%Y-%m-%d\ %T) WordPress setup completed" >> $home/log/wps-install.log
}


# WP PLUGINS
# ---------------------------------------------------------------------------------

wps_wp_plugins() {

	if [[  ! -z $MEMCACHED_PORT  ]]; then
		wp plugin install wp-ffpc --activate
		sed -i "s/127.0.0.1:11211/$MEMCACHED/g" $home/conf.d/nginx.conf		
		curl -sL https://raw.githubusercontent.com/petermolnar/wp-ffpc/master/wp-ffpc.php \
		| sed "s/127.0.0.1:11211/$MEMCACHED/g" \
		| sed "s/'memcached'/'memcache'/g" \
		| sed "s/'pingback_header'.*/'pingback_header' => true,/g" \
		| sed "s/'response_header'.*/'response_header' => true,/g" \
		| sed "s/'generate_time'.*/'generate_time' => true,/g" \
		> $web/app/plugins/wp-ffpc/wp-ffpc.php
		echo "define('WP_CACHE', true);" >> $www/config/environments/production.php
	fi
	
	if [[  ! -z $REDIS_PORT  ]]; then
		wp plugin install redis-cache --activate
		sed -i "s/127.0.0.1:11211/$REDIS/g" $home/conf.d/nginx.conf
		echo "define('WP_REDIS_HOST', getenv('REDIS_PORT_6379_TCP_ADDR'));" >> $www/config/environments/production.php
		echo "define('WP_REDIS_PORT', getenv('REDIS_PORT_6379_TCP_PORT'));" >> $www/config/environments/production.php
	fi
}
