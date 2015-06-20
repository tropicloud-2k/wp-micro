# ------------------------
# MYSQL SETUP
# ------------------------

wpm_mysql_setup() {
	
	wpm_header "MariaDB Setup"
	
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
	
	echo -ne "Starting MySQL Server..."
	while [[  ! -e /run/mysqld/mysqld.sock  ]]; do
		echo -n '.' && sleep 1
	done
	echo -ne ", done\n"
	
	echo -ne "Creating MySQL Databases..."
	while ! wpm_mysql_create true; do
		echo -n '.' && sleep 1
	done
	echo -ne ", done\n"
	
	echo -ne "Securing MySQL Installation..."
	while ! wpm_mysql_secure true; do
		echo -n '.' && sleep 1
	done
	echo -ne ", done\n"
	
	echo -ne "Flushing MySQL Privileges..."
	while ! `mysql -u root -e "FLUSH PRIVILEGES"` true; do
		echo -n '.' && sleep 1
	done
	echo -ne ", done\n"

}
