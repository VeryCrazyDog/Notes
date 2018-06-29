# Retrieving Database Information

## Schema Information

Find the rough estimation of number of rows for all tables in a database
```sql
SELECT table_name, table_rows
FROM information_schema.tables
WHERE table_schema = DATABASE()
ORDER BY table_rows DESC;
```

Find the total number of indexes for all tables in a database
```sql
SELECT table_name, COUNT(*) as total_indexes
FROM (
	SELECT DISTINCT table_name, index_name
	FROM information_schema.statistics
	WHERE table_schema = DATABASE()
) s
GROUP BY table_name
ORDER BY total_indexes DESC;
```

# Import and Export

Export all table structures with data in a schema using SQL format, with no `CREATE DATABASE` statement
```sh
mysqldump -u user_name -p --lock-tables database_name > database_name.$(date +'%Y%m%d%H%M%S').sql
```

Export multiple table structures with data in a schema using SQL format
```sh
mysqldump -u user_name -p --lock-tables database_name table_name1 table_name2 table_name3 > exported_file_name.$(date +'%Y%m%d%H%M%S').sql
```

Import tables structures with data to an existing database schema
```sh
mysql -u user_name -p database_name < file_name.sql
```
