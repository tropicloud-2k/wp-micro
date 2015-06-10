# ------------------------
# WPM START
# ------------------------

wpm_start() {
	
	
	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl start all;
		else /usr/bin/supervisorctl start $2;
		fi
		
	else
	
		if [[  ! -d /var/lib/mysql  ]]; then mysql_setup; fi
		if [[  ! -f /var/wpm/.env   ]]; then wpm_env; fi
		
		if [[  ! -f "/var/log/php-fpm.log"  ]]; then touch /var/log/php-fpm.log; fi
		if [[  ! -f "/var/log/nginx.log"  ]]; then touch /var/log/nginx.log; fi
		
		exec /usr/bin/supervisord -n -c /wpm/etc/supervisord.conf
	
	fi
}
