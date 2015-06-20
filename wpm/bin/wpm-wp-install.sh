wpm_wp_install() {

	mysqld_safe > /dev/null 2>&1 &
	while [[  ! -e /run/mysqld/mysqld.sock  ]]; do sleep 1; done
	
	cd /var/wpm/web
	
	wp core install --allow-root --url=$WP_HOME --title=$WP_TITLE --admin_name=$WP_USER --admin_email=$WP_MAIL --admin_password=$WP_PASS
	wp rewrite structure --allow-root '/%postname%/'
	
	if [[  -n $MEMCACHE_PORT  ]]; then 
		su -l $user -c "cd /var/wpm/web && wp plugin install wp-ffpc --activate"
		sed -i "s/127.0.0.1:11211/$WP_MEMCACHE/g" /var/wpm/web/app/plugins/wp-ffpc/wp-ffpc.php
		sed -i "s/'memcached'/'memcache'/g" /var/wpm/web/app/plugins/wp-ffpc/wp-ffpc.php
		echo "define('WP_CACHE', true);" >> /var/wpm/config/environments/production.php
	fi

	if [[  -n $REDIS_PORT  ]]; then 
		su -l $user -c "cd /var/wpm/web && wp plugin install redis-cache --activate"
		echo "define('WP_REDIS_HOST', getenv('WP_REDIS'));" >> /var/wpm/config/environments/production.php
	fi
	
	sed -i '/DISALLOW_FILE_MODS/d' /var/wpm/config/environments/production.php
	
	mysqladmin -u root shutdown
}

