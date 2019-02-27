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
	idxs.owner,
	cols.table_name,
	idxs.index_name,
	idxs.uniqueness,
	cols.column_name,
	cols.column_position,
	cols.descend
FROM all_indexes idxs INNER JOIN all_ind_columns cols
	ON idxs.owner = cols.index_owner AND idxs.index_name = cols.index_name
WHERE idxs.owner = USER AND cols.table_name LIKE UPPER('%')
ORDER BY idxs.owner, cols.table_name, idxs.index_name, cols.column_position;
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

Display tablespace usage

```sql
SELECT b.tablespace_name, tbs_size SizeMb, a.free_space FreeMb
FROM
	(
		SELECT tablespace_name, round(sum(bytes)/1024/1024 ,2) AS free_space
		FROM dba_free_space
		GROUP BY tablespace_name
	) a,
	(
		SELECT tablespace_name, sum(bytes)/1024/1024 AS tbs_size
		FROM dba_data_files
		GROUP BY tablespace_name
	) b
WHERE a.tablespace_name(+)=b.tablespace_name;
```



## Session Information

Find locks, their related objects and respective sessions under current logged in user

```sql
SELECT
	l.inst_id,
	l.sid,
	s."SERIAL#",
	s.osuser,
	s.machine,
	s.username,
	TO_CHAR(s.logon_time, 'YYYY-MM-DD HH24:MI:SS') AS logon_time,
	o.owner,
	o.object_name,
	o.object_type,
	s.status,
	s.last_call_et,
	'ALTER SYSTEM KILL SESSION ''' || TO_CHAR(s.sid) || ',' || TO_CHAR(s."SERIAL#") || ''' IMMEDIATE;' AS ks_sql
FROM
	gv$lock l
	INNER JOIN gv$session s ON s.inst_id = l.inst_id AND s.sid = l.sid
	INNER JOIN dba_objects o ON l.id1 = o.object_id
WHERE
	l.type = 'TO'
	AND s.username = USER
	AND o.object_name LIKE '%'
ORDER BY o.owner, o.object_name, l.inst_id, l.sid;
```

Find locked objects and their respective sessions under current logged in user

```sql
SELECT
	l.inst_id,
	l.session_id,
	s."SERIAL#",
	l.os_user_name,
	s.machine,
	l.oracle_username,
	TO_CHAR(s.logon_time, 'YYYY-MM-DD HH24:MI:SS') AS logon_time,
	o.owner,
	o.object_name,
	o.object_type,
	s.status,
	s.last_call_et,
	'ALTER SYSTEM KILL SESSION ''' || TO_CHAR(s.sid) || ',' || TO_CHAR(s."SERIAL#") || ''' IMMEDIATE;' AS ks_sql
FROM
	gv$locked_object l
	INNER JOIN gv$session s ON s.inst_id = l.inst_id AND s.sid = l.session_id
	INNER JOIN dba_objects o ON o.object_id = l.object_id
WHERE l.oracle_username = USER
ORDER BY o.owner, o.object_name, l.inst_id, l.session_id;
```

Find the object accessing by current logged in user in the current schema

```sql
-- This SQL might takes some time when criteria is given to gv$access
SELECT
	s.inst_id,
	s.sid,
	s."SERIAL#",
	s.osuser,
	s.machine,
	s.username,
	TO_CHAR(s.logon_time, 'YYYY-MM-DD HH24:MI:SS') AS logon_time,
	a.owner,
	a.object,
	a.type,
	s.status,
	s.last_call_et,
	'ALTER SYSTEM KILL SESSION ''' || TO_CHAR(s.sid) || ',' || TO_CHAR(s."SERIAL#") || ''' IMMEDIATE;' AS ks_sql
FROM gv$session s INNER JOIN gv$access a ON s.inst_id = a.inst_id AND s.sid = a.sid
WHERE s.username = USER
ORDER BY a.owner, a.object, s.inst_id, s.sid;
```

Find sessions which has been running for at least 1 day under the current logged in user

```sql
SELECT
	inst_id,
	sid,
	"SERIAL#",
	osuser,
	machine,
	username,
	TO_CHAR(logon_time, 'YYYY-MM-DD HH24:MI:SS') AS logon_time,
	schemaname,
	COALESCE(
		(SELECT command_name FROM v$sqlcommand WHERE command_type = command),
		TO_CHAR(command)
	) AS command,
	status,
	last_call_et,
	'ALTER SYSTEM KILL SESSION ''' || TO_CHAR(sid) || ',' || TO_CHAR("SERIAL#") || ''' IMMEDIATE;' AS ks_sql
FROM gv$session
WHERE username = USER AND status = 'ACTIVE' AND last_call_et >= 60 * 60 * 24
ORDER BY last_call_et DESC;
```

