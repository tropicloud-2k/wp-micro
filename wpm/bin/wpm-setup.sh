wpm_setup() {

	# ------------------------
	# PACKGES
	# ------------------------
	
	wpm_header "Alpine Packges"

	apk add --update \
		mariadb \
		mariadb-client \
		nginx \
		openssl \
		php-cli \
		php-common \
		php-curl \
		php-fpm \
		php-ftp \
		php-gd \
		php-gettext \
		php-json \
		php-mcrypt \
		php-memcache \
		php-mysql \
		php-opcache \
		php-openssl \
		php-phar \
		php-pear \
		php-pdo \
		php-pdo_pgsql \
		php-pdo_sqlite \
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
	
	wpm_header "Composer Install"
	
	curl -S https://getcomposer.org/installer | php
	mv composer.phar /usr/local/bin/composer
	
	# ------------------------
	# WP-CLI
	# ------------------------
	
	wpm_header "WP-CLI Install"

	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
		
	# ------------------------
	# WP-MICRO
	# ------------------------
	
	adduser -D -G nginx -s "/bin/sh" -h $home $user
	
	mkdir -p $home/etc
	mkdir -p $home/log
	mkdir -p $home/ssl
	
	cat /wpm/etc/nginx/nginx.conf > /etc/nginx/nginx.conf
	cat /wpm/etc/php/php-fpm.conf > /etc/php/php-fpm.conf

	chmod +x /wpm/wpm.sh && ln -s /wpm/wpm.sh /usr/bin/wpm

}
