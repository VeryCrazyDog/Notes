@rem Do not use "echo off" to not affect any child calls

@rem Set environment variables local to this batch file
@setlocal

@set WORKING_HOME=%~dp0
@set WORKING_HOME=%WORKING_HOME:~0,-1%

"%WORKING_HOME%\bin\mysqld.exe" --console
