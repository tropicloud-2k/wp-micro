# ------------------------
# MYSQL SETUP
# ------------------------

wpm_mysql() {
	
	wpm_header "MariaDB Setup"
	
	token=`openssl rand -hex 6`
	
	export wpm_db_user="wp_$token"
	export wpm_db_name="db_$token"
	
	wpm_mysql_database() {
		mysql -u root -e "CREATE USER '$db_user'@'%' IDENTIFIED BY '$mysql_password'"
		mysql -u root -e "CREATE DATABASE $db_name"
		mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '$db_user'@'%' WITH GRANT OPTION"
	}
	
	wpm_mysql_secure() {
		mysql -u root -e "DELETE FROM mysql.user WHERE User='';"
		mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
		mysql -u root -e "DROP DATABASE test;"
		mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
		mysql -u root -e "FLUSH PRIVILEGES"
	}
	
	sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf
	echo -ne `openssl rand -hex 36` > /etc/.header_mustache

	mysql_password=`cat /etc/.header_mustache`
	mysql_install_db --user=mysql > /dev/null 2>&1
	mysqld_safe > /dev/null 2>&1 &
	
	echo -ne "Starting MariaDB Server..."
	while [[  ! -e /run/mysqld/mysqld.sock  ]]; do
		echo -n '.' && sleep 1
	done
	echo -ne "done!\n"
	
	echo -ne "Creating MariaDB database..."
	while ! wpm_mysql_database true; do
		echo -n '.' && sleep 1
	done
	echo -ne "done!\n"
	
	echo -ne "Securing MariaDB installation..."
	while ! wpm_mysql_secure true; do
		echo -n '.' && sleep 1
	done
	echo -ne "done!\n"
	
	mysqladmin -u root shutdown

}
