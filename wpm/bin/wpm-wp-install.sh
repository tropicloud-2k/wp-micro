# ------------------------
# WORDPRESS INSTALL
# ------------------------

wp_core_install() {
wp core install --allow-root --url=$WP_HOME --title=$WP_TITLE --admin_name=$WP_USER --admin_email=$WP_MAIL --admin_password=$WP_PASS
wp rewrite structure --allow-root '/%postname%/' && wpm_wp_plugins
}

wpm_wp_install() {

	cd $web && wpm_env
	
	if [[  ! -z "$WP_TITLE" && ! -z "$WP_USER" && ! -z "$WP_MAIL" && ! -z "$WP_PASS"  ]]; then 
	
		# start mysql server
		mysqld_safe > /dev/null 2>&1 &
		while [[  ! -e /run/mysqld/mysqld.sock  ]]; do sleep 1; done
		
		wp_core_install > /var/log/wp_core_install.log
		
		# stop mysql server
		mysqladmin -u root shutdown
	
	fi
}
