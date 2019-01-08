Tutorial reference https://www.tutorialspoint.com/batch_script/

To redirect the stderr to NUL
```bat
dir file.xxx 2> nul
```

To redirect the stdout and stderr to different files
```bat
dir file.xxx > output.msg 2> output.err
```

To redirect both stdout and stderr to the same file
```bat
dir file.xxx > output.msg 2>&1

dir file.xxx 1> output.msg 2>&1
```

To redirect both stdout and stderr to append to the same file
```bat
dir file.xxx >> output.msg 2>&1

dir file.xxx 1>> output.msg 2>&1
```

Define function with parameter and return value
```bat
set INPUT=1
echo %INPUT%
echo "%RESULT%"
call :SET_VALUE RESULT "%INPUT%"
echo %INPUT%
echo %RESULT%
exit /b 0

rem Functions
:SET_VALUE
set %~1=%~2
exit /b 0
```

Perform string replacement using variable without using delayed expansion
```bat
set INPUT=Hello Day
set REPLACE=Day
set REPLACEMENT=World
call set RESULT=%%INPUT:%REPLACE%=%REPLACEMENT%%%
echo %RESULT%
```
