# ------------------------
# MARIADB SETUP
# ------------------------

wpm_mariadb_create() {
	mysql -u root -e "CREATE USER '$user'@'%' IDENTIFIED BY '$DB_PASSWORD'"
	mysql -u root -e "CREATE DATABASE $user"
	mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '$user'@'%' WITH GRANT OPTION"
}

wpm_mariadb_secure() {
	mysql -u root -e "DELETE FROM mysql.user WHERE User='';"
	mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
	mysql -u root -e "DROP DATABASE test;"
	mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
}

wpm_mysql_create() {
	mysql -u root -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD -h $MYSQL_PORT_3306_TCP_ADDR -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD'"
	mysql -u root -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD -h $MYSQL_PORT_3306_TCP_ADDR -e "CREATE DATABASE $DB_NAME"
	mysql -u root -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD -h $MYSQL_PORT_3306_TCP_ADDR -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' WITH GRANT OPTION"
	mysql -u root -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD -h $MYSQL_PORT_3306_TCP_ADDR -e "FLUSH PRIVILEGES"
}

wpm_mysql_setup() {

	if [[  -z $MYSQL_PORT  ]]; then
		
		wpm_header "MariaDB Setup"

		export DB_HOST="127.0.0.1"
		export DB_NAME="$user"
		export DB_USER="$user"
		export DB_PASSWORD=`openssl rand -hex 36`
		
		apk add --update mariadb && rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/*
		cat /wpm/etc/run/mariadb.ini > /etc/wpm/run/mariadb.ini
		sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf

		mysql_install_db --user=mysql > /dev/null 2>&1
		mysqld_safe > /dev/null 2>&1 &
		
		echo -ne "Starting mysql server..."
		while [[  ! -e /run/mysqld/mysqld.sock  ]]; do
			echo -n '.' && sleep 1
		done && echo -ne " done.\n"
		
		echo -ne "Creating mysql database..."
		while ! wpm_mariadb_create true; do
			echo -n '.' && sleep 1
		done && echo -ne " done.\n"
		
		echo -ne "Securing mysql installation..."
		while ! wpm_mariadb_secure true; do
			echo -n '.' && sleep 1
		done && echo -ne " done.\n"
		
		echo -ne "Flushing mysql privileges..."
		while ! `mysql -u root -e "FLUSH PRIVILEGES"` true; do
			echo -n '.' && sleep 1
		done && echo -ne " done.\n"
		
		mysqladmin -u root shutdown
				
	else
			
		if [[  ! -z $MYSQL_PORT_3306_TCP_ADDR  ]]; then if [[  -z $DB_HOST      ]]; then export DB_HOST="$MYSQL_PORT_3306_TCP_ADDR"; fi; fi
		if [[  ! -z $MYSQL_ENV_MYSQL_DATABASE  ]]; then if [[  -z $DB_NAME      ]]; then export DB_NAME="$MYSQL_ENV_MYSQL_DATABASE"; fi; fi 
		if [[  ! -z $MYSQL_ENV_MYSQL_USER      ]]; then if [[  -z $DB_USER      ]]; then export DB_USER="$MYSQL_ENV_MYSQL_USER"; fi; fi 
		if [[  ! -z $MYSQL_ENV_MYSQL_PASSWORD  ]]; then if [[  -z $DB_PASSWORD  ]]; then export DB_PASSWORD="$MYSQL_ENV_MYSQL_PASSWORD"; fi; fi
		if [[    -z $MYSQL_ENV_MYSQL_DATABASE  ]]; then
		
			export DB_NAME=`echo ${HOSTNAME//./_} | cut -c 1-16`
			export DB_USER=$DB_NAME
			export DB_PASSWORD=`openssl rand -hex 36`
			
			wpm_mysql_create
			
		fi
	fi
	
	echo -e "$(date +%Y-%m-%d\ %T) MySQL setup completed" >> /var/log/wpm-install.log	
}
