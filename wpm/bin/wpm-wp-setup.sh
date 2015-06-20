wpm_wp_setup() {

	wpm_header "WordPress Install"
	
	# ------------------------
	# NGINX
	# ------------------------

	if [[  $WP_SSL == 'true'  ]]; then 
		export WP_HOME="https://${HOSTNAME}"
	    cat /wpm/etc/nginx/wpssl.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/wpm/wordpress.conf
	else 
		export WP_HOME="http://${HOSTNAME}"
	    cat /wpm/etc/nginx/wp.conf | sed -e "s/example.com/$HOSTNAME/g" > /etc/wpm/wordpress.conf
	fi
	
	if [[  $WP_ENV == 'production'  ]]; then
		if [[  ! -z $MEMCACHE_PORT  ]]; then 
			export WP_MEMCACHE=`echo $MEMCACHE_PORT | cut -d/ -f3`
			sed -i "s/127.0.0.1:11211/$WP_MEMCACHE/g" /etc/wpm/nginx.conf
		fi		
		if [[  ! -z $REDIS_PORT  ]]; then 
			export WP_REDIS=`echo $REDIS_PORT | cut -d/ -f3`
			sed -i "s/127.0.0.1:11211/$WP_REDIS/g" /etc/wpm/nginx.conf
		fi
	fi
	
	# ------------------------
	# PHP-FPM
	# ------------------------
	
	if [[  $(free -m | grep 'Mem' | awk '{print $2}') -gt 1800  ]];
	then cat /wpm/etc/php/php-fpm.conf > /etc/wpm/php-fpm.conf
	else cat /wpm/etc/php/php-fpm-min.conf > /etc/wpm/php-fpm.conf
	fi
	
	# ------------------------
	# WORDPRESS
	# ------------------------
	
	su -l $user -c "cd /var/wpm && git clone $WP_REPO ."
	su -l $user -c "cd /var/wpm && composer install"
	su -l $user -c "ln -s $wpm ~/"
	
	if [[  ! -f /var/wpm/.env   ]]; then wpm_env; fi

	if [[  -n "$WP_TITLE" && -n "$WP_USER" && -n "$WP_MAIL" && -n "$WP_PASS"  ]]; then wpm_wp_install; fi
	
	if [[  -n $MEMCACHE_PORT || -n $REDIS_PORT  ]]; then
		
		wpm_header "Backing Services"
		
		if [[  -n $MEMCACHE_PORT  ]]; then echo -e "\033[1;37m  Memcached:\033[0m $WP_MEMCACHE\033[0m"; fi
		if [[  -n $REDIS_PORT  ]]; then echo -e "\033[1;37m  Redis:\033[0m $WP_REDIS\033[0m"; fi

	fi

	wpm_ssl $HOSTNAME

}
