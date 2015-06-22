# ------------------------
# WPM HEADER
# ------------------------

wpm_header() {

	if [[  $1 == '--links'  ]]; then lorem="$2"; else lorem="$1"; fi	

	echo -e "\033[0;30m
-----------------------------------------------------
\033[1;33m  (wpm+) \033[0m|\033[1;37m $lorem \033[0;30m
-----------------------------------------------------
\033[0m"

	if [[  $1 == '--links'  ]]; then
		if [[  ! -z $REDIS_PORT  ]];
		then echo -e "\033[1;32m  •\033[0;37m Redis\033[0m listening at `echo $REDIS_PORT | cut -d/ -f3`"		
		else echo -e "\033[1;31m  •\033[0;37m Redis\033[0m not connected"
		fi		
		if [[  ! -z $MEMCACHED_PORT  ]];
		then echo -e "\033[1;32m  •\033[0;37m Memcached\033[0m listening at `echo $MEMCACHED_PORT | cut -d/ -f3`"
		else echo -e "\033[1;31m  •\033[0;37m Memcached\033[0m not connected"
		fi
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
	wpm_header --links "Welcome!"
	echo -e "\033[0m  Using \033[0;37m${HOSTNAME}\033[0m as hostname (domain).\n"
}

wpm_hostname_false(){
	wpm_header "Error! Hostname is not set."
	echo -e "\033[1;31m  Use the \033[1;37m-h\033[1;31m flag to set the hostname (domain).\n\033[0m"
	echo -e "  Ex: docker run -P -h example.com -d tropicloud/wp-micro\n"	
	echo -e "  Aborting script...\n\n" && exit 1
}
