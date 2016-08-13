# Backup multiple tables from a database
mysqldump -u user_name -p --lock-tables database_name table_name1 table_name2 table_name3 > backup_file_name.sql

# Backup a database
mysqldump -u user_name -p --lock-tables database_name > database_name.sql

# Restoring a single table into another database
mysql -u user_name -p database_name < table_name.sql

# Set login path
mysql_config_editor set --login-path=<login_path_name> --host=<host> --user=<username> --password

# Print all login path
mysql_config_editor print --all

# Show replication details
# This utility shows the replication slaves for a master. It prints a graph of the master and its slaves labeling each with the host name and port number.
# The login user must have the REPLICATION SLAVE and REPLICATION CLIENT privileges to successfully execute this utility
mysqlrplshow --master=<login_path_name>:3306 --discover-slaves-login=<login_path_name> --recurse
mysqlrplshow --master=<username>:<password>@<master_host> --discover-slaves-login=<username>:<password> --recurse

# Connect via unixODBC using SQLDriverConnect
# Reference: https://dev.mysql.com/doc/connector-odbc/en/connector-odbc-configuration-connection-parameters.html
isql -v -k "DRIVER={MySQL ODBC 5.3 Unicode Driver};SERVER=localhost;PORT=;SOCKET={/var/lib/mysql/mysql.sock};DATABASE=;USER=username;PASSWORD=password;OPTION=3;"

# Connect via unixODBC using DNS
# Reference: https://dev.mysql.com/doc/connector-odbc/en/connector-odbc-configuration-connection-parameters.html
isql -v dns username password
