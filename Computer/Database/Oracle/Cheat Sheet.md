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
SELECT LISTAGG (DUMMY, ', ' ) WITHIN GROUP (ORDER BY DUMMY) AS RESULT
FROM (SELECT * FROM DUAL UNION ALL SELECT * FROM DUAL);

-- For string larger than 4000 bytes and can use RTRIM
SELECT RTRIM(XMLAGG(XMLELEMENT(
	E,
	DUMMY,
	', '
).EXTRACT('//text()') ORDER BY DUMMY).GetClobVal(), ', ') AS RESULT
FROM (SELECT * FROM DUAL UNION ALL SELECT * FROM DUAL);

-- For string larger than 4000 bytes and cannot use RTRIM
SELECT REGEXP_REPLACE(XMLAGG(XMLELEMENT(
	E,
	DUMMY,
	' AND '
).EXTRACT('//text()') ORDER BY DUMMY).GetClobVal(), ' AND $', '') AS RESULT
FROM (SELECT * FROM DUAL UNION ALL SELECT * FROM DUAL);
```



# Retrieving Database Information

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

Find overall database size and tablespaces free space
```sql
SELECT
	ROUND(SUM(USED.BYTES) / (1024 * 1024 * 1024) ) || ' GB' "Database Size",
	ROUND(FREE.P / (1024 * 1024 * 1024)) || ' GB' "Free Space"
FROM (
	SELECT BYTES FROM V$DATAFILE
	UNION ALL
	SELECT BYTES FROM V$TEMPFILE
	UNION ALL
	SELECT BYTES FROM V$LOG
) USED, (
	SELECT SUM(BYTES) AS P FROM DBA_FREE_SPACE
) FREE
GROUP BY FREE.P;
```

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
