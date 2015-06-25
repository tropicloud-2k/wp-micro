# ------------------------
# MARIADB SETUP
# ------------------------

wpm_mysql_create() {
	mysql -u root -e "CREATE USER '$user'@'%' IDENTIFIED BY '$DB_PASSWORD'"
	mysql -u root -e "CREATE DATABASE $user"
	mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '$user'@'%' WITH GRANT OPTION"
}

wpm_mysql_secure() {
	mysql -u root -e "DELETE FROM mysql.user WHERE User='';"
	mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
	mysql -u root -e "DROP DATABASE test;"
	mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
}

wpm_mysql_setup() {

	if [[  -z $MYSQL_PORT  ]]; then
		
		wpm_header "MySQL Setup"

		apk add --update mariadb && rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/*
		sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf
		
		export DB_HOST="127.0.0.1"
		export DB_NAME="$user"
		export DB_USER="$user"
		export DB_PASSWORD=`openssl rand -hex 36`
		
		mysql_install_db --user=mysql > /dev/null 2>&1
		mysqld_safe > /dev/null 2>&1 &
		
		echo -ne "Starting mysql server..."
		while [[  ! -e /run/mysqld/mysqld.sock  ]]; do
			echo -n '.' && sleep 1
		done && echo -ne " done.\n"
		
		echo -ne "Creating mysql database..."
		while ! wpm_mysql_create true; do
			echo -n '.' && sleep 1
		done && echo -ne " done.\n"
		
		echo -ne "Securing mysql installation..."
		while ! wpm_mysql_secure true; do
			echo -n '.' && sleep 1
		done && echo -ne " done.\n"
		
		echo -ne "Flushing mysql privileges..."
		while ! `mysql -u root -e "FLUSH PRIVILEGES"` true; do
			echo -n '.' && sleep 1
		done && echo -ne " done.\n"
		
		mysqladmin -u root shutdown
				
	else
	
		export DB_HOST="$MYSQL_PORT_3306_TCP_ADDR"
		export DB_NAME="$MYSQL_ENV_MYSQL_DATABASE"
		export DB_USER="$MYSQL_ENV_MYSQL_USER"
		export DB_PASSWORD="$MYSQL_ENV_MYSQL_PASSWORD"		
		
	fi
	
	echo -e "$(date +%Y-%m-%d\ %T) MySQL setup completed" >> /var/log/wpm-install.log	
}
