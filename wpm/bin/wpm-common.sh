# ------------------------
# WPM CHECK	
# ------------------------

wpm_check() {
	case "$HOSTNAME" in
		*.*) wpm_check_true;;
		*) wpm_check_false;;
	esac
}

wpm_check_true() {
	if [[  ! -d /var/lib/mysql  ]]; then wpm_mysql_setup; fi
	if [[  ! -d $web  ]]; then wpm_wp_setup; fi
}

wpm_check_false() {
	wpm_header "(error) hostname is not set!"
	echo -e "\033[1;31m  Use the \033[1;37m-h\033[1;31m flag to set the hostname (domain)\n
\033[0m  Ex: docker run -P -h example.com -d tropicloud/wp-micro \n
\033[0m  Aborting script...\n\n"
	exit 1;
}

# ------------------------
# WPM HEADER
# ------------------------

wpm_header() {
	echo -e "\033[0;30m
-----------------------------------------------------
\033[0;34m  (wpm)\033[0m | \033[1;37m$1\033[0;30m
-----------------------------------------------------
\033[0m"
}

# ------------------------
# WPM LINKS
# ------------------------

wpm_links() {
	if [[  ! -z $MYSQL_PORT  ]];
	then echo -e "\033[1;32m  •\033[0;37m MySQL\033[0m --> `echo $MYSQL_PORT | cut -d/ -f3 | cut -d: -f1`"
	else echo -e "\033[1;31m  •\033[0;37m MySQL\033[0m (not linked)"
	fi	
	if [[  ! -z $REDIS_PORT  ]];
	then echo -e "\033[1;32m  •\033[0;37m Redis\033[0m --> `echo $REDIS_PORT | cut -d/ -f3 | cut -d: -f1`"		
	else echo -e "\033[1;31m  •\033[0;37m Redis\033[0m (not linked)"
	fi		
	if [[  ! -z $MEMCACHED_PORT  ]];
	then echo -e "\033[1;32m  •\033[0;37m Memcached\033[0m --> `echo $MEMCACHED_PORT | cut -d/ -f3 | cut -d: -f1`"
	else echo -e "\033[1;31m  •\033[0;37m Memcached\033[0m (not linked)"
	fi
}

# ------------------------
# WPM CHMOD
# ------------------------

wpm_chmod() { 
	
	chown -R ${WPS_UID}:${WPS_GID} $home
	
	find $home -type f -exec chmod 644 {} \;
	find $home -type d -exec chmod 755 {} \;
}

wpm_adminer() { 
	wpm_header "Adminer (mysql admin)"
	echo -e "  Password: $WPM_PASSWORD\n"
	php -S 0.0.0.0:8080 -t /usr/local/adminer
}
