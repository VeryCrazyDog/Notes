Yes/No confirmation prompt
```bat
rem GOTO syntax
set RESPONSE=N
set /p RESPONSE=Are you sure? (y/[N]): 
if /i not "%RESPONSE%" == "Y" goto ANSWER_NO
echo Yes!
goto END
:ANSWER_NO
echo No.
:END

rem Block syntax
set RESPONSE=N
set /p RESPONSE=Are you sure? (y/[N]): 
if /i "%RESPONSE%" == "Y" (
	echo Yes!
) else (
	echo No.
)

rem Choice command
choice /m "Are you sure?"
if ERRORLEVEL 2 (
	echo No.
) else (
	echo Yes!
)
```

Set environment variable to folder containing the executing batch file
```bat
rem Path without trailing backslash
set WORKING_HOME=%~dp0
set WORKING_HOME=%WORKING_HOME:~0,-1%

rem Alternatively use trailing dot semantic, which is equivalent to path without trailing backslash
set WORKING_HOME=%~dp0.
```

Set date time into variable, independent of the region and date format
```bat
for /f "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /value 2^>nul`) do if '.%%i.'=='.LocalDateTime.' set NOW=%%j
set COMPACT=%NOW:~0,14%
set READABLE=%NOW:~0,4%-%NOW:~4,2%-%NOW:~6,2% %NOW:~8,2%:%NOW:~10,2%:%NOW:~12,2%
echo Local time in different formats are:
echo [%READABLE%]
echo [%COMPACT%]
```

Add hidden attribute to folders and files with filename started with dot
```bat
for %%f in (.*.*) do attrib +h %%f
for /d %%f in (.*.*) do attrib +h %%f
```

Run command, store the output to log folder and delete log files older than 365 days
```bat
rem Get the current timestamp
for /f "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /value 2^>nul`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set START_TIMESTAMP=%ldt:~0,14%
rem Create log folder if not exists
if not exist "log" (
	mkdir "log"
)
rem Run command
echo Hello World!>>"log\%START_TIMESTAMP%.txt" 2>&1
rem Delete outdated files
forfiles /p "log" /d -365 /c "cmd /c del @file" 2>nul || cd .
```
