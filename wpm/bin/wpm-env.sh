# ------------------------
# WPM ENV.
# ------------------------

wpm_env() {

	cat > $home/www/.env <<END
DB_NAME=$user
DB_USER=$user
DB_PASSWORD=`cat /etc/.header_mustache`
DB_HOST=127.0.0.1

WP_ENV=production
WP_HOME=$SCHEME://$HOSTNAME
WP_SITEURL=$SCHEME://$HOSTNAME/wp
END

chown $user:nginx $home/www/.env

}
