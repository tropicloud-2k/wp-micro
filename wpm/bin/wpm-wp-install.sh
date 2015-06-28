# ------------------------
# WORDPRESS INSTALL
# ------------------------

wpm_core_install() {

	su -l $WPS_USER -c "cd $web && wp core install \
	--url=$WP_HOME \
	--title=$WP_TITLE \
	--admin_name=$WP_USER \
	--admin_email=$WP_MAIL \
	--admin_password=$WP_PASS"
	su -l $WPS_USER -c "cd $web && wp rewrite structure '/%postname%/'"
	wpm_wp_plugins
}

wpm_wp_install() {

	wpm_env
	cd $web
	
	if [[  ! -z "$WP_TITLE" && ! -z "$WP_USER" && ! -z "$WP_MAIL" && ! -z "$WP_PASS"  ]]; then 
		if [[  -z $MYSQL_PORT  ]]; then
			mysqld_safe > /dev/null 2>&1 &
			while [[  ! -e /run/mysqld/mysqld.sock  ]]; do sleep 1; done && wpm_wp_core_install			
			mysqladmin -u root shutdown
		else wpm_core_install
		fi
	fi
	echo -e "$(date +%Y-%m-%d\ %T) WordPress setup completed" >> $WPS_HOME/log/wpm-install.log
}
