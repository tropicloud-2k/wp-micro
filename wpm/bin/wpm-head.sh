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
		*.*) wpm_header "Hostname" && echo -e "  Using \033[0;37m${HOSTNAME}\033[0m as hostname (domain)\n  Proceeding...";;
		*) wpm_header "Hostname" && echo -e "\033[1;31m  Use the \033[0;31m-h\033[1;31m flag to set hostname (domain)\n  Aborting...\033[0m" && exit 1;;
	esac
}

