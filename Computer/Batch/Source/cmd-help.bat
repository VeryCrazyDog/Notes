@set WORKING_HOME=%~dp0
@set WORKING_HOME=%WORKING_HOME:~0,-1%

@echo List of available commands:
@echo.
@dir /b "%WORKING_HOME%"
