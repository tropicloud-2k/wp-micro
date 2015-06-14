# ------------------------
# MYSQL SETUP
# ------------------------

wpm_mysql_setup() {
	
	echo -ne `openssl rand -hex 36` > /etc/wpm/.mustache
	sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf

	mysql_password=`cat /etc/wpm/.mustache`
	mysql_install_db --user=mysql > /dev/null 2>&1
	mysqld_safe > /dev/null 2>&1 &
	
	echo -ne "=> Starting MariaDB Server..."
	while [[  ! -e /run/mysqld/mysqld.sock  ]]; do
		echo -n '.' && sleep 1
	done
	echo -ne " done!\n"
	
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
