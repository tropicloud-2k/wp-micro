# ------------------------
# WPM HEADER
# ------------------------

wpm_header() {
	echo -e "\033[0;30m
-----------------------------------------------------
\033[1;33m  (wpm+) \033[0m|\033[1;37m $1 \033[0;30m
-----------------------------------------------------"
	echo -e "\033[0m$2"
}

# ------------------------
# WPM LINKS
# ------------------------

wpm_links() {
	if [[  ! -z $REDIS_PORT  ]];
	then echo -e "\033[1;32m  •\033[0;37m Redis\033[0m listening at `echo $REDIS_PORT | cut -d/ -f3`"		
	else echo -e "\033[1;31m  •\033[0;37m Redis\033[0m not connected"
	fi		
	if [[  ! -z $MEMCACHED_PORT  ]];
	then echo -e "\033[1;32m  •\033[0;37m Memcached\033[0m listening at `echo $MEMCACHED_PORT | cut -d/ -f3`"
	else echo -e "\033[1;31m  •\033[0;37m Memcached\033[0m not connected"
	fi
	echo -e ""
}

# ------------------------
# WPM HOSTNAME
# ------------------------

wpm_hostname() {
	case "$HOSTNAME" in
		*.*) _domain_true;;
		*) _domain_false;;
	esac
}
_domain_false(){
	wpm_header "Error! Hostname is not set."
	echo -e "\033[1;31m  Use the \033[1;37m-h\033[1;31m flag to set the hostname (domain).\n\033[0m"
	echo -e "  Ex: docker run -P -h example.com -d tropicloud/wp-micro\n"
	echo -e "  Aborting script...\n\n" && exit 1
}
_domain_true(){ echo -e "\n\033[0;32mUsing \033[0;37m${HOSTNAME}\033[0;32m as hostname (domain)."; }

