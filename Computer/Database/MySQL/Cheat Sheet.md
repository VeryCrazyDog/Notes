# Retrieving Database Information

## Schema Information

Find the rough estimation of number of rows for all tables in a database

```sql
SELECT table_name, table_rows
FROM information_schema.tables
WHERE table_schema = DATABASE()
ORDER BY table_rows DESC;
```
