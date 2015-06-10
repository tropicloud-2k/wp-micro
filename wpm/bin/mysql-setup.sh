# ------------------------
# MYSQL SETUP
# ------------------------

mysql_setup() {
	
	sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf
	
	mysql_password=`cat /etc/wpm/.wpm_shadow`
	mysql_install_db --user=mysql > /dev/null 2>&1
	mysqld_safe > /dev/null 2>&1 &
	
	timeout=30
	echo -n "=> Waiting for MariaDB service startup"
	
	while [[  ! /usr/bin/mysqladmin -u root status >/dev/null 2>&1  ]]; do
		timeout=$(($timeout - 1))
		if [[  $timeout -eq 0  ]]; then
			echo -e "=> Could not start MariaDB server. Aborting..."
			exit 1
		fi
		echo -n "." && sleep 1
	done
	
	echo "=> Creating MySQL user and database"
	mysql -u root -e "CREATE USER '$user'@'%' IDENTIFIED BY '$mysql_password'"
	mysql -u root -e "CREATE DATABASE $user"
	mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '$user'@'%' WITH GRANT OPTION"
	
	echo "=> Securing MariaDB installation"
	mysql -u root -e "DELETE FROM mysql.user WHERE User='';"
	mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
	mysql -u root -e "DROP DATABASE test;"
	mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
	mysql -u root -e "FLUSH PRIVILEGES"
		
	mysqladmin -u root shutdown

}	
