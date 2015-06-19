# ------------------------
# WPM START
# ------------------------

wpm_start() {	

	if [[  ! -d /var/lib/mysql  ]]; then wpm_mysql_setup; fi
	if [[  ! -d /var/wpm/web  ]]; then wpm_wp_setup; fi

	wpm_header "Service Startup"

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl start all;
		else /usr/bin/supervisorctl start $2;
		fi

	else exec /usr/bin/supervisord -n -c /etc/supervisord.conf	
	fi
}

# ------------------------
# WPM STOP
# ------------------------

wpm_stop() {

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl stop all;
		else /usr/bin/supervisorctl stop $2;
		fi
	
	fi
}

# ------------------------
# WPM RESTART
# ------------------------

wpm_restart() {
	
	wpm_header "Service Restart"

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl restart all;
		else /usr/bin/supervisorctl restart $2;
		fi
		
	else exec /usr/bin/supervisord -n -c /etc/supervisord.conf;
	fi
}

# ------------------------
# WPM RELOAD
# ------------------------

wpm_reload() {

	if [[  -f /tmp/supervisord.pid  ]];
	then /usr/bin/supervisorctl reload;
	fi
}

# ------------------------
# WPM SHUTDOWN
# ------------------------

wpm_shutdown() {

	if [[  -f /tmp/supervisord.pid  ]];
	then /usr/bin/supervisorctl shutdown;
	fi
}

# ------------------------
# WPM STATUS
# ------------------------

wpm_status() {
	
	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl status all;
		else /usr/bin/supervisorctl status $2;
		fi
	
	fi
}

# ------------------------
# WPM LOG
# ------------------------

wpm_log() {

	if [[  -f /tmp/supervisord.pid  ]];
	then /usr/bin/supervisorctl maintail;
	fi
}

# ------------------------
# WPM LOGIN
# ------------------------

wpm_login() {

	wpm_header "Logged in as $user"
	su -l $user;
}

# ------------------------
# WPM ROOT
# ------------------------

wpm_root() {

	wpm_header "Logged in as root"
	/bin/sh;
}
