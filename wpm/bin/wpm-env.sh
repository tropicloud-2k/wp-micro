# ------------------------
# WPM ENV.
# ------------------------

wpm_env() {

	export DB_HOST=127.0.0.1
	export DB_NAME=$user
	export DB_USER=$user
	export WP_SITEURL=${WP_HOME}/wp
	
	echo '' > /etc/.env && env | grep = >> /etc/.env
	for var in `cat /etc/.env`; do echo -e $var >> /var/wpm/.env; done
	
	cat >> /var/wpm/.env <<END

# WP SALT
AUTH_KEY="`openssl rand 48 -base64`"
SECURE_AUTH_KEY="`openssl rand 48 -base64`"
LOGGED_IN_KEY="`openssl rand 48 -base64`"
NONCE_KEY="`openssl rand 48 -base64`"
AUTH_SALT="`openssl rand 48 -base64`"
SECURE_AUTH_SALT="`openssl rand 48 -base64`"
LOGGED_IN_SALT="`openssl rand 48 -base64`"
NONCE_SALT="`openssl rand 48 -base64`"
END

	cat >> $home/.profile <<"EOF"
for var in $(cat /etc/.env); do 
	key=$(echo $var | cut -d= -f1)
	val=$(echo $var | cut -d= -f2)
	export ${key}=${val}
done
EOF

	cat >> /root/.profile <<"EOF"
for var in $(cat /etc/.env); do 
	key=$(echo $var | cut -d= -f1)
	val=$(echo $var | cut -d= -f2)
	export ${key}=${val}
done
EOF

	chown $user:nginx /var/wpm/.env
	chown $user:nginx $home/.profile

}
