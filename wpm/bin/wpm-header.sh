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

	if [[  ! -z $MEMCACHE_PORT || ! -z $REDIS_PORT  ]]; then
		if [[  ! -z $REDIS_PORT  ]]; then echo -e "\033[0m  Redis\033[1;37m @\033[0m $WPM_REDIS \033[1;32m(active)"; fi
		if [[  ! -z $MEMCACHE_PORT  ]]; then echo -e "\033[0m  Memcached\033[1;37m @\033[0m $WPM_MEMCACHE \033[1;32m(active)\n"; fi
	fi
}
