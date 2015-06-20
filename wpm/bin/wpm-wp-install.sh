# ------------------------
# WORDPRESS INSTALL
# ------------------------

wpm_wp_install() {

	mysqld_safe > /dev/null 2>&1 &
	
	while [[  ! -e /run/mysqld/mysqld.sock  ]]; do sleep 1; done
	
	cd $wpm
	
	wp core install --allow-root --url=$WP_HOME --title=$WP_TITLE --admin_name=$WP_USER --admin_email=$WP_MAIL --admin_password=$WP_PASS
	wp rewrite structure --allow-root '/%postname%/'
	
	if [[  -n $MEMCACHE_PORT  ]]; then wp_ffpc; fi
	if [[  -n $REDIS_PORT  ]]; then wp_redis; fi
	
# 	sed -i '/DISALLOW_FILE_MODS/d' /var/wpm/config/environments/production.php
	sed -i "s/define('WP_DEBUG', true)/define('WP_DEBUG', false)/g" /var/wpm/config/environments/development.php
	
	mysqladmin -u root shutdown

}