Find sessions which are not idle and waiting indefinitely under the current logged in user

```sql
-- Not supported on Oracle Database 9i
SELECT
	inst_id,
	sid,
	"SERIAL#",
	osuser,
	machine,
	username,
	TO_CHAR(logon_time, 'YYYY-MM-DD HH24:MI:SS') AS logon_time,
	schemaname,
	COALESCE(
		(SELECT command_name FROM v$sqlcommand WHERE command_type = command),
		TO_CHAR(command)
	) AS command,
	status,
	last_call_et,
	state,
	event,
	wait_class,
	'ALTER SYSTEM KILL SESSION ''' || TO_CHAR(sid) || ',' || TO_CHAR("SERIAL#") || ''' IMMEDIATE;' AS ks_sql
FROM gv$session
WHERE username = USER AND wait_class <> 'Idle' AND time_remaining_micro = -1
ORDER BY logon_time;
```

Find sessions which are running DBMS jobs for at least 1 day under the current logged in user, only limit to current connected node if RAC is used

```sql
SELECT
	r.sid,
	s."SERIAL#",
	s.osuser,
	s.machine,
	s.username,
	TO_CHAR(s.logon_time, 'YYYY-MM-DD HH24:MI:SS') AS logon_time,
	j.schema_user,
	r.job,
	r.last_date,
	r.last_sec,
	r.this_date,
	r.this_sec,
	j.what,
	s.status,
	s.last_call_et,
	'ALTER SYSTEM KILL SESSION ''' || TO_CHAR(r.sid) || ',' || TO_CHAR(s."SERIAL#") || ''' IMMEDIATE;' AS ks_sql
FROM dba_jobs_running r
	INNER JOIN dba_jobs j ON r.job = j.job
	INNER JOIN v$session s ON r.sid = s.sid
WHERE j.schema_user = USER AND s.last_call_et >= 60 * 60 * 24
ORDER BY s.last_call_et DESC;
```



# Operation on Database

Mark DBMS JOB with JOB ID `777` as broken

