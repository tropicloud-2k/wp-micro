wpm_wp_install() {

	mysqld_safe > /dev/null 2>&1 &
	while [[  ! -e /run/mysqld/mysqld.sock  ]]; do sleep 1; done
	
	cd /var/wpm/web
	wp core install --allow-root --url=$WP_HOME --title=$WP_TITLE --admin_name=$WP_USER --admin_email=$WP_MAIL --admin_password=$WP_PASS
	
	mysqladmin -u root shutdown

}
