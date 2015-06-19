# ------------------------
# MYSQL SETUP
# ------------------------

wpm_mysql_setup() {
	
	wpm_header "MariaDB Setup"
	
	sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf
	mysql_password=`openssl rand -hex 36` && echo -ne $mysql_password > /etc/.header_mustache
	
	wpm_mysql_database() {
		mysql -u root -e "CREATE USER '$user'@'%' IDENTIFIED BY '$mysql_password'"
		mysql -u root -e "CREATE DATABASE $user"
		mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '$user'@'%' WITH GRANT OPTION"
	}
	
	wpm_mysql_secure() {
		mysql -u root -e "DELETE FROM mysql.user WHERE User='';"
		mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
		mysql -u root -e "DROP DATABASE test;"
		mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
		mysql -u root -e "FLUSH PRIVILEGES"
	}
	
	mysql_install_db --user=mysql > /dev/null 2>&1
	mysqld_safe > /dev/null 2>&1 &
	
	echo -ne "Starting MariaDB Server..."
	while [[  ! -e /run/mysqld/mysqld.sock  ]]; do
		echo -n '.' && sleep 1
	done
	echo -ne "\033[1;32m done\n\033[0m"
	
	
	echo -ne "Creating MariaDB database..."
	while ! wpm_mysql_database true; do
		echo -n '.' && sleep 1
	done
	echo -ne "\033[1;32m done\n\033[0m"
	
	echo -ne "Securing MariaDB installation..."
	while ! wpm_mysql_secure true; do
		echo -n '.' && sleep 1
	done
	echo -ne "\033[1;32m done\n\033[0m"
	
	mysqladmin -u root shutdown

}
