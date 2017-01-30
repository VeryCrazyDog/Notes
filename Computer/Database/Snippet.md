Take Transpose

```sql
-- Microsoft Access
SELECT
	DateValue([create_date]) AS [create_date],
	SUM(IIf(status = 'Success', 1, 0)) AS [success],
	SUM(IIf(status = 'Failed', 1, 0)) AS [failed],
	COUNT(*) AS [total]
FROM my_table
GROUP BY DateValue([create_date]);
```
