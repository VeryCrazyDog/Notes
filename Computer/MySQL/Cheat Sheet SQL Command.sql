#-----------------------------------------
# User account related
#-----------------------------------------

# Flsuh privleges after dump import
FLUSH PRIVILEGES;

# Remove anonymous users
DELETE FROM mysql.user WHERE User='';

# Remove remote root
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

# Change root password
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('newpassword');
SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('newpassword');
SET PASSWORD FOR 'root'@'::1' = PASSWORD('newpassword');

# Remove test database
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

# Create user for replication
CREATE USER 'repl'@'%' IDENTIFIED BY 'some_pass';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';

# Create user
CREATE USER 'user'@'%' IDENTIFIED BY 'cleartext password';
CREATE USER 'user'@'%' IDENTIFIED BY PASSWORD '3829b75c1fd31580';
GRANT ALL PRIVILEGES ON `myappdb`.* TO 'pet'@'%';

# Create replication monitor account
GRANT REPLICATION CLIENT ON *.* TO 'repl_mon'@'%' IDENTIFIED BY PASSWORD '*8EFF5B0482706E5971BB945796F48E2186B0446E'
GRANT CREATE, DROP ON `test`.* TO 'repl_mon'@'%'

# Change password
SET PASSWORD = PASSWORD('cleartext password');
SET PASSWORD FOR user = PASSWORD('cleartext password');

# Show granted privileges
SHOW GRANTS FOR 'user'@'%';

# Revoke privileges
REVOKE ALL PRIVILEGES ON `myappdb`.* FROM 'user'@'%';

#-----------------------------------------
# Replication related
#-----------------------------------------

# Skip SQL command to fix replication error
SET GLOBAL SQL_SLAVE_SKIP_COUNTER = 1;
START SLAVE;

#-----------------------------------------
# Export related
#-----------------------------------------

# Dump SQL query data into tab-separated file
SELECT * FROM my_db.my_table INTO OUTFILE '/tmp/sql_data.txt';

# Dump SQL query data into CSV file
SELECT * FROM my_db.my_table INTO OUTFILE '/tmp/sql_data.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

# Import data in to database using tab-separated file
LOAD DATA LOCAL INFILE 'C:/data.txt' INTO TABLE my_db.my_table;

# Import data in to database using CSV file
LOAD DATA LOCAL INFILE 'C:/data.csv' INTO TABLE my_db.my_table FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';
