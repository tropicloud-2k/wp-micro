# ------------------------
# WORDPRESS INSTALL
# ------------------------

wpm_wp_install() {

	cd $web && wpm_env
	
	if [[  ! -z "$WP_TITLE" && ! -z "$WP_USER" && ! -z "$WP_MAIL" && ! -z "$WP_PASS"  ]]; then 
		wp core install --allow-root --url=$WP_HOME --title=$WP_TITLE --admin_name=$WP_USER --admin_email=$WP_MAIL --admin_password=$WP_PASS
		wp rewrite structure --allow-root '/%postname%/'
		wpm_wp_plugins
	fi

}
