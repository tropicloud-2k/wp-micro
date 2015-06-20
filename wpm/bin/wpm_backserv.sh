wpm_back_serv() {

if [[  ! -z $MEMCACHE_PORT || ! -z $REDIS_PORT  ]]; then
	
	wpm_header "Links"
	
	if [[  ! -z $REDIS_PORT  ]]; then echo -e "\033[1;37m  Redis:\033[0m $WPM_REDIS\033[0m"; fi
	if [[  ! -z $MEMCACHE_PORT  ]]; then echo -e "\033[1;37m  Memcached:\033[0m $WPM_MEMCACHE\033[0m"; fi

fi

}
