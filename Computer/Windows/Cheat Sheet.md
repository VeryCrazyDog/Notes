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

# Others

Create a dummy file with specific size

```bat
rem Create 1MB file with filename 'filename.dat'
fsutil file createnew filename.dat 1048576

rem Create 1GB file with filename 'filename.dat'
fsutil file createnew filename.dat 1073741824
```
