# Find Hardware Information

Find CPU model
```bat
wmic cpu get /format:list | find /i "name"
```

Find the number of physical CPU socket
```bat
wmic cpu get /format:list | find /i "deviceid" | find /c /i "cpu"
```

Find the number of cores per CPU (Not available on all Windows version):
```bat
wmic cpu get /format:list | find /i "core"
```