```sql
BEGIN DBMS_JOB.BROKEN(777, TRUE); END;
/
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
FROM all_tab_columns a INNER JOIN all_tab_columns b
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

## SQL Generation

Generate SQL to query number of records for all tables

```sql
SET DEFINE OFF;
SELECT
	'SELECT *' || CHR(10) || 'FROM (' || CHR(10) || CHR(9) ||
	REGEXP_REPLACE(
		REPLACE(
			XMLAGG(
				XMLELEMENT(E, sql, CHR(10) || CHR(9) || 'UNION' || CHR(10) || CHR(9))
			).EXTRACT('//text()').GetClobVal(),
			'&apos;',
			''''
		),
		CHR(10) || CHR(9) || 'UNION' || CHR(10) || CHR(9) || '$',
		''
	) || CHR(10) || ') t' || CHR(10) || 'ORDER BY count DESC;' AS result
FROM (
	SELECT
		'SELECT ''' || table_name || ''' AS table_name, COUNT(*) AS count FROM ' || table_name AS sql
	FROM user_tables
) t;
```

Generate DROP statement for all objects in database, excluding database links

```sql
-- LOBs, indexes, triggers, package bodies, system generated types will be dropped automatically when the related objects are dropped
SELECT
	'DROP ' || object_type || ' ' || object_name ||
		CASE
			WHEN object_type = 'TABLE' THEN ' CASCADE CONSTRAINTS'
			ELSE ''
		END || ';' AS sql
FROM user_objects
WHERE
	object_type NOT IN ('DATABASE LINK', 'LOB', 'INDEX', 'TRIGGER', 'PACKAGE BODY')
	AND NOT (object_type = 'TABLE' AND object_name IN (SELECT container_name FROM user_mviews))
	AND NOT (object_type = 'TYPE' AND object_name LIKE 'SYS_');
```

Generate disable constraint SQL statements

```sql
SELECT
	'ALTER TABLE "' || c.owner || '"."' || c.table_name || '" DISABLE CONSTRAINT "' || c.constraint_name || '";' AS sql,
	c.constraint_type
FROM user_constraints c INNER JOIN user_tables t ON c.table_name = t.table_name
WHERE
	c.status = 'ENABLED'
	AND NOT (t.iot_type IS NOT NULL AND c.constraint_type = 'P')
	-- Exclude tables used by materialized view
	AND c.table_name NOT IN (SELECT container_name FROM user_mviews)
	-- Edit the below condition to exclude any constraints that is not needed
	AND c.constraint_type IN ('U', 'R', 'P', 'C')
ORDER BY c.constraint_type DESC;
```

Generate enable constraint SQL statements for disabled constraints

```sql
SELECT
	'ALTER TABLE "' || c.owner || '"."' || c.table_name || '" ENABLE CONSTRAINT "' || c.constraint_name || '";' AS sql,
	c.constraint_type
FROM user_constraints c INNER JOIN user_tables t ON c.table_name = t.table_name
WHERE c.status = 'DISABLED'
ORDER BY c.constraint_type;
```

Generate disable trigger SQL statements in table level

```sql
SELECT
	'ALTER TABLE "' || table_owner || '"."' || table_name || '" DISABLE ALL TRIGGERS;' AS sql
FROM (
	SELECT DISTINCT table_owner, table_name
	FROM user_triggers
	WHERE
		base_object_type = 'TABLE'
		AND status = 'ENABLED'
) ut;
```

Generate SQL to truncate all tables

```sql
SELECT
	'ALTER TABLE "' || c.owner || '"."' || c.table_name || '" DISABLE CONSTRAINT "' || c.constraint_name || '";' AS sql,
	1 AS type_order,
	c.constraint_type
FROM user_constraints c INNER JOIN user_tables t ON c.table_name = t.table_name
WHERE
	c.status = 'ENABLED'
	AND NOT (t.iot_type IS NOT NULL AND c.constraint_type = 'P')
	-- Exclude tables used by materialized view
	AND c.table_name NOT IN (SELECT container_name FROM user_mviews)
	AND c.constraint_type = 'R'
UNION ALL
SELECT
	'TRUNCATE TABLE ' || table_name || ';' AS sql,
	2,
	''
FROM user_tables
WHERE table_name NOT IN (SELECT container_name FROM user_mviews)
UNION ALL
SELECT
	'ALTER TABLE "' || c.owner || '"."' || c.table_name || '" ENABLE CONSTRAINT "' || c.constraint_name || '";' AS sql,
	3 AS type_order,
	c.constraint_type
FROM user_constraints c INNER JOIN user_tables t ON c.table_name = t.table_name
WHERE
	c.status = 'ENABLED'
	AND NOT (t.iot_type IS NOT NULL AND c.constraint_type = 'P')
	-- Exclude tables used by materialized view
	AND c.table_name NOT IN (SELECT container_name FROM user_mviews)
	AND c.constraint_type = 'R'
ORDER BY 2, 3 DESC;
```

Generate SQL to handle DBMS jobs

```sql
SELECT
	CASE WHEN broken = 'N' THEN 'EXECUTE DBMS_JOB.BROKEN(' || job || ', TRUE);' ELSE '' END AS broken_sql,
	'EXECUTE DBMS_JOB.REMOVE(' || job || ');' AS remove_sql
FROM user_jobs;
```

# User and Privilege Management

Query privileges
```sql
-- Query a particular user/role using DBA dictionary views
SELECT * FROM dba_role_privs WHERE grantee = USER;
SELECT * FROM dba_sys_privs WHERE grantee = USER;
SELECT * FROM dba_tab_privs WHERE grantee = USER OR owner = USER;

-- Query the current logged in user/role
SELECT * FROM user_role_privs;
SELECT * FROM user_sys_privs;
SELECT * FROM user_tab_privs;
```

Query default tablespaces
```sql
-- Query a particular user using DBA dictionary view
SELECT * FROM dba_users WHERE username = USER;

-- Query the current logged in user
SELECT * FROM user_users;

-- Query the database default
SELECT property_name, property_value FROM database_properties WHERE property_name LIKE 'DEFAULT%TABLESPACE';
```

Query database quota
```sql
-- Query a particular user using DBA dictionary view
SELECT * FROM dba_ts_quotas WHERE username = USER;

-- Query the current logged in user
SELECT * FROM user_ts_quotas;
```
