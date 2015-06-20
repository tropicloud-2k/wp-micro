# ------------------------
# WORDPRESS PLUGINS
# ------------------------

wp_ffpc() {
	su -l $user -c "cd /var/wpm/web && wp plugin install wp-ffpc --activate"
	sed -i "s/127.0.0.1:11211/$WP_MEMCACHE/g" /var/wpm/web/app/plugins/wp-ffpc/wp-ffpc.php
	sed -i "s/'memcached'/'memcache'/g" /var/wpm/web/app/plugins/wp-ffpc/wp-ffpc.php
	sed -i "s/'pingback_header'*/'pingback_header' => true,/g" /var/wpm/web/app/plugins/wp-ffpc/wp-ffpc.php
	sed -i "s/'response_header'*/'response_header' => true,/g" /var/wpm/web/app/plugins/wp-ffpc/wp-ffpc.php
	sed -i "s/'generate_time'*/'generate_time' => true,/g" /var/wpm/web/app/plugins/wp-ffpc/wp-ffpc.php
	echo "define('WP_CACHE', true);" >> /var/wpm/config/environments/production.php
}

wp_redis() {
	su -l $user -c "cd /var/wpm/web && wp plugin install redis-cache --activate"
	echo "define('WP_REDIS_HOST', getenv('WP_REDIS'));" >> /var/wpm/config/environments/production.php
}

# ------------------------
# WORDPRESS INSTALL
# ------------------------

wpm_wp_install() {

	mysqld_safe > /dev/null 2>&1 &
	
	while [[  ! -e /run/mysqld/mysqld.sock  ]]; do sleep 1; done
	
	cd /var/wpm/web
	
	wp core install --allow-root --url=$WP_HOME --title=$WP_TITLE --admin_name=$WP_USER --admin_email=$WP_MAIL --admin_password=$WP_PASS
	wp rewrite structure --allow-root '/%postname%/'
	
	if [[  -n $MEMCACHE_PORT  ]]; then wp_ffpc; fi
	if [[  -n $REDIS_PORT  ]]; then wp_redis; fi
	
# 	sed -i '/DISALLOW_FILE_MODS/d' /var/wpm/config/environments/production.php
	sed -i "s/define('WP_DEBUG', true)/define('WP_DEBUG', false)/g" /var/wpm/config/environments/development.php
	
	mysqladmin -u root shutdown

}
