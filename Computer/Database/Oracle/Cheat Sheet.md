# Debugging

Enable unlimited buffer size for DBMS output

```sql
DBMS_OUTPUT.ENABLE(NULL);
```

Print line to DBMS output, please remember to open DBMS output view for viewing the message

```sql
DBMS_OUTPUT.PUT_LINE('Hello World!');
```



# Data Selection Technique

Select a delimitered list

```sql
-- For string less than or equal to 4000 bytes
SELECT LISTAGG(DUMMY, ' AND ') WITHIN GROUP (ORDER BY ID) AS RESULT
FROM (SELECT 1 AS ID, 'Y' AS DUMMY FROM DUAL UNION ALL SELECT 2, 'X' FROM DUAL);

-- For string larger than 4000 bytes
SELECT REGEXP_REPLACE(XMLAGG(XMLELEMENT(
	E,
	DUMMY,
	' AND '
) ORDER BY ID).EXTRACT('//text()').GetClobVal(), ' AND $', '') AS RESULT
FROM (SELECT 1 AS ID, 'Y' AS DUMMY FROM DUAL UNION ALL SELECT 2, 'X' FROM DUAL);
```



# Retrieving Database Information

## Schema Information

Find table primary key and their respective columns

```sql
SELECT CONS.OWNER, CONS.STATUS, COLS.TABLE_NAME, COLS.COLUMN_NAME, COLS.POSITION
FROM ALL_CONSTRAINTS CONS INNER JOIN ALL_CONS_COLUMNS COLS
	ON CONS.OWNER = COLS.OWNER AND CONS.CONSTRAINT_NAME = COLS.CONSTRAINT_NAME
WHERE CONS.OWNER = USER AND CONS.CONSTRAINT_TYPE = 'P' AND COLS.TABLE_NAME LIKE UPPER('%')
ORDER BY CONS.OWNER, COLS.TABLE_NAME, COLS.POSITION;
```

Find table indexes and their respective columns

```sql
SELECT
	IDXS.OWNER,
	COLS.TABLE_NAME,
	IDXS.INDEX_NAME,
	IDXS.UNIQUENESS,
	COLS.COLUMN_NAME,
	COLS.COLUMN_POSITION,
	COLS.DESCEND
FROM ALL_INDEXES IDXS INNER JOIN ALL_IND_COLUMNS COLS
	ON IDXS.OWNER = COLS.INDEX_OWNER AND IDXS.INDEX_NAME = COLS.INDEX_NAME
WHERE IDXS.OWNER = USER AND COLS.TABLE_NAME LIKE UPPER('%')
ORDER BY IDXS.OWNER, COLS.TABLE_NAME, IDXS.INDEX_NAME, COLS.COLUMN_POSITION;
```

Find current value of a sequence

```sql
SELECT
	sequence_owner,
	sequence_name,
	last_number
FROM all_sequences
WHERE
	sequence_owner = USER
	AND sequence_name LIKE '%';
```


## Data Size Information

Find overall database file size and tablespaces free space, please notice that the
actual data size is `data_file - free_space`

```sql
SELECT data_file, temp_file, log_file, free_space
FROM (
	SELECT
		name,
		ROUND(bytes / 1024 / 1024 / 1024, 2) gigabytes
	FROM (
		SELECT 'Data File' AS name, SUM(bytes) AS bytes FROM V$DATAFILE
		UNION ALL
		SELECT 'Temp File', SUM(bytes) FROM V$TEMPFILE
		UNION ALL
		SELECT 'Log File', SUM(bytes) FROM V$LOG
		UNION ALL
		SELECT 'Free Space', SUM(bytes) FROM dba_free_space
	)
)
PIVOT (
	MAX(gigabytes)
	FOR name IN ('Data File' AS data_file, 'Temp File' AS temp_file, 'Log File' AS log_file, 'Free Space' AS free_space)
);
```

Display a list of segments (table, index, etc) under the current owner order by data size

```sql
SELECT
	owner,
	segment_name,
	segment_type,
	ROUND(bytes / 1024 / 1024 / 1024, 2) gigabytes
FROM dba_segments
WHERE owner = USER
ORDER BY bytes DESC;
```

Display a list of owners order by data size

```sql
SELECT
	owner,
	ROUND(SUM(bytes) / 1024 / 1024 / 1024, 2) gigabytes
FROM dba_segments
GROUP BY owner
ORDER BY gigabytes DESC;
```


## Session Information

Find locked objects and their respective session

```sql
SELECT A.INST_ID, A.SESSION_ID, B."SERIAL#", B.STATUS, A.ORACLE_USERNAME, A.OS_USER_NAME, A.PROCESS, C.NAME, B.MACHINE
FROM GV$LOCKED_OBJECT A
	INNER JOIN GV$SESSION B ON A.SESSION_ID = B.SID
	INNER JOIN SYS.OBJ$ C ON A.OBJECT_ID = C."OBJ#";
```



# Operation on Database

Mark DBMS JOB with JOB ID `777` as broken

```sql
DBMS_JOB.BROKEN(777, TRUE);
```

Kill session with session ID `SESSION_ID` equal to `777` and serial number `SERIAL#` equal to `1234` immediately

```sql
ALTER SYSTEM KILL SESSION '777, 1234' IMMEDIATE;
```



# Database Checking

Check if columns are the same as their corresponding reference table

```sql
-- This assume the table is named 'tb_table_name' and the reference table is named 'tb_log_table_name'
SELECT
	a.table_name AS a_table_name,
	b.table_name AS b_table_name,
	a.column_name,
	a.data_type AS a_data_type,
	b.data_type AS b_data_type,
	a.data_length AS a_data_length,
	b.data_length AS b_data_length,
	a.data_precision AS a_data_precision,
	b.data_precision AS b_data_precision,
	a.nullable AS a_nullable,
	b.nullable AS b_nullable
FROM ALL_TAB_COLUMNS a INNER JOIN ALL_TAB_COLUMNS b
	ON
		a.owner = b.owner
		AND SUBSTR(a.table_name, 0, 3) || 'LOG_' || SUBSTR(a.table_name, 4) = b.table_name
		AND a.column_name = b.column_name
WHERE
	a.owner = USER
	AND (
		a.data_type <> b.data_type
		OR a.data_length <> b.data_length
		OR a.data_precision <> b.data_precision
		OR a.nullable <> b.nullable
	);
```
