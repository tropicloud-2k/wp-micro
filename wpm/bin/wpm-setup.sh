wpm_setup() {

	# ------------------------
	# PACKGES
	# ------------------------
	
	wpm_header "Requirements"

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
	
	curl -sS https://getcomposer.org/installer | php
	mv composer.phar /usr/local/bin/composer
	
	# ------------------------
	# WP-CLI
	# ------------------------
	
	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
		
	# ------------------------
	# WP-MICRO
	# ------------------------
	
	chmod +x /wpm/wpm.sh && ln -s /wpm/wpm.sh /usr/bin/wpm
	adduser -D -G nginx -s "/bin/sh" -h $home $user

	mkdir -p /etc/wpm
	mkdir -p /var/ssl

}
