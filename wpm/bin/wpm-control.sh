# ------------------------
# WPM RUN
# ------------------------

wpm_run() {	

	if [[  ! -d /var/lib/mysql  ]]; then wpm_mysql_setup; fi
	if [[  ! -d /var/wpm/web  ]]; then wpm_wp_setup; fi

	wpm_header "Run forest! Run fast!" && wpm_listen
	
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

	wpm_header "Stop"

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl stop all;
		else /usr/bin/supervisorctl stop $2;
		fi
	
	fi
	echo ""
}

# ------------------------
# WPM RESTART
# ------------------------

wpm_restart() {
	
	wpm_header "Restart"

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl restart all;
		else /usr/bin/supervisorctl restart $2;
		fi
		
	else exec /usr/bin/supervisord -n -c /etc/supervisord.conf;
	fi
	echo ""
}

# ------------------------
# WPM RELOAD
# ------------------------

wpm_reload() {

	wpm_header "Reload"

	if [[  -f /tmp/supervisord.pid  ]];
	then /usr/bin/supervisorctl reload;
	fi
	echo ""
}

# ------------------------
# WPM SHUTDOWN
# ------------------------

wpm_shutdown() {

	wpm_header "Shutdown"

	if [[  -f /tmp/supervisord.pid  ]];
	then /usr/bin/supervisorctl shutdown;
	fi
	echo ""
}

# ------------------------
# WPM STATUS
# ------------------------

wpm_status() {
	
	wpm_header "Status"

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl status all;
		else /usr/bin/supervisorctl status $2;
		fi
	
	fi
	echo ""
}

# ------------------------
# WPM LOG
# ------------------------

wpm_log() {

	wpm_header "Log"
	
	if [[  -f /tmp/supervisord.pid  ]];
	then /usr/bin/supervisorctl maintail;
	fi
	echo ""
}

# ------------------------
# WPM PS
# ------------------------

wpm_ps() {

	wpm_header "Container Processes"
	ps auxf
	echo ""
}

# ------------------------
# WPM LOGIN
# ------------------------

wpm_login() {

	wpm_header "\033[0mLogged in as \033[1;37m$user\033[0m"
	su -l $user
}

# ------------------------
# WPM ROOT
# ------------------------

wpm_root() {

	wpm_header "\033[0mLogged in as \033[1;37mroot\033[0m"
	su -l root
}
