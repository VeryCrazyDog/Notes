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
dir file.xxx 1> output.msg 2>&1
```
