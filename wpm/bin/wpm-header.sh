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
