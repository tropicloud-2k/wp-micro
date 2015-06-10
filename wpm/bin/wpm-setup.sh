wpm_setup() {

	# ------------------------
	# WP-MICRO
	# ------------------------
	
	chmod +x /wpm/wpm.sh && ln -s /wpm/wpm.sh /usr/bin/wpm
	
	mkdir -p /etc/wpm
	mkdir -p /var/log/wpm
	mkdir -p /var/ssl
	
	echo -ne `openssl rand -hex 36` > /etc/wpm/.wpm_shadow
	
	# ------------------------
	# PACKGES
	# ------------------------
	
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
	
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/local/bin/wp
	chmod +x /usr/local/bin/wp
		
	# ------------------------
	# WORDPRESS
	# ------------------------
	
	adduser -D -G nginx -s "/bin/sh" -h $home $user
	
	su -l $user -c "git clone https://github.com/roots/bedrock.git ."
	su -l $user -c "composer install"
	
}
