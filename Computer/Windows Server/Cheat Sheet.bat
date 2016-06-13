rem 5 pause to prevent accidental execution
pause
pause
pause
pause
pause

rem Find CPU model
wmic cpu get /format:list | find /i "name"

rem Find the number of physical CPU socket
wmic cpu get /format:list | find /i "deviceid" | find /c /i "cpu"

rem Find the number of cores per CPU (Not available on all Windows):
wmic cpu get /format:list | find /i "core"
