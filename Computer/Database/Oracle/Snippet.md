# Data Masking

Masking email address

```sql
SELECT
	email,
	SUBSTR(email, 0, 3)
		|| '*****@'
		|| SUBSTR(email, INSTR(email, '@') + 1, 2)
		|| '*******'
		|| SUBSTR(email, -4) AS simple_mask,
	RPAD(SUBSTR(email, 0, 3), INSTR(email, '@') - 1, '*')
		|| SUBSTR(email, INSTR(email, '@'), 3)
		|| LPAD(
			SUBSTR(email, -4),
			LENGTH(email) - INSTR(email, '@') - 2,
			'*'
		) AS complex_mask
FROM (SELECT 'thisismyemail@gmail.com' AS email FROM dual);
```
