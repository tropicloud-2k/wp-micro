wpm_setup() {

	# ------------------------
	# PACKGES
	# ------------------------
	
	wpm_header "Packages"

	apk add --update \
		libmemcached \
		mariadb \
		mariadb-client \
		nginx \
		openssl \
		php-cli \
		php-curl \
		php-fpm \
		php-ftp \
		php-gd \
		php-gettext \
		php-iconv \
		php-json \
		php-mcrypt \
		php-memcache \
		php-mysql \
		php-opcache \
		php-openssl \
		php-phar \
		php-pear \
		php-pdo \
		php-pdo_mysql \
		php-xml \
		php-zlib \
		php-zip \
		supervisor \
		nano curl git zip
	                 
	rm -rf /var/cache/apk/*
	rm -rf /var/lib/apt/lists/*
	
	# ------------------------
	# COMPOSER
	# ------------------------
	
	wpm_header "Composer"

	curl -sS https://getcomposer.org/installer | php
	mv composer.phar /usr/local/bin/composer
	
	# ------------------------
	# PREDIS
	# ------------------------
	
	wpm_header "Predis"

	pear channel-discover pear.nrk.io
	pear install nrk/Predis
	
	# ------------------------
	# WP-CLI
	# ------------------------
		
	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

	# ------------------------
	# WP-MICRO
	# ------------------------
	
	adduser -D -G nginx -s /bin/sh -h $home $user
	
	mkdir -p /etc/wpm
	mkdir -p /var/wpm
	mkdir -p /var/ssl
	mkdir -p /var/log/php
	
	chown -R $user:nginx /var/wpm
	chmod +x /wpm/wpm.sh && ln -s /wpm/wpm.sh /usr/bin/wpm
	
	ln -s /var/log $home
	ln -s /var/ssl $home

	cat /wpm/etc/nginx/nginx.conf > /etc/wpm/nginx.conf
	cat /wpm/etc/supervisord.conf > /etc/supervisord.conf

	wpm_header "Image Ok!"

}
