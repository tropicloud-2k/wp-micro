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
	echo -e "\033[0m  Using \033[0;37m${HOSTNAME}\033[0m as hostname (domain).\n"
	if [[  ! -z $REDIS_PORT  ]];
	then echo -e "\033[1;32m  •\033[0;37m Redis \033[0m(`echo $REDIS_PORT | cut -d/ -f3`)"		
	else echo -e "\033[1;31m  •\033[0;37m Redis \033[0m(not connected)"
	fi		
	if [[  ! -z $MEMCACHED_PORT  ]];
	then echo -e "\033[1;32m  •\033[0;37m Memcached \033[0m(`echo $MEMCACHED_PORT | cut -d/ -f3`)"
	else echo -e "\033[1;31m  •\033[0;37m Redis \033[0m(not connected)"
	fi		
}

wpm_hostname_false(){
	wpm_header "\033[1;31m(Error)\033[1;37m Hostname not set!"
	echo -e "\033[1;31m  HOSTNAME NOT SET!\n"
	echo -e "\033[1;31m  Use the \033[0;31m-h\033[1;31m flag to set the container hostname (domain).\n"
	echo -e "\033[1;31m  Ex: docker run -P -h example.com -d tropicloud/wp-micro\n"	
	echo -e "\033[1;31m  Aborting script..."	
	echo -e "\033[0m"	
	exit 1
}
