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
		*.*) wpm_header "Hostname" && echo -e "Using \033[0;37m${HOSTNAME}\033[0m as the domain/hostname.\n\033[1;32mDone.\033[0m";;
		*) wpm_header "Hostname" && echo -e "\033[1;31mPlease use the \033[0;31m-h\033[1;31m flag to set hostname (domain)\n\033[0mAborting..." && exit 1;;
	esac
}

