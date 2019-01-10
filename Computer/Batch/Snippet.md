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
for /f "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set NOW=%%j
set COMPACT=%NOW:~0,14%
set READABLE=%NOW:~0,4%-%NOW:~4,2%-%NOW:~6,2% %NOW:~8,2%:%NOW:~10,2%:%NOW:~12,2%
echo Local time in different formats are:
echo [%READABLE%]
echo [%COMPACT%]
```

Template for launching program
```bat
@rem Do not use "echo off" to not affect any child calls

@rem Set environment variables local to this batch file
@setlocal

@rem Reset to Windows 7 default environment variables
@set PATH=C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\
@set CLASSPATH=

@rem Configure additional environment variables
@set PATH=%PATH%

@rem Switch to the program start location
@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%
@cd /d %HOME%

@rem Launch the program
@start %COMSPEC%
```

Add hidden attribute to folders and files with filename started with dot
```bat
for %%f in (.*.*) do attrib +h %%f
for /d %%f in (.*.*) do attrib +h %%f
```
