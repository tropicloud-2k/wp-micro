# ------------------------
# MYSQL SETUP
# ------------------------

wpm_mysql_setup() {
	
	wpm_header "MariaDB Setup"
	
	export DB_PASSWORD=`openssl rand -hex 36`

	sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf
	
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
	
	mysql_install_db --user=mysql > /dev/null 2>&1
	mysqld_safe > /dev/null 2>&1 &
	
	echo -ne "Starting MySQL Server..."
	while [[  ! -e /run/mysqld/mysqld.sock  ]]; do
		echo -n '.' && sleep 1
	done && echo -ne " done\n"
	
	echo -ne "Creating MySQL Database..."
	while ! wpm_mysql_create true; do
		echo -n '.' && sleep 1
	done && echo -ne " done\n"
	
	echo -ne "Securing MySQL Installation..."
	while ! wpm_mysql_secure true; do
		echo -n '.' && sleep 1
	done && echo -ne " done\n"
	
	echo -ne "Flushing MySQL Privileges..."
	while ! `mysql -u root -e "FLUSH PRIVILEGES"` true; do
		echo -n '.' && sleep 1
	done && echo -ne " done\n"
	
	mysqladmin -u root shutdown

}
