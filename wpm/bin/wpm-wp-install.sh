# ------------------------
# WORDPRESS INSTALL
# ------------------------

wpm_wp_install() {

	wpm_environment
	
	cd $web
	
	if [[  ! -z "$WP_TITLE" && ! -z "$WP_USER" && ! -z "$WP_MAIL" && ! -z "$WP_PASS"  ]]; then 
	
		# start mysql server
		mysqld_safe > /dev/null 2>&1 &
		while [[  ! -e /run/mysqld/mysqld.sock  ]]; do sleep 1; done
		
		wp core install --allow-root --url=$WP_HOME --title=$WP_TITLE --admin_name=$WP_USER --admin_email=$WP_MAIL --admin_password=$WP_PASS
		wp rewrite structure --allow-root '/%postname%/'
		wpm_wp_plugins
		
		# stop mysql server
		mysqladmin -u root shutdown
		
	fi
	echo -e "$(date +%Y-%m-%d\ %T) - WordPress installed successfully." >> /var/log/wpm-install.log
}
