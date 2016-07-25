# Hardware Information

Check total physical RAM

```sh
prtconf | grep Memory
```


# System Information

Check resource usage summary for each user

```sh
prstat –t
```


Print resource usage for every 2 second for a total of 3 cycles, swap and free are in Kbytes

```sh
vmstat 2 3
```
