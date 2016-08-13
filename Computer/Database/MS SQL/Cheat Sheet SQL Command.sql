-----------------------------------------
-- Backup and restore related
-----------------------------------------

-- Reference: http://msdn.microsoft.com/en-us/library/ms186865%28v=sql.110%29.aspx

-- One time database backup to a new media set and erase all existing backup sets
BACKUP DATABASE [testdb] TO DISK = N'C:\TEMP\testdb.bak' WITH COPY_ONLY, FORMAT, INIT, NAME = N'testdb-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10
GO

-- One time transaction log backup to a new media set and erase all existing backup sets
BACKUP LOG [testdb] TO DISK = N'C:\TEMP\testdb.trn' WITH COPY_ONLY, FORMAT, INIT, NAME = N'testdb-Transaction Log Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10
GO

-- (To be verify if applicable to database with mirroring) Restore database to a previous point from backup
USE [master]
-- Disconnect all existing connection by set the database to single user mode, and rollback all incomplete transaction
ALTER DATABASE [testdb] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
-- Backup tail log to existing media and append to existing backup set, leave the database in restore mode for database restore
BACKUP LOG [testdb] TO DISK = N'C:\TEMP\testdb_taillog.bak' WITH NOFORMAT, NOINIT, NAME = N'testdb-taillog Backup', NOSKIP, NOREWIND, NOUNLOAD, NORECOVERY, STATS = 5
-- Restore database backup from position 1 in backup set, and rollback all incomplete transactions at the time of backup after restore
RESTORE DATABASE [testdb] FROM DISK = N'C:\TEMP\testdb.bak' WITH FILE = 1, NOUNLOAD, STATS = 5
-- Set to multi user mode
ALTER DATABASE [testdb] SET MULTI_USER
GO

-- Restore database to a new database
USE [master]
-- Restore from position 1 in backup set, and rollback all incomplete transactions at the time of backup after restore
RESTORE DATABASE [new_testdb] FROM DISK = N'C:\TEMP\testdb.bak' WITH FILE = 1, MOVE N'testdb' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\new_testdb.mdf', MOVE N'testdb_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\new_testdb_log.ldf', NOUNLOAD, STATS = 5
GO

-----------------------------------------
-- Usage related
-----------------------------------------

-- Select previous executed queries
SELECT TOP 100 SQLTEXT.text, STATS.last_execution_time
FROM           sys.dm_exec_query_stats STATS
CROSS APPLY    sys.dm_exec_sql_text(STATS.sql_handle) AS SQLTEXT
WHERE          STATS.last_execution_time > GETDATE()-1
ORDER BY       STATS.last_execution_time DESC;

-- List object dependencies in a database
EXECUTE sp_msdependencies @intrans = 1;

-- Insert a row into a table without supplying any values
INSERT INTO sender_addresses DEFAULT VALUES;

-- Consume a value without racing condition
UPDATE TOP(1) sender_addresses SET in_use = 1 OUTPUT INSERTED.msisdn WHERE in_use = 0;
