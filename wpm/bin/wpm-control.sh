
# START
# ---------------------------------------------------------------------------------

wps_start() { wps_check; wps_header "Start"; wps_links && echo ""
	
	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl -u $HOSTNAME -p $WPM_ENV_HTTP_PASS start all
		else /usr/bin/supervisorctl -u $HOSTNAME -p $WPM_ENV_HTTP_PASS start $2
		fi

	else wps_chmod && exec /usr/bin/supervisord -n -c /etc/supervisord.conf
	fi
}


# STOP
# ---------------------------------------------------------------------------------

wps_stop() { wps_header "Stop"

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl -u $HOSTNAME -p $WPM_ENV_HTTP_PASS stop all
		else /usr/bin/supervisorctl -u $HOSTNAME -p $WPM_ENV_HTTP_PASS stop $2
		fi
	
	fi; echo ""
}


# RESTART
# ---------------------------------------------------------------------------------

wps_restart() { wps_header "Restart"

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl -u $HOSTNAME -p $WPM_ENV_HTTP_PASS restart all
		else /usr/bin/supervisorctl -u $HOSTNAME -p $WPM_ENV_HTTP_PASS restart $2
		fi
		
	else exec /usr/bin/supervisord -n -c /etc/supervisord.conf
	fi; echo ""
}


# RELOAD
# ---------------------------------------------------------------------------------

wps_reload() { wps_header "Reload"

	if [[  -f /tmp/supervisord.pid  ]];
	then /usr/bin/supervisorctl -u $HOSTNAME -p $WPM_ENV_HTTP_PASS reload
	fi; echo ""
}


# SHUTDOWN
# ---------------------------------------------------------------------------------

wps_shutdown() { wps_header "Shutdown"

	if [[  -f /tmp/supervisord.pid  ]];
	then /usr/bin/supervisorctl -u $HOSTNAME -p $WPM_ENV_HTTP_PASS shutdown
	fi; echo ""
}


# STATUS
# ---------------------------------------------------------------------------------

wps_status() { wps_header "Status"

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl -u $HOSTNAME -p $WPM_ENV_HTTP_PASS status all
		else /usr/bin/supervisorctl -u $HOSTNAME -p $WPM_ENV_HTTP_PASS status $2
		fi
	
	fi; echo ""
}


# LOG
# ---------------------------------------------------------------------------------

wps_log() { wps_header "Log"
	
	if [[  -f /tmp/supervisord.pid  ]];
	then /usr/bin/supervisorctl -u $HOSTNAME -p $WPM_ENV_HTTP_PASS maintail
	fi; echo ""
}


# PS
# ---------------------------------------------------------------------------------

wps_ps() { wps_header "Container Processes"

	ps auxf
	echo ""
}


# LOGIN
# ---------------------------------------------------------------------------------

wps_login() { wps_header "\033[0mLogged as \033[1;37m$user\033[0m"

	su -l $user
}


# ROOT
# ---------------------------------------------------------------------------------

wps_root() { wps_header "\033[0mLogged as \033[1;37mroot\033[0m"

	su -l root
}
