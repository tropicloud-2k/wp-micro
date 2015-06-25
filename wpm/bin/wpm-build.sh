wpm_build() {

	# ------------------------
	# PACKGES
	# ------------------------
	
	wpm_header "Build"

	apk add --update \
		mariadb-client \
		msmtp \
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
		php-pdo_pgsql \
		php-pdo_sqlite \
		php-xml \
		php-zlib \
		php-zip \
		supervisor \
		libmemcached \
		nano curl git zip
	                 
	rm -rf /var/cache/apk/*
	rm -rf /var/lib/apt/lists/*
	
	# ------------------------
	# COMPOSER
	# ------------------------
	
	curl -sS https://getcomposer.org/installer | php
	mv composer.phar /usr/local/bin/composer
	
	# ------------------------
	# PREDIS
	# ------------------------
	
	pear channel-discover pear.nrk.io
	pear install nrk/Predis
	
	# ------------------------
	# WP-CLI
	# ------------------------

	curl -sL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/local/bin/wp
	chmod +x /usr/local/bin/wp
	
	# ------------------------
	# WP-MICRO
	# ------------------------
	
	chmod +x /wpm/wpm.sh && ln -s /wpm/wpm.sh /usr/bin/wpm
	adduser -D -G nginx -s /bin/sh -h $home $user
	
	mkdir -p /var/wpm
	mkdir -p /etc/wpm/run
	mkdir -p /var/log/php

	cat /wpm/etc/.profile > $home/.profile
	cat /wpm/etc/.profile > /root/.profile
	
	cat /wpm/etc/nginx/nginx.conf > /etc/wpm/nginx.conf
	cat /wpm/etc/supervisord.conf > /etc/supervisord.conf
	cat /wpm/etc/run/php-fpm.ini  > /etc/wpm/run/php-fpm.ini
	cat /wpm/etc/run/nginx.ini    > /etc/wpm/run/nginx.ini
	
	chmod 644 /etc/supervisord.conf
	chown -R $user:nginx $wpm	
	
	wpm_header "Build completed."
}
