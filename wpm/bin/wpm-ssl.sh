# ------------------------
# WPM SSL
# ------------------------

wpm_ssl() {

	wpm_header "SSL Cert."

	cd /var/ssl
	
	cat /wpm/etc/nginx/openssl.conf | sed -e "s/example.com/$HOSTNAME/g" > openssl.conf
	
	openssl req -nodes -sha256 -newkey rsa:2048 -keyout $HOSTNAME.key -out $HOSTNAME.csr -config openssl.conf -batch
	openssl rsa -in $HOSTNAME.key -out $HOSTNAME.key
	openssl x509 -req -days 365 -sha256 -in $HOSTNAME.csr -signkey $HOSTNAME.key -out $HOSTNAME.crt
	
	rm -f openssl.conf
}
