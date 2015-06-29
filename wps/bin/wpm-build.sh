
wps_build() { wps_header "Build"


# PACKGES
# ---------------------------------------------------------------------------------	
	
	apk add --update \
		mariadb-client \
		msmtp \
		nginx \
		openssl \
		php-cli \
		php-curl \
		php-fpm \
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
		curl git nano
	                 
	rm -rf /var/cache/apk/*
	rm -rf /var/lib/apt/lists/*

	
# ADMINER
# ---------------------------------------------------------------------------------
	
	mkdir -p /usr/local/adminer
	curl -sL http://www.adminer.org/latest-en.php > /usr/local/adminer/index.php

	
# COMPOSER
# ---------------------------------------------------------------------------------

	curl -sS https://getcomposer.org/installer | php
	mv composer.phar /usr/local/bin/composer

	
# PREDIS
# ---------------------------------------------------------------------------------
	
	pear channel-discover pear.nrk.io
	pear install nrk/Predis

	
# WP-CLI
# ---------------------------------------------------------------------------------

	curl -sL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/local/bin/wp
	chmod +x /usr/local/bin/wp

	
# WP-USER
# ---------------------------------------------------------------------------------
	
	chmod +x /wps/wps.sh && ln -s /wps/wps.sh /usr/bin/wps
	adduser -D -G nginx -s /bin/sh -h $home $user
	
	mkdir -p $home/conf.d
	mkdir -p $home/init.d
	mkdir -p $home/log/nginx
	mkdir -p $home/log/php
	mkdir -p $home/ssl
	
	cat /wps/etc/.profile > /root/.profile
	cat /wps/etc/.profile > $home/.profile
		
	wps_header "Build completed"
}

