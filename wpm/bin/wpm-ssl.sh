# ------------------------
# WPM SSL
# ------------------------

wpm_ssl() {

	cd /var/ssl
	
	cat /wpm/etc/nginx/openssl.conf | sed -e "s/example.com/$HOSTNAME/g" > openssl.conf
	
	openssl req -nodes -sha256 -newkey rsa:2048 -keyout app.key -out app.csr -config openssl.conf -batch
	openssl rsa -in app.key -out app.key
	openssl x509 -req -days 365 -sha256 -in app.csr -signkey app.key -out app.crt
	
	rm -f openssl.conf
			
}	
