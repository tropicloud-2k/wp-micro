# ------------------------
# WORDPRESS SETUP
# ------------------------

wpm_wordpress() {

	su -l $user -c "git clone https://github.com/roots/bedrock.git www"
	su -l $user -c "cd www && composer install"
	
	if [[  -z $SSL  ]];
	then SCHEME="http" && cat /wpm/etc/nginx/wp.conf | sed -e "s/example.com/$HOSTNAME/g" > $home/etc/nginx.conf
	else SCHEME="https" && cat /wpm/etc/nginx/wpssl.conf | sed -e "s/example.com/$HOSTNAME/g" > $home/etc/nginx.conf && wpm_ssl $HOSTNAME
	fi

}
