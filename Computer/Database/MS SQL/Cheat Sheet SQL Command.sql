-----------------------------------------
-- Backup and restore related
-----------------------------------------

-- Reference: http://msdn.microsoft.com/en-us/library/ms186865%28v=sql.110%29.aspx

-- Backup database with new media and overwrite backup set
BACKUP DATABASE [database_name] TO DISK = N'path_to_media_file' WITH FORMAT, INIT, MEDIANAME = N'media_name', NAME = N'backup_set_name', SKIP, STATS = 10, CHECKSUM
GO

-- Backup transaction log to existing media and overwrite backup set
BACKUP LOG [database_name] TO DISK = N'path_to_media_file' WITH NOFORMAT, INIT, NAME = N'backup_set_name', SKIP, STATS = 10, CHECKSUM
GO

-- (To be tested again) Restore database and overwrite existing database
USE [master]
ALTER DATABASE [database_name] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [database_name] FROM DISK = N'path_to_media_file' WITH FILE = 1, MOVE N'database_name' TO N'new_database_data_file_mdf_path', MOVE N'database_log_name' TO N'new_database_data_file_ldf_path', REPLACE, STATS = 5
ALTER DATABASE [database_name] SET MULTI_USER
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
