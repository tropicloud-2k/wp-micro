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
# WPM LISTEN
# ------------------------

wpm_listen() {
	if [[  ! -z $REDIS_PORT  ]]; then echo -e "\033[1;32m  •\033[0;37m Redis \033[0m($REDIS_WPM)"; fi		
	if [[  ! -z $MEMCACHED_PORT  ]]; then echo -e "\033[1;32m  •\033[0;37m Memcached \033[0m($MEMCACHED_WPM)\n"; fi
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
	echo -e "\033[0m  Using \033[0;37m${HOSTNAME}\033[0m as hostname (domain)."
	wpm_listen
}

wpm_hostname_false(){
	wpm_header "Fatal Error!"
	echo -e "\033[1;31m  Please use the \033[0;31m-h\033[1;31m flag to set the container hostname (domain)."
	echo -e "\033[1;31m  Example:\n"	
	echo -e "\033[1;31m  docker run -it -p 80:80 -p 443:443 -e WP_SSL=true -h example.com tropicloud/wp-micro"	
	echo -e "\033[0m"	
	exit 1
}
