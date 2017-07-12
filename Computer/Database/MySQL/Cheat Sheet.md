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
