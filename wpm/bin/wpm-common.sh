# ------------------------
# WPM HEADER
# ------------------------

wpm_header() {
	echo -e "\033[0;30m
-----------------------------------------------------
\033[1;33m  (wpm+) \033[0m|\033[1;37m $1 \033[0;30m
-----------------------------------------------------
\033[0m"
}

# ------------------------
# WPM LINKS
# ------------------------

wpm_links() {
	if [[  ! -z $MYSQL_PORT  ]];
	then echo -e "\033[1;32m  •\033[0;37m MySQL\033[0m --link: `echo $MYSQL_PORT | cut -d/ -f3 | cut -d: -f1`"
	else echo -e "\033[1;31m  •\033[0;37m MySQL\033[0m (not linked)"
	fi	
	if [[  ! -z $REDIS_PORT  ]];
	then echo -e "\033[1;32m  •\033[0;37m Redis\033[0m --link: `echo $REDIS_PORT | cut -d/ -f3 | cut -d: -f1`"		
	else echo -e "\033[1;31m  •\033[0;37m Redis\033[0m (not linked)"
	fi		
	if [[  ! -z $MEMCACHED_PORT  ]];
	then echo -e "\033[1;32m  •\033[0;37m Memcached\033[0m --link: `echo $MEMCACHED_PORT | cut -d/ -f3 | cut -d: -f1`"
	else echo -e "\033[1;31m  •\033[0;37m Memcached\033[0m (not linked)"
	fi
}

# ------------------------
# WPM HOSTNAME
# ------------------------

wpm_hostname() {
	case "$HOSTNAME" in
		*.*) wpm_hostname_true;;
		*) wpm_hostname_false;;
	esac
}

wpm_hostname_true(){
	wpm_header "Welcome to WP-MICRO"
	echo -e "\033[0m  Using \033[0;37m${HOSTNAME}\033[0m as hostname (domain)\n"
	wpm_links
}

wpm_hostname_false(){
	wpm_header "Error! Hostname is not set."
	echo -e "\033[1;31m  Use the \033[1;37m-h\033[1;31m flag to set the hostname (domain)\n
\033[0m  Ex: docker run -P -h example.com -d tropicloud/wp-micro \n
\033[0m  Aborting script...\n\n" && exit 1
}
