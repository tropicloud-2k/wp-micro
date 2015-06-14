# ------------------------
# WPM START
# ------------------------

wpm_start() {	

	if [[  ! -d /var/lib/mysql  ]]; then wpm_mysql; fi
	if [[  ! -d /var/www/web  ]]; then wpm_wordpress; fi
	if [[  ! -f /var/www/web/.env   ]]; then wpm_env; fi

	wpm_header "Service Startup"

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl start all;
		else /usr/bin/supervisorctl start $2;
		fi

	else exec /usr/bin/supervisord -n -c /wpm/etc/supervisord.conf	
	fi
}
