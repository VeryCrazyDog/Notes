Yes/No confirmation prompt

```bat
set /P RESPONSE=Are you sure? (y/[n]): 
if /I [%RESPONSE%]==[Y] (
	echo Yes!
) else (
	echo No.
)
```

Set date time into variable, independent of the region and date format

```bat
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set NOW=%%j
set NOW=%NOW:~0,4%-%NOW:~4,2%-%NOW:~6,2% %NOW:~8,2%:%NOW:~10,2%:%NOW:~12,6%
echo Local date is [%NOW%]
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
